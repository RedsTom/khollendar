package fr.redstom.khollendar.service;

import fr.redstom.khollendar.entity.*;
import fr.redstom.khollendar.repository.KholleAssignmentRepository;
import fr.redstom.khollendar.repository.KholleSessionRepository;
import fr.redstom.khollendar.repository.UserPreferenceRepository;
import fr.redstom.khollendar.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class KholleAssignmentServiceTest {

    @Mock
    private KholleSessionRepository sessionRepository;

    @Mock
    private UserPreferenceRepository preferenceRepository;

    @Mock
    private KholleAssignmentRepository assignmentRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private KholleAssignmentService assignmentService;

    private KholleSession session;
    private List<KholleSlot> slots;
    private List<User> users;
    private List<UserPreference> preferences;

    @BeforeEach
    void setUp() {
        // Création d'une session de test
        session = KholleSession.builder()
                .id(1L)
                .subject("Mathématiques")
                .status(KholleSessionStatus.REGISTRATIONS_CLOSED)
                .build();

        // Création de 3 créneaux
        slots = Arrays.asList(
                KholleSlot.builder().id(1L).dateTime(LocalDateTime.now().plusDays(1)).session(session).build(),
                KholleSlot.builder().id(2L).dateTime(LocalDateTime.now().plusDays(2)).session(session).build(),
                KholleSlot.builder().id(3L).dateTime(LocalDateTime.now().plusDays(3)).session(session).build()
        );

        session = session.toBuilder().kholleSlots(slots).build();

        // Création de 6 utilisateurs
        users = Arrays.asList(
                User.builder().id(1L).username("user1").build(),
                User.builder().id(2L).username("user2").build(),
                User.builder().id(3L).username("user3").build(),
                User.builder().id(4L).username("user4").build(),
                User.builder().id(5L).username("user5").build(),
                User.builder().id(6L).username("user6").build()
        );

        // Création des préférences (tous préfèrent le créneau 1 en premier choix)
        preferences = new ArrayList<>();
        for (int i = 0; i < 6; i++) {
            User user = users.get(i);
            // Choix 1 : slot 1
            preferences.add(UserPreference.builder()
                    .id((long) (i * 3 + 1))
                    .user(user)
                    .session(session)
                    .slot(slots.get(0))
                    .preferenceRank(1)
                    .isUnavailable(false)
                    .build());
            // Choix 2 : slot 2
            preferences.add(UserPreference.builder()
                    .id((long) (i * 3 + 2))
                    .user(user)
                    .session(session)
                    .slot(slots.get(1))
                    .preferenceRank(2)
                    .isUnavailable(false)
                    .build());
            // Choix 3 : slot 3
            preferences.add(UserPreference.builder()
                    .id((long) (i * 3 + 3))
                    .user(user)
                    .session(session)
                    .slot(slots.get(2))
                    .preferenceRank(3)
                    .isUnavailable(false)
                    .build());
        }
    }

    @Test
    void testAssignStudentsToSlots_Success() {
        // Given
        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session))
                .thenReturn(preferences);
        when(userRepository.findAll()).thenReturn(users);
        when(assignmentRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Map<User, KholleSlot> assignments = assignmentService.assignStudentsToSlots(1L);

        // Then
        assertNotNull(assignments);
        assertEquals(6, assignments.size());

        // Vérification que chaque utilisateur a une affectation
        for (User user : users) {
            assertTrue(assignments.containsKey(user));
            assertNotNull(assignments.get(user));
        }

        // Vérification que les créneaux sont équilibrés (2 étudiants par créneau)
        Map<KholleSlot, Long> slotDistribution = new HashMap<>();
        for (KholleSlot slot : assignments.values()) {
            slotDistribution.merge(slot, 1L, Long::sum);
        }

        for (Long count : slotDistribution.values()) {
            assertTrue(count >= 1 && count <= 3, "Chaque créneau devrait avoir entre 1 et 3 étudiants");
        }

        // Vérification des appels aux repositories
        verify(sessionRepository).findById(1L);
        verify(assignmentRepository).deleteBySession(session);
        verify(assignmentRepository).saveAll(any());
    }

    @Test
    void testAssignStudentsToSlots_WithUnavailabilities_NeverAssignsToUnavailableSlot() {
        // Given: User1 est indisponible pour les slots 1 et 2, disponible seulement pour slot 3
        User user1 = users.get(0);
        List<UserPreference> preferencesWithUnavailability = new ArrayList<>();

        // User1: Indisponibilités sur slots 1 et 2
        preferencesWithUnavailability.add(UserPreference.builder()
                .id(100L)
                .user(user1)
                .session(session)
                .slot(slots.get(0))
                .preferenceRank(-1)
                .isUnavailable(true)
                .build());
        preferencesWithUnavailability.add(UserPreference.builder()
                .id(101L)
                .user(user1)
                .session(session)
                .slot(slots.get(1))
                .preferenceRank(-1)
                .isUnavailable(true)
                .build());
        // User1: Seule préférence positive = slot 3
        preferencesWithUnavailability.add(UserPreference.builder()
                .id(102L)
                .user(user1)
                .session(session)
                .slot(slots.get(2))
                .preferenceRank(1)
                .isUnavailable(false)
                .build());

        // Les autres utilisateurs préfèrent tous le slot 1
        for (int i = 1; i < 6; i++) {
            User user = users.get(i);
            preferencesWithUnavailability.add(UserPreference.builder()
                    .id((long) (200 + i))
                    .user(user)
                    .session(session)
                    .slot(slots.get(0))
                    .preferenceRank(1)
                    .isUnavailable(false)
                    .build());
        }

        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session))
                .thenReturn(preferencesWithUnavailability);
        when(userRepository.findAll()).thenReturn(users);
        when(assignmentRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Map<User, KholleSlot> assignments = assignmentService.assignStudentsToSlots(1L);

        // Then
        assertNotNull(assignments);
        assertEquals(6, assignments.size());

        // CRITIQUE: User1 NE DOIT JAMAIS être affecté aux slots 1 ou 2
        KholleSlot user1Assignment = assignments.get(user1);
        assertNotNull(user1Assignment, "User1 doit avoir une affectation");
        assertNotEquals(slots.get(0).id(), user1Assignment.id(),
                "User1 ne doit PAS être affecté au slot 1 (indisponible)");
        assertNotEquals(slots.get(1).id(), user1Assignment.id(),
                "User1 ne doit PAS être affecté au slot 2 (indisponible)");
        assertEquals(slots.get(2).id(), user1Assignment.id(),
                "User1 doit être affecté au slot 3 (seul créneau disponible)");
    }

    @Test
    void testAssignStudentsToSlots_MultipleUsersWithDifferentUnavailabilities() {
        // Given: Configuration complexe avec plusieurs utilisateurs ayant des indisponibilités différentes
        List<UserPreference> complexPreferences = new ArrayList<>();

        // User1: Indisponible slot 1, préfère 2 puis 3
        complexPreferences.add(UserPreference.builder()
                .user(users.get(0))
                .session(session)
                .slot(slots.get(0))
                .preferenceRank(-1)
                .isUnavailable(true)
                .build());
        complexPreferences.add(UserPreference.builder()
                .user(users.get(0))
                .session(session)
                .slot(slots.get(1))
                .preferenceRank(1)
                .isUnavailable(false)
                .build());
        complexPreferences.add(UserPreference.builder()
                .user(users.get(0))
                .session(session)
                .slot(slots.get(2))
                .preferenceRank(2)
                .isUnavailable(false)
                .build());

        // User2: Indisponible slot 2, préfère 1 puis 3
        complexPreferences.add(UserPreference.builder()
                .user(users.get(1))
                .session(session)
                .slot(slots.get(1))
                .preferenceRank(-1)
                .isUnavailable(true)
                .build());
        complexPreferences.add(UserPreference.builder()
                .user(users.get(1))
                .session(session)
                .slot(slots.get(0))
                .preferenceRank(1)
                .isUnavailable(false)
                .build());
        complexPreferences.add(UserPreference.builder()
                .user(users.get(1))
                .session(session)
                .slot(slots.get(2))
                .preferenceRank(2)
                .isUnavailable(false)
                .build());

        // User3: Indisponible slot 3, préfère 1 puis 2
        complexPreferences.add(UserPreference.builder()
                .user(users.get(2))
                .session(session)
                .slot(slots.get(2))
                .preferenceRank(-1)
                .isUnavailable(true)
                .build());
        complexPreferences.add(UserPreference.builder()
                .user(users.get(2))
                .session(session)
                .slot(slots.get(0))
                .preferenceRank(1)
                .isUnavailable(false)
                .build());
        complexPreferences.add(UserPreference.builder()
                .user(users.get(2))
                .session(session)
                .slot(slots.get(1))
                .preferenceRank(2)
                .isUnavailable(false)
                .build());

        // Users 4-6: Pas d'indisponibilités, préfèrent tous slot 1
        for (int i = 3; i < 6; i++) {
            complexPreferences.add(UserPreference.builder()
                    .user(users.get(i))
                    .session(session)
                    .slot(slots.get(0))
                    .preferenceRank(1)
                    .isUnavailable(false)
                    .build());
            complexPreferences.add(UserPreference.builder()
                    .user(users.get(i))
                    .session(session)
                    .slot(slots.get(1))
                    .preferenceRank(2)
                    .isUnavailable(false)
                    .build());
            complexPreferences.add(UserPreference.builder()
                    .user(users.get(i))
                    .session(session)
                    .slot(slots.get(2))
                    .preferenceRank(3)
                    .isUnavailable(false)
                    .build());
        }

        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session))
                .thenReturn(complexPreferences);
        when(userRepository.findAll()).thenReturn(users);
        when(assignmentRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Map<User, KholleSlot> assignments = assignmentService.assignStudentsToSlots(1L);

        // Then
        assertNotNull(assignments);
        assertEquals(6, assignments.size());

        // Vérifications des indisponibilités
        assertNotEquals(slots.get(0).id(), assignments.get(users.get(0)).id(),
                "User1 ne doit pas être affecté au slot 1 (indisponible)");
        assertNotEquals(slots.get(1).id(), assignments.get(users.get(1)).id(),
                "User2 ne doit pas être affecté au slot 2 (indisponible)");
        assertNotEquals(slots.get(2).id(), assignments.get(users.get(2)).id(),
                "User3 ne doit pas être affecté au slot 3 (indisponible)");
    }

    @Test
    void testAssignStudentsToSlots_UserWithAllSlotsUnavailable_ThrowsException() {
        // Given: Un utilisateur a marqué TOUS les créneaux comme indisponibles
        User problematicUser = users.get(0);
        List<UserPreference> impossiblePreferences = new ArrayList<>();

        // Tous les slots sont indisponibles pour cet utilisateur
        for (KholleSlot slot : slots) {
            impossiblePreferences.add(UserPreference.builder()
                    .user(problematicUser)
                    .session(session)
                    .slot(slot)
                    .preferenceRank(-1)
                    .isUnavailable(true)
                    .build());
        }

        // Les autres utilisateurs ont des préférences normales
        for (int i = 1; i < 6; i++) {
            User user = users.get(i);
            impossiblePreferences.add(UserPreference.builder()
                    .user(user)
                    .session(session)
                    .slot(slots.get(0))
                    .preferenceRank(1)
                    .isUnavailable(false)
                    .build());
        }

        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session))
                .thenReturn(impossiblePreferences);
        when(userRepository.findAll()).thenReturn(users);

        // When & Then: Doit lever une exception car impossible d'affecter l'utilisateur
        IllegalStateException exception = assertThrows(IllegalStateException.class, () -> {
            assignmentService.assignStudentsToSlots(1L);
        });

        assertTrue(exception.getMessage().contains("Impossible de trouver un créneau disponible"));
        assertTrue(exception.getMessage().contains(problematicUser.username()));
    }

    @Test
    void testAssignStudentsToSlots_UsersWithNoPreferences_AreAssignedRandomly() {
        // Given: Certains utilisateurs n'ont pas de préférences du tout
        List<UserPreference> partialPreferences = new ArrayList<>();

        // Seulement les 3 premiers utilisateurs ont des préférences
        for (int i = 0; i < 3; i++) {
            User user = users.get(i);
            partialPreferences.add(UserPreference.builder()
                    .user(user)
                    .session(session)
                    .slot(slots.get(0))
                    .preferenceRank(1)
                    .isUnavailable(false)
                    .build());
        }

        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session))
                .thenReturn(partialPreferences);
        when(userRepository.findAll()).thenReturn(users);
        when(assignmentRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Map<User, KholleSlot> assignments = assignmentService.assignStudentsToSlots(1L);

        // Then
        assertNotNull(assignments);
        assertEquals(6, assignments.size());

        // Les utilisateurs sans préférences (users 3-5) doivent quand même être affectés
        for (int i = 3; i < 6; i++) {
            assertNotNull(assignments.get(users.get(i)),
                    "User " + (i + 1) + " sans préférences doit être affecté");
        }
    }

    @Test
    void testAssignStudentsToSlots_UnavailabilitiesRespectedEvenWhenNoCapacity() {
        // Given: Situation où tous les créneaux préférés sont pleins,
        // mais l'algorithme ne doit toujours pas affecter à un créneau indisponible

        // Créons 10 utilisateurs pour forcer la saturation
        List<User> manyUsers = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            manyUsers.add(User.builder().id((long) i).username("user" + i).build());
        }

        List<UserPreference> saturatedPreferences = new ArrayList<>();

        // User0: Indisponible pour slots 1 et 2, préfère seulement slot 3
        saturatedPreferences.add(UserPreference.builder()
                .user(manyUsers.get(0))
                .session(session)
                .slot(slots.get(0))
                .preferenceRank(-1)
                .isUnavailable(true)
                .build());
        saturatedPreferences.add(UserPreference.builder()
                .user(manyUsers.get(0))
                .session(session)
                .slot(slots.get(1))
                .preferenceRank(-1)
                .isUnavailable(true)
                .build());
        saturatedPreferences.add(UserPreference.builder()
                .user(manyUsers.get(0))
                .session(session)
                .slot(slots.get(2))
                .preferenceRank(1)
                .isUnavailable(false)
                .build());

        // Users 1-9: Tous préfèrent slot 1, puis 2, puis 3
        for (int i = 1; i < 10; i++) {
            for (int slotIdx = 0; slotIdx < 3; slotIdx++) {
                saturatedPreferences.add(UserPreference.builder()
                        .user(manyUsers.get(i))
                        .session(session)
                        .slot(slots.get(slotIdx))
                        .preferenceRank(slotIdx + 1)
                        .isUnavailable(false)
                        .build());
            }
        }

        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session))
                .thenReturn(saturatedPreferences);
        when(userRepository.findAll()).thenReturn(manyUsers);
        when(assignmentRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Map<User, KholleSlot> assignments = assignmentService.assignStudentsToSlots(1L);

        // Then
        assertNotNull(assignments);
        assertEquals(10, assignments.size());

        // CRITIQUE: User0 ne doit JAMAIS être affecté aux slots 1 ou 2,
        // même si le slot 3 est saturé
        KholleSlot user0Assignment = assignments.get(manyUsers.get(0));
        assertNotNull(user0Assignment);
        assertNotEquals(slots.get(0).id(), user0Assignment.id(),
                "User0 ne doit pas être affecté au slot 1 même si saturé ailleurs");
        assertNotEquals(slots.get(1).id(), user0Assignment.id(),
                "User0 ne doit pas être affecté au slot 2 même si saturé ailleurs");
        assertEquals(slots.get(2).id(), user0Assignment.id(),
                "User0 doit être affecté au slot 3 (seul disponible)");
    }

    @Test
    void testAssignStudentsToSlots_SessionNotFound() {
        // Given
        when(sessionRepository.findById(999L)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(IllegalArgumentException.class, () -> {
            assignmentService.assignStudentsToSlots(999L);
        });
    }

    @Test
    void testAssignStudentsToSlots_NoSlots() {
        // Given
        KholleSession emptySession = session.toBuilder()
                .kholleSlots(Collections.emptyList())
                .build();
        when(sessionRepository.findById(1L)).thenReturn(Optional.of(emptySession));

        // When & Then
        assertThrows(IllegalStateException.class, () -> {
            assignmentService.assignStudentsToSlots(1L);
        });
    }

    @Test
    void testAssignStudentsToSlots_UpdatesSessionStatus() {
        // Given
        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session))
                .thenReturn(preferences);
        when(userRepository.findAll()).thenReturn(users);
        when(assignmentRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        assignmentService.assignStudentsToSlots(1L);

        // Then
        verify(sessionRepository).save(argThat(savedSession ->
                savedSession.status() == KholleSessionStatus.RESULTS_AVAILABLE));
    }

    @Test
    void testGetAssignment() {
        // Given
        User user = users.get(0);
        KholleSlot slot = slots.get(0);
        KholleAssignment assignment = KholleAssignment.builder()
                .id(1L)
                .user(user)
                .session(session)
                .slot(slot)
                .assignedAt(LocalDateTime.now())
                .obtainedPreferenceRank(1)
                .build();

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(assignmentRepository.findByUserAndSession(user, session)).thenReturn(Optional.of(assignment));

        // When
        Optional<KholleAssignment> result = assignmentService.getAssignment(1L, 1L);

        // Then
        assertTrue(result.isPresent());
        assertEquals(user, result.get().user());
        assertEquals(slot, result.get().slot());
    }

    @Test
    void testIsSessionAssigned_True() {
        // Given
        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(assignmentRepository.findBySession(session)).thenReturn(Arrays.asList(
                KholleAssignment.builder().build()
        ));

        // When
        boolean result = assignmentService.isSessionAssigned(1L);

        // Then
        assertTrue(result);
    }

    @Test
    void testIsSessionAssigned_False() {
        // Given
        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(assignmentRepository.findBySession(session)).thenReturn(Collections.emptyList());

        // When
        boolean result = assignmentService.isSessionAssigned(1L);

        // Then
        assertFalse(result);
    }

    @Test
    void testAssignStudentsToSlots_PreferencesAreBalanced() {
        // Given: Test que l'algorithme max-min fairness équilibre bien les affectations
        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session))
                .thenReturn(preferences);
        when(userRepository.findAll()).thenReturn(users);
        when(assignmentRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        Map<User, KholleSlot> assignments = assignmentService.assignStudentsToSlots(1L);

        // Then
        Map<Long, Long> slotCounts = assignments.values().stream()
                .collect(Collectors.groupingBy(KholleSlot::id, Collectors.counting()));

        // Les créneaux doivent être relativement équilibrés (6 users / 3 slots = 2 par slot)
        long maxCount = Collections.max(slotCounts.values());
        long minCount = Collections.min(slotCounts.values());

        assertTrue(maxCount - minCount <= 1,
                "Les créneaux doivent être équilibrés avec au maximum 1 étudiant de différence");
    }
}
