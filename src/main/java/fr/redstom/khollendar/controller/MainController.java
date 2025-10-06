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

import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.service.KholleService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final KholleService kholleService;

    /** Page d'accueil. Affiche le fonctionnement de l'application et les prochaines kholles. */
    @GetMapping("/")
    public String index(Model model) {
        List<KholleSession> upcomingSessions =
                kholleService.getUpcomingKholleSessions(0, 5).getContent();

        model.addAttribute("title", "Accueil");
        model.addAttribute("upcomingSessions", upcomingSessions);

        return "pages/index";
    }
}
