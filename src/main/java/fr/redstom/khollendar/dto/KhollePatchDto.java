/*
 * Kholle'n'dar is a web application to manage oral interrogations planning
 * for French students.
 * Copyright (C) 2025 Tom BUTIN
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
  * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package fr.redstom.khollendar.dto;

import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSessionStatus;

public record KhollePatchDto(String subject, KholleSessionStatus status) {

    public KholleSession apply(KholleSession session) {
        KholleSession.KholleSessionBuilder builder = session.toBuilder();

        if (this.subject != null && !this.subject.isBlank()) {
            builder = builder.subject(this.subject.trim());
        }
        if (this.status != null) {
            builder = builder.status(this.status);
        }

        return builder.build();
    }
}
