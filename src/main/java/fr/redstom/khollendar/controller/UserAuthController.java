package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.SecretCodeDto;
import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/user-auth")
@RequiredArgsConstructor
public class UserAuthController {

    private final UserService userService;

    // Étape 1 : Sélection de l'utilisateur
    @GetMapping("/select")
    public String selectUser(CsrfToken csrf, Model model) {
        List<User> users = userService.getAllUsers();
        
        model.addAttribute("title", "Connexion utilisateur");
        model.addAttribute("users", users);
        model.addAttribute("_csrf", csrf);
        
        return "pages/user/login/select";
    }

    // Étape 2 : Entrée ou définition du code secret
    @PostMapping("/select")
    public String processUserSelection(@RequestParam Long userId, HttpSession session, RedirectAttributes redirectAttributes) {
        Optional<User> optionalUser = userService.getUserById(userId);
        
        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Utilisateur non trouvé");
            return "redirect:/user-auth/select";
        }
        
        User user = optionalUser.get();
        session.setAttribute("selectedUserId", userId);
        
        if (user.codeInitialized()) {
            return "redirect:/user-auth/enter-code";
        } else {
            return "redirect:/user-auth/initialize-code";
        }
    }

    // Entrer le code secret (si déjà initialisé)
    @GetMapping("/enter-code")
    public String enterCodeForm(HttpSession session, CsrfToken csrf, Model model, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("selectedUserId");
        if (userId == null) {
            redirectAttributes.addFlashAttribute("error", "Veuillez sélectionner un utilisateur");
            return "redirect:/user-auth/select";
        }
        
        Optional<User> optionalUser = userService.getUserById(userId);
        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Utilisateur non trouvé");
            return "redirect:/user-auth/select";
        }
        
        User user = optionalUser.get();
        if (!user.codeInitialized()) {
            return "redirect:/user-auth/initialize-code";
        }
        
        model.addAttribute("title", "Entrer votre code secret");
        model.addAttribute("username", user.username());
        model.addAttribute("_csrf", csrf);
        
        return "pages/user/login/enter-code";
    }

    // Traiter l'entrée du code secret
    @PostMapping("/enter-code")
    public String processEnterCode(
            @Validated @ModelAttribute SecretCodeDto secretCodeDto,
            BindingResult bindingResult,
            HttpSession session,
            CsrfToken csrf,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Long userId = (Long) session.getAttribute("selectedUserId");
        if (userId == null) {
            redirectAttributes.addFlashAttribute("error", "Veuillez sélectionner un utilisateur");
            return "redirect:/user-auth/select";
        }
        
        Optional<User> optionalUser = userService.getUserById(userId);
        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Utilisateur non trouvé");
            return "redirect:/user-auth/select";
        }
        
        User user = optionalUser.get();
        
        if (bindingResult.hasErrors()) {
            model.addAttribute("title", "Entrer votre code secret");
            model.addAttribute("username", user.username());
            model.addAttribute("_csrf", csrf);
            return "pages/user/login/enter-code";
        }
        
        if (!userService.isValidSecretCode(user, secretCodeDto.secretCode())) {
            model.addAttribute("title", "Entrer votre code secret");
            model.addAttribute("username", user.username());
            model.addAttribute("error", "Code secret invalide");
            model.addAttribute("_csrf", csrf);
            return "pages/user/login/enter-code";
        }
        
        // Authentification réussie
        session.setAttribute("authenticatedUserId", userId);
        redirectAttributes.addFlashAttribute("success", "Connexion réussie");
        return "redirect:/kholles"; // Redirection vers la page principale après connexion
    }

    // Initialiser le code secret (première utilisation)
    @GetMapping("/initialize-code")
    public String initializeCodeForm(HttpSession session, CsrfToken csrf, Model model, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("selectedUserId");
        if (userId == null) {
            redirectAttributes.addFlashAttribute("error", "Veuillez sélectionner un utilisateur");
            return "redirect:/user-auth/select";
        }
        
        Optional<User> optionalUser = userService.getUserById(userId);
        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Utilisateur non trouvé");
            return "redirect:/user-auth/select";
        }
        
        User user = optionalUser.get();
        if (user.codeInitialized()) {
            return "redirect:/user-auth/enter-code";
        }
        
        model.addAttribute("title", "Définir votre code secret");
        model.addAttribute("username", user.username());
        model.addAttribute("_csrf", csrf);
        
        return "pages/user/login/initialize-code";
    }

    // Traiter l'initialisation du code secret
    @PostMapping("/initialize-code")
    public String processInitializeCode(
            @Validated @ModelAttribute SecretCodeDto secretCodeDto,
            BindingResult bindingResult,
            HttpSession session,
            CsrfToken csrf,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Long userId = (Long) session.getAttribute("selectedUserId");
        if (userId == null) {
            redirectAttributes.addFlashAttribute("error", "Veuillez sélectionner un utilisateur");
            return "redirect:/user-auth/select";
        }
        
        Optional<User> optionalUser = userService.getUserById(userId);
        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Utilisateur non trouvé");
            return "redirect:/user-auth/select";
        }
        
        User user = optionalUser.get();
        
        if (bindingResult.hasErrors()) {
            model.addAttribute("title", "Définir votre code secret");
            model.addAttribute("username", user.username());
            model.addAttribute("_csrf", csrf);
            return "pages/user/login/initialize-code";
        }
        
        try {
            userService.setSecretCode(user, secretCodeDto.secretCode());
            // Authentification réussie après initialisation
            session.setAttribute("authenticatedUserId", userId);
            redirectAttributes.addFlashAttribute("success", "Code secret défini avec succès");
            return "redirect:/"; // Redirection vers la page principale après connexion
        } catch (IllegalArgumentException e) {
            model.addAttribute("title", "Définir votre code secret");
            model.addAttribute("username", user.username());
            model.addAttribute("error", e.getMessage());
            model.addAttribute("_csrf", csrf);
            return "pages/user/login/initialize-code";
        }
    }
}
