import CodexBarCore
import KeyboardShortcuts
import SwiftUI

@MainActor
struct AdvancedPane: View {
    @Bindable var settings: SettingsStore
    @State private var isInstallingCLI = false
    @State private var cliStatus: String?

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                SettingsSection(contentSpacing: 8) {
                    Text(PrototypeChineseLocalization.text("Keyboard shortcut"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    HStack(alignment: .center, spacing: 12) {
                        Text(PrototypeChineseLocalization.text("Open menu"))
                            .font(.body)
                        Spacer()
                        KeyboardShortcuts.Recorder(for: .openMenu)
                    }
                    Text(PrototypeChineseLocalization.text("Trigger the menu bar menu from anywhere."))
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                }

                Divider()

                SettingsSection(contentSpacing: 10) {
                    HStack(spacing: 12) {
                        Button {
                            Task { await self.installCLI() }
                        } label: {
                            if self.isInstallingCLI {
                                ProgressView().controlSize(.small)
                            } else {
                                Text(PrototypeChineseLocalization.text("Install CLI"))
                            }
                        }
                        .disabled(self.isInstallingCLI)

                        if let status = self.cliStatus {
                            Text(status)
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                                .lineLimit(2)
                        }
                    }
                    Text(PrototypeChineseLocalization.text(
                        "Symlink CodexBarCLI to /usr/local/bin and /opt/homebrew/bin as codexbar."))
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                }

                Divider()

                SettingsSection(contentSpacing: 10) {
                    PreferenceToggleRow(
                        title: PrototypeChineseLocalization.text("Show Debug Settings"),
                        subtitle: PrototypeChineseLocalization.text("Expose troubleshooting tools in the Debug tab."),
                        binding: self.$settings.debugMenuEnabled)
                    PreferenceToggleRow(
                        title: PrototypeChineseLocalization.text("Surprise me"),
                        subtitle: PrototypeChineseLocalization.text(
                            "Check if you like your agents having some fun up there."),
                        binding: self.$settings.randomBlinkEnabled)
                    PreferenceToggleRow(
                        title: PrototypeChineseLocalization.text("Weekly limit confetti"),
                        subtitle: PrototypeChineseLocalization.text(
                            "Play full-screen confetti when weekly usage resets."),
                        binding: self.$settings.confettiOnWeeklyLimitResetsEnabled)
                }

                Divider()

                SettingsSection(contentSpacing: 10) {
                    PreferenceToggleRow(
                        title: PrototypeChineseLocalization.text("Hide personal information"),
                        subtitle: PrototypeChineseLocalization.text(
                            "Obscure email addresses in the menu bar and menu UI."),
                        binding: self.$settings.hidePersonalInfo)
                    PreferenceToggleRow(
                        title: PrototypeChineseLocalization.text("Show provider storage usage"),
                        subtitle: PrototypeChineseLocalization.text("Show local disk usage in menus. Scans known provider-owned paths in the background."),
                        binding: self.$settings.providerStorageFootprintsEnabled)
                }

                Divider()

                SettingsSection(
                    title: PrototypeChineseLocalization.text("Keychain access"),
                    caption: PrototypeChineseLocalization.text(
                        "Disable all Keychain reads and writes. Browser cookie import is unavailable; paste Cookie headers manually in Providers."))
                {
                    PreferenceToggleRow(
                        title: PrototypeChineseLocalization.text("Disable Keychain access"),
                        subtitle: PrototypeChineseLocalization.text(
                            "Prevents any Keychain access while enabled."),
                        binding: self.$settings.debugDisableKeychainAccess)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }
}

extension AdvancedPane {
    private func installCLI() async {
        if self.isInstallingCLI { return }
        self.isInstallingCLI = true
        defer { self.isInstallingCLI = false }

        let helperURL = Bundle.main.bundleURL.appendingPathComponent("Contents/Helpers/CodexBarCLI")
        let fm = FileManager.default
        guard fm.fileExists(atPath: helperURL.path) else {
            self.cliStatus = PrototypeChineseLocalization.cliNotFound()
            return
        }

        let destinations = [
            "/usr/local/bin/codexbar",
            "/opt/homebrew/bin/codexbar",
        ]

        var results: [String] = []
        for dest in destinations {
            let dir = (dest as NSString).deletingLastPathComponent
            guard fm.fileExists(atPath: dir) else { continue }
            guard fm.isWritableFile(atPath: dir) else {
                results.append(PrototypeChineseLocalization.noWriteAccess(dir))
                continue
            }

            if fm.fileExists(atPath: dest) {
                if Self.isLink(atPath: dest, pointingTo: helperURL.path) {
                    results.append(PrototypeChineseLocalization.installed(dir))
                } else {
                    results.append(PrototypeChineseLocalization.exists(dir))
                }
                continue
            }

            do {
                try fm.createSymbolicLink(atPath: dest, withDestinationPath: helperURL.path)
                results.append(PrototypeChineseLocalization.installed(dir))
            } catch {
                results.append(PrototypeChineseLocalization.failed(dir))
            }
        }

        self.cliStatus = results.isEmpty
            ? PrototypeChineseLocalization.noWritableBinDirs()
            : results.joined(separator: " · ")
    }

    private static func isLink(atPath path: String, pointingTo destination: String) -> Bool {
        guard let link = try? FileManager.default.destinationOfSymbolicLink(atPath: path) else { return false }
        let dir = (path as NSString).deletingLastPathComponent
        let resolved = URL(fileURLWithPath: link, relativeTo: URL(fileURLWithPath: dir))
            .standardizedFileURL
            .path
        return resolved == destination
    }
}
