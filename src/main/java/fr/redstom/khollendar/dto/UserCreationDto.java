package fr.redstom.khollendar.dto;

import jakarta.validation.constraints.NotBlank;

public record UserCreationDto(
    @NotBlank(message = "Le nom d'utilisateur est obligatoire")
    String username
) {}
