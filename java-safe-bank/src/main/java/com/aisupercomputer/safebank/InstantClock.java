package com.aisupercomputer.safebank;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

final class InstantClock {
  private static final DateTimeFormatter TIME =
      DateTimeFormatter.ofPattern("HH:mm:ss").withZone(ZoneId.systemDefault());

  private InstantClock() {}

  static String nowTime() {
    return TIME.format(Instant.now());
  }
}
