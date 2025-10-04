package fr.redstom.khollendar.dto;

import java.util.Arrays;
import lombok.Builder;
import lombok.NonNull;

@Builder
public record KholleSessionCreationDto(String subject, KholleCreationDto... slots) {
    @Override
    @NonNull public String toString() {
        return "KholleSessionCreationDto{"
                + "subject='"
                + subject
                + '\''
                + ", slots="
                + Arrays.toString(slots)
                + '}';
    }
}
