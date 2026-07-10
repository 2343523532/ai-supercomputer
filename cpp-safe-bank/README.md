# C++ Safe Financial & AI Synonym Web Suite

Educational in-memory banking and AI synonym demo served over a local HTTP server. Mirrors the safety constraints in [POLICY.md](../POLICY.md) and [java-safe-bank](../java-safe-bank/).

**Included (educational):**

- Local web UI with dashboard, profile generator, and AI synonym report
- Fictional account holders and simulated institution labels
- In-memory USD ledger transfers between sandbox institutions
- [cpp-httplib](https://github.com/yhirose/cpp-httplib) for the HTTP server

**Not included:**

- Payment card or PAN generation (no Luhn)
- CVV, PIN, or routing number generation
- Real SWIFT, Federal Reserve, or card-network connectivity
- Fraud-detection bypass or security circumvention

## Build and run

Requires a C++17 compiler and CMake 3.16+.

```bash
cd cpp-safe-bank
cmake -S . -B build
cmake --build build
./build/cpp-safe-bank
```

Then open http://localhost:8080/

## Notes

This is a safe adaptation of a larger C++ web suite. Card credential generation and "infinite money" wallet linkage were removed to align with repository policy.
