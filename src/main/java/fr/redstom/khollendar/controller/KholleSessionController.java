package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.KholleSessionCreationDto;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.service.KholleService;
import fr.redstom.khollendar.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

@Controller
@RequestMapping("/kholles")
@RequiredArgsConstructor
public class KholleSessionController {

    private final KholleService kholleService;
    private final UserService userService;

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

        return "pages/kholles/list";
    }

    @GetMapping("/create")
    public String createForm(CsrfToken csrf, Model model) {
        model.addAttribute("title", "Créer une session de khôlles");
        model.addAttribute("_csrf", csrf);

        return "pages/kholles/create";
    }

    @PostMapping("/create")
    public String create(@ModelAttribute KholleSessionCreationDto dto) {
        kholleService.createKholle(dto);
        return "redirect:/kholles";
    }

    @GetMapping("/{id}")
    public String show(@PathVariable Long id, CsrfToken csrf, Model model) {
        Optional<KholleSession> session = kholleService.getKholleSessionById(id);

        if(session.isEmpty()) {
            return "redirect:/kholles";
        }

        model.addAttribute("title", "Détails de la session de khôlle");
        model.addAttribute("session", session.get());
        model.addAttribute("_csrf", csrf);
        return "pages/kholles/show";
    }

    @GetMapping("/{id}/preferences")
    public String preferencesForm(@PathVariable Long id, HttpSession session, CsrfToken csrf, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        // Vérifier si l'utilisateur est authentifié
        Long userId = (Long) session.getAttribute("selectedUserId");
        if (userId == null) {
            // Si l'utilisateur n'est pas authentifié, sauvegarder l'URL de redirection et envoyer vers la page de connexion
            session.setAttribute("redirectAfterLogin", request.getRequestURI());
            return "redirect:/user-auth/select";
        }

        // Récupérer l'utilisateur et la session de khôlle
        Optional<User> optionalUser = userService.getUserById(userId);
        Optional<KholleSession> optionalKholleSession = kholleService.getKholleSessionById(id);

        if (optionalUser.isEmpty() || optionalKholleSession.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Utilisateur ou session de khôlle non trouvée");
            return "redirect:/kholles";
        }

        User user = optionalUser.get();
        KholleSession kholleSession = optionalKholleSession.get();
        List<KholleSlot> slots = new ArrayList<>(kholleSession.kholleSlots());

        // Préparer les données pour la vue
        model.addAttribute("title", "Mes disponibilités pour " + kholleSession.subject());
        model.addAttribute("session", kholleSession);
        model.addAttribute("slots", slots);
        model.addAttribute("currentUser", user);
        model.addAttribute("slotPreferences", new HashMap<String, String>());
        model.addAttribute("_csrf", csrf);

        return "pages/kholles/preferences";
    }

    @PostMapping("/{id}/preferences")
    public String savePreferences(
            @PathVariable Long id,
            HttpSession session,
            @RequestParam Map<String, String> formData,
            RedirectAttributes redirectAttributes
    ) {
        // Pour l'instant, nous ne faisons que simuler l'enregistrement des préférences
        // Dans une implémentation complète, nous sauvegarderions ces données dans la base de données
        redirectAttributes.addFlashAttribute("success", "Vos disponibilités ont été enregistrées avec succès!");
        return "redirect:/kholles/" + id;
    }
}
