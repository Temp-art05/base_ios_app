import SwiftUI

/// Nút chính (Strategy A: `accessibilityID` là tham số `init`, caller override khi có nhiều instance).
public struct PrimaryButton: View {
    private let title: String
    private let isLoading: Bool
    private let accessibilityID: String
    private let action: () -> Void

    public init(
        _ title: String,
        isLoading: Bool = false,
        accessibilityID: String = DSAccessibilityID.Button.primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.accessibilityID = accessibilityID
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView().tint(AppColor.textOnPrimary)
                } else {
                    Text(title).textStyle(.headline)
                }
            }
            .foregroundStyle(AppColor.textOnPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: AppSize.buttonHeight)
            .background(
                LinearGradient(
                    colors: [AppPrimary.p500, AppPrimary.p700],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    PrimaryButton("Continue") {}.padding()
}
