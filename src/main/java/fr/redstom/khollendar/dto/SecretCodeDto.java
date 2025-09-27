package fr.redstom.khollendar.dto;

import jakarta.validation.constraints.Pattern;

public record SecretCodeDto(
    @Pattern(regexp = "\\d{6}", message = "Le code secret doit être composé de 6 chiffres")
    String secretCode
) {}
