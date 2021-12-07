//
//  ARQuickLookView.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 07.12.2021.
//

import SwiftUI
import QuickLook
import ARKit

struct ARQuickLookView: UIViewControllerRepresentable {
    // Properties: the file name (without extension), and whether we'll let
    // the user scale the preview content.
    
    func makeCoordinator() -> ARQuickLookView.Coordinator {
        // The coordinator object implements the mechanics of dealing with
        // the live UIKit view controller.
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        // Create the preview controller, and assign our Coordinator class
        // as its data source.
        let controller = QLPreviewController()
        controller.delegate = context.coordinator
        controller.dataSource = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ controller: QLPreviewController,
                                context: Context) {
        // nothing to do here
    }
    
    class Coordinator: NSObject, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
        let parent: ARQuickLookView
//        private lazy var fileURL: URL = Bundle.main.url(forResource: parent.name,
//                                                        withExtension: "reality")!
        
        init(_ parent: ARQuickLookView) {
            self.parent = parent
            super.init()
        }
        
        // The QLPreviewController asks its delegate how many items it has:
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        // For each item (see method above), the QLPreviewController asks for
        // a QLPreviewItem instance describing that item:
        func previewController(
            _ controller: QLPreviewController,
            previewItemAt index: Int
        ) -> QLPreviewItem {
            
            let data = try! Data(contentsOf: URL(string: "https://s-on-staging.s3.eu-central-1.amazonaws.com/uploads/food_item/image/23/Burger.png")!)
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
            try! data.write(to: fileURL)
            
//            let item = ARQuickLookPreviewItem(fileAt: fileURL)
//
            
            let url = Bundle.main.url(forResource: "AirForce", withExtension: "usdz")
            let item = url as! QLPreviewItem
            
            return item
        }
    }
    
  
}
