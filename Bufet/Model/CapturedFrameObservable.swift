//
//  CapturedFrameObservable.swift
//  Bufet
//
//  Created by Razvan Rujoiu on 07.12.2021.
//

import SwiftUI
import ARKit

class CapturedFrameObservable: ObservableObject {
    @Published var frame = UIImage()
}
