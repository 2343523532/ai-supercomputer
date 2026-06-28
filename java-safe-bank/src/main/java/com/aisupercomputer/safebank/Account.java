package com.aisupercomputer.safebank;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** In-memory institution account (educational only). */
public final class Account {
  private final String institutionName;
  private final String region;
  private final Map<String, Long> balances = new HashMap<>();
  private final List<Transaction> transactions = new ArrayList<>();

  public Account(String institutionName, String region) {
    this.institutionName = institutionName;
    this.region = region;
  }

  public String institutionName() {
    return institutionName;
  }

  public String region() {
    return region;
  }

  public long balance(String currency) {
    return balances.getOrDefault(currency, 0L);
  }

  public void setBalance(String currency, long amount) {
    balances.put(currency, amount);
  }

  public void record(Transaction tx) {
    transactions.add(tx);
  }

  public List<Transaction> transactions() {
    return Collections.unmodifiableList(transactions);
  }
}
