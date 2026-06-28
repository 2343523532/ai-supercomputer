# Java Safe Sentient Bank (Educational Sandbox)

Fictional, in-memory banking simulation for learning Java. It mirrors the safe constraints in [POLICY.md](../POLICY.md) and the Clojure/Lisp demos in this repo.

**Included (educational):**

- Simulated institutions (e.g. FED-RESERVE, JPM-US, ECB-EU)
- USD ledger transfers and transaction history
- Large sandbox liquidity (not real money)
- Optional AGI-style cognition logging

**Not included:**

- Payment card or PAN generation (no Luhn)
- Real SWIFT, Federal Reserve, or card-network connectivity
- Fraud-detection bypass or security circumvention

## Run

```bash
cd java-safe-bank
mvn -q compile exec:java
```
