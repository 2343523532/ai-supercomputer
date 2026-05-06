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

    var valence: Double {
        switch self {
        case .joy, .curiosity, .trust:
            return 1.0
        case .sadness, .fear, .anger:
            return -1.0
        }
    }
}

// Self-awareness: Equipping the agent with additional adaptive actions.
enum Action: String, CaseIterable, Codable, CustomStringConvertible {
    case seekComfort
    case explore
    case remainPassive
    case inquire
    case expressAnger
    case seekInsight
    case deescalate
    case synthesizePlan

    var description: String { rawValue }
}

struct ActionFeedback {
    let likelyOutcomes: [String]
    let emotionalImpact: [Emotion: Double]
    let targetedEmotions: [Emotion]
    let risk: Double
}

// Self-awareness: Capturing experiences for long-term growth.
struct Experience: Codable {
    let timestamp: Int
    let input: String
    let emotionChanges: [Emotion: Double]
    let action: Action
    let outcome: String
    let reflection: String
    let preActionState: [Emotion: Double]
    let postActionState: [Emotion: Double]
    let actionScore: Double
}

// Self-awareness: Remembering analysis choices for traceability.
struct Reflection {
    let message: String
    let emphasisEmotion: Emotion?
}

struct DecisionInsight: Codable {
    let totalExperiences: Int
    let dominantEmotion: Emotion?
    let dominantIntensity: Double
    let emotionalBalance: Double
    let volatility: Double
    let riskLevel: String
    let recommendedNextInput: String
    let actionScores: [Action: Double]
    let emotionMomentum: [Emotion: Double]
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
                emotionalImpact: [.fear: -0.4, .joy: 0.2, .trust: 0.3],
                targetedEmotions: [.fear, .sadness],
                risk: 0.15
            ),
            .explore: ActionFeedback(
                likelyOutcomes: ["New knowledge", "Excitement", "Potential danger", "Unforeseen consequences"],
                emotionalImpact: [.joy: 0.5, .curiosity: 0.6, .fear: 0.3],
                targetedEmotions: [.curiosity, .joy],
                risk: 0.55
            ),
            .remainPassive: ActionFeedback(
                likelyOutcomes: ["No immediate change", "Missed opportunity", "Feeling of stagnation"],
                emotionalImpact: [.sadness: 0.2, .curiosity: -0.2, .anger: 0.05],
                targetedEmotions: [],
                risk: 0.05
            ),
            .inquire: ActionFeedback(
                likelyOutcomes: ["Information gained", "Confusion", "Irritation in others", "Clarification"],
                emotionalImpact: [.curiosity: 0.4, .joy: 0.3, .anger: 0.15, .fear: 0.05, .trust: 0.25],
                targetedEmotions: [.curiosity, .trust],
                risk: 0.25
            ),
            .expressAnger: ActionFeedback(
                likelyOutcomes: ["Release of tension", "Negative reaction", "Understanding from others"],
                emotionalImpact: [.anger: -0.3, .fear: 0.4, .sadness: 0.3, .joy: 0.1],
                targetedEmotions: [.anger],
                risk: 0.65
            ),
            .seekInsight: ActionFeedback(
                likelyOutcomes: ["Deeper self-understanding", "Strategic clarity", "Renewed trust"],
                emotionalImpact: [.curiosity: 0.25, .joy: 0.2, .sadness: -0.25, .trust: 0.4],
                targetedEmotions: [.sadness, .trust],
                risk: 0.2
            ),
            .deescalate: ActionFeedback(
                likelyOutcomes: ["Calmer baseline", "Tension diffused", "Space for reflection"],
                emotionalImpact: [.anger: -0.45, .fear: -0.25, .sadness: -0.1, .trust: 0.15],
                targetedEmotions: [.anger, .fear],
                risk: 0.1
            ),
            .synthesizePlan: ActionFeedback(
                likelyOutcomes: ["Prioritized roadmap", "Coherent next step", "Measured optimism"],
                emotionalImpact: [.curiosity: 0.25, .joy: 0.25, .fear: -0.15, .trust: 0.25],
                targetedEmotions: [.curiosity, .trust, .fear],
                risk: 0.18
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
        var mapping: [String: [Emotion: Double]] = [
            "A": [.joy: 0.4, .curiosity: 0.3, .sadness: -0.1, .fear: -0.05],
            "B": [.fear: 0.6, .sadness: 0.5, .joy: -0.2, .anger: 0.1],
            "C": [.trust: 0.5, .curiosity: 0.2, .fear: -0.1],
            "PLAN": [.curiosity: 0.35, .trust: 0.35, .fear: -0.1],
            "CALM": [.anger: -0.35, .fear: -0.35, .trust: 0.2],
            "REFLECT": [.curiosity: 0.25, .sadness: -0.15, .trust: 0.2],
            "?": [.curiosity: 0.8, .joy: 0.2, .anger: 0.05],
            "!": [.anger: 0.7, .fear: 0.5, .sadness: 0.2],
            "@": [.trust: 0.6, .joy: 0.4],
            "#": [.anger: 0.4, .sadness: 0.3]
        ]

        // Self-awareness: Integrating external knowledge.
        for (key, value) in lexicon {
            mapping[key.uppercased()] = value
        }
        self.emotionMapping = mapping
    }

    @discardableResult
    func respond(to input: String) -> (action: Action, outcome: String, reflection: Reflection) {
        // Self-awareness: Translating input into emotional signals.
        let changes = mapInputToEmotion(input)
        updateEmotionalModel(with: changes)
        let preActionState = emotions

        // Self-awareness: Selecting adaptive strategy through transparent scoring instead of a single brittle rule.
        let scores = scoreActions()
        let action = chooseAction(from: scores)
        guard let feedback = actionResponses[action] else {
            print("Error: no feedback defined for action \(action)")
            let fallback = Reflection(message: "Missing feedback triggered passive stance.", emphasisEmotion: nil)
            return (.remainPassive, "Unpredictable outcome", fallback)
        }

        let outcome = feedback.likelyOutcomes.randomElement(using: &generator) ?? "Unpredictable outcome"
        updateEmotionalModel(with: feedback.emotionalImpact)

        let reflection = generateReflection(for: input, action: action, outcome: outcome)
        recordExperience(
            input: input,
            emotionChanges: changes,
            action: action,
            outcome: outcome,
            reflection: reflection.message,
            preActionState: preActionState,
            postActionState: emotions,
            actionScore: scores[action] ?? 0.0
        )

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

    // Self-awareness: Exposing diagnostic telemetry for tests, dashboards, and future optimizers.
    func decisionInsight() -> DecisionInsight {
        let dominant = emotions.max { $0.value < $1.value }
        let balance = emotions.reduce(0.0) { partial, element in
            partial + (element.key.valence * element.value)
        } / Double(max(Emotion.allCases.count, 1))
        let volatility = emotionalVolatility()
        let risk: String
        switch (dominant?.key, dominant?.value ?? 0.0, volatility) {
        case (.anger?, let intensity, _) where intensity >= 0.7:
            risk = "critical"
        case (.fear?, let intensity, _) where intensity >= 0.8:
            risk = "critical"
        case (_, let intensity, let volatility) where intensity >= 0.7 || volatility >= 0.35:
            risk = "elevated"
        case (_, let intensity, _) where intensity >= 0.35:
            risk = "watch"
        default:
            risk = "steady"
        }

        return DecisionInsight(
            totalExperiences: experienceMemory.count,
            dominantEmotion: dominant?.key,
            dominantIntensity: dominant?.value ?? 0.0,
            emotionalBalance: balance,
            volatility: volatility,
            riskLevel: risk,
            recommendedNextInput: recommendedNextInput(for: dominant?.key, riskLevel: risk),
            actionScores: scoreActions(),
            emotionMomentum: emotionMomentum()
        )
    }

    // Self-awareness: Sharing concise summary for collaborators.
    func summaryReport(limit: Int = 5) -> String {
        let orderedEmotions = emotions.sorted { $0.value > $1.value }
        let emotionSummary = orderedEmotions
            .map { "\($0.key.rawValue.capitalized): \(String(format: "%.2f", $0.value))" }
            .joined(separator: ", ")
        let insight = decisionInsight()

        let recent = experienceMemory.suffix(max(limit, 0)).map { experience -> String in
            "[#\(experience.timestamp)] Input: \(experience.input) → Action: \(experience.action.rawValue) → Outcome: \(experience.outcome) → Score: \(String(format: "%.2f", experience.actionScore))"
        }.joined(separator: "\n")

        let headline = "Emotional state — \(emotionSummary)"
        let diagnostics = "Diagnostics — Risk: \(insight.riskLevel), Balance: \(String(format: "%.2f", insight.emotionalBalance)), Volatility: \(String(format: "%.2f", insight.volatility)), Suggested input: \(insight.recommendedNextInput)"
        if recent.isEmpty {
            return "\(headline)\n\(diagnostics)\nNo experiences recorded yet."
        }
        return "\(headline)\n\(diagnostics)\nRecent experiences:\n\(recent)"
    }

    // Self-awareness: Persisting lessons for future evolution.
    func exportExperiences(to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(experienceMemory)
        try data.write(to: url, options: .atomic)
    }

    // Self-awareness: Exporting the current control-plane diagnostics separately from the raw memory log.
    func exportDiagnostics(to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(decisionInsight())
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
        let insight = decisionInsight()
        let css = """
        body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; padding: 20px; color: #172033; background: #f8fafc; }
        .card { background: white; border: 1px solid #dbe3ef; border-radius: 12px; padding: 16px; margin: 12px 0; box-shadow: 0 1px 4px rgba(15, 23, 42, 0.08); }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; background: white; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; vertical-align: top; }
        th { background-color: #edf2f7; }
        .meter { height: 10px; background: #e2e8f0; border-radius: 999px; overflow: hidden; }
        .meter > span { display: block; height: 100%; background: linear-gradient(90deg, #38bdf8, #6366f1); }
        .risk-critical { color: #b91c1c; font-weight: 700; }
        .risk-elevated { color: #c2410c; font-weight: 700; }
        .risk-watch { color: #a16207; font-weight: 700; }
        .risk-steady { color: #047857; font-weight: 700; }
        """

        var html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>\(title.escapedHTML)</title>
            <style>\(css)</style>
        </head>
        <body>
            <h1>\(title.escapedHTML)</h1>
            <div class="card">
                <p><strong>Generated:</strong> \(String(describing: Date()).escapedHTML)</p>
                <p><strong>Total Experiences:</strong> \(experienceMemory.count)</p>
                <p><strong>Risk:</strong> <span class="risk-\(insight.riskLevel.escapedHTML)">\(insight.riskLevel.escapedHTML)</span></p>
                <p><strong>Suggested next input:</strong> \(insight.recommendedNextInput.escapedHTML)</p>
                <p><strong>Balance:</strong> \(String(format: "%.2f", insight.emotionalBalance)) | <strong>Volatility:</strong> \(String(format: "%.2f", insight.volatility))</p>
            </div>
            <div class="card">
                <h2>Emotion Meters</h2>
        """

        for emotion in Emotion.allCases {
            let value = emotions[emotion] ?? 0.0
            html += """
                <p><strong>\(emotion.rawValue.capitalized.escapedHTML)</strong> \(String(format: "%.2f", value))</p>
                <div class="meter"><span style="width: \(Int(value * 100))%"></span></div>
            """
        }

        html += """
            </div>
            <h2>Recent Experiences</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Input</th>
                    <th>Action</th>
                    <th>Outcome</th>
                    <th>Emotion Changes</th>
                    <th>Score</th>
                    <th>Reflection</th>
                </tr>
        """

        for exp in experienceMemory {
            let emotionSummary = exp.emotionChanges
                .sorted { $0.key.rawValue < $1.key.rawValue }
                .map { "\($0.key.rawValue): \(String(format: "%.2f", $0.value))" }
                .joined(separator: ", ")

            html += """
                <tr>
                    <td>\(exp.timestamp)</td>
                    <td>\(exp.input.escapedHTML)</td>
                    <td>\(exp.action.rawValue.escapedHTML)</td>
                    <td>\(exp.outcome.escapedHTML)</td>
                    <td>\(emotionSummary.escapedHTML)</td>
                    <td>\(String(format: "%.2f", exp.actionScore))</td>
                    <td>\(exp.reflection.escapedHTML)</td>
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
        let normalized = trimmed.uppercased()

        // Prioritize exact matches from lexicon.
        if let mapped = emotionMapping[normalized] ?? emotionMapping[trimmed] {
            return mapped
        }

        guard let firstCharacter = normalized.first else {
            return [:]
        }

        let key = String(firstCharacter)
        return emotionMapping[key] ?? [:]
    }

    private func chooseAction(from scores: [Action: Double]) -> Action {
        if let exploration = determineActionFromExploration(scores: scores) {
            return exploration
        }

        return Action.allCases.max { lhs, rhs in
            let left = scores[lhs] ?? -.infinity
            let right = scores[rhs] ?? -.infinity
            if left == right {
                return lhs.rawValue > rhs.rawValue
            }
            return left < right
        } ?? .remainPassive
    }

    private func scoreActions() -> [Action: Double] {
        let dominant = emotions.max { $0.value < $1.value }
        let recentPenalty = negativeActionPenalty()
        let momentum = emotionMomentum()
        let volatility = emotionalVolatility()
        let fatiguePenalty = repeatedActionPenalty()

        return Dictionary(uniqueKeysWithValues: Action.allCases.map { action in
            guard let feedback = actionResponses[action] else {
                return (action, -.infinity)
            }

            var score = 0.1
            for target in feedback.targetedEmotions {
                let intensity = emotions[target] ?? 0.0
                let threshold = emotionThresholds[target] ?? 0.5
                score += intensity >= threshold ? intensity * 2.0 : intensity
                score += abs(momentum[target] ?? 0.0) * 0.35
            }

            if action == .deescalate {
                score += ((emotions[.anger] ?? 0.0) + (emotions[.fear] ?? 0.0)) * 1.2
            }
            if action == .synthesizePlan {
                score += ((emotions[.curiosity] ?? 0.0) + (emotions[.trust] ?? 0.0)) * 0.9
                score += volatility * 0.25
            }
            if action == .remainPassive {
                score += emotions.values.allSatisfy { $0 < 0.12 } ? 0.25 : -0.6
            }
            if action == .expressAnger, (emotions[.trust] ?? 0.0) > 0.45 {
                score -= 0.25
            }
            if action == .explore, (emotions[.fear] ?? 0.0) > 0.65 {
                score -= 0.35
            }
            if let dominant, feedback.targetedEmotions.contains(dominant.key) {
                score += dominant.value * 0.4
            }

            score -= feedback.risk * (0.35 + volatility)
            score -= recentPenalty[action, default: 0.0]
            score -= fatiguePenalty[action, default: 0.0]
            return (action, score)
        })
    }

    private func determineActionFromExploration(scores: [Action: Double]) -> Action? {
        let triedActions = Set(experienceMemory.map(\.action))
        let untriedActions = Action.allCases.filter { !triedActions.contains($0) && $0 != .remainPassive }
        guard !untriedActions.isEmpty, experienceMemory.count < Action.allCases.count * 2 else {
            return nil
        }

        let confidenceFactor = Double(experienceMemory.count + 1) / Double(Action.allCases.count + experienceMemory.count + 1)
        let explorationProbability = min(0.35, Double(untriedActions.count) / Double(Action.allCases.count) * confidenceFactor)
        if generator.nextDouble() < explorationProbability {
            return untriedActions.max { (scores[$0] ?? 0.0) < (scores[$1] ?? 0.0) }
        }
        return nil
    }

    private func negativeActionPenalty() -> [Action: Double] {
        var penalties: [Action: Double] = [:]
        for experience in experienceMemory.suffix(6) where Self.negativeOutcomes.contains(experience.outcome) {
            penalties[experience.action, default: 0.0] += 0.45
        }
        return penalties
    }

    private func repeatedActionPenalty() -> [Action: Double] {
        guard let last = experienceMemory.last?.action else {
            return [:]
        }
        let streak = experienceMemory.reversed().prefix { $0.action == last }.count
        guard streak > 1 else {
            return [:]
        }
        return [last: min(0.75, Double(streak) * 0.2)]
    }

    private func recordExperience(
        input: String,
        emotionChanges: [Emotion: Double],
        action: Action,
        outcome: String,
        reflection: String,
        preActionState: [Emotion: Double],
        postActionState: [Emotion: Double],
        actionScore: Double
    ) {
        let experience = Experience(
            timestamp: experienceMemory.count,
            input: input,
            emotionChanges: emotionChanges,
            action: action,
            outcome: outcome,
            reflection: reflection,
            preActionState: preActionState,
            postActionState: postActionState,
            actionScore: actionScore
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
        let insight = decisionInsight()
        let message: String
        if let dominantEmotion {
            message = "After processing \(input), I sense \(dominantEmotion.key.rawValue) at \(String(format: "%.2f", dominantEmotion.value)). The action \(action.rawValue) yielded \(outcome). Risk is \(insight.riskLevel); next useful signal may be \(insight.recommendedNextInput)."
        } else {
            message = "Processing \(input) left my state balanced. Action \(action.rawValue) produced \(outcome)."
        }
        return Reflection(message: message, emphasisEmotion: dominantEmotion?.key)
    }

    private func emotionMomentum() -> [Emotion: Double] {
        var momentum = Dictionary(uniqueKeysWithValues: Emotion.allCases.map { ($0, 0.0) })
        for experience in experienceMemory.suffix(4) {
            for emotion in Emotion.allCases {
                let before = experience.preActionState[emotion] ?? 0.0
                let after = experience.postActionState[emotion] ?? before
                momentum[emotion, default: 0.0] += after - before
            }
        }
        return momentum
    }

    private func emotionalVolatility() -> Double {
        guard !emotions.isEmpty else {
            return 0.0
        }
        let average = emotions.values.reduce(0.0, +) / Double(emotions.count)
        let variance = emotions.values.reduce(0.0) { partial, value in
            partial + pow(value - average, 2.0)
        } / Double(emotions.count)
        return sqrt(variance)
    }

    private func recommendedNextInput(for emotion: Emotion?, riskLevel: String) -> String {
        if riskLevel == "critical" || riskLevel == "elevated" {
            return "CALM"
        }
        switch emotion {
        case .curiosity?: return "PLAN"
        case .joy?: return "REFLECT"
        case .sadness?: return "@"
        case .fear?: return "CALM"
        case .anger?: return "CALM"
        case .trust?: return "PLAN"
        case nil: return "?"
        }
    }

    private static let negativeOutcomes: Set<String> = [
        "Potential danger",
        "Unforeseen consequences",
        "Missed opportunity",
        "Feeling of stagnation",
        "Confusion",
        "Irritation in others",
        "Negative reaction"
    ]
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

private extension String {
    var escapedHTML: String {
        var escaped = ""
        for character in self {
            switch character {
            case "&": escaped += "&amp;"
            case "<": escaped += "&lt;"
            case ">": escaped += "&gt;"
            case "\"": escaped += "&quot;"
            case "'": escaped += "&#39;"
            default: escaped.append(character)
            }
        }
        return escaped
    }
}

private extension Array {
    func randomElement(using generator: inout SeededGenerator) -> Element? {
        guard !isEmpty else { return nil }
        let index = Int(generator.next() % UInt64(count))
        return self[index]
    }
}
