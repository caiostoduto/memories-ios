//
//  ChooseVideo.swift
//  Memories
//
//  Created by Caio Stoduto on 21/01/23.
//

import SwiftUI
import PhotosUI
import MobileCoreServices

struct ChooseVideo: View {
    private var manager: ContentView
    @State var selectedVideo: PHPickerResult? = nil
    @State var sheetIsPresenting = true
    
    init(manager: ContentView) {
        self.manager = manager
    }
    
    var body: some View {
        Image(uiImage: UIImage(cgImage: self.manager.Memory.currentSnapshot!))
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $sheetIsPresenting) {
                VideoPicker(self).onDisappear {
                    if selectedVideo != nil {
                        let provider = selectedVideo!.itemProvider
                        
                        print(provider.registeredContentTypes)
                        
                        switch (provider.registeredTypeIdentifiers.first) {
                        case "com.apple.live-photo-bundle":
                            provider.loadObject(ofClass: PHLivePhoto.self) { _livePhoto, err in
                                if (err != nil) { fatalError(err!.localizedDescription) }
                                
                                let livePhoto = _livePhoto as? PHLivePhoto
                                let assetResources = PHAssetResource.assetResources(for: livePhoto!)
                                let resource = assetResources.first(where: { $0.uniformTypeIdentifier == "com.apple.quicktime-movie"})!
                                
                                let photoDir = generateFolderForLivePhotoResources()
                                let url = saveAssetResource(resource: resource, inDirectory: photoDir!, buffer: nil, maybeError: nil)
                                self.manager.Memory.create(video: url!)
                            }
                            break
                        case "com.apple.quicktime-movie", "public.mpeg-4":
                            provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, err in
                                if (err != nil) { fatalError(err!.localizedDescription) }
                                
                                self.manager.Memory.create(video: url!)
                            }
                            break
                        default:
                            fatalError("Unexpected video type")
                            // self.manager.Memory
                        }
                        
                        self.manager.state = 0
                    } else {
                        self.manager.state -= 1
                    }
                }
            }
    }
}

private struct VideoPicker: UIViewControllerRepresentable {
    private let parent: ChooseVideo
            
    init(_ parent: ChooseVideo) {
        self.parent = parent
    }

    typealias UIViewControllerType = PHPickerViewController
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .any(of: [.videos, .livePhotos])
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(parent) }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: ChooseVideo
                
        init(_ parent: ChooseVideo) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if (results.isEmpty) {
                parent.selectedVideo = nil
            } else {
                parent.selectedVideo = results[0] // Always has only 1 element
            }
            parent.sheetIsPresenting = false // Set sheetIsPresenting to false because picking has finished.
        }
    }
}

func saveAssetResource(
    resource: PHAssetResource,
    inDirectory: NSURL,
    buffer: NSMutableData?, maybeError: Error?
    ) -> URL? {
    guard maybeError == nil else {
        print("Could not request data for resource: \(resource), error: \(String(describing: maybeError))")
        return nil
    }
    
    let maybeExt = UTTypeCopyPreferredTagWithClass(
        resource.uniformTypeIdentifier as CFString,
        kUTTagClassFilenameExtension
    )?.takeRetainedValue()

    guard let ext = maybeExt else {
        return nil
    }

    guard var fileUrl = inDirectory.appendingPathComponent(NSUUID().uuidString) else {
        print("file url error")
        return nil
    }

    fileUrl = fileUrl.appendingPathExtension(ext as String)

    if let buffer = buffer, buffer.write(to: fileUrl, atomically: true) {
        print("Saved resource form buffer \(resource) to filepath \(String(describing: fileUrl))")
    } else {
        PHAssetResourceManager.default().writeData(for: resource, toFile: fileUrl, options: nil) { (error) in
            print("Saved resource directly \(resource) to filepath \(String(describing: fileUrl))")
        }
    }
        
    return fileUrl
}

func generateFolderForLivePhotoResources() -> NSURL? {
    let photoDir = NSURL(
        // NB: Files in NSTemporaryDirectory() are automatically cleaned up by the OS
        fileURLWithPath: NSTemporaryDirectory(),
        isDirectory: true
        ).appendingPathComponent(NSUUID().uuidString)

    let fileManager = FileManager()
    // we need to specify type as ()? as otherwise the compiler generates a warning
    let success : ()? = try? fileManager.createDirectory(
        at: photoDir!,
        withIntermediateDirectories: true,
        attributes: nil
    )

    return success != nil ? photoDir! as NSURL : nil
}

/* struct ChooseVideo_Previews: PreviewProvider {
    static var previews: some View {
        ChooseVideo()
    }
} */
