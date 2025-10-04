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
                    .build());
            // Choix 2 : slot 2
            preferences.add(UserPreference.builder()
                    .id((long) (i * 3 + 2))
                    .user(user)
                    .session(session)
                    .slot(slots.get(1))
                    .preferenceRank(2)
                    .build());
            // Choix 3 : slot 3
            preferences.add(UserPreference.builder()
                    .id((long) (i * 3 + 3))
                    .user(user)
                    .session(session)
                    .slot(slots.get(2))
                    .preferenceRank(3)
                    .build());
        }
    }

    @Test
    void testAssignStudentsToSlots_Success() {
        // Given
        when(sessionRepository.findById(1L)).thenReturn(Optional.of(session));
        when(preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session))
                .thenReturn(preferences);
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
}
