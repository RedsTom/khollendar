package fr.redstom.khollesmanager.dto;

import java.time.LocalDateTime;

public record DateRange(
        LocalDateTime startTime,
        LocalDateTime endTime
) {
}
