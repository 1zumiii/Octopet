import AppKit

/// Offscreen rendering, used by the build script for the app icon and README preview.
enum Render {
    static func png(_ frame: Frame, scale: CGFloat, to path: String) {
        let size = PetView.size(for: scale)
        write(size: size, to: path) { Painter(scale: scale, blinking: false).draw(frame) }
    }

    /// Square icon: rounded cream tile with the idle pet centred.
    static func icon(pixels: CGFloat, to path: String) {
        let size = NSSize(width: pixels, height: pixels)
        write(size: size, to: path) {
            let inset = pixels * 0.1
            NSColor(red: 0.98, green: 0.96, blue: 0.92, alpha: 1).setFill()
            NSBezierPath(roundedRect: NSRect(origin: .zero, size: size).insetBy(dx: inset, dy: inset),
                         xRadius: pixels * 0.18, yRadius: pixels * 0.18).fill()
            // idle pet spans x -4...20, y 0...16 half-units (12x8 units); centre it
            let scale = pixels * 0.62 / 12
            let ctx = NSGraphicsContext.current!.cgContext
            ctx.translateBy(x: pixels / 2 - (Canvas.originX + 4) * scale,
                            y: pixels / 2 - (Canvas.originY + 4) * scale)
            Painter(scale: scale, blinking: false).draw(.idle(sunk: false))
        }
    }

    private static func write(size: NSSize, to path: String, _ body: () -> Void) {
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size.width), pixelsHigh: Int(size.height),
                                   bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                   colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        NSGraphicsContext.saveGraphicsState()
        let ctx = NSGraphicsContext(bitmapImageRep: rep)!
        NSGraphicsContext.current = ctx
        // flip so y grows downward, matching PetView
        ctx.cgContext.translateBy(x: 0, y: size.height); ctx.cgContext.scaleBy(x: 1, y: -1)
        body()
        NSGraphicsContext.restoreGraphicsState()
        try? rep.representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: path))
    }
}
