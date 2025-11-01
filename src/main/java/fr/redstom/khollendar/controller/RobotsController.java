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
