package fr.redstom.khollesmanager.repository;

import fr.redstom.khollesmanager.entity.KholleSession;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface KholleSessionRepository extends CrudRepository<KholleSession, Long>, PagingAndSortingRepository<KholleSession, Long> {
    
    @Query("SELECT ks FROM KholleSession ks JOIN ks.kholleSlots slot WHERE slot.dateTime > ?1 GROUP BY ks ORDER BY MIN(slot.dateTime) ASC")
    List<KholleSession> findUpcomingKholleSessions(LocalDateTime now);
    
    @Query("SELECT ks FROM KholleSession ks JOIN ks.kholleSlots slot WHERE slot.dateTime > ?1 GROUP BY ks ORDER BY MIN(slot.dateTime) ASC")
    Page<KholleSession> findUpcomingKholleSessionsPaged(LocalDateTime now, Pageable pageable);

    @Query("SELECT ks FROM KholleSession ks JOIN ks.kholleSlots slot WHERE slot.dateTime < ?1 GROUP BY ks ORDER BY MAX(slot.dateTime) DESC")
    Page<KholleSession> findPreviousKholleSessions(LocalDateTime now, Pageable pageable);
}

