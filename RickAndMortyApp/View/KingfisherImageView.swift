import SwiftUI
import Kingfisher

struct KingfisherImageView: View {
    
    private let image: String
    private let width: CGFloat
    private let height: CGFloat
    
    init(image: String, width: CGFloat = 80, height: CGFloat = 80) {
        self.image = image
        self.width = width
        self.height = height
    }
    
    var body: some View {
        KFImage(URL(string: image))
            .placeholder {
                ProgressView()
            }
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
    }
}

