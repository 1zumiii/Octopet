import Foundation

/// Menu text in Chinese or English, following the system language.
enum Strings {
    static let isChinese = Locale.preferredLanguages.first?.hasPrefix("zh") ?? false

    private static func t(_ zh: String, _ en: String) -> String { isChinese ? zh : en }

    static var sizeOriginal: String { t("原版大小", "Original size") }
    static var sizeLarge: String    { t("大一点", "Bigger") }
    static var sizeHuge: String     { t("超大只", "Extra large") }
    static var sizeGiant: String    { t("巨无霸", "Giant") }
    static var autoSwitch: String   { t("摸鱼模式", "Work-life balance") }
    static var launchAtLogin: String { t("开机自动启动", "Launch at login") }
    static var quit: String         { t("再见小章鱼 👋", "Bye, little octopus 👋") }
}
