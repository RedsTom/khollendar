package fr.redstom.khollesmanager.repository;

import fr.redstom.khollesmanager.entity.KholleSlot;
import org.springframework.data.repository.CrudRepository;

public interface KholleRepository extends CrudRepository<KholleSlot, Long> {
}
