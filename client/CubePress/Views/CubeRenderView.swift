////
////  CubeRenderView.swift
////  CubePress
////
////  Created by Robert Bates on 5/2/23.
////
//
//import SwiftUI
//import SceneKit
//
//let screenWidth = UIScreen.main.bounds.width
//let screenHeight = UIScreen.main.bounds.height
//
//struct ContentView: View {
//    
//    let settings = SharedView.shared
//    var (scene,cameraNode) = GameScene.shared.makeView()
//    
//    var body: some View {
//        CubeRenderView(scene: scene, cameraNode: cameraNode)
//    }
//}
//
//struct CubeRenderView: View {
//    let settings = SharedView.shared
//    @State var scene: SCNScene
//    @State var cameraNode: SCNNode
//    
//    @State private var location: CGPoint = CGPoint.zero
//    @GestureState private var fingerLocation: CGPoint? = nil
//    
//    var fingerDrag: some Gesture {
//        DragGesture()
//            .updating($fingerLocation) { (value, fingerLocation, transaction) in
//                settings.location = value.location
//                settings.translation = value.translation
//                if !settings.lockView { GameScene.shared.changeCamera() }
//                if abs(value.translation.width) > abs(value.translation.height) {
//                    if value.translation.width > value.predictedEndTranslation.width {
//                        settings.direct = .west
//                    } else {
//                        settings.direct = .east
//                    }
//                } else {
//                    if value.translation.height > value.predictedEndTranslation.height {
//                        settings.direct = .north
//                    } else {
//                        settings.direct = .south
//                    }
//                }
//            }
//    }
//    
//    var body: some View {
//        SceneView(
//            scene: scene,
//            pointOfView: cameraNode,
//            options: [.autoenablesDefaultLighting, .rendersContinuously], delegate: SceneDelegate())
//            .gesture(
//                fingerDrag
//            )
//    }
//}
//
//enum Direct {
//    case north
//    case south
//    case east
//    case west
//}
//
//class SharedView: ObservableObject {
//    @Published var location = CGPoint.zero
//    @Published var translation:CGSize!
//    @Published var lockView = false
//    @Published var view:UIView!
//    @Published var scene:SCNScene!
//    @Published var direct:Direct = .north
//    static var shared = SharedView()
//}
//
//@MainActor class SceneDelegate: NSObject, SCNSceneRendererDelegate {
//    let settings = SharedView.shared
//    var spawnTime:TimeInterval = 0
//    
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        if time > spawnTime {
//            let hits = renderer.hitTest(settings.location, options: [:])
//            if hits.count > 0 { settings.lockView = true }
//            for hit in hits {
//                switch settings.direct {
//                case .north:
//                    runAction(hit: hit, degrees: -90, vector: SCNVector3(1,0,0))
//                case .south:
//                    runAction(hit: hit, degrees: 90, vector: SCNVector3(1,0,0))
//                case .east:
//                    runAction(hit: hit, degrees: 90, vector: SCNVector3(0,1,0))
//                case .west:
//                    runAction(hit: hit, degrees: -90, vector: SCNVector3(0,1,0))
//                }
//                settings.location = CGPoint.zero
//                settings.lockView = false
//            }
//            spawnTime = time + 1
//            
//        }
//    }
//    func runAction(hit:SCNHitTestResult, degrees:Float, vector:SCNVector3) {
//        let rotate = SCNAction.rotate(by: CGFloat(GLKMathDegreesToRadians(degrees)), around: vector, duration: 1)
//        hit.node.runAction(rotate)
//    }
//}
//
//
//class GameScene: UIView {
//    static var shared = GameScene()
//    let settings = SharedView.shared
//    var view: SCNView!
//    var scene: SCNScene!
//    var cameraNode: SCNNode!
//    var cameraOrbit: SCNNode!
//    var cubeGeometry: SCNBox!
//    
//    func makeView() -> (SCNScene,SCNNode) {
//        
//        let camera = SCNCamera()
//        camera.fieldOfView = 90.0
//        camera.orthographicScale = 9
//        camera.zNear = 0
//        camera.zFar = 100
//        let light = SCNLight()
//        light.color = UIColor.white
//        light.type = .omni
//        cameraNode = SCNNode()
//        cameraNode.simdPosition = SIMD3<Float>(0.0, 0.0, 6)
//        cameraNode.camera = camera
//        cameraNode.light = light
//        
//        cameraOrbit = SCNNode()
//        cameraOrbit.position = SCNVector3(1, 1, 1)
//        cameraOrbit.addChildNode(cameraNode)
//        
//        scene = SCNScene()
//        scene.background.contents = UIColor.black
//        
//        scene.rootNode.addChildNode(cameraOrbit)
//        doGeometry()
//        
//        for i in 0..<3 {
//            for k in 0..<3 {
//                for m in 0..<3 {
//                    addBox(xAxis: Float(i), yAxis: Float(k), zAxis: Float(m))
//                }
//            }
//        }
//        
//        addLightNode(xAxis: -4, yAxis: -4, zAxis: -4)
//        addLightNode(xAxis: 4, yAxis: 4, zAxis: 4)
//        addLightNode(xAxis: 4, yAxis: 4, zAxis: -4)
//        addLightNode(xAxis: -4, yAxis: -4, zAxis: 4)
//        
//        view = SCNView()
//        view.scene = scene
//        view.pointOfView = cameraNode
//        scene.rootNode.addChildNode(cameraOrbit)
//        
//        return (scene, cameraNode)
//    }
//    
//    func doGeometry() {
//        let redMaterial = SCNMaterial()
//        redMaterial.diffuse.contents = UIColor.red
//        let greenMaterial = SCNMaterial()
//        greenMaterial.diffuse.contents = UIColor.green
//        let blueMaterial = SCNMaterial()
//        blueMaterial.diffuse.contents = UIColor.blue
//        let yellowMaterial = SCNMaterial()
//        yellowMaterial.diffuse.contents = UIColor.yellow
//        let orangeMaterial = SCNMaterial()
//        orangeMaterial.diffuse.contents = UIColor.orange
//        let whiteMaterial = SCNMaterial()
//        whiteMaterial.diffuse.contents = UIColor.white
//        cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.1)
//        cubeGeometry.materials = [redMaterial, greenMaterial, orangeMaterial, blueMaterial, whiteMaterial, yellowMaterial]
//    }
//    
//    func addBox(xAxis: Float, yAxis: Float, zAxis: Float) {
//        let cubeNode = SCNNode(geometry: cubeGeometry)
//        cubeNode.position = SCNVector3(xAxis, yAxis, zAxis)
//        scene?.rootNode.addChildNode(cubeNode)
//    }
//    
//    func addLightNode(xAxis: Float, yAxis: Float, zAxis: Float) {
//        let light4 = SCNLight()
//        light4.type = SCNLight.LightType.omni
//        let lightNode4 = SCNNode()
//        lightNode4.light = light4
//        lightNode4.position = SCNVector3(x: xAxis, y: yAxis, z: zAxis)
//        scene?.rootNode.addChildNode(lightNode4)
//    }
//    
//    func changeCamera() {
//        let dx = cameraOrbit.eulerAngles.x
//        let dy = cameraOrbit.eulerAngles.y
//        let scrollWidthRatio = Float(settings.translation.width / screenWidth) / 16
//        let scrollHeightRatio = Float(settings.translation.height / screenHeight) / 16
//        cameraOrbit.eulerAngles.y = Float(-2 * Float.pi) * scrollWidthRatio + dy
//        cameraOrbit.eulerAngles.x = Float(-Float.pi) * scrollHeightRatio + dx
//    }
//}
//
//struct CubeRenderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CubeRenderView()
//    }
//}
//
