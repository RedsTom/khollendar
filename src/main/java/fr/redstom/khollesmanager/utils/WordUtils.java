package fr.redstom.khollesmanager.utils;

import java.util.List;

public class WordUtils {

    public static String plural(String word, String suffix, List<?> elements){
        return word + (elements.size() > 1 ? suffix : "");
    }

    public static String plural(String word, List<?> elements) {
        return plural(word, "s", elements);
    }

}
