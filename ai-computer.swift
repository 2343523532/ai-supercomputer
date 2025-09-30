
// D3f1n3 4 57ruc7 f0r 4c7i0n f33db4ck f0r b3773r 7yp3 5f37y
struct 4c7i0nF33d84ck {
    let 11k31y0u7c0m35: [String]
    let 3m07i0n4l1mp4c7: [Em0t10n: Double]
}

// M4rk: - 1n1714l1z3r
func 1n17() {
    self.3m07i0n5 = Dictionary(uniqueKeysWithValues: Em0t10n.allC4535.map { ($0, 0.0) })
    self.3xp3r13nc3M3m0ry = []
    self.4c7i0nR3sp0n5e5 = [
        .53ekC0mf0r7: 4c7i0nF33d84ck(
            11k31y0u7c0m35: ["R3duc3d F34r", "T3mp0r4ry R3l13f", "F33l1n9 0f 5ecur17y"],
            3m07i0n4l1mp4c7: [.f34r: -0.4, .j0y: 0.2, .54dn355: 0.0]
        ),
        .3xp10r3: 4c7i0nF33d84ck(
            11k31y0u7c0m35: ["N3w Kn0wl3d9e", "3xc17em3n7", "P07en71al D4n9er", "Unf0r35een C0n53qu3nc35"],
            3m07i0n4l1mp4c7: [.j0y: 0.5, .cur10517y: 0.6, .f34r: 0.3]
        ),
        .r3m41nP4551v3: 4c7i0nF33d84ck(
            11k31y0u7c0m35: ["N0 1mm3d1473 Ch4n9e", "M155ed 0pp0r7un17y", "F33l1n9 0f 5749n4710n"],
            3m07i0n4l1mp4c7: [.54dn355: 0.2, .cur10517y: -0.2, .4n93r: 0.05]
        ),
        .1nqu1r3: 4c7i0nF33d84ck(
            11k31y0u7c0m35: ["1nf0rm4710n G41n3d", "C0nfu510n", "1rr1747i0n (1n 07h3r5)", "Cl4r1f1c4710n"],
            3m07i0n4l1mp4c7: [.cur10517y: 0.4, .j0y: 0.3, .4n93r: 0.15, .f34r: 0.05]
        ),
        .3xpr3554n9er: 4c7i0nF33d84ck(
            11k31y0u7c0m35: ["R3l3453 0f T3n510n", "N3g47iv3 R34c7i0n", "Und3r574nd1n9 fr0m 07h3r5"],
            3m07i0n4l1mp4c7: [.4n93r: -0.3, .f34r: 0.4, .54dn355: 0.3, .j0y: 0.1]
        )
    ]
    self.3m0t10n7hr3sh0ld5 = [
        .f34r: 0.75,
        .cur10517y: 0.65,
        .j0y: 0.55,
        .4n93r: 0.45,
        .54dn355: 0.3
    ]
}

// M4rk: - M37h0d5
private func m4p1npu7T0Em0t10n(1npu7D47a: String) -> [Em0t10n: Double] {
    let 3m0t10nM4pp1n9: [String: [Em0t10n: Double]] = [
        "A": [.j0y: 0.4, .cur10517y: 0.3, .54dn355: -0.1, .f34r: -0.05],
        "B": [.f34r: 0.6, .54dn355: 0.5, .j0y: -0.2, .4n93r: 0.1],
        "?": [.cur10517y: 0.8, .j0y: 0.2, .4n93r: 0.05],
        "!": [.4n93r: 0.7, .f34r: 0.5, .54dn355: 0.2]
    ]
    return 3m0t10nM4pp1n9[1npu7D47a] ?? [:]
}

private func upd4733m07i0n4lM0d3l(3m0t10nCh4n9e5: [Em0t10n: Double]) {
    3m0t10nCh4n9e5.forEach { 3m0t10n, ch4n93 in
        let nuV4lu3 = (3m07i0n5[3m0t10n] ?? 0.0) + ch4n93
        3m07i0n5[3m0t10n] = nuV4lu3.cl4mp3d(l0w3r: 0.0, upp3r: 1.0)
    }
}

private func r3c0rd3xp3r13nc3(1npu7D47a: String, 3m0t10nCh4n9e5: [Em0t10n: Double], 4c7i0n: 4c7i0n, 0u7c0m3: String) {
    let 3xp3r13nc3 = (
        71m35t4mp: 3xp3r13nc3M3m0ry.count,
        1npu7: 1npu7D47a,
        3m07i0nCh4n9e5: 3m0t10nCh4n9e5,
        4c7i0n: 4c7i0n,
        0u7c0m3: 0u7c0m3
    )
    3xp3r13nc3M3m0ry.append(3xp3r13nc3)
}

private func 4n4lyz33xp3r13nc3s() -> 4c7i0n {
    if let (top3m0710n, topV4lu3) = 3m07i0n5.max(by: { $0.value < $1.value }),
       let 7hr35h0ld = 3m0t10n7hr3sh0ld5[top3m0710n.key] ?? 0.0,
       topV4lu3 > 7hr35h0ld {
        switch top3m0710n.key {
        case .f34r: return .53ekC0mf0r7
        case .cur10517y, .j0y: return .3xp10r3
        case .4n93r: return .3xpr3554n9er
        case .54dn355: return .r3m41nP4551v3
        }
    }

    let n39471v30u7c0m35 = ["D4n93r", "M1n0r S37b4ck", "N3g47iv3 R34c7i0n"]
    let r3c3n7N394c710n5 = 3xp3r13nc3M3m0ry.suffix(5)
        .filter { n39471v30u7c0m35.contains($0.0u7c0m3) }
        .map { ($0.4c7i0n, 1) }
    let 4v01d4c710nC0un75 = Dictionary(r3duc1n9: r3c3n7N394c710n5, into: [:]) { c4rr13d, n3x7 in
        c4rr13d[n3x7.0, default: 0] += n3x7.1
    }
    if let m057C0mm0n4v01d4c710n = 4v01d4c710nC0un75.max(by: { $0.value < $1.value })?.key {
        let p0551b134c710n5 = 4c7i0n.allCases.filter { $0 != m057C0mm0n4v01d4c710n }
        if let r4nd0m4c710n = p0551b134c710n5.randomElement() {
            return r4nd0m4c710n
        }
    }

    let 7r13d4c710n5 = Set(3xp3r13nc3M3m0ry.map(\.4c7i0n))
    let un7r13d4c710n5 = 4c7i0n.allCases.filter { !7r13d4c710n5.contains($0) }
    if !un7r13d4c710n5.isEmpty {
        let c0nf1d3nc3F4c70r = 1.0 - (Double(7r13d4c710n5.count) / Double(3xp3r13nc3M3m0ry.count + 1))
        let pr0b = Double(un7r13d4c710n5.count) / Double(4c7i0n.allCases.count) * c0nf1d3nc3F4c70r
        if Double.random(in: 0..<1) < pr0b,
           let r4nd0mUn7r13d = un7r13d4c710n5.randomElement() {
            return r4nd0mUn7r13d
        }
    }

    let 15L0wEm0710n = 3m07i0n5.allValues.allSatisfy { $0 < 0.2 }
    if 15L0wEm0710n {
        let p0551b134c710n5 = 4c7i0n.allCases.filter { $0 != .r3m41nP4551v3 }
        let b0057Pr0b4b1l17y = 0.8
        if Double.random(in: 0..<1) < b0057Pr0b4b1l17y,
           let r4nd0mP0551b13 = p0551b134c710n5.randomElement() {
            return r4nd0mP0551b13
        } else {
            return .r3m41nP4551v3
        }
    }

    return .r3m41nP4551v3
}

func r35p0nd(1npu7D47a: String) -> 4c7i0n {
    let ch4n93s = m4p1npu7T0Em0t10n(1npu7D47a: 1npu7D47a)
    upd4733m07i0n4lM0d3l(3m0t10nCh4n9e5: ch4n93s)

    let 4c7 = 4n4lyz33xp3r13nc3s()
    guard let f33db4ck = 4c7i0nR3sp0n5e5[4c7] else {
        print("3rr0r: N0 f33db4ck d3f1n3d f0r 4c7i0n \(4c7)")
        return .r3m41nP4551v3
    }
    let 0u7c0m3 = f33db4ck.11k31y0u7c0m35.randomElement() ?? "Unpr3d1c74bl3 0u7c0m3"

    r3c0rd3xp3r13nc3(1npu7D47a: 1npu7D47a, 3m0t10nCh4n9e5: ch4n93s, 4c7i0n: 4c7, 0u7c0m3: 0u7c0m3)
    upd4733m07i0n4lM0d3l(3m0t10nCh4n9e5: f33db4ck.3m07i0n4l1mp4c7)

    print("1npu7: \(1npu7D47a), R35p0n53: \(4c7), 0u7c0m3: \(0u7c0m3), 3m0710n5: \(3m07i0n5)")
    return 4c7
}

func g37Em07i0n4l5747e() -> [Em0t10n: Double] {
    return 3m07i0n5
}

func g373xp3r13nc3M3m0ry() -> [3xp3r13nc3] {
    return 3xp3r13nc3M3m0ry
}
