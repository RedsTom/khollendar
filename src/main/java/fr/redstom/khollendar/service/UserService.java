package fr.redstom.khollendar.service;

import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Page<User> getPaginatedUsers(int page, int size) {
        return userRepository.findAll(PageRequest.of(page, size));
    }

    public User createUser(String username) {
        if (userRepository.existsByUsername(username)) {
            throw new IllegalArgumentException("Un utilisateur avec ce nom existe déjà");
        }

        User newUser = User.builder()
                .username(username)
                .codeInitialized(false)
                .build();

        return userRepository.save(newUser);
    }

    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public boolean isValidSecretCode(User user, String secretCode) {
        return user.codeInitialized() && passwordEncoder.matches(secretCode, user.secretCode());
    }

    public void setSecretCode(User user, String secretCode) {
        // Vérifier que le code est bien à 6 chiffres
        if (!secretCode.matches("\\d{6}")) {
            throw new IllegalArgumentException("Le code secret doit être composé de 6 chiffres");
        }

        user.secretCode(passwordEncoder.encode(secretCode));
        user.codeInitialized(true);
        userRepository.save(user);
    }
}
