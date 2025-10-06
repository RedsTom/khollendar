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
package fr.redstom.khollendar.service;

import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.repository.UserRepository;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * Service de gestion des utilisateurs Fournit les opérations CRUD et de gestion des codes secrets
 * pour les utilisateurs
 */
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    /**
     * Crée un nouvel utilisateur avec le nom d'utilisateur fourni
     *
     * @param username Le nom d'utilisateur unique
     * @return L'utilisateur créé
     * @throws IllegalArgumentException si le nom d'utilisateur existe déjà
     */
    public User createUser(String username) {
        if (userRepository.existsByUsername(username)) {
            throw new IllegalArgumentException("Un utilisateur avec ce nom existe déjà");
        }

        User newUser = User.builder().username(username).codeInitialized(false).build();

        return userRepository.save(newUser);
    }

    /**
     * Récupère tous les utilisateurs
     *
     * @return Liste de tous les utilisateurs
     */
    public List<User> getAllUsers() {
        return userRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
    }

    /**
     * Récupère une page d'utilisateurs avec pagination
     *
     * @param page Le numéro de page (commençant à 0)
     * @param size Le nombre d'éléments par page
     * @return Page contenant les utilisateurs
     */
    public Page<User> getPaginatedUsers(int page, int size) {
        return userRepository.findAll(PageRequest.of(page, size, Sort.by(Sort.Direction.ASC, "id")));
    }

    /**
     * Récupère un utilisateur par son ID
     *
     * @param id L'identifiant de l'utilisateur
     * @return L'utilisateur trouvé, ou vide si non trouvé
     */
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }

    /**
     * Récupère un utilisateur par son nom d'utilisateur
     *
     * @param username Le nom d'utilisateur
     * @return L'utilisateur trouvé, ou vide si non trouvé
     */
    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    /**
     * Vérifie si le code secret fourni correspond à celui de l'utilisateur
     *
     * @param user L'utilisateur dont on vérifie le code
     * @param secretCode Le code secret à vérifier
     * @return true si le code est valide et l'utilisateur a initialisé son code
     */
    public boolean isValidSecretCode(User user, String secretCode) {
        return user.codeInitialized() && passwordEncoder.matches(secretCode, user.secretCode());
    }

    /**
     * Définit le code secret d'un utilisateur
     *
     * @param user L'utilisateur pour lequel définir le code
     * @param secretCode Le code secret (doit être composé de 6 chiffres)
     * @throws IllegalArgumentException si le code ne respecte pas le format attendu
     */
    public void setSecretCode(User user, String secretCode) {
        if (!secretCode.matches("\\d{6}")) {
            throw new IllegalArgumentException("Le code secret doit être composé de 6 chiffres");
        }

        user.secretCode(passwordEncoder.encode(secretCode));
        user.codeInitialized(true);

        userRepository.save(user);
    }

    /**
     * Remet à zéro le code secret d'un utilisateur
     *
     * @param userId L'ID de l'utilisateur dont le code doit être réinitialisé
     */
    public void resetUserCode(Long userId) {
        userRepository.findById(userId).ifPresent(user -> {
            user.secretCode(null);
            user.codeInitialized(false);

            userRepository.save(user);
        });
    }

    /**
     * Supprime un utilisateur par son ID
     *
     * @param userId L'ID de l'utilisateur à supprimer
     */
    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }

    /**
     * Vérifie si un utilisateur existe par son ID
     *
     * @param userId L'ID de l'utilisateur à vérifier
     */
    public boolean exists(Long userId) {
        return userRepository.existsById(userId);
    }
}
