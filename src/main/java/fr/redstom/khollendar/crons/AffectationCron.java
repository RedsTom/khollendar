package fr.redstom.khollendar.crons;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class AffectationCron {

    /**
     * Cron job that runs every day to start the affectation process.
     * This process assigns kholles to students based on predefined rules and availability at least 24 hours
     * before the first slot of a session.
     */
    @Scheduled(fixedRate = 1, timeUnit = TimeUnit.DAYS)
    public void startAffectationProcess() {
        System.out.println("Affectation process started...");
    }


}
