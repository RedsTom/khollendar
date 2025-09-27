package fr.redstom.khollesmanager.controller;

import fr.redstom.khollesmanager.service.KholleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final KholleService kholleService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("title", "Accueil");
        model.addAttribute("content", "Bienvenue sur KhollesManager, votre application de gestion de khôlles !");

        // Récupération des 5 prochaines sessions de khôlle
        model.addAttribute("upcomingSessions", kholleService.getUpcomingKholleSessions(0, 5).getContent());

        return "index";
    }

}
