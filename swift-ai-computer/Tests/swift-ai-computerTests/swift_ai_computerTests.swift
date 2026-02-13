import XCTest
@testable import swift_ai_computer

final class swift_ai_computerTests: XCTestCase {
    func testLexiconSupport() {
        // Create a custom lexicon
        let customLexicon: [String: [Emotion: Double]] = [
            "XYZ": [.joy: 0.8, .curiosity: 0.5]
        ]

        let agent = AISupercomputer(lexicon: customLexicon)

        // Respond to input defined in lexicon
        let result = agent.respond(to: "XYZ")

        // Verify that the emotional state reflects the lexicon values
        // Note: This assumes starting state is 0.0 for all emotions
        let state = agent.emotionalState()
        XCTAssertEqual(state[.joy], 0.8, accuracy: 0.001)
        XCTAssertEqual(state[.curiosity], 0.5, accuracy: 0.001)
    }

    func testVisualizationExport() throws {
        let agent = AISupercomputer()
        agent.respond(to: "A")
        agent.respond(to: "B")

        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("visualization.html")

        // Clean up if exists
        try? FileManager.default.removeItem(at: tempURL)

        try agent.exportVisualization(to: tempURL)

        // Verify file exists
        XCTAssertTrue(FileManager.default.fileExists(atPath: tempURL.path))

        // Verify content
        let content = try String(contentsOf: tempURL)
        XCTAssertTrue(content.contains("AI Supercomputer - Experience Visualization"))
        XCTAssertTrue(content.contains("<table>"))
        // Check for table cell content instead of input format
        XCTAssertTrue(content.contains("<td>A</td>"))
    }

    func testSummaryExport() throws {
        let agent = AISupercomputer(seed: 42)
        agent.respond(to: "A")
        agent.respond(to: "?")

        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("summary.txt")
        try? FileManager.default.removeItem(at: tempURL)

        try agent.exportSummary(to: tempURL, limit: 2)

        XCTAssertTrue(FileManager.default.fileExists(atPath: tempURL.path))
        let content = try String(contentsOf: tempURL)
        XCTAssertTrue(content.contains("Emotional state —"))
        XCTAssertTrue(content.contains("Recent experiences:"))
        XCTAssertTrue(content.contains("Input: A"))
    }

}
