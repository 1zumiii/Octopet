import AppKit

// Command-line helpers used by scripts/build.sh:
//   Octopet --icon <out.png> <pixels>
//   Octopet --preview <outDir> <scale>   (PNG sequence at 30 fps: idle -> type -> idle)
let args = CommandLine.arguments
if args.count >= 4, args[1] == "--icon" {
    Render.icon(pixels: CGFloat(Double(args[3]) ?? 1024), to: args[2]); exit(0)
}
if args.count >= 4, args[1] == "--preview" {
    let dir = args[2], scale = CGFloat(Double(args[3]) ?? 10)
    var anim = Animator(), n = 0
    func run(_ ticks: Int) {
        for i in 0..<ticks {
            if i % 2 == 0 { Render.png(anim.frame, scale: scale, to: String(format: "%@/%04d.png", dir, n)); n += 1 }
            anim.advance()
        }
    }
    run(88); anim.click(); run(64 + 96); anim.click(); run(32 + 44)
    exit(0)
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)          // no Dock icon, no menu bar

let view = PetView(frame: .zero)
let size = PetView.size(for: view.scale)
let screen = NSScreen.main?.visibleFrame ?? .zero
let window = NSWindow(contentRect: NSRect(x: screen.maxX - size.width - 40, y: screen.minY + 20,
                                          width: size.width, height: size.height),
                      styleMask: .borderless, backing: .buffered, defer: false)
window.isOpaque = false
window.backgroundColor = .clear
window.hasShadow = false
window.level = .floating
window.collectionBehavior = [.canJoinAllSpaces, .stationary]
window.contentView = view
window.orderFrontRegardless()

Timer.scheduledTimer(withTimeInterval: 1.0 / 60, repeats: true) { _ in view.step() }
app.run()
