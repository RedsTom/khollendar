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

import fr.redstom.khollendar.entity.User;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
@RequiredArgsConstructor
public class UserAuthService {

    private final UserService userService;

    public String prepareUserSelectionFragment(Model model) {
        List<User> allUsers = userService.getAllUsers();
        model.addAttribute("users", allUsers);

        return "fragments/auth/UserSelectionForm";
    }

    public String prepareUserSelectionFragment(Model model, String error) {
        String fragment = prepareUserSelectionFragment(model);
        model.addAttribute("error", error);

        return fragment;
    }

    public String prepareCodeInitializationFragment(Model model, User user) {
        model.addAttribute("username", user.username());
        model.addAttribute("cardTitle", "Définir votre code secret");
        model.addAttribute("formAction", "/user/initialize-code");
        model.addAttribute("inputLabel", "Nouveau code secret (6 chiffres)");
        model.addAttribute("inputHelpText", "Votre code doit être composé de 6 chiffres uniquement.");
        model.addAttribute("submitButtonText", "Définir mon code");
        model.addAttribute("warningMessage", "C'est votre première connexion. Vous devez définir un code secret.");

        return "fragments/auth/UserCodeForm";
    }

    public String prepareCodeInitializationFragment(Model model, User user, String error) {
        String fragment = prepareCodeInitializationFragment(model, user);
        model.addAttribute("error", error);

        return fragment;
    }

    public String prepareCodeEntryFragment(Model model, User user) {
        model.addAttribute("username", user.username());
        model.addAttribute("cardTitle", "Connexion utilisateur");
        model.addAttribute("formAction", "/user/enter-code");
        model.addAttribute("inputLabel", "Code secret (6 chiffres)");
        model.addAttribute("submitButtonText", "Se connecter");

        return "fragments/auth/UserCodeForm";
    }

    public String prepareCodeEntryFragment(Model model, User user, String error) {
        String fragment = prepareCodeEntryFragment(model, user);
        model.addAttribute("error", error);

        return fragment;
    }
}
