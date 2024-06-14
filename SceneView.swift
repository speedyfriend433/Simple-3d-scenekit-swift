import SwiftUI
import SceneKit

struct SceneView: UIViewRepresentable {
    var scene: SCNScene

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.black
        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // update logic here
    }
}
