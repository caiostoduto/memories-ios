//
//  CropPhotoView.swift
//  Memories
//
//  Created by Caio Stoduto on 19/01/23.
//

import SwiftUI

struct CropPhotoView: View {
    let manager: ContentView!
    
    @State private var circlesPresets = [
        CirclePreset(origin: CGPoint(x: 57, y: 146)),
        CirclePreset(origin: CGPoint(x: 354, y: 172)),
        CirclePreset(origin: CGPoint(x: 340, y: 518)),
        CirclePreset(origin: CGPoint(x: 57, y: 497))
    ]
    
    init(manager: ContentView) {
        self.manager = manager
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: self.manager.AR.lastSnapshot!)
                    .scaledToFit()
            //Image(uiImage: self.manager.AR.lastSnapshot!)
            //   .edgesIgnoringSafeArea(.all)Image(/*@START_MENU_TOKEN@*/"Image Name"/*@END_MENU_TOKEN@*/)
            
            Group {
                // Circles
                ForEach(0..<4) { i in // 0...3
                    Circle()
                        .stroke(.white, lineWidth: 1)
                        .frame(width: 20, height: 20)
                        .position(circlesPresets[i].center)
                }
                
                
                Path { path in
                    path.move(to: circlesPresets[0].center)
                    path.addLines([circlesPresets[1].center, circlesPresets[2].center, circlesPresets[3].center, circlesPresets[0].center])
                    path.closeSubpath()
                }.stroke(.white, lineWidth: 1)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct CirclePreset {
    var origin: CGPoint
    var center: CGPoint
    
    init(origin: CGPoint) {
        self.origin = origin
        self.center = origin
    }
}

#if DEBUG
struct CropPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        CropPhotoView(manager: ContentView())
    }
}
#endif
