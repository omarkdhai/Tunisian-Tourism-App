package com.tourism.gateway.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

@Configuration
@EnableWebFluxSecurity
public class SecurityConfig {

    @Bean
    public SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http) {
        http
                .csrf(ServerHttpSecurity.CsrfSpec::disable)
                .authorizeExchange(exchanges -> exchanges
                        .pathMatchers(
                                "/eureka/**",
                                "/actuator/**",
                                "/api/users/register",
                                "/api/reviews/place/**",
                                "/api/notifications/send",
                                "/api/guides/search"
                        ).permitAll()
                        .pathMatchers(HttpMethod.GET,
                                "/api/places",
                                "/api/places/*",
                                "/api/places/search",
                                "/api/places/nearby",
                                "/api/places/category/**",
                                "/api/places/similar/*"
                        ).permitAll()
                        .anyExchange().authenticated()
                )
                .oauth2ResourceServer(oauth2 -> oauth2
                        .jwt(jwt -> {})
                );

        return http.build();
    }
}
