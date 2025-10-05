package fr.redstom.khollendar.service;

import fr.redstom.khollendar.dto.KhollePreferencesDto;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;

/** Service responsable de la gestion des sessions HTTP */
@Service
public class SessionService {

    private static final String SESSION_USER_ID = "selectedUserId";
    private static final String SESSION_PREFERENCES = "khollePreferences";
    private static final String REDIRECT_AFTER_LOGIN = "redirectAfterLogin";

    /**
     * Récupère l'ID de l'utilisateur connecté depuis la session
     *
     * @return l'ID de l'utilisateur ou null s'il n'est pas connecté
     */
    public Long getCurrentUserId(HttpSession session) {
        return (Long) session.getAttribute(SESSION_USER_ID);
    }

    /** Vérifie si l'utilisateur est connecté */
    public boolean isUserAuthenticated(HttpSession session) {
        return getCurrentUserId(session) != null;
    }

    /** Enregistre l'URL de redirection après connexion */
    public void setRedirectAfterLogin(HttpSession session, String redirectUrl) {
        session.setAttribute(REDIRECT_AFTER_LOGIN, redirectUrl);
    }

    /** Enregistre les préférences dans la session */
    public void savePreferences(HttpSession session, KhollePreferencesDto preferences) {
        session.setAttribute(SESSION_PREFERENCES, preferences);
    }

    /** Récupère les préférences depuis la session */
    public KhollePreferencesDto getPreferences(HttpSession session, Long kholleId) {
        KhollePreferencesDto preferences =
                (KhollePreferencesDto) session.getAttribute(SESSION_PREFERENCES);
        if (preferences == null || !preferences.kholleSessionId().equals(kholleId)) {
            preferences = new KhollePreferencesDto(kholleId);
        }
        return preferences;
    }

    /** Réinitialise complètement la session utilisateur */
    public void clearUserSession(HttpSession session) {
        session.removeAttribute(SESSION_USER_ID);
        session.removeAttribute(SESSION_PREFERENCES);
        session.removeAttribute(REDIRECT_AFTER_LOGIN);
    }
}
