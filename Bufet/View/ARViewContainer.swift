//
//  ARViewContainer.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 05.12.2021.
//
import SwiftUI
import UIKit
import RealityKit
import ARKit

var arView: ARView!
var lastAnchor: AnchorEntity?

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var selectedFood: SelectedFood
                
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
  
    func makeUIView(context: Context) -> ARView {
        arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical, .horizontal]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        arView.session.delegate = context.coordinator
        arView.session.run(config)
        return arView
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        if (!selectedFood.food.image.isEmpty) {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try! Data(contentsOf: URL(string: self.selectedFood.food.image)!)
                let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
                try! data.write(to: fileURL)
                DispatchQueue.main.async {
                    do {
                        let texture = try TextureResource.load(contentsOf: fileURL)
                        var material = SimpleMaterial()
                        material.baseColor = MaterialColorParameter.texture(texture)
                        material.tintColor = UIColor.white.withAlphaComponent(0.99)
                        let entity = ModelEntity(mesh: .generatePlane(width: 0.1, height: 0.1), materials: [material])
                        let anchor = AnchorEntity(.plane(.any, classification: .any, minimumBounds: .zero))
                        anchor.addChild(entity)
                        if let lastAnchor = lastAnchor {
                            uiView.scene.removeAnchor(lastAnchor)
                        }
                        lastAnchor = anchor
                        uiView.scene.addAnchor(anchor)
                        
                        entity.generateCollisionShapes(recursive: true)
                        arView.installGestures([.translation, .rotation, .scale], for: entity)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    class Coordinator: NSObject, ARSessionDelegate, ARSCNViewDelegate {
        var arVC: ARViewContainer

        init(_ arViewContainer: ARViewContainer) {
            self.arVC = arViewContainer
        }
    }
}



