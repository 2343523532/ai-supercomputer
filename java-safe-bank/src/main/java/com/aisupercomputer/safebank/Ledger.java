package com.aisupercomputer.safebank;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Local in-memory ledger. Simulated institution names are fictional labels only — no real
 * SWIFT/Fed/card-network integration.
 */
public final class Ledger {
  /** Sandbox liquidity seed (USD cents), not real funds. */
  public static final long SANDBOX_LIQUIDITY_USD = 10_000_000_000_000L;

  private final Map<String, Account> accounts = new LinkedHashMap<>();
  private final AgiState agi = new AgiState();

  public void initializeNetwork() {
    accounts.clear();
    put("FED-RESERVE", new Account("Federal Reserve (simulated)", "US"));
    put("JPM-US", new Account("JP Morgan Chase (simulated)", "US"));
    put("ECB-EU", new Account("European Central Bank (simulated)", "EU"));

    setBalance("FED-RESERVE", "USD", SANDBOX_LIQUIDITY_USD);
    for (String bank : new String[] {"JPM-US", "ECB-EU"}) {
      transfer("FED-RESERVE", bank, "USD", SANDBOX_LIQUIDITY_USD, "Initial sandbox liquidity");
    }

    agi.think("Global banking network initialized (in-memory sandbox).");
  }

  public Optional<Account> account(String id) {
    return Optional.ofNullable(accounts.get(id));
  }

  public long balance(String accountId, String currency) {
    return account(accountId).map(a -> a.balance(currency)).orElse(0L);
  }

  public boolean transfer(String fromId, String toId, String currency, long amount, String note) {
    Account sender = accounts.get(fromId);
    Account receiver = accounts.get(toId);
    if (sender == null || receiver == null || amount <= 0) {
      return false;
    }
    if (sender.balance(currency) < amount) {
      agi.think("Transfer rejected: insufficient sandbox balance for " + fromId);
      return false;
    }

    sender.setBalance(currency, sender.balance(currency) - amount);
    receiver.setBalance(currency, receiver.balance(currency) + amount);

    Instant now = Instant.now();
    Transaction out =
        new Transaction(now, "TRANSFER_OUT", fromId, toId, currency, amount, note);
    Transaction in =
        new Transaction(now, "TRANSFER_IN", fromId, toId, currency, amount, note);
    sender.record(out);
    receiver.record(in);

    agi.think(
        String.format(
            "Simulated transfer %s -> %s: %,d %s (%s)", fromId, toId, amount, currency, note));
    return true;
  }

  public Map<String, Account> accounts() {
    return Map.copyOf(accounts);
  }

  public AgiState agi() {
    return agi;
  }

  private void put(String id, Account account) {
    accounts.put(id, account);
  }

  private void setBalance(String id, String currency, long amount) {
    Account account = accounts.get(id);
    if (account != null) {
      account.setBalance(currency, amount);
    }
  }
}
