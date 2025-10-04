package fr.redstom.khollendar.dto;

import java.util.ArrayList;
import java.util.List;

/** Data Transfer Object pour gérer les préférences utilisateur sur une session de khôlle */
public record KhollePreferencesDto(
        Long kholleSessionId, List<Long> unavailableSlotIds, List<Long> rankedSlotIds, int step) {
    /** Constructeur avec valeurs par défaut */
    public KhollePreferencesDto(Long kholleSessionId) {
        this(kholleSessionId, new ArrayList<>(), new ArrayList<>(), 1);
    }

    /** Avance à l'étape suivante */
    public KhollePreferencesDto nextStep() {
        return new KhollePreferencesDto(
                kholleSessionId, unavailableSlotIds, rankedSlotIds, step + 1);
    }

    /** Revient à l'étape précédente */
    public KhollePreferencesDto previousStep() {
        return new KhollePreferencesDto(
                kholleSessionId, unavailableSlotIds, rankedSlotIds, Math.max(1, step - 1));
    }

    /** Met à jour les créneaux indisponibles */
    public KhollePreferencesDto withUnavailableSlots(List<Long> newUnavailableSlotIds) {
        return new KhollePreferencesDto(
                kholleSessionId,
                newUnavailableSlotIds != null ? newUnavailableSlotIds : new ArrayList<>(),
                rankedSlotIds,
                step);
    }

    /** Met à jour les créneaux classés par préférence */
    public KhollePreferencesDto withRankedSlots(List<Long> newRankedSlotIds) {
        return new KhollePreferencesDto(
                kholleSessionId,
                unavailableSlotIds,
                newRankedSlotIds != null ? newRankedSlotIds : new ArrayList<>(),
                step);
    }
}
