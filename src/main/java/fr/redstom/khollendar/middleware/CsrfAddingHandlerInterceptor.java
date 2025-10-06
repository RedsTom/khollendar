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
package fr.redstom.khollendar.middleware;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.NonNull;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Component
public class CsrfAddingHandlerInterceptor implements HandlerInterceptor {

    /**
     * Add CSRF token to the model if available.
     *
     * @param request current HTTP request
     * @param response current HTTP response
     * @param handler the handler (or {@link HandlerMethod}) that started asynchronous execution,
     *     for type and/or instance examination
     * @param modelAndView the {@code ModelAndView} that the handler returned (can also be {@code
     *     null})
     */
    @Override
    public void postHandle(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull Object handler,
            ModelAndView modelAndView) {
        if (modelAndView == null) {
            return;
        }

        CsrfToken csrfToken = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
        modelAndView.addObject("_csrf", csrfToken);
    }
}
