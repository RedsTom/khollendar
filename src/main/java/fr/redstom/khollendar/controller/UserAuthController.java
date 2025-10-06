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
package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.SecretCodeDto;
import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.service.SessionService;
import fr.redstom.khollendar.service.UserAuthService;
import fr.redstom.khollendar.service.UserService;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserAuthController {

    private final UserService userService;
    private final UserAuthService userAuthService;

    // Étape 1 : Sélection de l'utilisateur
    @GetMapping("/login")
    public String selectUser(@RequestParam(required = false) String redirectTo, HttpSession httpSession, Model model) {
        List<User> users = userService.getAllUsers();

        // Stocker l'URL de redirection dans la session si elle est présente
        if (redirectTo != null && !redirectTo.isEmpty()) {
            httpSession.setAttribute(SessionService.REDIRECT_AFTER_LOGIN, redirectTo);
        }

        model.addAttribute("users", users);

        return "pages/user/login";
    }

    // Étape 2 : Entrée ou définition du code secret
    @PostMapping("/select")
    public String processUserSelection(@RequestParam Long userId, HttpSession session, Model model) {
        Optional<User> optionalUser = userService.getUserById(userId);

        if (optionalUser.isEmpty()) {
            List<User> users = userService.getAllUsers();
            return userAuthService.prepareUserSelectionFragment(model, "L'utilisateur sélectionné est invalide.");
        }

        User user = optionalUser.get();
        session.setAttribute("selectedUserId", userId);

        if (user.codeInitialized()) {
            return userAuthService.prepareCodeEntryFragment(model, user);
        } else {
            return userAuthService.prepareCodeInitializationFragment(model, user);
        }
    }

    // Traiter l'entrée du code secret
    @PostMapping("/enter-code")
    public String processEnterCode(
            @Validated @ModelAttribute SecretCodeDto secretCodeDto,
            BindingResult bindingResult,
            HttpSession session,
            Model model) {
        Long userId = (Long) session.getAttribute(SessionService.SESSION_USER_ID);
        if (userId == null) {
            return userAuthService.prepareUserSelectionFragment(
                    model, "Votre session a expiré. Veuillez sélectionner à nouveau votre utilisateur.");
        }

        Optional<User> optionalUser = userService.getUserById(userId);
        if (optionalUser.isEmpty()) {
            return userAuthService.prepareUserSelectionFragment(model, "L'utilisateur sélectionné est invalide.");
        }

        User user = optionalUser.get();

        if (bindingResult.hasErrors() || !userService.isValidSecretCode(user, secretCodeDto.secretCode())) {
            return userAuthService.prepareCodeEntryFragment(model, user, "Code secret invalide");
        }

        // Authentification réussie
        session.setAttribute("authenticatedUserId", userId);

        // Rediriger vers l'URL stockée dans la session si elle existe
        String redirectTo = (String) session.getAttribute("redirectAfterLogin");
        if (redirectTo != null && !redirectTo.isEmpty()) {
            session.removeAttribute("redirectAfterLogin"); // Supprimer l'URL de redirection après utilisation
            return "redirect:" + redirectTo;
        } else {
            return "redirect:/"; // Redirection par défaut
        }
    }

    // Traiter l'initialisation du code secret
    @PostMapping("/initialize-code")
    public String processInitializeCode(
            @Validated @ModelAttribute SecretCodeDto secretCodeDto,
            BindingResult bindingResult,
            HttpSession session,
            Model model) {
        // TODO: Sécurité douteuse
        Long userId = (Long) session.getAttribute(SessionService.SESSION_USER_ID);
        if (userId == null) {
            return userAuthService.prepareUserSelectionFragment(
                    model, "Votre session a expiré. Veuillez sélectionner à nouveau votre utilisateur.");
        }

        Optional<User> optionalUser = userService.getUserById(userId);
        if (optionalUser.isEmpty()) {
            return userAuthService.prepareUserSelectionFragment(model, "L'utilisateur sélectionné est invalide.");
        }

        User user = optionalUser.get();

        if (bindingResult.hasErrors()) {
            return userAuthService.prepareCodeInitializationFragment(
                    model, user, "Le code secret doit être composé de 6 chiffres.");
        }

        try {
            userService.setSecretCode(user, secretCodeDto.secretCode());

            // Authentification réussie après initialisation
            session.setAttribute("authenticatedUserId", userId);

            // Rediriger vers l'URL stockée dans la session si elle existe
            String redirectTo = (String) session.getAttribute("redirectAfterLogin");
            if (redirectTo != null && !redirectTo.isEmpty()) {
                session.removeAttribute("redirectAfterLogin"); // Supprimer l'URL de redirection après utilisation
                return "redirect:" + redirectTo;
            } else {
                return "redirect:/"; // Redirection par défaut
            }
        } catch (IllegalArgumentException e) {
            return userAuthService.prepareCodeInitializationFragment(model, user, e.getMessage());
        }
    }
}
