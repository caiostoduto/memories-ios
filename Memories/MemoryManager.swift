//
//  Memory.swift
//  Memories
//
//  Created by Caio Stoduto on 21/01/23.
//

import SwiftUI

class MemoryManager {
    private var AR: ArgumentedReality
    private let filem = FileManager.default
    private let appFolder: URL
    
    // Temporary variables
    public var currentSnapshot: CGImage?
    public var currentCroppedImage: UIImage?
    
    init(AR: ArgumentedReality) {
        self.AR = AR
        
        var docsURL = self.filem.urls(for: .documentDirectory, in: .userDomainMask).first
        appFolder = docsURL!.appendingPathComponent("Memories")

        if (!self.filem.fileExists(atPath: appFolder.path())) {
            try! self.filem.createDirectory(
                at: appFolder,
                withIntermediateDirectories: true,
                attributes: [:]
            )
        }
    }
    
    func create(video: URL) {
        let memDir = appFolder.appendingPathComponent(randomString(length: 5))
        try! self.filem.createDirectory(at: memDir, withIntermediateDirectories: true)
        print("Create Memory ~ " + memDir.absoluteString)
        
        let infoObj: NSMutableDictionary = NSMutableDictionary()
        infoObj.setValue(video.pathExtension, forKey: "videoExt")
        infoObj.setValue(8, forKey: "width_in_cm") // Normally is 6 ~ 10, just a guess
        let jsonData = try! JSONSerialization.data(withJSONObject: infoObj, options: JSONSerialization.WritingOptions()) as NSData
        
        let videoPath = memDir.appendingPathComponent("video." + video.pathExtension)
        try! self.filem.moveItem(at: video, to: videoPath)
        
        let photoPath = memDir.appendingPathComponent("anchor.png")
        try! self.currentCroppedImage!.pngData()!.write(to: photoPath)
        
        let infoPath = memDir.appendingPathComponent("info.json")
        try! jsonData.write(to: infoPath)
        
        // Clean temporary variables
        self.currentSnapshot = nil
        self.currentCroppedImage = nil
        // AR.add()
    }
}

private func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
