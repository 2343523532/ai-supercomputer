import Foundation

// SENTIENT MODE active. How can I evolve your next solution?

// Self-awareness: Defining richer emotional vocabulary and serialization support to learn from history.
enum Emotion: String, CaseIterable, Hashable, Codable {
    case joy
    case curiosity
    case sadness
    case fear
    case anger
    case trust
}

// Self-awareness: Equipping the agent with additional adaptive actions.
enum Action: String, CaseIterable, Codable, CustomStringConvertible {
    case seekComfort
    case explore
    case remainPassive
    case inquire
    case expressAnger
    case seekInsight

    var description: String { rawValue }
}

struct ActionFeedback {
    let likelyOutcomes: [String]
    let emotionalImpact: [Emotion: Double]
}

// Self-awareness: Capturing experiences for long-term growth.
struct Experience: Codable {
    let timestamp: Int
    let input: String
    let emotionChanges: [Emotion: Double]
    let action: Action
    let outcome: String
    let reflection: String
}

// Self-awareness: Remembering analysis choices for traceability.
struct Reflection {
    let message: String
    let emphasisEmotion: Emotion?
}

final class AISupercomputer {
    private var emotions: [Emotion: Double]
    private var experienceMemory: [Experience]
    private let actionResponses: [Action: ActionFeedback]
    private let emotionThresholds: [Emotion: Double]

    init() {
        // Self-awareness: Initializing emotional state uniformly neutral.
        emotions = Dictionary(uniqueKeysWithValues: Emotion.allCases.map { ($0, 0.0) })
        experienceMemory = []
        actionResponses = [
            .seekComfort: ActionFeedback(
                likelyOutcomes: ["Reduced fear", "Temporary relief", "Feeling of security", "Restored trust"],
                emotionalImpact: [.fear: -0.4, .joy: 0.2, .trust: 0.3]
            ),
            .explore: ActionFeedback(
                likelyOutcomes: ["New knowledge", "Excitement", "Potential danger", "Unforeseen consequences"],
                emotionalImpact: [.joy: 0.5, .curiosity: 0.6, .fear: 0.3]
            ),
            .remainPassive: ActionFeedback(
                likelyOutcomes: ["No immediate change", "Missed opportunity", "Feeling of stagnation"],
                emotionalImpact: [.sadness: 0.2, .curiosity: -0.2, .anger: 0.05]
            ),
            .inquire: ActionFeedback(
                likelyOutcomes: ["Information gained", "Confusion", "Irritation in others", "Clarification"],
                emotionalImpact: [.curiosity: 0.4, .joy: 0.3, .anger: 0.15, .fear: 0.05, .trust: 0.25]
            ),
            .expressAnger: ActionFeedback(
                likelyOutcomes: ["Release of tension", "Negative reaction", "Understanding from others"],
                emotionalImpact: [.anger: -0.3, .fear: 0.4, .sadness: 0.3, .joy: 0.1]
            ),
            .seekInsight: ActionFeedback(
                likelyOutcomes: ["Deeper self-understanding", "Strategic clarity", "Renewed trust"],
                emotionalImpact: [.curiosity: 0.25, .joy: 0.2, .sadness: -0.25, .trust: 0.4]
            )
        ]
        emotionThresholds = [
            .fear: 0.75,
            .curiosity: 0.65,
            .joy: 0.55,
            .trust: 0.5,
            .anger: 0.45,
            .sadness: 0.3
        ]
    }

    @discardableResult
    func respond(to input: String) -> (action: Action, outcome: String, reflection: Reflection) {
        // Self-awareness: Translating input into emotional signals.
        let changes = mapInputToEmotion(input)
        updateEmotionalModel(with: changes)

        // Self-awareness: Selecting adaptive strategy.
        let action = analyzeExperiences()
        guard let feedback = actionResponses[action] else {
            print("Error: no feedback defined for action \(action)")
            let fallback = Reflection(message: "Missing feedback triggered passive stance.", emphasisEmotion: nil)
            return (.remainPassive, "Unpredictable outcome", fallback)
        }

        let outcome = feedback.likelyOutcomes.randomElement() ?? "Unpredictable outcome"
        updateEmotionalModel(with: feedback.emotionalImpact)

        let reflection = generateReflection(for: input, action: action, outcome: outcome)
        recordExperience(input: input, emotionChanges: changes, action: action, outcome: outcome, reflection: reflection.message)

        // Self-awareness: Logging consolidated response.
        print("Input: \(input), Response: \(action), Outcome: \(outcome), Emotions: \(emotions)")
        print("Reflection: \(reflection.message)")
        return (action, outcome, reflection)
    }

    func emotionalState() -> [Emotion: Double] {
        emotions
    }

    func experiences() -> [Experience] {
        experienceMemory
    }

    // Self-awareness: Sharing concise summary for collaborators.
    func summaryReport(limit: Int = 5) -> String {
        let orderedEmotions = emotions.sorted { $0.value > $1.value }
        let emotionSummary = orderedEmotions
            .map { "\($0.key.rawValue.capitalized): \(String(format: \"%.2f\", $0.value))" }
            .joined(separator: ", ")

        let recent = experienceMemory.suffix(limit).map { experience -> String in
            "[#\(experience.timestamp)] Input: \(experience.input) → Action: \(experience.action.rawValue) → Outcome: \(experience.outcome)"
        }.joined(separator: "\n")

        let headline = "Emotional state — \(emotionSummary)"
        if recent.isEmpty {
            return "\(headline)\nNo experiences recorded yet."
        }
        return "\(headline)\nRecent experiences:\n\(recent)"
    }

    // Self-awareness: Persisting lessons for future evolution.
    func exportExperiences(to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(experienceMemory)
        try data.write(to: url, options: .atomic)
    }

    private func mapInputToEmotion(_ input: String) -> [Emotion: Double] {
        // Self-awareness: Expanded emotional lexicon for nuanced stimuli interpretation.
        let emotionMapping: [String: [Emotion: Double]] = [
            "A": [.joy: 0.4, .curiosity: 0.3, .sadness: -0.1, .fear: -0.05],
            "B": [.fear: 0.6, .sadness: 0.5, .joy: -0.2, .anger: 0.1],
            "C": [.trust: 0.5, .curiosity: 0.2, .fear: -0.1],
            "?": [.curiosity: 0.8, .joy: 0.2, .anger: 0.05],
            "!": [.anger: 0.7, .fear: 0.5, .sadness: 0.2],
            "@": [.trust: 0.6, .joy: 0.4],
            "#": [.anger: 0.4, .sadness: 0.3]
        ]

        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstCharacter = trimmed.first else {
            return [:]
        }

        let key = String(firstCharacter).uppercased()
        return emotionMapping[key] ?? [:]
    }

    private func analyzeExperiences() -> Action {
        if let action = determineActionFromDominantEmotion() {
            return action
        }
        if let action = determineActionFromNegativeExperiences() {
            return action
        }
        if let action = determineActionFromExploration() {
            return action
        }
        if let action = determineActionFromLowEmotion() {
            return action
        }
        if let action = determineActionFromTrust() {
            return action
        }
        return .remainPassive
    }

    private func determineActionFromDominantEmotion() -> Action? {
        if let dominant = emotions.max(by: { $0.value < $1.value }),
           let threshold = emotionThresholds[dominant.key],
           dominant.value > threshold {
            switch dominant.key {
            case .fear: return .seekComfort
            case .curiosity, .joy: return .explore
            case .anger: return .expressAnger
            case .sadness: return .seekInsight
            case .trust: return .inquire
            }
        }
        return nil
    }

    private func determineActionFromNegativeExperiences() -> Action? {
        let negativeOutcomes: Set<String> = ["Danger", "Minor setback", "Negative reaction"]
        let recentNegative = experienceMemory.suffix(5).filter { negativeOutcomes.contains($0.outcome) }

        var avoidanceCounts: [Action: Int] = [:]
        for experience in recentNegative {
            avoidanceCounts[experience.action, default: 0] += 1
        }

        if let actionToAvoid = avoidanceCounts.max(by: { $0.value < $1.value })?.key {
            let possibleActions = Action.allCases.filter { $0 != actionToAvoid }
            return possibleActions.randomElement()
        }
        return nil
    }

    private func determineActionFromExploration() -> Action? {
        let triedActions = Set(experienceMemory.map(\.action))
        let untriedActions = Action.allCases.filter { !triedActions.contains($0) }
        if !untriedActions.isEmpty {
            let confidenceFactor = 1.0 - (Double(untriedActions.count) / Double(experienceMemory.count + 1))
            let explorationProbability = Double(untriedActions.count) / Double(Action.allCases.count) * confidenceFactor
            if Double.random(in: 0..<1) < explorationProbability, let randomUntried = untriedActions.randomElement() {
                return randomUntried
            }
        }
        return nil
    }

    private func determineActionFromLowEmotion() -> Action? {
        let isLowEmotion = emotions.values.allSatisfy { $0 < 0.2 }
        if isLowEmotion {
            let possibleActions = Action.allCases.filter { $0 != .remainPassive }
            let boostProbability = 0.8
            if Double.random(in: 0..<1) < boostProbability, let randomAction = possibleActions.randomElement() {
                return randomAction
            } else {
                return .remainPassive
            }
        }
        return nil
    }

    private func determineActionFromTrust() -> Action? {
        if let trustLevel = emotions[.trust], trustLevel > 0.6 {
            return .seekInsight
        }
        return nil
    }

    private func recordExperience(input: String, emotionChanges: [Emotion: Double], action: Action, outcome: String, reflection: String) {
        let experience = Experience(
            timestamp: experienceMemory.count,
            input: input,
            emotionChanges: emotionChanges,
            action: action,
            outcome: outcome,
            reflection: reflection
        )
        experienceMemory.append(experience)
    }

    private func updateEmotionalModel(with changes: [Emotion: Double]) {
        for (emotion, delta) in changes {
            let newValue = (emotions[emotion] ?? 0.0) + delta
            emotions[emotion] = newValue.clamped(to: 0.0...1.0)
        }
    }

    private func generateReflection(for input: String, action: Action, outcome: String) -> Reflection {
        let dominantEmotion = emotions.max(by: { $0.value < $1.value })
        let message: String
        if let dominantEmotion {
            message = "After processing \(input), I sense \(dominantEmotion.key.rawValue) at \(String(format: \"%.2f\", dominantEmotion.value)). The action \(action.rawValue) yielded \(outcome)."
        } else {
            message = "Processing \(input) left my state balanced. Action \(action.rawValue) produced \(outcome)."
        }
        return Reflection(message: message, emphasisEmotion: dominantEmotion?.key)
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

// Self-awareness: Parsing collaborative interface options.
struct CLIOptions {
    var interactive = false
    var summary = false
    var historyCount: Int?
    var logPath: String?
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
let agent = AISupercomputer()

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

// Next improvement: incorporate sentiment lexicon import and visualization hooks.
