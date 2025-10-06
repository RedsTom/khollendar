package fr.redstom.khollendar.middleware;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class HtmxRedirectFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String hxRequest = httpRequest.getHeader("HX-Request");

        if (!"true".equals(hxRequest)) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletResponseWrapper wrapper = new HttpServletResponseWrapper(httpResponse) {

            @Override
            public void sendRedirect(String location) {
                setStatus(HttpServletResponse.SC_MOVED_TEMPORARILY);
                setHeader("HX-Redirect", location);
            }
        };

        chain.doFilter(request, wrapper);
    }
}