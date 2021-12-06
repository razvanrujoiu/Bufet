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
    @Binding var capturedImage: UIImage
  
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
                let entity = ModelEntity(mesh: .generatePlane(width: 0.1, height: 0.1), materials: [material])
                let anchor = AnchorEntity(.plane(.any, classification: .any, minimumBounds: .zero))
                anchor.addChild(entity)
                uiView.scene.addAnchor(anchor)
                
                if let capturedFrame = uiView.session.currentFrame {
                    let ciimg = CIImage(cvPixelBuffer: capturedFrame.capturedImage)
                    if let cgImage = convertCIImageToCGImage(inputImage: ciimg) {
                        self.capturedImage = UIImage(cgImage: cgImage)
                    }
                }
            } catch {
                print(error.localizedDescription)
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
