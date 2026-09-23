import AppKit

/// Transparent view that renders the pet and handles click / drag / right-click menu.
final class PetView: NSView {
    static let sizes: [(title: () -> String, scale: Int)] = [
        ({ Strings.sizeOriginal }, 3), ({ Strings.sizeLarge }, 4), ({ Strings.sizeHuge }, 6), ({ Strings.sizeGiant }, 9),
    ]
    private static let scaleKey = "scale"
    private static let autoKey = "autoSwitch"

    var animator: Animator = {
        var a = Animator()
        a.autoSwitch = UserDefaults.standard.bool(forKey: PetView.autoKey)
        return a
    }()
    var scale: CGFloat = {
        let saved = UserDefaults.standard.integer(forKey: PetView.scaleKey)
        return CGFloat(saved > 0 ? saved : 3)
    }()

    private var lastFrame: Frame?
    private var lastBlink = false
    private var dragOffset = NSPoint.zero
    private var dragged = false

    override var isFlipped: Bool { true }

    static func size(for scale: CGFloat) -> NSSize {
        NSSize(width: Canvas.width * scale, height: Canvas.height * scale)
    }

    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.set(); dirtyRect.fill()
        Painter(scale: scale, blinking: animator.blinking).draw(animator.frame)
    }

    /// Advance one tick; only redraw when the picture actually changes.
    func step() {
        animator.advance()
        let frame = animator.frame, blink = animator.blinking
        if frame != lastFrame || blink != lastBlink {
            lastFrame = frame; lastBlink = blink
            needsDisplay = true
        }
    }

    // MARK: mouse

    override func mouseDown(with event: NSEvent) { dragOffset = event.locationInWindow; dragged = false }

    override func mouseDragged(with event: NSEvent) {
        dragged = true
        let p = NSEvent.mouseLocation
        window?.setFrameOrigin(NSPoint(x: p.x - dragOffset.x, y: p.y - dragOffset.y))
    }

    override func mouseUp(with event: NSEvent) {
        if !dragged { animator.click() }
    }

    // MARK: menu

    override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu()
        for size in Self.sizes {
            let item = NSMenuItem(title: size.title(), action: #selector(pickSize(_:)), keyEquivalent: "")
            item.tag = size.scale; item.target = self
            item.state = CGFloat(size.scale) == scale ? .on : .off
            menu.addItem(item)
        }
        menu.addItem(.separator())
        let auto = NSMenuItem(title: Strings.autoSwitch, action: #selector(toggleAuto), keyEquivalent: "")
        auto.target = self; auto.state = animator.autoSwitch ? .on : .off
        menu.addItem(auto)
        let login = NSMenuItem(title: Strings.launchAtLogin, action: #selector(toggleLogin), keyEquivalent: "")
        login.target = self; login.state = LoginItem.isEnabled ? .on : .off
        menu.addItem(login)
        menu.addItem(.separator())
        menu.addItem(withTitle: Strings.quit, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")
        return menu
    }

    @objc private func toggleLogin() { LoginItem.setEnabled(!LoginItem.isEnabled) }

    @objc private func toggleAuto() {
        animator.autoSwitch.toggle()
        UserDefaults.standard.set(animator.autoSwitch, forKey: Self.autoKey)
    }

    @objc private func pickSize(_ item: NSMenuItem) {
        scale = CGFloat(item.tag)
        UserDefaults.standard.set(item.tag, forKey: Self.scaleKey)
        guard let window else { return }
        var f = window.frame
        f.size = Self.size(for: scale)
        window.setFrame(f, display: true)
        frame = NSRect(origin: .zero, size: f.size)
        needsDisplay = true
    }
}
