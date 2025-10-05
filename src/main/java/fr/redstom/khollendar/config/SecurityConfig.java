package fr.redstom.khollendar.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Value("${admin.password}")
    private String adminPassword;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // @formatter:off
        http
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers("/admin/**",
                                         "/kholles/create",
                                         "/kholles/create/**",
                                         "/kholles/*/delete",
                                         "/kholles/*/rename",
                                         "/kholles/*/status",
                                         "/kholles/*/assignments/trigger",
                                         "/kholles/assignments/trigger-all")
                        .hasRole("ADMIN")

                        .requestMatchers("/**", "/user-auth/**").permitAll())
                .formLogin(formLogin -> formLogin
                        .loginPage("/login")
                        .defaultSuccessUrl("/")
                        .failureUrl("/login?error=true")
                        .permitAll())
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/")
                        .invalidateHttpSession(true)
                        .permitAll());
        // @formatter:on

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService(PasswordEncoder passwordEncoder) {
        String encodedPassword = passwordEncoder.encode(adminPassword);

        // @formatter:off
        UserDetails admin = User.builder()
                .username("admin")
                .password(encodedPassword)
                .roles("ADMIN")
                .build();
        // @formatter:on

        return new InMemoryUserDetailsManager(admin);
    }
}
