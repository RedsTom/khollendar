package fr.redstom.khollendar.dto;

import lombok.NonNull;

import java.time.LocalDateTime;

public record KholleCreationDto(
        LocalDateTime time
) {
    @Override
    @NonNull
    public String toString() {
        return time.toString();
    }
}
