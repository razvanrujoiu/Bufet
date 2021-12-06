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
        
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        if (!selectedFood.food.image.isEmpty) {
            let data = try! Data(contentsOf: URL(string: self.selectedFood.food.image)!)
            try! data.write(to: fileURL)
            do {
                // Create a TextureResource by loading the contents of the file URL.
                let texture = try TextureResource.load(contentsOf: fileURL)
                var material = SimpleMaterial()
                material.baseColor = MaterialColorParameter.texture(texture)
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
