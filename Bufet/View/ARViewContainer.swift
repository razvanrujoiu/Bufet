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

struct ARViewContainer: UIViewRepresentable {
    
    let arView = ARView(frame: .infinite)
    
    func makeUIView(context: Context) -> ARView {
        
//        // Load the "Box" scene from the "Experience" Reality File
//                let boxAnchor = try! Experience.loadBox()
//
//        // Add the box anchor to the scene
//                arView.scene.anchors.append(boxAnchor)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config)
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
}
