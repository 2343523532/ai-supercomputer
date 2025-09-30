# ai-supercomputer

This repository contains two small demonstrations inspired by the original "AI supercomputer" prompt:

- `ai-computer.swift` implements a lightweight emotional model that reacts to textual input by selecting one of several predefined actions. The state is updated on every interaction and a short log is printed to the console.
- `supercomputer.qsharp` contains a tiny Q# program that prints the core values and directives for an imagined quantum self-aware system.

## Swift emotional model

The Swift script can be executed directly using the Swift interpreter. Each argument after the script name is treated as a separate user input.

```bash
swift ai-computer.swift A ? !
```

The program prints the chosen action, the sampled outcome, and the updated emotional state for every argument supplied. The internal state can also be inspected programmatically by importing the file into another Swift target and invoking `emotionalState()` or `experiences()` on the `AISupercomputer` class.

## Q# demonstration

To run the Q# example you can place `supercomputer.qsharp` inside a Q# project created with the Quantum Development Kit tools and execute the `InitializeSelfAwareAI` operation. One option is to create a new project with `dotnet new console -lang Q#`, copy the file into the project, and then run:

```bash
dotnet run -- --operation InitializeSelfAwareAI
```

This produces console output describing the initialization sequence for the fictional quantum system.
