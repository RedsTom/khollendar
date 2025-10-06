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
package fr.redstom.khollendar.utils;

import java.util.List;
import java.util.regex.Pattern;

public class WordUtils {

    /**
     * Met en majuscule la première lettre d'une chaîne
     *
     * @param str La chaîne à traiter
     * @return La chaîne avec la première lettre en majuscule
     */
    public static String capitalizeFirst(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }

    public static String plural(String word, String suffix, List<?> elements) {
        return word + (elements.size() > 1 ? suffix : "");
    }

    public static String plural(String word, List<?> elements) {
        return plural(word, "s", elements);
    }

    public static String definiteArticle(String word, String full, String abbreviated) {
        char firstChar = Character.toLowerCase(word.charAt(0));
        if (Pattern.matches("[aeiouyàâäéèêëîïôöùûü]", String.valueOf(firstChar))) {
            return abbreviated;
        } else {
            return full + " ";
        }
    }
}
