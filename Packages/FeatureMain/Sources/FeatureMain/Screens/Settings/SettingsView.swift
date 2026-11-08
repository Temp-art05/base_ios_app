import SwiftUI
import DesignSystem

/// Public để app target map từ `Route.settings`.
public struct SettingsView: View {
    @AppStorage(AppAppearance.storageKey) private var appearance: AppAppearance = .system

    public init() {}

    public var body: some View {
        Form {
            Picker("Appearance", selection: $appearance) {
                ForEach(AppAppearance.allCases) { Text($0.title).tag($0) }
            }
            .accessibilityIdentifier(AccessibilityID.Settings.appearancePicker)

            LabeledContent("Version", value: Self.versionString)
                .accessibilityIdentifier(AccessibilityID.Settings.versionLabel)
        }
        .navigationTitle("Settings")
        .accessibilityIdentifier(AccessibilityID.Settings.screen)
    }

    private static var versionString: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "-"
        let build = info?["CFBundleVersion"] as? String ?? "-"
        return "\(version) (\(build))"
    }
}
