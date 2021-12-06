//
//  ARViewContainer.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 05.12.2021.
//
import SwiftUI
 
import RealityKit
import ARKit


struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var selectedFood: SelectedFood
//    @EnvironmentObject var capturedImage: CapturedImage
    @Binding var capturedImage: CapturedImage
    
    func makeCoordinator() -> ARViewCoordinator {
        ARViewCoordinator(self, capturedImage: $capturedImage)
    }
  
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical, .horizontal]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config)
        return arView
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
  
        if (!selectedFood.food.image.isEmpty) {
            let data = try! Data(contentsOf: URL(string: self.selectedFood.food.image)!)
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
            try! data.write(to: fileURL)
            do {
                let texture = try TextureResource.load(contentsOf: fileURL)
                var material = SimpleMaterial()
                material.baseColor = MaterialColorParameter.texture(texture)
                material.tintColor = UIColor.white.withAlphaComponent(0.99)
                let entity = ModelEntity(mesh: .generatePlane(width: 0.1, height: 0.1), materials: [material])
                let anchor = AnchorEntity(.plane(.any, classification: .any, minimumBounds: .zero))
                anchor.addChild(entity)
                uiView.scene.addAnchor(anchor)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}

class ARViewCoordinator: NSObject, ARSessionDelegate {
    var arVC: ARViewContainer
    @Binding var capturedImage: CapturedImage
    
    init(_ arViewContainer: ARViewContainer, capturedImage: Binding<CapturedImage>) {
        self.arVC = arViewContainer
        _capturedImage = capturedImage
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let capturedFrame = session.currentFrame {
            let ciimg = CIImage(cvPixelBuffer: capturedFrame.capturedImage)
            if let cgImage = convertCIImageToCGImage(inputImage: ciimg) {
                capturedImage.image = UIImage(cgImage: cgImage)
            }
        }
    }
    
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
}
