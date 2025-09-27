package fr.redstom.khollendar.service;

import fr.redstom.khollendar.dto.KholleCreationDto;
import fr.redstom.khollendar.dto.KholleSessionCreationDto;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import fr.redstom.khollendar.repository.KholleSessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class KholleService {

    private final KholleSessionRepository kholleSessionRepository;


    /**
     * Sauvegarde une nouvelle session de khôlles à partir d'un DTO de formulaire
     *
     * @param dto La session à enregistrer
     * @return La session enregistrée
     */
    public KholleSession createKholle(KholleSessionCreationDto dto) {
        // Création d'une nouvelle session avec les informations de base
        KholleSession session = KholleSession.builder()
                .subject(dto.subject())
                .kholleSlots(new ArrayList<>())
                .build();

        // Sauvegarde de la session d'abord pour obtenir un ID
        session = kholleSessionRepository.save(session);

        // Création des créneaux (slots) associés à cette session sauvegardée
        List<KholleSlot> slots = new ArrayList<>();
        for (KholleCreationDto slotDto : dto.slots()) {
            KholleSlot slot = KholleSlot.builder()
                    .dateTime(slotDto.time())
                    .session(session)  // Référence à la session déjà persistée
                    .build();
            slots.add(slot);
        }

        // Mise à jour de la session avec les slots
        session = session.toBuilder()
                .kholleSlots(slots)
                .build();

        // Sauvegarde finale de la session avec ses slots
        return kholleSessionRepository.save(session);
    }

    /**
     * Récupère toutes les sessions de khôlles avec pagination
     * @param page La page à récupérer
     * @param size Le nombre d'éléments par page
     * @return Page contenant les sessions de khôlles
     */
    public Page<KholleSession> getAllKholleSessions(int page, int size) {
        return kholleSessionRepository.findAll(
                PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "id"))
        );
    }

    /**
     * Récupère toutes les sessions de khôlles à venir avec pagination
     * @param page La page à récupérer
     * @param size Le nombre d'éléments par page
     * @return Page contenant les sessions de khôlles à venir
     */
    public Page<KholleSession> getUpcomingKholleSessions(int page, int size) {
        return kholleSessionRepository.findUpcomingKholleSessionsPaged(
                LocalDateTime.now(),
                PageRequest.of(page, size)
        );
    }

    /**
     * Récupère les sessions de khôlles passées avec pagination
     * @param page La page à récupérer
     * @param size Le nombre d'éléments par page
     * @return Page contenant les sessions de khôlles passées
     */
    public Page<KholleSession> getPreviousKholleSessions(int page, int size) {
        return kholleSessionRepository.findPreviousKholleSessions(
                LocalDateTime.now(),
                PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "id"))
        );
    }
}
