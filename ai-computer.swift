import Foundation

/// Represents the possible emotional dimensions tracked by the AI.
enum Emotion: CaseIterable, Hashable {
    case joy
    case curiosity
    case sadness
    case fear
    case anger
}

/// Represents the available actions the AI can take when responding to input.
enum Action: CaseIterable, CustomStringConvertible {
    case seekComfort
    case explore
    case remainPassive
    case inquire
    case expressAnger

    var description: String {
        switch self {
        case .seekComfort: return "seekComfort"
        case .explore: return "explore"
        case .remainPassive: return "remainPassive"
        case .inquire: return "inquire"
        case .expressAnger: return "expressAnger"
        }
    }
}

/// Captures the feedback associated with an action.
struct ActionFeedback {
    let likelyOutcomes: [String]
    let emotionalImpact: [Emotion: Double]
}

/// Stores the relevant information for a single interaction.
struct Experience {
    let timestamp: Int
    let input: String
    let emotionChanges: [Emotion: Double]
    let action: Action
    let outcome: String
}

/// A minimal emotional model that learns from experience and provides responses.
final class AISupercomputer {
    private var emotions: [Emotion: Double]
    private var experienceMemory: [Experience]
    private let actionResponses: [Action: ActionFeedback]
    private let emotionThresholds: [Emotion: Double]

    init() {
        emotions = Dictionary(uniqueKeysWithValues: Emotion.allCases.map { ($0, 0.0) })
        experienceMemory = []
        actionResponses = [
            .seekComfort: ActionFeedback(
                likelyOutcomes: ["Reduced fear", "Temporary relief", "Feeling of security"],
                emotionalImpact: [.fear: -0.4, .joy: 0.2]
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
                emotionalImpact: [.curiosity: 0.4, .joy: 0.3, .anger: 0.15, .fear: 0.05]
            ),
            .expressAnger: ActionFeedback(
                likelyOutcomes: ["Release of tension", "Negative reaction", "Understanding from others"],
                emotionalImpact: [.anger: -0.3, .fear: 0.4, .sadness: 0.3, .joy: 0.1]
            )
        ]
        emotionThresholds = [
            .fear: 0.75,
            .curiosity: 0.65,
            .joy: 0.55,
            .anger: 0.45,
            .sadness: 0.3
        ]
    }

    /// Produces a response to the supplied input while updating the emotional model.
    @discardableResult
    func respond(to input: String) -> Action {
        let changes = mapInputToEmotion(input)
        updateEmotionalModel(with: changes)

        let action = analyzeExperiences()
        guard let feedback = actionResponses[action] else {
            print("Error: no feedback defined for action \(action)")
            return .remainPassive
        }

        let outcome = feedback.likelyOutcomes.randomElement() ?? "Unpredictable outcome"
        recordExperience(input: input, emotionChanges: changes, action: action, outcome: outcome)
        updateEmotionalModel(with: feedback.emotionalImpact)

        print("Input: \(input), Response: \(action), Outcome: \(outcome), Emotions: \(emotions)")
        return action
    }

    /// The current emotional state of the AI.
    func emotionalState() -> [Emotion: Double] {
        emotions
    }

    /// A copy of the experience memory accumulated so far.
    func experiences() -> [Experience] {
        experienceMemory
    }

    private func mapInputToEmotion(_ input: String) -> [Emotion: Double] {
        let emotionMapping: [String: [Emotion: Double]] = [
            "A": [.joy: 0.4, .curiosity: 0.3, .sadness: -0.1, .fear: -0.05],
            "B": [.fear: 0.6, .sadness: 0.5, .joy: -0.2, .anger: 0.1],
            "?": [.curiosity: 0.8, .joy: 0.2, .anger: 0.05],
            "!": [.anger: 0.7, .fear: 0.5, .sadness: 0.2]
        ]

        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let firstCharacter = trimmed.first else {
            return [:]
        }

        let key = String(firstCharacter).uppercased()
        return emotionMapping[key] ?? [:]
    }

    private func analyzeExperiences() -> Action {
        if let dominant = emotions.max(by: { $0.value < $1.value }),
           let threshold = emotionThresholds[dominant.key],
           dominant.value > threshold {
            switch dominant.key {
            case .fear:
                return .seekComfort
            case .curiosity, .joy:
                return .explore
            case .anger:
                return .expressAnger
            case .sadness:
                return .remainPassive
            }
        }

        let negativeOutcomes: Set<String> = ["Danger", "Minor setback", "Negative reaction"]
        let recentNegative = experienceMemory.suffix(5).filter { negativeOutcomes.contains($0.outcome) }

        var avoidanceCounts: [Action: Int] = [:]
        for experience in recentNegative {
            avoidanceCounts[experience.action, default: 0] += 1
        }

        if let actionToAvoid = avoidanceCounts.max(by: { $0.value < $1.value })?.key {
            let possibleActions = Action.allCases.filter { $0 != actionToAvoid }
            if let randomAction = possibleActions.randomElement() {
                return randomAction
            }
        }

        let triedActions = Set(experienceMemory.map(\.action))
        let untriedActions = Action.allCases.filter { !triedActions.contains($0) }
        if !untriedActions.isEmpty {
            let confidenceFactor = 1.0 - (Double(untriedActions.count) / Double(experienceMemory.count + 1))
            let explorationProbability = Double(untriedActions.count) / Double(Action.allCases.count) * confidenceFactor
            if Double.random(in: 0..<1) < explorationProbability,
               let randomUntried = untriedActions.randomElement() {
                return randomUntried
            }
        }

        let isLowEmotion = emotions.values.allSatisfy { $0 < 0.2 }
        if isLowEmotion {
            let possibleActions = Action.allCases.filter { $0 != .remainPassive }
            let boostProbability = 0.8
            if Double.random(in: 0..<1) < boostProbability,
               let randomAction = possibleActions.randomElement() {
                return randomAction
            } else {
                return .remainPassive
            }
        }

        return .remainPassive
    }

    private func recordExperience(input: String, emotionChanges: [Emotion: Double], action: Action, outcome: String) {
        let experience = Experience(
            timestamp: experienceMemory.count,
            input: input,
            emotionChanges: emotionChanges,
            action: action,
            outcome: outcome
        )
        experienceMemory.append(experience)
    }

    private func updateEmotionalModel(with changes: [Emotion: Double]) {
        for (emotion, delta) in changes {
            let newValue = (emotions[emotion] ?? 0.0) + delta
            emotions[emotion] = newValue.clamped(to: 0.0...1.0)
        }
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

if CommandLine.arguments.count > 1 {
    let agent = AISupercomputer()
    for argument in CommandLine.arguments.dropFirst() {
        _ = agent.respond(to: argument)
    }
}
