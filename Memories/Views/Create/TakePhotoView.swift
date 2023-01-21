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
        }.padding(.bottom, 10)
    }
    
    func takePhoto() {
        self.manager.AR.snapshot { image in
            self.manager.Memory.currentSnapshot = image!.cgImage!.resizeAndCrop(size: UIScreen.main.bounds.size)
            self.manager.state += 1
        }
    }
}

private extension CGImage {
    func resizeAndCrop(size:CGSize) -> CGImage? {
        let widthRatio = size.width / size.width
        let heightRatio = size.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        let bytesPerPixel = self.bitsPerPixel / self.bitsPerComponent
        let destBytesPerRow = width * bytesPerPixel
        
        guard let colorSpace = self.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: Int(size.width * scaleFactor), height: Int(size.height * scaleFactor), bitsPerComponent: self.bitsPerComponent, bytesPerRow: destBytesPerRow, space: colorSpace, bitmapInfo: self.alphaInfo.rawValue) else { return nil }
        
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return context.makeImage()
    }
}

#if DEBUG
struct TakePhoto_Previews: PreviewProvider {
    static var previews: some View {
        TakePhoto(manager: ContentView())
    }
}
#endif
