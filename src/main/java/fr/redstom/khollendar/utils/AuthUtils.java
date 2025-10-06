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
                        .anyMatch(grantedAuthority ->
                                grantedAuthority.getAuthority().equals("ROLE_ADMIN"));
    }
}
