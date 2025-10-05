package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.UserCreationDto;
import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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
    public String listUsers(@RequestParam(defaultValue = "0") int page, Model model) {
        Page<User> users = userService.getPaginatedUsers(page, 10);

        model.addAttribute("title", "Gestion des utilisateurs");
        model.addAttribute("users", users);
        model.addAttribute("currentPage", page);

        return "pages/admin/users/list";
    }

    @PostMapping
    public String createUser(
            @Validated @ModelAttribute("newUser") UserCreationDto userDto,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {
        if (bindingResult.hasErrors()) {
            Page<User> users = userService.getPaginatedUsers(0, 10);

            model.addAttribute("title", "Gestion des utilisateurs");
            model.addAttribute("users", users);
            model.addAttribute("currentPage", 0);

            return "pages/admin/users/list";
        }

        try {
            User user = userService.createUser(userDto.username());
            redirectAttributes.addFlashAttribute(
                    "success", "Utilisateur " + user.username() + " créé avec succès");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/admin/users";
    }

    @PostMapping("/{userId}/reset-code")
    public ResponseEntity<Void> resetUserCode(
            @PathVariable Long userId, RedirectAttributes redirectAttributes) {
        if (!userService.exists(userId)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        userService.resetUserCode(userId);

        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long userId) {
        if (!userService.exists(userId)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        userService.deleteUser(userId);

        return ResponseEntity.status(HttpStatus.NO_CONTENT).header("HX-Refresh", "true").build();
    }
}
