import Foundation

/// State machine driving the pet at 60 ticks per second.
struct Animator {
    enum Mode: String { case idle, pullOut, typing, putAway }

    private(set) var mode: Mode
    private(set) var tick: Int
    private(set) var blinkLeft = 0

    /// "Slacking mode": switch between idle and typing on its own, at random intervals.
    var autoSwitch = false { didSet { scheduleNextSwitch() } }
    private var ticksUntilSwitch = 0

    init(mode: Mode = .idle, tick: Int = 0) { self.mode = mode; self.tick = tick }

    /// Timelines as (duration in ticks, frame).
    private static let pullOut: [(Int, Frame)] = [
        (3, .rummage(handDown: false)), (6, .rummage(handDown: true)),
        (5, .rummage(handDown: false)), (10, .rummage(handDown: true)),
        (4, .liftOut), (10, .holdUp), (6, .swingDown), (3, .setDown), (8, .release),
        (5, .turn), (3, .squash),
    ]
    private static let putAway: [(Int, Frame)] = [
        (6, .fold), (3, .tuck), (13, .stuff(late: false)), (4, .stuff(late: true)), (6, .stand),
    ]
    /// Typing arm cycle A -> B -> C, measured at 6/5/5 ticks per phase.
    private static let typingPhases = [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2]

    var blinking: Bool { blinkLeft > 0 }

    var frame: Frame {
        switch mode {
        case .idle:    return .idle(sunk: (tick / 22) % 2 == 1)
        case .typing:  return .typing(phase: Self.typingPhases[tick % Self.typingPhases.count],
                                      laptopUp: (tick / 10) % 2 == 0)
        case .pullOut: return Self.frame(in: Self.pullOut, at: tick) ?? .typing(phase: 0, laptopUp: true)
        case .putAway: return Self.frame(in: Self.putAway, at: tick) ?? .idle(sunk: false)
        }
    }

    mutating func advance() {
        tick += 1
        if blinkLeft > 0 { blinkLeft -= 1 } else if mode == .idle && Int.random(in: 0..<300) == 0 { blinkLeft = 8 }
        if mode == .pullOut && tick >= Self.duration(Self.pullOut) { mode = .typing; tick = 0; scheduleNextSwitch() }
        if mode == .putAway && tick >= Self.duration(Self.putAway) { mode = .idle; tick = 0; scheduleNextSwitch() }
        if autoSwitch && (mode == .idle || mode == .typing) {
            ticksUntilSwitch -= 1
            if ticksUntilSwitch <= 0 { click() }
        }
    }

    /// Seconds to stay in the current state: mostly working (45s–3min) with the
    /// occasional short slack-off (8–25s). Averaging two random draws clusters
    /// around the middle, so extreme stretches are rare.
    private mutating func scheduleNextSwitch() {
        let (lo, hi): (Double, Double) = mode == .typing ? (45, 180) : (8, 25)
        let r = (Double.random(in: 0...1) + Double.random(in: 0...1)) / 2
        ticksUntilSwitch = Int((lo + (hi - lo) * r) * 60)
    }

    /// Click toggles between idle and typing (ignored mid-transition).
    mutating func click() {
        switch mode {
        case .idle:   mode = .pullOut; tick = 0
        case .typing: mode = .putAway; tick = 0
        default: break
        }
    }

    private static func duration(_ seq: [(Int, Frame)]) -> Int { seq.reduce(0) { $0 + $1.0 } }

    private static func frame(in seq: [(Int, Frame)], at t: Int) -> Frame? {
        var t = t
        for (d, f) in seq { if t < d { return f }; t -= d }
        return nil
    }
}
