import SwiftUI

struct Joystick: View {
    @Binding var offset: CGSize

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Circle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let translation = gesture.translation
                                let radius = geometry.size.width / 2
                                let distance = sqrt(translation.width * translation.width + translation.height * translation.height)
                                if distance < radius {
                                    offset = translation
                                } else {
                                    let angle = atan2(translation.height, translation.width)
                                    offset = CGSize(width: cos(angle) * radius, height: sin(angle) * radius)
                                }
                            }
                            .onEnded { _ in
                                offset = .zero
                            }
                    )
            }
        }
    }
}
