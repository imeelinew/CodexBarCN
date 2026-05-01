import AppKit
import CodexBarCore
import SwiftUI

@MainActor
struct GeneralPane: View {
    @Bindable var settings: SettingsStore
    @Bindable var store: UsageStore

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                SettingsSection(contentSpacing: 12) {
                    Text(PrototypeChineseLocalization.text("System"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    PreferenceToggleRow(
                        title: PrototypeChineseLocalization.text("Start at Login"),
                        subtitle: PrototypeChineseLocalization.startAtLoginHint(),
                        binding: self.$settings.launchAtLogin)
                }

                Divider()

                SettingsSection(contentSpacing: 12) {
                    Text(PrototypeChineseLocalization.text("Usage"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 4) {
                            Toggle(isOn: self.$settings.costUsageEnabled) {
                                Text(PrototypeChineseLocalization.text("Show cost summary"))
                                    .font(.body)
                            }
                            .toggleStyle(.checkbox)

                            Text(PrototypeChineseLocalization.noUsageLogsSummary())
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                                .fixedSize(horizontal: false, vertical: true)

                            if self.settings.costUsageEnabled {
                                Text(PrototypeChineseLocalization.autoRefreshHourlyTimeout())
                                    .font(.footnote)
                                    .foregroundStyle(.tertiary)

                                self.costStatusLine(provider: .claude)
                                self.costStatusLine(provider: .codex)
                            }
                        }
                    }
                }

                Divider()

                SettingsSection(contentSpacing: 12) {
                    Text(PrototypeChineseLocalization.text("Automation"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(PrototypeChineseLocalization.text("Refresh cadence"))
                                    .font(.body)
                                Text(PrototypeChineseLocalization.refreshCadenceHint())
                                    .font(.footnote)
                                    .foregroundStyle(.tertiary)
                            }
                            Spacer()
                            Picker(
                                PrototypeChineseLocalization.text("Refresh cadence"),
                                selection: self.$settings.refreshFrequency)
                            {
                                ForEach(RefreshFrequency.allCases) { option in
                                    Text(option.label).tag(option)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.menu)
                            .frame(maxWidth: 200)
                        }
                        if self.settings.refreshFrequency == .manual {
                            Text(PrototypeChineseLocalization.autoRefreshOffHint())
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    PreferenceToggleRow(
                        title: PrototypeChineseLocalization.text("Check provider status"),
                        subtitle: PrototypeChineseLocalization.text(
                            "Polls OpenAI/Claude status pages and Google Workspace for Gemini/Antigravity, surfacing incidents in the icon and menu."),
                        binding: self.$settings.statusChecksEnabled)
                    PreferenceToggleRow(
                        title: PrototypeChineseLocalization.text("Session quota notifications"),
                        subtitle: PrototypeChineseLocalization.text(
                            "Notifies when the 5-hour session quota hits 0% and when it becomes available again."),
                        binding: self.$settings.sessionQuotaNotificationsEnabled)
                }

                Divider()

                SettingsSection(contentSpacing: 12) {
                    HStack {
                        Spacer()
                        Button(PrototypeChineseLocalization.text("Quit CodexBar")) { NSApp.terminate(nil) }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }

    private func costStatusLine(provider: UsageProvider) -> some View {
        let name = ProviderDescriptorRegistry.descriptor(for: provider).metadata.displayName

        guard provider == .claude || provider == .codex else {
            return Text(PrototypeChineseLocalization.providerUnsupported(name))
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }

        if self.store.isTokenRefreshInFlight(for: provider) {
            let elapsed: String = {
                guard let startedAt = self.store.tokenLastAttemptAt(for: provider) else { return "" }
                let seconds = max(0, Date().timeIntervalSince(startedAt))
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = seconds < 60 ? [.second] : [.minute, .second]
                formatter.unitsStyle = .abbreviated
                return formatter.string(from: seconds).map { " (\($0))" } ?? ""
            }()
            return Text(PrototypeChineseLocalization.providerFetching(name, elapsed: elapsed))
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        if let snapshot = self.store.tokenSnapshot(for: provider) {
            let updated = UsageFormatter.updatedString(from: snapshot.updatedAt)
            let cost = snapshot.last30DaysCostUSD.map { UsageFormatter.usdString($0) } ?? "—"
            return Text(PrototypeChineseLocalization.providerUpdatedCost(name, updated: updated, cost: cost))
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        if let error = self.store.tokenError(for: provider), !error.isEmpty {
            let truncated = UsageFormatter.truncatedSingleLine(error, max: 120)
            return Text(PrototypeChineseLocalization.providerError(name, error: truncated))
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        if let lastAttempt = self.store.tokenLastAttemptAt(for: provider) {
            let rel = RelativeDateTimeFormatter()
            rel.unitsStyle = .abbreviated
            let when = rel.localizedString(for: lastAttempt, relativeTo: Date())
            return Text(PrototypeChineseLocalization.providerLastAttempt(name, when: when))
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        return Text(PrototypeChineseLocalization.providerNoData(name))
            .font(.footnote)
            .foregroundStyle(.tertiary)
    }
}
