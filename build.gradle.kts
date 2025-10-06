import okhttp3.internal.trimSubstring
import java.time.Instant
import java.time.LocalDateTime

plugins {
    java
    id("org.springframework.boot") version "3.5.6"
    id("io.spring.dependency-management") version "1.1.7"
    id("gg.jte.gradle") version "3.1.16"
    id("com.diffplug.spotless") version "8.0.0"
}

group = "fr.redstom"
version = "0.0.1-SNAPSHOT"
description = "kholle-n-dar"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

configurations {
    compileOnly {
        extendsFrom(configurations.annotationProcessor.get())
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-jdbc")
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("gg.jte:jte-spring-boot-starter-3:3.1.16")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.flywaydb:flyway-core")
    implementation("org.flywaydb:flyway-database-postgresql")
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    compileOnly("org.projectlombok:lombok")
    developmentOnly("org.springframework.boot:spring-boot-devtools")
    runtimeOnly("org.postgresql:postgresql")
    annotationProcessor("org.projectlombok:lombok")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

jte {
    generate()
    binaryStaticContent = true
}

spotless {
    format("misc") {
        target("*.gradle", ".gitattributes", ".gitignore")

        trimTrailingWhitespace()
        leadingTabsToSpaces()
        endWithNewline()
    }

    java {
        palantirJavaFormat()

        formatAnnotations()

        importOrder()
        removeUnusedImports()

        licenseHeader(
            """
                /*
                 * Kholle'n'dar is a web application to manage oral interrogations planning 
                 * for French students.
                 * Copyright (C) ${LocalDateTime.now().year} Tom BUTIN
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
       """.trimIndent())

        leadingTabsToSpaces(4)
        trimTrailingWhitespace()
        endWithNewline()

        toggleOffOn("// @formatter:off", "// @formatter:on")
    }
}


tasks.withType<Test> {
    useJUnitPlatform()
}
