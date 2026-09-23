import AppKit

/// Colours sampled from the original pet.
enum Palette {
    static let body   = NSColor(red: 0.85, green: 0.46, blue: 0.34, alpha: 1)
    static let shade  = NSColor(red: 0.74, green: 0.38, blue: 0.27, alpha: 1)   // side face / far limb
    static let laptop = NSColor(white: 0.55, alpha: 1)
    static let eye    = NSColor.black
}

/// Canvas geometry, in "units" (one big pixel of the pet).
/// All poses are written in HALF-units relative to the idle body's top-left corner.
enum Canvas {
    static let width: CGFloat = 19
    static let height: CGFloat = 13
    static let originX: CGFloat = 7
    static let originY: CGFloat = 4
}
