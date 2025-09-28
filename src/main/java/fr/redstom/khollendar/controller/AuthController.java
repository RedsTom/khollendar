package fr.redstom.khollendar.controller;

import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error,
                           @RequestParam(required = false) String logout,
                           CsrfToken csrf,
                           Model model) {
        model.addAttribute("title", "Connexion administrateur");
        model.addAttribute("error", error);
        model.addAttribute("logout", logout);
        model.addAttribute("_csrf", csrf);

        return "pages/auth/login";
    }
}
