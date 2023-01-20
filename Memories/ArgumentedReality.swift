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
    var lastSnapshot: UIImage?
    
    init() {
        arView.session.run(config)
        container = ARViewContainer(arView: arView)
    }
    
    func snapshot(completion: @escaping ()->()) {
        arView.snapshot(saveToHDR: false) { image in
            self.lastSnapshot = image?.scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size)
            
            completion()
        }
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

private extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
    }
}
