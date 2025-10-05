package fr.redstom.khollendar.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    @GetMapping("/login")
    public String loginPage(Model model, @RequestParam(required = false) boolean error) {
        model.addAttribute("title", "Connexion administrateur");
        model.addAttribute("error", error);

        return "pages/auth/login";
    }
}
