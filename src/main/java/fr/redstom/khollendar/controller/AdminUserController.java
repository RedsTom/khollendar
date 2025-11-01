/*
 * Kholle'n'dar is a web application to manage oral interrogations planning
 * for French students.
 * Copyright (C) 2025 Tom BUTIN
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
  * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.UserCreationDto;
import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final UserService userService;

    @GetMapping
    public String list() {
        return "pages/admin/users/list";
    }

    @GetMapping("/paginated")
    public String paginated(
            @RequestParam(defaultValue = "0") int page,
            Model model) {
        Page<User> users = userService.getPaginatedUsers(page, 10);

        model.addAttribute("title", "Gestion des utilisateurs");
        model.addAttribute("users", users);
        model.addAttribute("currentPage", page);

        return "fragments/admin/UserList";
    }

    @PostMapping
    public String createUser(
            @Validated @ModelAttribute("newUser") UserCreationDto userDto,
            BindingResult bindingResult,
            @RequestParam(defaultValue = "0") int page,
            Model model) {
        if (bindingResult.hasErrors()) {
            Page<User> users = userService.getPaginatedUsers(page, 10);
            model.addAttribute("users", users);
            return "fragments/admin/UserList";
        }

        try {
            userService.createUser(userDto.username());
            Page<User> users = userService.getPaginatedUsers(page, 10);
            model.addAttribute("users", users);
            return "fragments/admin/UserList";
        } catch (IllegalArgumentException e) {
            Page<User> users = userService.getPaginatedUsers(page, 10);
            model.addAttribute("users", users);
            model.addAttribute("error", e.getMessage());
            return "fragments/admin/UserList";
        }
    }

    @PostMapping("/{userId}/reset-code")
    public String resetUserCode(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "0") int page,
            Model model) {
        if (!userService.exists(userId)) {
            Page<User> users = userService.getPaginatedUsers(page, 10);
            model.addAttribute("users", users);
            return "fragments/admin/UserList";
        }

        userService.resetUserCode(userId);

        Page<User> users = userService.getPaginatedUsers(page, 10);
        model.addAttribute("users", users);

        return "fragments/admin/UserList";
    }

    @DeleteMapping("/{userId}")
    public String deleteUser(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "0") int page,
            Model model) {
        if (!userService.exists(userId)) {
            Page<User> users = userService.getPaginatedUsers(page, 10);
            model.addAttribute("users", users);
            return "fragments/admin/UserList";
        }

        userService.deleteUser(userId);

        Page<User> users = userService.getPaginatedUsers(page, 10);
        model.addAttribute("users", users);

        return "fragments/admin/UserList";
    }
}
