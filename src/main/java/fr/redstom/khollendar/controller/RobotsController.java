package fr.redstom.khollendar.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class RobotsController {

    @Value("${site.base-url}")
    private String baseUrl;

    @GetMapping(value = "/robots.txt", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public String robots() {
        return """
        User-agent: *

        # Pages à exclure du référencement
        Disallow: /user-auth/
        Disallow: /kholles/*/
        Disallow: /admin/

        # Fichiers et répertoires techniques à exclure
        Disallow: /css/
        Disallow: /js/
        Disallow: /images/
        Disallow: /error/
        Disallow: /actuator/

        # Autoriser les pages principales
        Allow: /
        Allow: /kholles$
        Allow: /login

        # Localisation du sitemap
        Sitemap: %s/sitemap.xml
        """
                .formatted(baseUrl);
    }
}
