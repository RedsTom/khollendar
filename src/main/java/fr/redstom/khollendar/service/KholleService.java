/*
 * Kholle'n'dar is a web application to manage oral interrogations planning
 * for French students.
 * Copyright (C) 2025 Tom BUTIN
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
  * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package fr.redstom.khollendar.service;

import fr.redstom.khollendar.dto.KholleCreationDto;
import fr.redstom.khollendar.dto.KhollePatchDto;
import fr.redstom.khollendar.dto.KholleSessionCreationDto;
import fr.redstom.khollendar.entity.*;
import fr.redstom.khollendar.repository.KholleSessionRepository;
import fr.redstom.khollendar.repository.UserPreferenceRepository;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

@Service
@RequiredArgsConstructor
public class KholleService {

    private final KholleSessionRepository kholleSessionRepository;
    private final UserPreferenceRepository userPreferenceRepository;
    private final UserService userService;

    /**
     * Sauvegarde une nouvelle session de khôlles à partir d'un DTO de formulaire
     *
     * @param dto La session à enregistrer
     * @return La session enregistrée
     */
    public KholleSession createKholle(KholleSessionCreationDto dto) {
        // Création d'une nouvelle session avec les informations de base
        KholleSession session = KholleSession.builder()
                .subject(dto.subject())
                .kholleSlots(new ArrayList<>())
                .build();

        // Sauvegarde de la session d'abord pour obtenir un ID
        session = kholleSessionRepository.save(session);

        // Création des créneaux (slots) associés à cette session sauvegardée
        List<KholleSlot> slots = new ArrayList<>();
        for (KholleCreationDto slotDto : dto.slots()) {
            KholleSlot slot = KholleSlot.builder()
                    .dateTime(slotDto.time())
                    .session(session) // Référence à la session déjà persistée
                    .build();
            slots.add(slot);
        }

        // Mise à jour de la session avec les slots
        session = session.toBuilder().kholleSlots(slots).build();

        // Sauvegarde finale de la session avec ses slots
        return kholleSessionRepository.save(session);
    }

    /**
     * Récupère toutes les sessions de khôlles avec pagination
     *
     * @param page La page à récupérer
     * @param size Le nombre d'éléments par page
     * @return Page contenant les sessions de khôlles, triées par ID décroissant
     */
    public Page<KholleSession> getAllKholleSessions(int page, int size) {
        return kholleSessionRepository.findAll(PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "id")));
    }

    /**
     * Récupère toutes les sessions de khôlles à venir avec pagination
     *
     * @param page La page à récupérer
     * @param size Le nombre d'éléments par page
     * @return Page contenant les sessions de khôlles à venir, triées par date croissante
     */
    public Page<KholleSession> getUpcomingKholleSessions(int page, int size) {
        return kholleSessionRepository.findUpcomingKholleSessionsPaged(LocalDateTime.now(), PageRequest.of(page, size));
    }

    /**
     * Récupère les sessions de khôlles passées avec pagination
     *
     * @param page La page à récupérer
     * @param size Le nombre d'éléments par page
     * @return Page contenant les sessions de khôlles passées, triées par date décroissante
     */
    public Page<KholleSession> getPreviousKholleSessions(int page, int size) {
        return kholleSessionRepository.findPreviousKholleSessions(LocalDateTime.now(), PageRequest.of(page, size));
    }

    /**
     * Récupère une session de khôlle par son ID
     *
     * @param id L'identifiant de la session à récupérer
     * @return La session correspondante, si elle existe
     */
    public Optional<KholleSession> getKholleSessionById(Long id) {
        return kholleSessionRepository.findKholleSessionById(id);
    }

    /**
     * Sauvegarde les préférences d'un utilisateur pour une session de khôlle
     *
     * @param userId L'ID de l'utilisateur
     * @param sessionId L'ID de la session de khôlle
     * @param unavailableSlots Liste des IDs des créneaux marqués comme indisponibles
     * @param rankedSlots Liste des IDs des créneaux disponibles classés par ordre de préférence
     */
    @Transactional
    public void savePreferences(Long userId, Long sessionId, List<Long> unavailableSlots, List<Long> rankedSlots) {
        User user = userService
                .getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur avec l'ID " + userId + " non trouvé"));

        KholleSession session = getKholleSessionById(sessionId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Session de khôlle avec l'ID " + sessionId + " non trouvée"));

        // Supprimer toutes les préférences existantes pour cet utilisateur et cette session
        userPreferenceRepository.deleteByUserAndSession(user, session);

        // Sauvegarder les indisponibilités (avec isUnavailable = true)
        for (Long slotId : unavailableSlots) {
            KholleSlot slot = session.kholleSlots().stream()
                    .filter(s -> s.id().equals(slotId))
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Créneau avec l'ID " + slotId + " non trouvé dans la session " + sessionId));

            UserPreference unavailability = UserPreference.builder()
                    .user(user)
                    .session(session)
                    .slot(slot)
                    .preferenceRank(-1) // Les indisponibilités ont un rang négatif
                    .isUnavailable(true)
                    .build();

            userPreferenceRepository.save(unavailability);
        }

        // Sauvegarder les nouvelles préférences uniquement pour les créneaux disponibles
        // (rankedSlots)
        for (int i = 0; i < rankedSlots.size(); i++) {
            Long slotId = rankedSlots.get(i);

            // Trouver le créneau correspondant dans la session
            KholleSlot slot = session.kholleSlots().stream()
                    .filter(s -> s.id().equals(slotId))
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Créneau avec l'ID " + slotId + " non trouvé dans la session " + sessionId));

            // Créer une nouvelle préférence
            UserPreference preference = UserPreference.builder()
                    .user(user)
                    .session(session)
                    .slot(slot)
                    .preferenceRank(i + 1) // Le rang commence à 1 (premier choix = rang 1)
                    .isUnavailable(false)
                    .build();

            userPreferenceRepository.save(preference);
        }
    }

    /**
     * Récupère les préférences d'un utilisateur pour une session de khôlle
     *
     * @param userId L'ID de l'utilisateur
     * @param sessionId L'ID de la session de khôlle
     * @return Liste des préférences ordonnées par rang de préférence
     */
    public List<UserPreference> getUserPreferences(Long userId, Long sessionId) {
        User user = userService
                .getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur avec l'ID " + userId + " non trouvé"));

        KholleSession session = getKholleSessionById(sessionId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Session de khôlle avec l'ID " + sessionId + " non trouvée"));

        return userPreferenceRepository.findByUserAndSessionOrderByPreferenceRankAsc(user, session);
    }

    /**
     * Vérifie si un utilisateur a déjà enregistré ses préférences pour une session
     *
     * @param userId L'ID de l'utilisateur
     * @param sessionId L'ID de la session de khôlle
     * @return true si l'utilisateur a déjà enregistré des préférences, false sinon
     */
    public boolean hasUserRegisteredPreferences(Long userId, Long sessionId) {
        User user = userService
                .getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur avec l'ID " + userId + " non trouvé"));

        KholleSession session = getKholleSessionById(sessionId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Session de khôlle avec l'ID " + sessionId + " non trouvée"));

        return userPreferenceRepository.existsByUserAndSession(user, session);
    }

    /**
     * Récupère le nombre total d'utilisateurs ayant enregistré leurs préférences pour une session
     *
     * @param sessionId L'ID de la session de khôlle
     * @return Le nombre d'utilisateurs ayant enregistré leurs préférences
     */
    public long getRegisteredUsersCount(Long sessionId) {
        KholleSession session = getKholleSessionById(sessionId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Session de khôlle avec l'ID " + sessionId + " non trouvée"));

        return userPreferenceRepository.countDistinctUsersBySession(session);
    }

    /**
     * Récupère toutes les préférences des utilisateurs pour une session, organisées par utilisateur
     *
     * @param sessionId L'ID de la session de khôlle
     * @return Map avec en clé l'utilisateur et en valeur la liste de ses préférences triées par
     *     rang
     */
    public Map<User, List<UserPreference>> getAllUserPreferencesForSession(Long sessionId) {
        KholleSession session = getKholleSessionById(sessionId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Session de khôlle avec l'ID " + sessionId + " non trouvée"));

        // Récupérer toutes les préférences pour cette session
        List<UserPreference> allPreferences =
                userPreferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session);

        // Organiser par utilisateur
        Map<User, List<UserPreference>> preferencesByUser = new LinkedHashMap<>();
        for (UserPreference preference : allPreferences) {
            preferencesByUser
                    .computeIfAbsent(preference.user(), k -> new ArrayList<>())
                    .add(preference);
        }

        return preferencesByUser;
    }

    /**
     * Récupère les créneaux indisponibles pour un utilisateur et une session (créneaux marqués
     * explicitement comme indisponibles avec isUnavailable = true)
     *
     * @param userId L'ID de l'utilisateur
     * @param sessionId L'ID de la session de khôlle
     * @return Liste des créneaux indisponibles
     */
    public List<KholleSlot> getUnavailableSlots(Long userId, Long sessionId) {
        User user = userService
                .getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur avec l'ID " + userId + " non trouvé"));

        KholleSession session = getKholleSessionById(sessionId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Session de khôlle avec l'ID " + sessionId + " non trouvée"));

        // Récupérer les préférences de l'utilisateur
        List<UserPreference> userPreferences =
                userPreferenceRepository.findByUserAndSessionOrderByPreferenceRankAsc(user, session);

        // Retourner uniquement les créneaux marqués comme indisponibles
        return userPreferences.stream()
                .filter(UserPreference::isUnavailable)
                .map(UserPreference::slot)
                .sorted(Comparator.comparing(KholleSlot::dateTime))
                .toList();
    }

    /**
     * Supprime une session de khôlle et toutes ses données associées
     *
     * @param sessionId L'ID de la session à supprimer
     */
    @Transactional
    public void deleteKholleSession(Long sessionId) {
        KholleSession session = getKholleSessionById(sessionId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Session de khôlle avec l'ID " + sessionId + " non trouvée"));

        // Les préférences et les slots seront supprimés en cascade grâce aux relations JPA
        kholleSessionRepository.delete(session);
    }

    /**
     * Modifie une session de khôlle en appliquant un patch
     *
     * @param sessionId L'ID de la session à modifier
     * @param patch Le patch contenant les modifications
     *
     * @return La session mise à jour
     */
    @Transactional
    public KholleSession edit(Long sessionId, @Validated KhollePatchDto patch) {
        KholleSession session = getKholleSessionById(sessionId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Session de khôlle avec l'ID " + sessionId + " non trouvée"));

        KholleSession updatedSession = patch.apply(session);
        return kholleSessionRepository.save(updatedSession);
    }
}
