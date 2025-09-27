package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.KholleSessionCreationDto;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.service.KholleService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/kholles")
@RequiredArgsConstructor
public class KholleSessionController {

    private final KholleService kholleService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "0") int previousPage,
            @RequestParam(defaultValue = "0") int upcomingPage,
            @RequestParam(defaultValue = "0") int allPage,
            CsrfToken csrf,
            Model model
    ) {
        model.addAttribute("title", "Liste des sessions de khôlles");

        // Configuration de la pagination avec les tailles demandées
        Page<KholleSession> previousSessions = kholleService.getPreviousKholleSessions(previousPage, 5);
        Page<KholleSession> upcomingSessions = kholleService.getUpcomingKholleSessions(upcomingPage, 5);
        Page<KholleSession> allSessions = kholleService.getAllKholleSessions(allPage, 10);

        // Ajout des données paginées au modèle
        model.addAttribute("previousSessions", previousSessions);
        model.addAttribute("upcomingSessions", upcomingSessions);
        model.addAttribute("allSessions", allSessions);

        // Paramètres de pagination pour la construction des liens dans la vue
        model.addAttribute("previousPage", previousPage);
        model.addAttribute("upcomingPage", upcomingPage);
        model.addAttribute("allPage", allPage);

        model.addAttribute("_csrf", csrf);

        return "kholles/list";
    }

    @GetMapping("/create")
    public String createForm(CsrfToken csrf, Model model) {
        model.addAttribute("title", "Créer une session de khôlles");
        model.addAttribute("_csrf", csrf);

        return "kholles/create";
    }

    @PostMapping("/create")
    public String create(@ModelAttribute KholleSessionCreationDto dto) {
        kholleService.createKholle(dto);
        return "redirect:/kholles";
    }
}
