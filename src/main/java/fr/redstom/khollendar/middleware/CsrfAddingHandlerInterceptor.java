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
