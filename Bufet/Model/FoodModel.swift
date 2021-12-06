//
//  FoodModel.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 06.12.2021.
//

import Foundation
import ARKit
import RealityKit

class FoodModel: Entity, HasModel, HasAnchoring, HasCollision {
    
    required init(image: String) {
        super.init()
        let data = try! Data(contentsOf: URL(string: image)!)
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try! data.write(to: fileURL)
        do {
            let texture = try TextureResource.load(contentsOf: fileURL)
            var material = SimpleMaterial()
            material.baseColor = MaterialColorParameter.texture(texture)
            material.tintColor = UIColor.white.withAlphaComponent(0.99)
            self.components[ModelComponent] = ModelComponent(mesh: .generatePlane(width: 0.1, height: 0.1), materials: [material])
        } catch {
            print(error)
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
