import AppKit

/// Draws half-unit rectangles and the reusable body parts.
struct Painter {
    let scale: CGFloat          // points per unit
    let blinking: Bool

    private typealias P = Palette

    /// Fill a rect given in half-units relative to the idle body origin.
    func fill(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ color: NSColor) {
        color.setFill()
        NSRect(x: (Canvas.originX + x / 2) * scale,
               y: (Canvas.originY + y / 2) * scale,
               width: w / 2 * scale,
               height: h / 2 * scale).fill()
    }

    /// Two eyes; normal eyes (height 2) close to a thin line while blinking.
    func eyes(_ left: (CGFloat, CGFloat), _ right: (CGFloat, CGFloat), height: CGFloat = 2) {
        if blinking && height == 2 {
            fill(left.0, left.1 + 1, 2, 0.6, P.eye); fill(right.0, right.1 + 1, 2, 0.6, P.eye)
        } else {
            fill(left.0, left.1, 2, height, P.eye); fill(right.0, right.1, 2, height, P.eye)
        }
    }

    /// Four straight legs of the front view.
    func frontLegs(top: CGFloat = 12, length: CGFloat = 4) {
        for x: CGFloat in [0, 4, 10, 14] { fill(x, top, 2, length, P.body) }
    }

    /// Bent legs of the 3/4 view: stem, knee, foot trailing back (the body leans forward).
    func sideLegs() {
        for (x, color) in [(CGFloat(-2), P.body), (2, P.body), (8, P.body), (12, P.shade)] {
            fill(x, 13, 2, 1, color); fill(x, 14, 3, 1, color); fill(x + 1, 15, 2, 1, color)
        }
    }

    /// Open laptop seen from the side; `baseline` is the row of its base.
    func openLaptop(baseline b: CGFloat = 16) {
        fill(-13, b - 5, 1, 1, P.laptop); fill(-13, b - 4, 2, 1, P.laptop); fill(-12, b - 3, 2, 1, P.laptop)
        fill(-11, b - 2, 2, 1, P.laptop); fill(-10, b - 1, 2, 1, P.laptop); fill(-9, b, 6, 1, P.laptop)
    }

    /// Front-view body block (8x6 units) with optional vertical offset.
    func frontBody(dy: CGFloat = 0) { fill(0, dy, 16, 12, P.body) }

    /// 3/4-view body: front face + shaded side face.
    func sideBody() { fill(-2, 2, 12, 11, P.body); fill(10, 2, 4, 11, P.shade) }
}
