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

import fr.redstom.khollendar.dto.KhollePreferencesDto;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;

/** Service responsable de la gestion des sessions HTTP */
@Service
public class SessionService {

    public static final String SESSION_USER_ID = "selectedUserId";
    public static final String SESSION_PREFERENCES = "khollePreferences";
    public static final String REDIRECT_AFTER_LOGIN = "redirectAfterLogin";

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
        KhollePreferencesDto preferences = (KhollePreferencesDto) session.getAttribute(SESSION_PREFERENCES);
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
