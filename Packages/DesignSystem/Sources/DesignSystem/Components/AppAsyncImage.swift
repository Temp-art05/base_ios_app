import SwiftUI

/// Ảnh remote có placeholder/failure đồng nhất. Cần cache đĩa mạnh hơn ⇒ đổi nội dung file này
/// (vd. Nuke/SDWebImage) mà không đụng call-site.
public struct AppAsyncImage: View {
    private let url: URL?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            case .failure:
                placeholder(systemImage: "photo")
            default:
                placeholder(systemImage: nil)
            }
        }
    }

    private func placeholder(systemImage: String?) -> some View {
        ZStack {
            AppColor.surface
            if let systemImage {
                Image(systemName: systemImage).foregroundStyle(AppColor.textSecondary)
            } else {
                ProgressView()
            }
        }
    }
}
