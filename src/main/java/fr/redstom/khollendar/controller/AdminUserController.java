package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.UserCreationDto;
import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final UserService userService;

    @GetMapping
    public String listUsers(
            @RequestParam(defaultValue = "0") int page,
            CsrfToken csrf,
            Model model
    ) {
        Page<User> users = userService.getPaginatedUsers(page, 10);

        model.addAttribute("title", "Gestion des utilisateurs");
        model.addAttribute("users", users);
        model.addAttribute("currentPage", page);
        model.addAttribute("newUser", new UserCreationDto());
        model.addAttribute("_csrf", csrf);

        return "admin/users/list";
    }

    @PostMapping
    public String createUser(
            @Validated @ModelAttribute("newUser") UserCreationDto userDto,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model,
            CsrfToken csrf
    ) {
        if (bindingResult.hasErrors()) {
            Page<User> users = userService.getPaginatedUsers(0, 10);

            model.addAttribute("title", "Gestion des utilisateurs");
            model.addAttribute("users", users);
            model.addAttribute("currentPage", 0);
            model.addAttribute("_csrf", csrf);

            return "admin/users/list";
        }

        try {
            User user = userService.createUser(userDto.username());
            redirectAttributes.addFlashAttribute("success", "Utilisateur " + user.username() + " créé avec succès");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/admin/users";
    }
}
