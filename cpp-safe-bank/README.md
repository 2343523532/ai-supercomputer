# C++ Safe Sentient Bank (Educational Web Sandbox)

Fictional, in-memory banking simulation with a local web UI. Mirrors the safe constraints in [POLICY.md](../POLICY.md) and the Java/Clojure demos in this repo.

**Included (educational):**

- Simulated institutions (e.g. FED-RESERVE, JPM-US, ECB-EU)
- USD ledger transfers and transaction history via a browser UI
- Large sandbox liquidity (not real money)
- AI synonym report pages (concept labeling demo)

**Not included:**

- Payment card or PAN generation (no Luhn)
- Routing numbers, CVV, PIN, or credential harvesting forms
- Real SWIFT, Federal Reserve, or card-network connectivity

## Build and run

Requires a C++17 compiler (`g++` or `clang++`).

**Option A — Makefile (simplest):**

```bash
cd cpp-safe-bank
make
./cpp-safe-bank
```

**Option B — CMake** (fetches [cpp-httplib](https://github.com/yhirose/cpp-httplib) on first configure):

```bash
cd cpp-safe-bank
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
./build/cpp-safe-bank
```

Open http://localhost:8080/ in your browser.
