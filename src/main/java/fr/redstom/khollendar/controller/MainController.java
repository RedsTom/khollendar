package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.service.KholleService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final KholleService kholleService;

    /**
     * Page d'accueil. Affiche le fonctionnement de l'application et les prochaines kholles.
     */
    @GetMapping("/")
    public String index(Model model, CsrfToken csrf) {
        List<KholleSession> upcomingSessions = kholleService.getUpcomingKholleSessions(0, 5).getContent();

        model.addAttribute("title", "Accueil");
        model.addAttribute("upcomingSessions", upcomingSessions);
        model.addAttribute("_csrf", csrf);

        return "pages/index";
    }
}
