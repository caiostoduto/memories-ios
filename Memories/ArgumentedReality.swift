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
    var lastSnapshot: CGImage?
    
    init() {
        arView.session.run(config)
        container = ARViewContainer(arView: arView)
    }
    
    func snapshot(completion: @escaping ()->()) {
        arView.snapshot(saveToHDR: false) { image in
            self.lastSnapshot = image!.cgImage!.resizeAndCrop(size: UIScreen.main.bounds.size)
            
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

private extension CGImage {
    func resizeAndCrop(size:CGSize) -> CGImage? {
        let widthRatio = size.width / size.width
        let heightRatio = size.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        let bytesPerPixel = self.bitsPerPixel / self.bitsPerComponent
        let destBytesPerRow = width * bytesPerPixel
        
        guard let colorSpace = self.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: Int(size.width * scaleFactor), height: Int(size.height * scaleFactor), bitsPerComponent: self.bitsPerComponent, bytesPerRow: destBytesPerRow, space: colorSpace, bitmapInfo: self.alphaInfo.rawValue) else { return nil }
        
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return context.makeImage()
        
        /* let width: Int = Int(size.width)
        let height: Int = Int(size.height)

        let bytesPerPixel = self.bitsPerPixel / self.bitsPerComponent
        let destBytesPerRow = width * bytesPerPixel


        guard let colorSpace = self.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: self.bitsPerComponent, bytesPerRow: destBytesPerRow, space: colorSpace, bitmapInfo: self.alphaInfo.rawValue) else { return nil }

        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))

        return context.makeImage() */
    }
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
