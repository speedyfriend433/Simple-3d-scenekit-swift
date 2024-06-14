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
        // 업데이트 로직을 필요에 따라 추가할 수 있습니다.
    }
}
