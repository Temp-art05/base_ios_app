import SwiftUI

/// Typography — font Outfit (đổi family: sửa `family`/`fontFiles` trong DesignSystem.swift).
/// Dùng qua `.textStyle(.body)`; KHÔNG dùng `Font.custom`/`.system(size:)` trong View.
public enum AppFont {
    static let family = "Outfit"

    public enum Style: CaseIterable, Sendable {
        case largeTitle, title, headline, body, callout, caption

        var size: CGFloat {
            switch self {
            case .largeTitle: 34
            case .title: 24
            case .headline: 17
            case .body: 16
            case .callout: 14
            case .caption: 12
            }
        }

        var weightSuffix: String {
            switch self {
            case .largeTitle, .title: "Bold"
            case .headline: "SemiBold"
            case .callout: "Medium"
            case .body, .caption: "Regular"
            }
        }

        var relativeTo: Font.TextStyle {
            switch self {
            case .largeTitle: .largeTitle
            case .title: .title2
            case .headline: .headline
            case .body: .body
            case .callout: .callout
            case .caption: .caption
            }
        }
    }

    public static func font(_ style: Style) -> Font {
        .custom("\(family)-\(style.weightSuffix)", size: style.size, relativeTo: style.relativeTo)
    }
}

public extension View {
    func textStyle(_ style: AppFont.Style) -> some View {
        font(AppFont.font(style))
    }
}
