import SwiftUI
import UIKit
import CoreText

/// Gọi `DesignSystem.setup()` MỘT lần ở `BaseApp.init` để đăng ký font.
public enum DesignSystem {
    private static let fontFiles = ["Outfit-Regular", "Outfit-Medium", "Outfit-SemiBold", "Outfit-Bold"]

    /// Bundle resource của DesignSystem — `Image("name", bundle: DesignSystem.bundle)`.
    public static let bundle: Bundle = .module

    public static func setup() {
        for name in fontFiles {
            guard let url = Bundle.module.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
