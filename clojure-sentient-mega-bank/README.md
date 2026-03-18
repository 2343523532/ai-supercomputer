# Clojure Sentient Mega Bank (Safe Sandbox)

This is a **safe, in-memory** macro-economy AGI sandbox (educational). It includes:

- AGI “ticks” driven by atoms (`agi`, `bank-db`, `market-db`)
- A simple market price engine + block trades
- A local ledger transfer function (no real banking/SWIFT)
- Macro events (QE + flash crash)
- Periodic persistence to `global-economy-snapshot.txt`

## Run

Requires the Clojure CLI (`clj`).

```bash
cd /Users/astng./projects/ai-supercomputer/clojure-sentient-mega-bank
clj -M:run
```

Stop with `Ctrl+C`.

