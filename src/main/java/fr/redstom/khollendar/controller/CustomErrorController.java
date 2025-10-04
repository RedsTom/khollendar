package fr.redstom.khollendar.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, CsrfToken csrf, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        String errorMessage = "Une erreur est survenue";
        String errorDescription = "Nous sommes désolés, quelque chose s'est mal passé.";

        if (status != null) {
            int statusCode = Integer.parseInt(status.toString());

            if (statusCode == HttpStatus.NOT_FOUND.value()) {
                errorMessage = "Page non trouvée";
                errorDescription = "La page que vous recherchez n'existe pas ou a été déplacée.";
            } else if (statusCode == HttpStatus.FORBIDDEN.value()) {
                errorMessage = "Accès interdit";
                errorDescription = "Vous n'avez pas les permissions nécessaires pour accéder à cette page.";
            } else if (statusCode == HttpStatus.INTERNAL_SERVER_ERROR.value()) {
                errorMessage = "Erreur serveur";
                errorDescription = "Une erreur interne s'est produite. Veuillez réessayer plus tard.";
            } else if (statusCode == HttpStatus.BAD_REQUEST.value()) {
                errorMessage = "Requête invalide";
                errorDescription = "La requête envoyée n'est pas valide.";
            } else if (statusCode == HttpStatus.UNAUTHORIZED.value()) {
                errorMessage = "Non autorisé";
                errorDescription = "Vous devez être connecté pour accéder à cette page.";
            }

            model.addAttribute("statusCode", statusCode);
        }

        model.addAttribute("errorMessage", errorMessage);
        model.addAttribute("errorDescription", errorDescription);
        model.addAttribute("_csrf", csrf);

        return "pages/error";
    }
}

