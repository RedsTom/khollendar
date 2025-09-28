package fr.redstom.khollendar.service;

import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import fr.redstom.khollendar.dto.KhollePreferencesDto;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class KholleSlotService {

    private final KholleService kholleService;
    private final PreferenceService preferenceService;
    private final SessionService sessionService;

    @Autowired
    public KholleSlotService(KholleService kholleService, PreferenceService preferenceService, SessionService sessionService) {
        this.kholleService = kholleService;
        this.preferenceService = preferenceService;
        this.sessionService = sessionService;
    }

    /**
     * Réordonne un slot dans la liste des préférences de l'utilisateur
     * @param sessionId ID de la session de khôlle
     * @param slotId ID du slot à déplacer
     * @param direction Direction ("up" ou "down")
     * @param httpSession Session HTTP pour récupérer/stocker les préférences
     * @param model Modèle pour la vue (peut être null si utilisé avec redirection)
     * @return true si la réorganisation a réussi, false sinon
     */
    public boolean reorderSlot(Long sessionId, Long slotId, String direction, HttpSession httpSession, Model model) {
        if (slotId == null || direction == null) {
            return false;
        }

        Long userId = sessionService.getCurrentUserId(httpSession);
        if (userId == null) {
            return false;
        }

        KhollePreferencesDto preferences = sessionService.getPreferences(httpSession, sessionId);
        if (preferences == null) {
            return false;
        }

        boolean moveUp = "up".equalsIgnoreCase(direction);

        try {
            // Réordonner les créneaux
            List<KholleSlot> reorderedSlots = this.doReorderSlots(
                    sessionId, preferences.unavailableSlotIds(), slotId, moveUp);

            // Mettre à jour le modèle pour le rendu si disponible
            if (model != null) {
                model.addAttribute("availableSlots", reorderedSlots);
            }

            // Mettre à jour les préférences dans la session
            List<Long> newOrder = reorderedSlots.stream().map(KholleSlot::id).collect(Collectors.toList());
            KhollePreferencesDto updatedPrefs = preferences.withRankedSlots(newOrder);
            sessionService.savePreferences(httpSession, updatedPrefs);

            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de la réorganisation des slots : " + e.getMessage());
            return false;
        }
    }

    /**
     * Effectue le réordonnancement des slots
     */
    private List<KholleSlot> doReorderSlots(Long kholleId, List<Long> unavailableSlotIds,
                                          Long slotIdToMove, boolean moveUp) {
        // Récupérer la session de khôlle
        KholleSession kholleSession = kholleService.getKholleSessionById(kholleId)
                .orElseThrow(() -> new IllegalArgumentException("Session de khôlle non trouvée"));

        // Récupérer tous les créneaux disponibles
        List<KholleSlot> allSlots = new ArrayList<>(kholleSession.kholleSlots());
        List<Long> finalUnavailableSlots = unavailableSlotIds != null ? unavailableSlotIds : new ArrayList<>();

        // Filtrer les slots disponibles et les trier par date
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
        if (moveUp && currentIndex > 0) {
            Collections.swap(availableSlots, currentIndex, currentIndex - 1);
        } else if (!moveUp && currentIndex >= 0 && currentIndex < availableSlots.size() - 1) {
            Collections.swap(availableSlots, currentIndex, currentIndex + 1);
        }

        return availableSlots;
    }

    /**
     * Prépare le formulaire de classement des slots pour l'affichage
     */
    public void prepareSlotRankingView(Long sessionId, Long userId, List<Long> unavailableSlotIds,
                                      List<Long> rankedSlotIds, Model model) {
        preferenceService.prepareRankingForm(sessionId, userId, unavailableSlotIds, rankedSlotIds, model);
    }
}
