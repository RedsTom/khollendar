package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.service.KholleService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final KholleService kholleService;

    @GetMapping("/")
    public String index(CsrfToken csrf, Model model) {
        model.addAttribute("title", "Accueil");
        model.addAttribute("content", "Bienvenue sur Khôlle'n'dar, votre application de gestion de khôlles !");

        model.addAttribute("upcomingSessions", kholleService.getUpcomingKholleSessions(0, 5).getContent());

        model.addAttribute("_csrf", csrf);

        return "index";
    }

}
