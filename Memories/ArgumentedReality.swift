//
//  ArgumentedReality.swift
//  Memories
//
//  Created by Caio Stoduto on 19/01/23.
//

import SwiftUI
import RealityKit

class ArgumentedReality {
    var container: ARViewContainer
    
    init() {
        container = ARViewContainer()
    }
    
    
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
