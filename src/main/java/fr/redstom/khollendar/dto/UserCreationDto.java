package fr.redstom.khollendar.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UserCreationDto {
    @NotBlank(message = "Le nom d'utilisateur est obligatoire")
    private String username;
}
