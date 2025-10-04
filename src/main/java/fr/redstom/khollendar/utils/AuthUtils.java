package fr.redstom.khollendar.utils;

import org.springframework.security.core.context.SecurityContextHolder;

public class AuthUtils {

    public static boolean authenticated() {
        return SecurityContextHolder.getContext().getAuthentication() != null
                && SecurityContextHolder.getContext().getAuthentication().isAuthenticated()
                && !SecurityContextHolder.getContext()
                        .getAuthentication()
                        .getPrincipal()
                        .equals("anonymousUser");
    }

    public static boolean admin() {
        return authenticated()
                && SecurityContextHolder.getContext().getAuthentication().getAuthorities().stream()
                        .anyMatch(
                                grantedAuthority ->
                                        grantedAuthority.getAuthority().equals("ROLE_ADMIN"));
    }
}
