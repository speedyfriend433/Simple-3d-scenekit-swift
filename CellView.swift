import SwiftUI

struct CellView: View {
    var size: CGFloat
    var color: Color
    var position: CGPoint

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .position(position)
    }
}
