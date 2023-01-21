//
//  ChooseVideo.swift
//  Memories
//
//  Created by Caio Stoduto on 21/01/23.
//

import SwiftUI
import PhotosUI

struct ChooseVideo: View {
    private var manager: ContentView
    @State var selectedVideo: PhotosPickerItem? = nil
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
                        self.manager.state -= 1
                    } else {
                        self.manager.state = 0
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
            parent.sheetIsPresenting = false // Set isPresented to false because picking has finished.
        }
    }
}

/* struct ChooseVideo_Previews: PreviewProvider {
    static var previews: some View {
        ChooseVideo()
    }
} */
