package fr.redstom.khollesmanager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller("/")
public class MainController {

    @GetMapping()
    public String index(Model model) {
        model.addAttribute("title", "Accueil");
        model.addAttribute("content", "Bienvenue sur KhollesManager, votre application de gestion de khôlles !");

        return "index";
    }

}
