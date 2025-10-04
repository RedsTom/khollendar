package fr.redstom.khollendar.dto;

import java.time.LocalDateTime;
import lombok.NonNull;

public record KholleCreationDto(LocalDateTime time) {
    @Override
    @NonNull public String toString() {
        return time.toString();
    }
}
