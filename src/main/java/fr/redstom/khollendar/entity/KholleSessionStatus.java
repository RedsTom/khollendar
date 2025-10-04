package fr.redstom.khollendar.entity;

/**
 * Énumération représentant les différents états possibles d'une session de khôlle
 */
public enum KholleSessionStatus {
    /**
     * Les inscriptions sont ouvertes, les utilisateurs peuvent enregistrer leurs préférences
     */
    REGISTRATIONS_OPEN("Inscriptions ouvertes"),

    /**
     * Les inscriptions sont fermées, les utilisateurs ne peuvent plus modifier leurs préférences
     */
    REGISTRATIONS_CLOSED("Inscriptions fermées"),

    /**
     * Les résultats sont disponibles, les affectations ont été effectuées
     */
    RESULTS_AVAILABLE("Résultats disponibles");

    private final String label;

    KholleSessionStatus(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}

