//
//  TakePhoto.swift
//  Memories
//
//  Created by Caio Stoduto on 18/01/23.
//

import SwiftUI

struct TakePhoto: View {
    private var manager: ContentView
    
    init(manager: ContentView) {
        self.manager = manager
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                // Shutter button
                Group {
                    Circle()
                        .stroke(.white, lineWidth: 4)
                        .frame(width: 75.0, height: 75)
                        .foregroundColor(.clear)
                    
                    Button {
                        takePhoto()
                    } label: {
                        // its a circle
                        Rectangle()
                            .frame(width: 65, height: 65)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }.frame(width: 75, height: 75)
                        .contentShape(Rectangle())
                }
                
                // Navigation
                HStack {
                    Button(action: {
                        self.manager.state -= 1
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 28))
                        
                    }).frame(width: 75, height: 75)
                    .contentShape(Rectangle())
                    
                    Spacer()
                }
            }
        }
    }
    
    func takePhoto() {
        self.manager.AR.snapshot {
            self.manager.state += 1
        }
    }
}

#if DEBUG
struct TakePhoto_Previews: PreviewProvider {
    static var previews: some View {
        TakePhoto(manager: ContentView())
    }
}
#endif
