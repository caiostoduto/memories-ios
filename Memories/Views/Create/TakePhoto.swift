//
//  TakePhoto.swift
//  Memories
//
//  Created by Caio Stoduto on 18/01/23.
//

import SwiftUI

struct TakePhoto: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
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
                    
                    // Take a photo
                    Button {
                        // TODO: Snapshot ARKit function
                    } label: {
                        // its a circle
                        Rectangle()
                            .frame(width: 65, height: 65)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                }
                
                HStack {
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 28))
                    })
                        .frame(width: 75, height: 75)
                        .contentShape(Rectangle())
                    
                    Spacer()
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct TakePhoto_Previews: PreviewProvider {
    static var previews: some View {
        TakePhoto()
    }
}
