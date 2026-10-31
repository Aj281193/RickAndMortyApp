import SwiftUI
import Kingfisher

struct KingfisherImageView: View {
    
    private let image: String
    
    init(_ image: String) {
        self.image = image
    }
    
    var body: some View {
        KFImage(URL(string: image))
            .placeholder {
                ProgressView()
            }
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
    }
}

