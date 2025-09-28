package fr.redstom.khollendar.utils;

import java.util.List;
import java.util.regex.Pattern;

public class WordUtils {

    public static String plural(String word, String suffix, List<?> elements){
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
