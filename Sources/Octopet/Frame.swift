import AppKit

/// Every distinct picture the pet can show. Poses were transcribed frame by frame
/// (in half-unit cells) from a 60 fps screen recording of the original.
enum Frame: Hashable {
    case idle(sunk: Bool)
    // pulling the laptop out of the pocket
    case rummage(handDown: Bool)
    case liftOut, holdUp, swingDown, setDown, release, turn, squash
    // working
    case typing(phase: Int, laptopUp: Bool)
    // putting it away
    case fold, tuck, stuff(late: Bool), stand
}

extension Painter {
    func draw(_ frame: Frame) {
        let O = Palette.body, D = Palette.shade, G = Palette.laptop, K = Palette.eye
        switch frame {
        case .idle(let sunk):                            // feet stay planted while the body bobs
            let d: CGFloat = sunk ? 1 : 0
            frontLegs(); frontBody(dy: d); eyes((2, 2 + d), (12, 2 + d))
            fill(-4, 4 + d, 4, 4, O); fill(16, 4 + d, 4, 4, O)

        case .rummage(let handDown):                     // crouched, peeking at the pocket, winking
            frontLegs(length: 3); fill(0, 1, 16, 11, O); fill(16, 3, 4, 4, O)
            fill(2, 5, 2, 2, K); fill(11, 6, 3, 1, K); fill(13, 5, 1, 1, D)
            let d: CGFloat = handDown ? 1 : 0
            fill(-3, 7 + d, 3, 3, O); fill(-2, 10 + d, 2, 1, O)

        case .liftOut:                                   // laptop pops out to the upper left
            frontLegs(); frontBody(); eyes((2, 2), (12, 2))
            fill(-4, 2, 4, 4, O); fill(-3, 6, 3, 1, O); fill(-2, 7, 2, 1, O); fill(16, 5, 4, 4, O)
            fill(-3, -3, 2, 1, G); fill(-5, -2, 4, 1, G); fill(-8, -1, 5, 1, G); fill(-8, 0, 3, 1, G); fill(-8, 1, 7, 1, G)

        case .holdUp:                                    // held up high, open L shape
            frontLegs(); frontBody(); eyes((2, 2), (12, 2))
            fill(-4, -1, 4, 4, O); fill(16, 5, 4, 4, O)
            fill(-7, -7, 1, 5, G); fill(-7, -2, 5, 1, G)

        case .swingDown:                                 // swung down to the left
            frontLegs(); frontBody(); eyes((2, 3), (12, 3)); fill(16, 4, 4, 4, O)
            fill(-2, 5, 2, 1, O); fill(-3, 6, 3, 1, O); fill(-2, 7, 2, 2, O); fill(-4, 9, 4, 3, O)
            fill(-12, 3, 2, 1, G); fill(-13, 4, 4, 1, G); fill(-13, 5, 5, 1, G)
            fill(-12, 6, 4, 1, G); fill(-11, 7, 9, 1, G); fill(-9, 8, 7, 1, G)

        case .setDown:
            openLaptop(); frontLegs(); frontBody(); eyes((2, 3), (12, 3)); fill(16, 5, 4, 4, O); fill(-4, 9, 4, 3, O)

        case .release:
            openLaptop(); frontLegs(); frontBody(); eyes((2, 3), (12, 3)); fill(16, 3, 4, 4, O); fill(-4, 4, 4, 4, O)

        case .turn:                                      // arms up like ears, stretched tall
            openLaptop(); frontLegs()
            fill(-2, -4, 4, 2, O); fill(8, -4, 4, 2, O); fill(-3, -2, 5, 1, O); fill(8, -2, 5, 1, O)
            fill(-3, -1, 18, 3, O); fill(15, -1, 2, 3, D); fill(-1, 2, 14, 10, O); fill(13, 2, 4, 10, D)
            eyes((0, 3), (10, 3))

        case .squash:                                    // lands in 3/4 view, eyes wide
            openLaptop(); sideLegs(); sideBody()
            fill(-5, 4, 2, 1, O); fill(-6, 5, 3, 2, O); fill(-6, 7, 2, 1, O); fill(-6, 8, 1, 1, O)
            fill(-3, 3, 1, 5, D); fill(-4, 7, 1, 1, D); fill(-5, 8, 3, 1, D); fill(-6, 9, 4, 1, D)
            fill(-6, 11, 4, 5, O)
            eyes((-2, 5), (6, 5), height: 3)

        case .typing(let phase, let laptopUp):
            openLaptop(baseline: laptopUp ? 14 : 15); sideLegs(); sideBody()
            eyes((-2, 5), (6, 5))
            switch phase % 3 {
            case 0:  fill(-5, 8, 3, 4, O); fill(-6, 9, 1, 3, D); fill(-6, 12, 4, 1, D)   // near arm presses
            case 1:  fill(-5, 7, 3, 4, O); fill(-6, 12, 4, 3, D)                          // far hand presses
            default: fill(-6, 7, 4, 2, D); fill(-6, 9, 1, 3, D); fill(-5, 9, 3, 5, O)    // arm rolls over
            }

        case .fold:                                      // startled, screen folding toward the body
            sideLegs()
            for (i, y) in (6...15).enumerated() { fill(-12 + CGFloat(i), CGFloat(y), i == 0 ? 1 : 2, 1, G) }
            fill(-1, 1, 12, 12, O); fill(11, 1, 4, 12, D)
            fill(-2, 2, 1, 1, D); fill(-4, 3, 1, 1, O); fill(-3, 3, 2, 1, D); fill(-5, 4, 3, 2, O); fill(-2, 4, 1, 2, D)
            fill(-5, 6, 1, 1, D); fill(-4, 6, 1, 1, O); fill(-3, 6, 2, 1, D); fill(-5, 7, 4, 2, D)
            fill(-3, 9, 2, 1, O); fill(-5, 10, 4, 2, O)
            eyes((-1, 4), (7, 4), height: 3)

        case .tuck:                                      // turning back, closed laptop held to the body
            frontLegs(); fill(0, 0, 14, 12, O); fill(14, 0, 2, 12, D); fill(14, 5, 4, 4, O)
            eyes((0, 3), (10, 3))
            fill(-2, 5, 2, 1, O); fill(-3, 6, 3, 1, O); fill(-4, 7, 4, 1, O); fill(-6, 8, 6, 2, O)
            fill(-4, 5, 1, 1, G); fill(-5, 6, 1, 1, G); fill(-7, 7, 2, 1, G); fill(-8, 8, 1, 2, G); fill(-8, 10, 6, 1, G)

        case .stuff(let late):                           // stuffing it into the pocket
            frontLegs(length: 3); fill(0, 1, 16, 11, O); fill(16, 3, 4, 4, O); eyes((2, 5), (12, 5))
            if late { fill(-2, 7, 2, 4, O) } else { fill(-3, 7, 3, 3, O); fill(-2, 10, 2, 1, O) }

        case .stand:
            frontLegs(); frontBody(); eyes((2, 2), (12, 2)); fill(-4, 5, 4, 4, O); fill(16, 5, 4, 4, O)
        }
    }
}
