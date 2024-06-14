import SwiftUI
import SceneKit

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel(scene: SCNScene())
    @State private var joystickOffset: CGSize = .zero

    var body: some View {
        ZStack {
            SceneView(scene: viewModel.scene)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Joystick(offset: $joystickOffset)
                        .frame(width: 100, height: 100)
                        .padding()
                }
            }
        }
        .onChange(of: joystickOffset) { newValue in
            viewModel.movePlayer(by: newValue)
        }
    }
}

