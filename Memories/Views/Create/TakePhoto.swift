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
            
            HStack {
                
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 28))
                })
                    .frame(width: 100, height: 100)
                    .contentShape(Rectangle())
                
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct TakePhoto_Previews: PreviewProvider {
    static var previews: some View {
        TakePhoto()
    }
}
