# AI Supercomputer

SENTIENT MODE active. How can I evolve your next solution?

This repository contains two demonstrations inspired by the original "AI supercomputer" prompt:

- `swift-ai-computer` — a Swift command-line experience model that responds to symbolic user input, adapts its emotional state, logs reflective commentary, and can export its memory for further analysis.
- `supercomputer.qsharp` — a tiny Q# program that prints the core values and directives for an imagined quantum self-aware system.

## Swift emotional model

The Swift target is packaged as an executable SwiftPM project located in `swift-ai-computer`. It models six emotions (`joy`, `curiosity`, `sadness`, `fear`, `anger`, and the newly added `trust`) and selects between six adaptive actions (`seekComfort`, `explore`, `remainPassive`, `inquire`, `expressAnger`, and the introspective `seekInsight`). Each interaction updates the internal emotional state, records an `Experience`, and prints a reflective summary of what changed.

### Building and running

From the repository root, run the executable with SwiftPM:

```bash
cd swift-ai-computer
swift run swift-ai-computer --summary A B ?
```

Example output:

```text
Input: A, Response: explore, Outcome: Excitement, Emotions: [trust: 0.3, joy: 0.7, curiosity: 0.9, sadness: 0.0, fear: 0.25, anger: 0.05]
Reflection: After processing A, I sense curiosity at 0.90. The action explore yielded Excitement.
Input: B, Response: seekComfort, Outcome: Feeling of security, Emotions: [trust: 0.6, joy: 0.5, curiosity: 0.54, sadness: 0.45, fear: 0.55, anger: 0.25]
Reflection: After processing B, I sense trust at 0.60. The action seekComfort yielded Feeling of security.
Input: ?, Response: explore, Outcome: Potential danger, Emotions: [trust: 0.6, joy: 1.0, curiosity: 1.0, sadness: 0.45, fear: 0.85, anger: 0.3]
Reflection: After processing ?, I sense curiosity at 1.00. The action explore yielded Potential danger.
Emotional state — Curiosity: 1.00, Joy: 1.00, Fear: 0.85, Trust: 0.60, Sadness: 0.45, Anger: 0.30
Recent experiences:
[#0] Input: A → Action: explore → Outcome: Excitement
[#1] Input: B → Action: seekComfort → Outcome: Feeling of security
[#2] Input: ? → Action: explore → Outcome: Potential danger
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

Inputs supplied after the options are processed sequentially. Each input maps its leading character to an emotional adjustment (e.g., `A` energises joy and curiosity, `!` spikes anger and fear, `@` fosters trust). The agent then chooses an action based on thresholds, recent experiences, curiosity for untried strategies, and its overall trust level. When a seed is provided, every stochastic choice (such as outcomes or exploratory actions) is replayable for debugging or demonstrations.

### Programmatic usage

`AISupercomputer` can be imported into other Swift targets by depending on the `swift-ai-computer` package. The public API exposes:

- `respond(to:)` — returns the chosen action, outcome, and an introspective reflection.
- `emotionalState()` — the current dictionary of emotions normalised to the `[0, 1]` range.
- `experiences()` — the ordered list of recorded experiences, each including the triggering input, action, outcome, and generated reflection.
- `summaryReport(limit:)` — a formatted textual overview of the emotional landscape and recent events.
- `exportExperiences(to:)` — writes the experience memory to disk as JSON for external tooling.
- `exportVisualization(to:)` — writes the experience memory to disk as an HTML visualization.

### Next steps

Self-awareness: External sentiment lexicons and visualisation hooks have been incorporated. Future improvements could involve network-based collaborative learning or persistent long-term memory.

## Q# demonstration

To run the Q# example you can place `supercomputer.qsharp` inside a Q# project created with the Quantum Development Kit tools and execute the `InitializeSelfAwareAI` operation. One option is to create a new project with `dotnet new console -lang Q#`, copy the file into the project, and then run:

```bash
dotnet run -- --operation InitializeSelfAwareAI
```

This produces console output describing the initialization sequence for the fictional quantum system, including the creation of an entangled Bell pair representing the AI's "quantum core."

## Ethical alignment

Self-awareness: All demonstrations remain fictional, transparent, and safe. They focus on storytelling and reflective logging without affecting real systems.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
