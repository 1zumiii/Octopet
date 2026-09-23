// swift-tools-version:5.7
// `swift run` for quick local testing; use scripts/build.sh to produce Octopet.app.
import PackageDescription

let package = Package(
    name: "Octopet",
    platforms: [.macOS(.v11)],
    targets: [.executableTarget(name: "Octopet", path: "Sources/Octopet")]
)
