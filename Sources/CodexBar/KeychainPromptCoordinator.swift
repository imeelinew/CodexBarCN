import AppKit
import CodexBarCore
import SweetCookieKit

enum KeychainPromptCoordinator {
    private static let promptLock = NSLock()
    private static let log = CodexBarLog.logger(LogCategories.keychainPrompt)

    static func install() {
        KeychainPromptHandler.handler = { context in
            self.presentKeychainPrompt(context)
        }
        BrowserCookieKeychainPromptHandler.handler = { context in
            self.presentBrowserCookiePrompt(context)
        }
    }

    private static func presentKeychainPrompt(_ context: KeychainPromptContext) {
        let (title, message) = self.keychainCopy(for: context)
        self.log.info("Keychain prompt requested", metadata: ["kind": "\(context.kind)"])
        self.presentAlert(title: title, message: message)
    }

    private static func presentBrowserCookiePrompt(_ context: BrowserCookieKeychainPromptContext) {
        let title = PrototypeChineseLocalization.text("Keychain Access Required")
        let message = PrototypeChineseLocalization.browserCookiePrompt(context.label)
        self.log.info("Browser cookie keychain prompt requested", metadata: ["label": context.label])
        self.presentAlert(title: title, message: message)
    }

    private static func keychainCopy(for context: KeychainPromptContext) -> (title: String, message: String) {
        let title = PrototypeChineseLocalization.text("Keychain Access Required")
        switch context.kind {
        case .claudeOAuth:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求 Claude Code OAuth 令牌",
                "以获取你的 Claude 用量。点击“好”继续。",
            ].joined(separator: " "))
        case .codexCookie:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 OpenAI Cookie Header",
                "以获取 Codex 面板扩展数据。点击“好”继续。",
            ].joined(separator: " "))
        case .claudeCookie:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 Claude Cookie Header",
                "以获取 Claude 网页端用量。点击“好”继续。",
            ].joined(separator: " "))
        case .cursorCookie:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 Cursor Cookie Header",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .opencodeCookie:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 OpenCode Cookie Header",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .factoryCookie:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 Factory Cookie Header",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .zaiToken:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 z.ai API 令牌",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .syntheticToken:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 Synthetic API Key",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .copilotToken:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 GitHub Copilot 令牌",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .kimiToken:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 Kimi 登录令牌",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .kimiK2Token:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 Kimi K2 API Key",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .minimaxCookie:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 MiniMax Cookie Header",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .minimaxToken:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 MiniMax API 令牌",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .augmentCookie:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 Augment Cookie Header",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        case .ampCookie:
            return (title, [
                "CodexBar 将向 macOS 钥匙串请求你的 Amp Cookie Header",
                "以获取用量。点击“好”继续。",
            ].joined(separator: " "))
        }
    }

    private static func presentAlert(title: String, message: String) {
        self.promptLock.lock()
        defer { self.promptLock.unlock() }

        if Thread.isMainThread {
            MainActor.assumeIsolated {
                self.showAlert(title: title, message: message)
            }
            return
        }
        DispatchQueue.main.sync {
            MainActor.assumeIsolated {
                self.showAlert(title: title, message: message)
            }
        }
    }

    @MainActor
    private static func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: PrototypeChineseLocalization.text("OK"))
        _ = alert.runModal()
    }
}
