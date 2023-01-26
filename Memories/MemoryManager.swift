//
//  Memory.swift
//  Memories
//
//  Created by Caio Stoduto on 21/01/23.
//

import SwiftUI
import ARKit

private let filem = FileManager.default
private let docsURL = filem.urls(
    for: .documentDirectory,
    in: .userDomainMask
).first
private let appFolder = docsURL!.appendingPathComponent("Memories")

class MemoryManager {
    private var AR: ArgumentedReality
    
    // Temporary variables
    public var currentSnapshot: CGImage?
    public var currentCroppedImage: UIImage?
    
    init(AR: ArgumentedReality) {
        self.AR = AR
        
        if (!filem.fileExists(atPath: appFolder.path())) {
            try! filem.createDirectory(
                at: appFolder,
                withIntermediateDirectories: true,
                attributes: [:]
            )
        }
    }
    
    func create(video: URL) {
        let memId = randomString(length: 5)
        let memDir = appFolder.appendingPathComponent(memId) // 62ˆ5 = 9.1 * 10ˆ8
        try! filem.createDirectory(at: memDir, withIntermediateDirectories: true)
        print("Create Memory ~ " + memDir.absoluteString)
        
        let infoObj: NSMutableDictionary = NSMutableDictionary()
        infoObj.setValue(video.pathExtension, forKey: "videoExt")
        infoObj.setValue(8, forKey: "width_in_cm") // Normally is 6 ~ 10, just a guess
        let jsonData = try! JSONSerialization.data(withJSONObject: infoObj, options: JSONSerialization.WritingOptions()) as NSData
        
        let videoPath = memDir.appendingPathComponent("video." + video.pathExtension)
        try! filem.moveItem(at: video, to: videoPath)
        
        let photoPath = memDir.appendingPathComponent("anchor.png")
        try! self.currentCroppedImage!.pngData()!.write(to: photoPath)
        
        let infoPath = memDir.appendingPathComponent("info.json")
        try! jsonData.write(to: infoPath)
        
        let mem = Memory(
            id: memId, videoURL: videoPath,
            image: self.currentCroppedImage!,
            width_in_cm: jsonData.value(forKey: "width_in_cm") as! CGFloat
        )
        
        AR.add(memory: mem)
        
        // Clean temporary variables
        self.currentSnapshot = nil
        self.currentCroppedImage = nil
    }
}

class Memory {
    let id: String
    let videoURL: URL
    let arImg: ARReferenceImage
    
    init(id: String, videoURL: URL, image: UIImage, width_in_cm: CGFloat) {
        self.id = id
        self.videoURL = videoURL
        self.arImg = ARReferenceImage(
            image.ciImage!.pixelBuffer!,
            orientation: .up,
            physicalWidth: width_in_cm
        )
    }
    
    func delete() {
        let memPath = appFolder.appendingPathComponent(id)
        try! filem.removeItem(at: memPath)
    }
}

private func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
