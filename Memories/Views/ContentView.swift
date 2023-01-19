//
//  ContentView.swift
//  Memories
//
//  Created by Caio Stoduto on 18/01/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @Namespace var namespace
    @State var shutterScale = 1
    
    init() {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        ZStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)

            NavigationView {
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
                            } label: {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 65))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        HStack {
                            Spacer()
                            
                            // Create new memory button
                            NavigationLink(destination: TakePhoto(), label: {
                                
                                // Button to add a new memory
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                            })
                                .frame(width: 100, height: 100)
                                .contentShape(Rectangle())
                        }
                    }
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
