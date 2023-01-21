//
//  ContentView.swift
//  Memories
//
//  Created by Caio Stoduto on 18/01/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var recording = false
    @State public var state = 0
    
    public var AR = ArgumentedReality()
    public var Memory: MemoryManager
    
    init() {
        Memory = MemoryManager(AR: AR)
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        ZStack {
            AR.container
                .edgesIgnoringSafeArea(.all)
            
            switch(state) {
            case 0:
            VStack {
                Spacer()
                
                ZStack {
                    // Shutter button
                    Group {
                        Circle()
                            .stroke(.white, lineWidth: 4)
                            .frame(width: 75.0, height: 75)
                            .foregroundColor(.clear)
                        
                        // Record video
                        Button {
                            // TODO: Record ARKit function
                            
                            withAnimation {
                                recording.toggle()
                            }
                        } label: {
                            // circle or square w/ round corners
                            Rectangle()
                                .frame(width: recording ? 30 : 65,
                                       height: recording ? 30 : 65)
                                .foregroundColor(.red)
                                .cornerRadius(recording ? 5 : 50)
                                .animation(.easeInOut(duration: 0.2), value: recording)
                        }.frame(width: 75, height: 75)
                        .contentShape(Rectangle())
                    }
                    
                    if (!recording) {
                        HStack {
                            Spacer()

                            // Button to add a new memory
                            Button(action: {
                                state = 1
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                                
                            }).frame(width: 75, height: 75)
                              .contentShape(Rectangle())
                        }
                    }
                }
            }.padding(.bottom, 10)
                
            case 1:
                TakePhoto(manager: self)
            case 2:
                CropPhotoView(manager: self)
            default:
                fatalError("Invalid state content")
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
