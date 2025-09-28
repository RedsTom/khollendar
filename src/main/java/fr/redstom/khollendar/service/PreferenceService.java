package fr.redstom.khollendar.service;

import fr.redstom.khollendar.dto.KhollePreferencesDto;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import fr.redstom.khollendar.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Service responsable de la gestion des préférences des utilisateurs pour les khôlles
 */
@Service
@RequiredArgsConstructor
public class PreferenceService {

    private final KholleService kholleService;
    private final UserService userService;

    /**
     * Prépare les données pour le formulaire d'indisponibilités (étape 1)
     */
    public void prepareUnavailabilityForm(Long kholleId, Long userId, Model model, List<Long> unavailableSlotIds) {
        // Récupérer l'utilisateur et la session de khôlle
        User user = userService.getUserById(userId).orElseThrow(() ->
            new IllegalArgumentException("Utilisateur non trouvé"));

        KholleSession kholleSession = kholleService.getKholleSessionById(kholleId).orElseThrow(() ->
            new IllegalArgumentException("Session de khôlle non trouvée"));

        List<KholleSlot> slots = new ArrayList<>(kholleSession.kholleSlots());

        // Préparer les données pour la vue
        model.addAttribute("title", "Mes disponibilités pour " + kholleSession.subject());
        model.addAttribute("session", kholleSession);
        model.addAttribute("slots", slots);
        model.addAttribute("currentUser", user);
        model.addAttribute("unavailableSlotIds", unavailableSlotIds);
    }

    /**
     * Prépare les données pour le formulaire de classement des préférences (étape 2)
     */
    public void prepareRankingForm(Long kholleId, Long userId, List<Long> unavailableSlotIds,
                                  List<Long> rankedSlotIds, Model model) {
        // Récupérer l'utilisateur et la session de khôlle
        User user = userService.getUserById(userId).orElseThrow(() ->
            new IllegalArgumentException("Utilisateur non trouvé"));

        KholleSession kholleSession = kholleService.getKholleSessionById(kholleId).orElseThrow(() ->
            new IllegalArgumentException("Session de khôlle non trouvée"));

        List<KholleSlot> slots = new ArrayList<>(kholleSession.kholleSlots());

        // Filtrer pour ne garder que les créneaux disponibles (non cochés comme indisponibles)
        List<Long> finalUnavailableSlots = unavailableSlotIds != null ? unavailableSlotIds : new ArrayList<>();
        List<KholleSlot> availableSlots = slots.stream()
                .filter(slot -> !finalUnavailableSlots.contains(slot.id()))
                .sorted(Comparator.comparing(KholleSlot::dateTime))
                .collect(Collectors.toList());

        // Si des préférences de classement sont déjà enregistrées, réorganiser les créneaux
        if (rankedSlotIds != null && !rankedSlotIds.isEmpty()) {
            // Réorganiser les créneaux disponibles selon le classement précédent
            availableSlots.sort(Comparator.comparing(slot -> {
                int index = rankedSlotIds.indexOf(slot.id());
                return index >= 0 ? index : Integer.MAX_VALUE;
            }));
        }

        // Préparer les données pour la vue de classement des préférences (étape 2)
        model.addAttribute("title", "Classement de mes préférences pour " + kholleSession.subject());
        model.addAttribute("session", kholleSession);
        model.addAttribute("availableSlots", availableSlots);
        model.addAttribute("currentUser", user);
    }

    /**
     * Prépare les données pour la page de confirmation des préférences (étape 3)
     */
    public void prepareConfirmationForm(Long kholleId, Long userId, List<Long> unavailableSlotIds,
                                       List<Long> rankedSlotIds, Model model) {
        // Récupérer l'utilisateur et la session de khôlle
        User user = userService.getUserById(userId).orElseThrow(() ->
            new IllegalArgumentException("Utilisateur non trouvé"));

        KholleSession kholleSession = kholleService.getKholleSessionById(kholleId).orElseThrow(() ->
            new IllegalArgumentException("Session de khôlle non trouvée"));

        // Récupérer tous les créneaux de la khôlle
        List<KholleSlot> allSlots = new ArrayList<>(kholleSession.kholleSlots());
        allSlots.sort(Comparator.comparing(KholleSlot::dateTime));

        // Convertir les IDs des créneaux indisponibles en objets KholleSlot
        Set<KholleSlot> unavailableSlots = allSlots.stream()
                .filter(slot -> unavailableSlotIds != null && unavailableSlotIds.contains(slot.id()))
                .collect(Collectors.toSet());

        // Convertir les IDs des créneaux classés en objets KholleSlot (dans l'ordre)
        List<KholleSlot> rankedSlotsObjects = Optional.ofNullable(rankedSlotIds)
                .orElse(new ArrayList<>()).stream()
                .map(slotId -> allSlots.stream()
                        .filter(s -> s.id().equals(slotId))
                        .findFirst()
                        .orElse(null))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        // Préparer les données pour la vue de confirmation (étape 3)
        model.addAttribute("title", "Confirmation des préférences pour " + kholleSession.subject());
        model.addAttribute("session", kholleSession);
        model.addAttribute("currentUser", user);
        model.addAttribute("rankedSlots", rankedSlotsObjects);
        model.addAttribute("unavailableSlots", unavailableSlots);
        model.addAttribute("allSlots", allSlots);
    }

    /**
     * Réorganise les créneaux selon la direction souhaitée (haut ou bas)
     * @return La liste réorganisée des créneaux
     */
    public List<KholleSlot> reorderSlots(Long kholleId, Long userId, List<Long> unavailableSlotIds,
                                         Long slotIdToMove, boolean moveUp) {
        // Récupérer la session de khôlle
        KholleSession kholleSession = kholleService.getKholleSessionById(kholleId).orElseThrow(() ->
            new IllegalArgumentException("Session de khôlle non trouvée"));

        // Récupérer tous les créneaux disponibles
        List<KholleSlot> allSlots = new ArrayList<>(kholleSession.kholleSlots());
        List<Long> finalUnavailableSlots = unavailableSlotIds != null ? unavailableSlotIds : new ArrayList<>();
        List<KholleSlot> availableSlots = allSlots.stream()
                .filter(slot -> !finalUnavailableSlots.contains(slot.id()))
                .sorted(Comparator.comparing(KholleSlot::dateTime))
                .collect(Collectors.toList());

        // Trouver l'index du créneau à déplacer
        int currentIndex = -1;
        for (int i = 0; i < availableSlots.size(); i++) {
            if (availableSlots.get(i).id().equals(slotIdToMove)) {
                currentIndex = i;
                break;
            }
        }

        // Si l'index est valide, échanger les positions
        if (moveUp && currentIndex > 0 && currentIndex < availableSlots.size()) {
            Collections.swap(availableSlots, currentIndex, currentIndex - 1);
        } else if (!moveUp && currentIndex >= 0 && currentIndex < availableSlots.size() - 1) {
            Collections.swap(availableSlots, currentIndex, currentIndex + 1);
        }

        return availableSlots;
    }

    /**
     * Enregistre les préférences utilisateur pour une khôlle
     */
    public void savePreferences(Long userId, Long kholleId, List<Long> unavailableSlotIds, List<Long> rankedSlotIds) {
        // Déléguer l'enregistrement au KholleService
        kholleService.savePreferences(userId, kholleId,
            unavailableSlotIds != null ? unavailableSlotIds : new ArrayList<>(),
            rankedSlotIds != null ? rankedSlotIds : new ArrayList<>());
    }
}
