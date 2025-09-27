package fr.redstom.khollendar.dto;

import java.time.LocalDateTime;

public record DateRange(
        LocalDateTime start,
        LocalDateTime end
) {
}
