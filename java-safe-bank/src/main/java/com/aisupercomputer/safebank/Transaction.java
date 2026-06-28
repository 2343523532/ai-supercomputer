package com.aisupercomputer.safebank;

import java.time.Instant;

public record Transaction(
    Instant timestamp,
    String type,
    String fromId,
    String toId,
    String currency,
    long amount,
    String note) {}
