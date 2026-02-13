import Foundation

struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed == 0 ? 0x4d595df4d0f33173 : seed
    }

    mutating func next() -> UInt64 {
        state = 2862933555777941757 &* state &+ 3037000493
        return state
    }

    mutating func nextDouble() -> Double {
        Double(next()) / Double(UInt64.max)
    }
}

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
    private var generator: SeededGenerator
    private let emotionMapping: [String: [Emotion: Double]] // Optimized: Pre-calculated mapping

    init(seed: UInt64? = nil, lexicon: [String: [Emotion: Double]] = [:]) {
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
        if let seed {
            generator = SeededGenerator(seed: seed)
        } else {
            var system = SystemRandomNumberGenerator()
            generator = SeededGenerator(seed: system.next())
        }

        // Self-awareness: Expanded emotional lexicon for nuanced stimuli interpretation.
        // Initialize default mapping
        var mapping: [String: [Emotion: Double]] = [
            "A": [.joy: 0.4, .curiosity: 0.3, .sadness: -0.1, .fear: -0.05],
            "B": [.fear: 0.6, .sadness: 0.5, .joy: -0.2, .anger: 0.1],
            "C": [.trust: 0.5, .curiosity: 0.2, .fear: -0.1],
            "?": [.curiosity: 0.8, .joy: 0.2, .anger: 0.05],
            "!": [.anger: 0.7, .fear: 0.5, .sadness: 0.2],
            "@": [.trust: 0.6, .joy: 0.4],
            "#": [.anger: 0.4, .sadness: 0.3]
        ]

        // Self-awareness: Integrating external knowledge.
        // Overlay provided lexicon
        for (key, value) in lexicon {
            mapping[key] = value
        }
        self.emotionMapping = mapping
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

        let outcome = feedback.likelyOutcomes.randomElement(using: &generator) ?? "Unpredictable outcome"
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

    // Self-awareness: Sharing a compact report artifact with other tools.
    func exportSummary(to url: URL, limit: Int = 5) throws {
        let summary = summaryReport(limit: max(limit, 1))
        try summary.write(to: url, atomically: true, encoding: .utf8)
    }

    // Self-awareness: Generating visual insights for deeper analysis.
    func exportVisualization(to url: URL) throws {
        let title = "AI Supercomputer - Experience Visualization"
        let css = """
        body { font-family: sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .meta { margin-bottom: 20px; }
        """

        var html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>\(title)</title>
            <style>\(css)</style>
        </head>
        <body>
            <h1>\(title)</h1>
            <div class="meta">
                <p><strong>Generated:</strong> \(Date())</p>
                <p><strong>Total Experiences:</strong> \(experienceMemory.count)</p>
            </div>
            <h2>Recent Experiences</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Input</th>
                    <th>Action</th>
                    <th>Outcome</th>
                    <th>Emotion Changes</th>
                </tr>
        """

        for exp in experienceMemory {
            let emotions = exp.emotionChanges
                .sorted { $0.key.rawValue < $1.key.rawValue }
                .map { "\($0.key.rawValue): \(String(format: \"%.2f\", $0.value))" }
                .joined(separator: ", ")

            html += """
                <tr>
                    <td>\(exp.timestamp)</td>
                    <td>\(exp.input)</td>
                    <td>\(exp.action.rawValue)</td>
                    <td>\(exp.outcome)</td>
                    <td>\(emotions)</td>
                </tr>
            """
        }

        html += """
            </table>
        </body>
        </html>
        """

        try html.write(to: url, atomically: true, encoding: .utf8)
    }

    private func mapInputToEmotion(_ input: String) -> [Emotion: Double] {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        // Prioritize exact matches from lexicon
        if let mapped = emotionMapping[trimmed] {
            return mapped
        }

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
            return possibleActions.randomElement(using: &generator)
        }
        return nil
    }

    private func determineActionFromExploration() -> Action? {
        let triedActions = Set(experienceMemory.map(\.action))
        let untriedActions = Action.allCases.filter { !triedActions.contains($0) }
        if !untriedActions.isEmpty {
            let confidenceFactor = 1.0 - (Double(untriedActions.count) / Double(experienceMemory.count + 1))
            let explorationProbability = Double(untriedActions.count) / Double(Action.allCases.count) * confidenceFactor
            if generator.nextDouble() < explorationProbability, let randomUntried = untriedActions.randomElement(using: &generator) {
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
            if generator.nextDouble() < boostProbability, let randomAction = possibleActions.randomElement(using: &generator) {
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

private extension Array {
    func randomElement(using generator: inout SeededGenerator) -> Element? {
        guard !isEmpty else { return nil }
        let index = Int(generator.next() % UInt64(count))
        return self[index]
    }
}
