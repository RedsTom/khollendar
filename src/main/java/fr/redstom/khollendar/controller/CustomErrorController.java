package fr.redstom.khollendar.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        int statusCode = parseErrorCode(request);

        String errorMessage = switch(statusCode) {
            case 404 -> "Page non trouvée";
            case 403 -> "Accès interdit";
            case 500 -> "Erreur serveur";
            case 400 -> "Requête invalide";
            case 401 -> "Non autorisé";
            default -> "Une erreur est survenue";
        };
        String errorDescription = switch(statusCode) {
            case 404 -> "La page que vous recherchez n'existe pas ou a été déplacée.";
            case 403 -> "Vous n'avez pas les permissions nécessaires pour accéder à cette page.";
            case 500 -> "Une erreur interne s'est produite. Veuillez réessayer plus tard.";
            case 400 -> "La requête envoyée n'est pas valide.";
            case 401 -> "Vous devez être connecté pour accéder à cette page.";
            default -> "Nous sommes désolés, quelque chose s'est mal passé.";
        };

        model.addAttribute("statusCode", statusCode);
        model.addAttribute("errorMessage", errorMessage);
        model.addAttribute("errorDescription", errorDescription);

        return "pages/error";
    }

    private int parseErrorCode(HttpServletRequest request) {
        return (Integer) request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
    }
}
