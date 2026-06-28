package com.aisupercomputer.safebank;

/**
 * Educational banking sandbox entry point.
 *
 * <p>Safety: no payment card generation (no Luhn), no real SWIFT/Fed connectivity, no fraud
 * bypass — see repository POLICY.md.
 */
public final class Main {
  private Main() {}

  public static void main(String[] args) {
    Ledger ledger = new Ledger();
    System.out.println(">>> INITIALIZING GLOBAL BANKING NETWORK (SAFE JAVA SANDBOX) <<<");
    ledger.initializeNetwork();

    ledger.transfer("JPM-US", "ECB-EU", "USD", 50_000_000_000L, "Cross-border sandbox payment");
    ledger.transfer("ECB-EU", "JPM-US", "USD", 10_000_000_000L, "Partial return transfer");

    printSnapshot(ledger);
  }

  private static void printSnapshot(Ledger ledger) {
    System.out.println();
    System.out.println("=== JAVA SAFE SENTIENT BANK SNAPSHOT ===");
    System.out.printf("AGI awareness: %.2f | memory entries: %d%n",
        ledger.agi().awareness(), ledger.agi().memoryEntries());
    for (var entry : ledger.accounts().entrySet()) {
      String id = entry.getKey();
      Account acc = entry.getValue();
      System.out.printf(
          "%-12s %-35s %s  USD %,d%n",
          id, acc.institutionName(), acc.region(), acc.balance("USD"));
    }
    System.out.println();
    System.out.println("All operations are fictional and in-memory only.");
  }
}
