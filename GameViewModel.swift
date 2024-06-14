import SwiftUI
import SceneKit
import Combine

class GameViewModel: ObservableObject {
    @Published var playerNode: SCNNode?
    @Published var cells: [SCNNode] = []
    @Published var cameraNode: SCNNode?

    var scene: SCNScene
    private var timer: AnyCancellable?

    init(scene: SCNScene) {
        self.scene = scene
        setupScene()
        startGame()
    }

    private func setupScene() {
        let playerGeometry = SCNSphere(radius: 1.0)
        playerGeometry.firstMaterial?.diffuse.contents = UIColor.red

        playerNode = SCNNode(geometry: playerGeometry)
        playerNode?.position = SCNVector3(x: 0, y: 0, z: 0)

        if let playerNode = playerNode {
            scene.rootNode.addChildNode(playerNode)
        }

        let floor = SCNFloor()
        floor.firstMaterial?.diffuse.contents = UIColor.green

        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(x: 0, y: -1, z: 0)
        scene.rootNode.addChildNode(floorNode)

        cameraNode = SCNNode()
        cameraNode?.camera = SCNCamera()
        cameraNode?.position = SCNVector3(x: 0, y: 10, z: 20)
        scene.rootNode.addChildNode(cameraNode!)
    }

    private func startGame() {
        spawnCells()
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.spawnCells()
            }
    }

    func resetGame() {
        playerNode?.geometry = SCNSphere(radius: 1.0)
        cells.forEach { $0.removeFromParentNode() }
        cells.removeAll()
        startGame()
    }

    private func spawnCells() {
        let cellGeometry = SCNSphere(radius: CGFloat.random(in: 0.5...1.5))
        cellGeometry.firstMaterial?.diffuse.contents = UIColor.green

        let cellNode = SCNNode(geometry: cellGeometry)
        cellNode.position = SCNVector3(
            x: Float.random(in: -20...20),
            y: 0,
            z: Float.random(in: -20...20)
        )

        cells.append(cellNode)
        scene.rootNode.addChildNode(cellNode)
    }

    func movePlayer(by offset: CGSize) {
        guard let playerNode = playerNode else { return }

        let dx = Float(offset.width / 50)
        let dz = Float(offset.height / 50)

        playerNode.position.x += dx
        playerNode.position.z += dz

        for cell in cells {
            cell.position.x -= dx
            cell.position.z -= dz
        }

        updateCamera()
        checkForEating()
    }

    private func updateCamera() {
        guard let playerNode = playerNode, let cameraNode = cameraNode else { return }
        cameraNode.position = SCNVector3(x: playerNode.position.x, y: cameraNode.position.y, z: playerNode.position.z + 20)
        cameraNode.look(at: playerNode.position)
    }

    private func checkForEating() {
        guard let playerNode = playerNode else { return }

        cells.removeAll { cell in
            let distance = playerNode.position.distance(to: cell.position)
            if distance < (playerNode.boundingSphere.radius + cell.boundingSphere.radius) {
                let newRadius = CGFloat(playerNode.boundingSphere.radius) + CGFloat(cell.boundingSphere.radius) / 2
                playerNode.geometry = SCNSphere(radius: newRadius)
                playerNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                cell.removeFromParentNode()
                return true
            }
            return false
        }
    }
}

private extension SCNVector3 {
    func distance(to vector: SCNVector3) -> Float {
        let dx = x - vector.x
        let dy = y - vector.y
        let dz = z - vector.z
        return sqrt(dx * dx + dy * dy + dz * dz)
    }
}
