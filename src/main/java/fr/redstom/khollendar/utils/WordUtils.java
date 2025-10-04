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
