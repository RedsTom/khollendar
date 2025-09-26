package fr.redstom.khollesmanager.repository;

import fr.redstom.khollesmanager.entity.KholleGroup;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.ListPagingAndSortingRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

public interface KholleGroupRepository extends CrudRepository<KholleGroup, Long>, PagingAndSortingRepository<KholleGroup, Long> {
}
