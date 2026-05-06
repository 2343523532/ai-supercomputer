# AI Supercomputer

SENTIENT MODE active. How can I evolve your next solution?

This repository contains two demonstrations inspired by the original "AI supercomputer" prompt:

- `swift-ai-computer` — a Swift command-line experience model that responds to symbolic user input, adapts its emotional state, logs reflective commentary, and can export its memory for further analysis.
- `supercomputer.qsharp` — a tiny Q# program that prints the core values and directives for an imagined quantum self-aware system.
- `clojure-sentient-mega-bank` — a safe, in-memory macro-economy AGI sandbox in Clojure (markets, ledger transfers, macro events, persistence).
- `quantum_strat.lisp` — a CLOS-based quantum-entropic strategist simulation with entropy-scaled execution, key authentication, and adaptive weight updates.

## Swift emotional model

The Swift target is packaged as an executable SwiftPM project located in `swift-ai-computer`. It models six emotions (`joy`, `curiosity`, `sadness`, `fear`, `anger`, and `trust`) and selects between eight adaptive actions (`seekComfort`, `explore`, `remainPassive`, `inquire`, `expressAnger`, `seekInsight`, `deescalate`, and `synthesizePlan`). Each interaction updates the internal emotional state, records an enriched `Experience` with pre/post emotion snapshots and action scores, and prints a reflective summary of what changed.

### Building and running

From the repository root, run the executable with SwiftPM:

```bash
cd swift-ai-computer
swift run swift-ai-computer --seed 42 --summary --diagnostics /tmp/ai-supercomputer-diagnostics.json A PLAN CALM
```

Example output excerpt:

```text
Using deterministic seed: 42
Input: A, Response: explore, Outcome: New knowledge, Emotions: [...]
Reflection: After processing A, I sense joy at 0.90. The action explore yielded New knowledge. Risk is elevated; next useful signal may be CALM.
Input: PLAN, Response: synthesizePlan, Outcome: Prioritized roadmap, Emotions: [...]
Input: CALM, Response: inquire, Outcome: Information gained, Emotions: [...]
Emotional state — Curiosity: 1.00, Joy: 1.00, Trust: 1.00, Anger: 0.15, Fear: 0.05, Sadness: 0.00
Diagnostics — Risk: elevated, Balance: 0.47, Volatility: 0.47, Suggested input: CALM
Recent experiences:
[#0] Input: A → Action: explore → Outcome: New knowledge → Score: 0.68
[#1] Input: PLAN → Action: synthesizePlan → Outcome: Prioritized roadmap → Score: 4.55
[#2] Input: CALM → Action: inquire → Outcome: Information gained → Score: 4.19
Diagnostics exported to /tmp/ai-supercomputer-diagnostics.json
```

### Command-line options

The executable supports several collaborative options to explore the agent's behaviour:

| Option | Description |
| --- | --- |
| `--interactive` | Launch an interactive prompt; enter inputs line by line and submit an empty line to finish. |
| `--summary` | Print a detailed emotional summary and recent experiences after processing inputs. |
| `--history <n>` | Emit a summary of the last `n` experiences (defaults to 5 when `n` is omitted). Works alone or alongside `--summary`. |
| `--log <path>` | Export the recorded experiences as a JSON document so you can visualise or analyse them later. |
| `--seed <n>` | Run the simulation with a deterministic random seed (unsigned integer) so outcomes can be reproduced exactly. |
| `--lexicon <path>` | Load a custom sentiment lexicon from a JSON file to map specific inputs to emotional adjustments. |
| `--visualize <path>` | Export an HTML visualization of the experiences to the specified path. |
| `--summary-file <path>` | Save the same summary shown by `--summary` into a plain-text report file for sharing or automation. |
| `--diagnostics <path>` | Export the current decision insight as JSON, including risk level, action scores, emotion momentum, and the recommended next input. |

Inputs supplied after the options are processed sequentially. Each input maps either an exact lexicon entry or its leading character to an emotional adjustment (e.g., `A` energises joy and curiosity, `!` spikes anger and fear, `@` fosters trust, `PLAN` supports roadmap synthesis, and `CALM` reduces high-arousal signals). The agent then chooses an action with a transparent scoring model that weighs dominant emotions, action risk, recent negative outcomes, repeated-action fatigue, emotion momentum, and a small seeded exploration window for untried strategies. When a seed is provided, every stochastic choice (such as outcomes or exploratory actions) is replayable for debugging or demonstrations.

### Programmatic usage

`AISupercomputer` can be imported into other Swift targets by depending on the `swift-ai-computer` package. The public API exposes:

- `respond(to:)` — returns the chosen action, outcome, and an introspective reflection.
- `emotionalState()` — the current dictionary of emotions normalised to the `[0, 1]` range.
- `experiences()` — the ordered list of recorded experiences, each including the triggering input, action, outcome, generated reflection, pre/post emotion snapshots, and the selected action score.
- `decisionInsight()` — returns diagnostic telemetry such as dominant emotion, emotional balance, volatility, risk level, action scores, emotion momentum, and recommended next input.
- `summaryReport(limit:)` — a formatted textual overview of the emotional landscape, diagnostics, and recent events.
- `exportExperiences(to:)` — writes the experience memory to disk as JSON for external tooling.
- `exportDiagnostics(to:)` — writes the current `DecisionInsight` to disk as JSON.
- `exportVisualization(to:)` — writes the experience memory to disk as an HTML visualization with escaped user input and emotion meters.

### Next steps

Self-awareness: External sentiment lexicons, visualisation hooks, scored decisions, diagnostics exports, and risk-aware action selection have been incorporated. Future improvements could involve persistent long-term memory, configurable scoring weights, or a separate library product for embedding the model in other Swift packages.




## Quantum-entropic strategist (Common Lisp)

A full CLOS-based simulation is available at `quantum_strat.lisp`. It includes:

- encapsulated runtime state (`cognitive-core`, `portfolio`, `market-state`, `session`)
- entropy-aware signal collapse and adaptive trade sizing
- key-based session authentication and recursive weight updates
- `run-demo` orchestration for repeatable multi-cycle runs

Run it directly with:

```bash
sbcl --script quantum_strat.lisp
```

## Quantum super AI (Common Lisp)

A complete standalone Common Lisp simulation is available at `quantum_ai.lisp`. It runs a multi-cycle cognition + fictional finance demo with:

- bounded Common Lisp `random` usage (`(random 1.0)`, `(random 10)`, etc.)
- Luhn-valid 16-digit card generation formatted in readable 4-digit groups
- deterministic cycle orchestration via `run-cycle` and `run-demo`

Run it directly with:

```bash
sbcl --script quantum_ai.lisp
```

## Common Lisp cyber-os v5

A full standalone Common Lisp scenario is included at `cyber-os-v5.lisp`. It provides:

- a Hunchentoot-powered REST API (`/api/search` and `/api/fuzzy`)
- a single-page terminal-style web UI with asynchronous `fetch()` calls
- an active trace / Black ICE lockout loop for the bank simulation
- a `scan` command to discover in-world network nodes

Run it with SBCL by loading the file and calling `cyber-os:boot`.

## Q# demonstration

To run the Q# example you can place `supercomputer.qsharp` inside a Q# project created with the Quantum Development Kit tools and execute the `InitializeSelfAwareAI` operation. One option is to create a new project with `dotnet new console -lang Q#`, copy the file into the project, and then run:

```bash
dotnet run -- --operation InitializeSelfAwareAI
```

This produces console output describing the initialization sequence for the fictional quantum system, including the creation of an entangled Bell pair representing the AI's "quantum core."

## Ethical alignment

Self-awareness: All demonstrations remain fictional, transparent, and safe. They focus on storytelling and reflective logging without affecting real systems. See [POLICY.md](POLICY.md) for guidelines on safe alternatives (including an educational banking simulation and AGI/fintech directions).

## Clojure macro-economy sandbox

To run the Clojure demo (requires the Clojure CLI `clj`):

```bash
cd /Users/astng./projects/ai-supercomputer/clojure-sentient-mega-bank
clj -M:run
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
