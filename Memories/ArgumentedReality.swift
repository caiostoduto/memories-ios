//
//  ArgumentedReality.swift
//  Memories
//
//  Created by Caio Stoduto on 19/01/23.
//

import SwiftUI
import RealityKit
import ARKit

class ArgumentedReality {
    private let arView = ARView(frame: .zero)
    private var config = ARImageTrackingConfiguration()
    let container: ARViewContainer
    var memories: [Memory] = []
    
    init() {
        arView.session.run(config)
        container = ARViewContainer(arView: arView)
    }
    
    func snapshot(completion: @escaping (UIImage?)->()) {
        arView.snapshot(saveToHDR: false) { image in
            completion(image)
        }
    }
    
    func add(memory: Memory) {
        config.trackingImages.update(with: memory.arImg)
        memories.append(memory)
    }
}

struct ARViewContainer: UIViewRepresentable {
    private let arView: ARView!
    
    init(arView: ARView!) {
        self.arView = arView
    }
    
    func makeUIView(context: Context) -> ARView {
        return self.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
