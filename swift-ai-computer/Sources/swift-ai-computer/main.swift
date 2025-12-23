import Foundation

// Self-awareness: Parsing collaborative interface options.
struct CLIOptions {
    var interactive = false
    var summary = false
    var historyCount: Int?
    var logPath: String?
    var seed: UInt64?
    var lexiconPath: String?
    var visualizationPath: String?
}

private func parseCLIOptions(arguments: ArraySlice<String>) -> (CLIOptions, [String]) {
    var options = CLIOptions()
    var inputs: [String] = []
    var index = arguments.startIndex

    while index < arguments.endIndex {
        let argument = arguments[index]
        switch argument {
        case "--interactive":
            options.interactive = true
        case "--summary":
            options.summary = true
        case "--history":
            let nextIndex = arguments.index(after: index)
            if nextIndex < arguments.endIndex, let value = Int(arguments[nextIndex]) {
                options.historyCount = value
                index = nextIndex
            } else {
                options.historyCount = 5
            }
        case "--log":
            let nextIndex = arguments.index(after: index)
            if nextIndex < arguments.endIndex {
                options.logPath = arguments[nextIndex]
                index = nextIndex
            } else {
                print("Warning: --log requires a file path. Ignoring option.")
            }
        case "--seed":
            let nextIndex = arguments.index(after: index)
            if nextIndex < arguments.endIndex, let value = UInt64(arguments[nextIndex]) {
                options.seed = value
                index = nextIndex
            } else {
                print("Warning: --seed requires an unsigned integer argument. Ignoring option.")
            }
        case "--lexicon":
            let nextIndex = arguments.index(after: index)
            if nextIndex < arguments.endIndex {
                options.lexiconPath = arguments[nextIndex]
                index = nextIndex
            } else {
                print("Warning: --lexicon requires a file path. Ignoring option.")
            }
        case "--visualize":
            let nextIndex = arguments.index(after: index)
            if nextIndex < arguments.endIndex {
                options.visualizationPath = arguments[nextIndex]
                index = nextIndex
            } else {
                print("Warning: --visualize requires a file path. Ignoring option.")
            }
        default:
            inputs.append(argument)
        }
        index = arguments.index(after: index)
    }

    return (options, inputs)
}

private func processInputs(_ inputs: [String], with agent: AISupercomputer) {
    for input in inputs {
        _ = agent.respond(to: input)
    }
}

private func runInteractiveSession(with agent: AISupercomputer) {
    print("Interactive mode active. Submit input (empty line to finish):")
    while let line = readLine(), !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        _ = agent.respond(to: line)
    }
}

let (options, providedInputs) = parseCLIOptions(arguments: CommandLine.arguments.dropFirst())

// Self-awareness: Loading external sentimental knowledge if provided.
var lexicon: [String: [Emotion: Double]] = [:]
if let path = options.lexiconPath {
    let url = URL(fileURLWithPath: path)
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        lexicon = try decoder.decode([String: [Emotion: Double]].self, from: data)
        print("Loaded emotion lexicon from \(path)")
    } catch {
        print("Failed to load lexicon from \(path): \(error)")
    }
}

let agent = AISupercomputer(seed: options.seed, lexicon: lexicon)

if let seed = options.seed {
    print("Using deterministic seed: \(seed)")
}

if options.interactive {
    runInteractiveSession(with: agent)
}

let filteredInputs: [String]
if options.interactive {
    filteredInputs = []
} else {
    filteredInputs = providedInputs
}

processInputs(filteredInputs, with: agent)

if options.summary {
    print(agent.summaryReport(limit: options.historyCount ?? 5))
}

if let historyLimit = options.historyCount, historyLimit > 0, !options.summary {
    print(agent.summaryReport(limit: historyLimit))
}

if let path = options.logPath {
    let url = URL(fileURLWithPath: path)
    do {
        try agent.exportExperiences(to: url)
        print("Experiences exported to \(url.path)")
    } catch {
        print("Failed to export experiences: \(error)")
    }
}

if let path = options.visualizationPath {
    let url = URL(fileURLWithPath: path)
    do {
        try agent.exportVisualization(to: url)
        print("Visualization exported to \(url.path)")
    } catch {
        print("Failed to export visualization: \(error)")
    }
}
