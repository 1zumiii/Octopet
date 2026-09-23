import Foundation

/// Launch at login through a per-user LaunchAgent (no helper app or entitlement needed).
enum LoginItem {
    static let label = "io.github.1zumiii.octopet"
    private static var plistPath: String { NSHomeDirectory() + "/Library/LaunchAgents/\(label).plist" }

    static var isEnabled: Bool { FileManager.default.fileExists(atPath: plistPath) }

    static func setEnabled(_ on: Bool) {
        let fm = FileManager.default
        if !on { try? fm.removeItem(atPath: plistPath); return }
        // Prefer launching the .app bundle; fall back to the raw executable when run unbundled.
        let bundle = Bundle.main.bundlePath
        let args = bundle.hasSuffix(".app") ? ["/usr/bin/open", "-a", bundle]
                                            : [Bundle.main.executablePath ?? CommandLine.arguments[0]]
        let plist: NSDictionary = ["Label": label, "ProgramArguments": args, "RunAtLoad": true]
        try? fm.createDirectory(atPath: (plistPath as NSString).deletingLastPathComponent,
                                withIntermediateDirectories: true)
        plist.write(toFile: plistPath, atomically: true)
    }
}
