package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.SecretCodeDto;
import fr.redstom.khollendar.entity.User;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/user-auth")
@RequiredArgsConstructor
public class UserAuthController {

    private final UserService userService;

    // Étape 1 : Sélection de l'utilisateur
    @GetMapping("/select")
    public String selectUser(
            @RequestParam(required = false) String redirectTo,
            HttpSession httpSession,
            Model model) {
        List<User> users = userService.getAllUsers();

        // Stocker l'URL de redirection dans la session si elle est présente
        if (redirectTo != null && !redirectTo.isEmpty()) {
            httpSession.setAttribute("redirectAfterLogin", redirectTo);
        }

        model.addAttribute("title", "Connexion utilisateur");
        model.addAttribute("users", users);

        return "pages/user/login/select";
    }

    // Étape 2 : Entrée ou définition du code secret
    @PostMapping("/select")
    public String processUserSelection(
            @RequestParam Long userId, HttpSession session, RedirectAttributes redirectAttributes) {
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
    public String enterCodeForm(
            HttpSession session, Model model, RedirectAttributes redirectAttributes) {
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

        return "pages/user/login/enter-code";
    }

    // Traiter l'entrée du code secret
    @PostMapping("/enter-code")
    public String processEnterCode(
            @Validated @ModelAttribute SecretCodeDto secretCodeDto,
            BindingResult bindingResult,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
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
            return "pages/user/login/enter-code";
        }

        if (!userService.isValidSecretCode(user, secretCodeDto.secretCode())) {
            model.addAttribute("title", "Entrer votre code secret");
            model.addAttribute("username", user.username());
            model.addAttribute("error", "Code secret invalide");
            return "pages/user/login/enter-code";
        }

        // Authentification réussie
        session.setAttribute("authenticatedUserId", userId);
        redirectAttributes.addFlashAttribute("success", "Connexion réussie");

        // Rediriger vers l'URL stockée dans la session si elle existe
        String redirectTo = (String) session.getAttribute("redirectAfterLogin");
        if (redirectTo != null && !redirectTo.isEmpty()) {
            session.removeAttribute(
                    "redirectAfterLogin"); // Supprimer l'URL de redirection après utilisation
            return "redirect:" + redirectTo;
        } else {
            return "redirect:/kholles"; // Redirection par défaut
        }
    }

    // Initialiser le code secret (première utilisation)
    @GetMapping("/initialize-code")
    public String initializeCodeForm(
            HttpSession session, Model model, RedirectAttributes redirectAttributes) {
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

        return "pages/user/login/initialize-code";
    }

    // Traiter l'initialisation du code secret
    @PostMapping("/initialize-code")
    public String processInitializeCode(
            @Validated @ModelAttribute SecretCodeDto secretCodeDto,
            BindingResult bindingResult,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {
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
            return "pages/user/login/initialize-code";
        }

        try {
            userService.setSecretCode(user, secretCodeDto.secretCode());
            // Authentification réussie après initialisation
            session.setAttribute("authenticatedUserId", userId);
            redirectAttributes.addFlashAttribute("success", "Code secret défini avec succès");

            // Rediriger vers l'URL stockée dans la session si elle existe
            String redirectTo = (String) session.getAttribute("redirectAfterLogin");
            if (redirectTo != null && !redirectTo.isEmpty()) {
                session.removeAttribute(
                        "redirectAfterLogin"); // Supprimer l'URL de redirection après utilisation
                return "redirect:" + redirectTo;
            } else {
                return "redirect:/"; // Redirection par défaut
            }
        } catch (IllegalArgumentException e) {
            model.addAttribute("title", "Définir votre code secret");
            model.addAttribute("username", user.username());
            model.addAttribute("error", e.getMessage());

            return "pages/user/login/initialize-code";
        }
    }
}
