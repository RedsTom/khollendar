package fr.redstom.khollendar.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SitemapController {

    @Value("${site.base-url}")
    private String baseUrl;

    @GetMapping(value = "/sitemap.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String sitemap() {
        String currentDate = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);

        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
            <url>
                <loc>%s/</loc>
                <lastmod>%s</lastmod>
                <changefreq>weekly</changefreq>
                <priority>1.0</priority>
            </url>
            <url>
                <loc>%s/kholles</loc>
                <lastmod>%s</lastmod>
                <changefreq>daily</changefreq>
                <priority>0.8</priority>
            </url>
            <url>
                <loc>%s/login</loc>
                <lastmod>%s</lastmod>
                <changefreq>monthly</changefreq>
                <priority>0.6</priority>
            </url>
        </urlset>
        """
                .formatted(baseUrl, currentDate, baseUrl, currentDate, baseUrl, currentDate);
    }
}
