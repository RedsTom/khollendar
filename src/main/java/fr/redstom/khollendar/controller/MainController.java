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
