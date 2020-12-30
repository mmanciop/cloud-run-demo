package com.example.helloworld;

import java.util.Random;
import java.util.concurrent.TimeUnit;

final class Util {

    private static final int MIN_SLEEP_MILLIS = 5;
    private static final int MAX_SLEEP_MILLIS = 10;

    private static final Random RANDOM = new Random();

    private Util() {
    }

    static void sleep() {
        try {
            TimeUnit.MILLISECONDS.sleep(MIN_SLEEP_MILLIS + RANDOM.nextInt(MAX_SLEEP_MILLIS - MIN_SLEEP_MILLIS));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
