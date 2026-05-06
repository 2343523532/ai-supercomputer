import XCTest
@testable import swift_ai_computer

final class swift_ai_computerTests: XCTestCase {
    func testLexiconSupportRecordsCustomEmotionChanges() {
        let customLexicon: [String: [Emotion: Double]] = [
            "XYZ": [.joy: 0.8, .curiosity: 0.5]
        ]

        let agent = AISupercomputer(seed: 7, lexicon: customLexicon)
        agent.respond(to: "XYZ")

        let experience = agent.experiences().first
        XCTAssertEqual(experience?.emotionChanges[.joy] ?? -1, 0.8, accuracy: 0.001)
        XCTAssertEqual(experience?.emotionChanges[.curiosity] ?? -1, 0.5, accuracy: 0.001)
        XCTAssertGreaterThan(agent.emotionalState()[.joy] ?? 0, 0.0)
    }

    func testDecisionInsightIncludesScoresRiskAndRecommendation() {
        let agent = AISupercomputer(seed: 11)
        agent.respond(to: "!")

        let insight = agent.decisionInsight()
        XCTAssertEqual(insight.totalExperiences, 1)
        XCTAssertFalse(insight.actionScores.isEmpty)
        XCTAssertTrue(["critical", "elevated", "watch", "steady"].contains(insight.riskLevel))
        XCTAssertFalse(insight.recommendedNextInput.isEmpty)
    }

    func testVisualizationExportEscapesUserInput() throws {
        let agent = AISupercomputer(seed: 23)
        agent.respond(to: "<script>alert('x')</script>")

        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("visualization.html")
        try? FileManager.default.removeItem(at: tempURL)

        try agent.exportVisualization(to: tempURL)

        XCTAssertTrue(FileManager.default.fileExists(atPath: tempURL.path))
        let content = try String(contentsOf: tempURL, encoding: .utf8)
        XCTAssertTrue(content.contains("AI Supercomputer - Experience Visualization"))
        XCTAssertTrue(content.contains("<table>"))
        XCTAssertTrue(content.contains("&lt;script&gt;alert(&#39;x&#39;)&lt;/script&gt;"))
        XCTAssertFalse(content.contains("<td><script>"))
    }

    func testSummaryExportIncludesDiagnostics() throws {
        let agent = AISupercomputer(seed: 42)
        agent.respond(to: "A")
        agent.respond(to: "?")

        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("summary.txt")
        try? FileManager.default.removeItem(at: tempURL)

        try agent.exportSummary(to: tempURL, limit: 2)

        XCTAssertTrue(FileManager.default.fileExists(atPath: tempURL.path))
        let content = try String(contentsOf: tempURL, encoding: .utf8)
        XCTAssertTrue(content.contains("Emotional state —"))
        XCTAssertTrue(content.contains("Diagnostics — Risk:"))
        XCTAssertTrue(content.contains("Recent experiences:"))
        XCTAssertTrue(content.contains("Input: A"))
    }

    func testDiagnosticsExportWritesJSON() throws {
        let agent = AISupercomputer(seed: 99)
        agent.respond(to: "PLAN")

        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("diagnostics.json")
        try? FileManager.default.removeItem(at: tempURL)

        try agent.exportDiagnostics(to: tempURL)
        let content = try String(contentsOf: tempURL, encoding: .utf8)
        XCTAssertTrue(content.contains("riskLevel"))
        XCTAssertTrue(content.contains("recommendedNextInput"))
    }
}
