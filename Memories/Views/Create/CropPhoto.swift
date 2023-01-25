//
//  CropPhotoView.swift
//  Memories
//
//  Created by Caio Stoduto on 19/01/23.
//

import SwiftUI
import ZImageCropper

struct CropPhotoView: View {
    private var manager: ContentView!
    
    @State private var selectedCircle: Int! = nil
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
            ZStack {
                Rectangle() // destination
                    .fill(.black.opacity(0.6))
                    .edgesIgnoringSafeArea(.all)
                
                Group {
                    // Circles
                    ForEach(0..<4) { i in // 0...3
                        Circle()
                            .fill()
                            .frame(width: circlesPresets[i].side, height: circlesPresets[i].side)
                            .animation(.linear(duration: 0.1), value: circlesPresets[i].side)
                            .position(circlesPresets[i].center)
                    }
                    
                    
                    Path { path in
                        path.move(to: circlesPresets[0].center)
                        path.addLines([circlesPresets[1].center, circlesPresets[2].center, circlesPresets[3].center, circlesPresets[0].center])
                        path.closeSubpath()
                    }.fill()
                    
                }.edgesIgnoringSafeArea(.all)
                    .blendMode(.destinationOut)
                
            }.compositingGroup()

            Group {
                // Circles
                ForEach(0..<4) { i in // 0...3
                    Circle()
                        .stroke(.white, lineWidth: 1)
                        .frame(width: circlesPresets[i].side, height: circlesPresets[i].side)
                        .animation(.linear(duration: 0.1), value: circlesPresets[i].side)
                        .position(circlesPresets[i].center)
                }
                
                
                Path { path in
                    path.move(to: circlesPresets[0].center)
                    path.addLines([circlesPresets[1].center, circlesPresets[2].center, circlesPresets[3].center, circlesPresets[0].center])
                    path.closeSubpath()
                }.stroke(.white, lineWidth: 1)
            }.edgesIgnoringSafeArea(.all)
            
            // Navigation
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        self.manager.state -= 1
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 28))
                        
                    }).frame(width: 75, height: 75)
                        .contentShape(Rectangle())
                    
                    Spacer()
                    
                    Button(action: {
                        let imageView = UIImageView(image:UIImage(
                            cgImage: self.manager.Memory.currentSnapshot!))
                        
                        let croppedImage = ZImageCropper.cropImage(
                            ofImageView: imageView, withinPoints: [
                                circlesPresets[0].center, //Start point
                                circlesPresets[1].center,
                                circlesPresets[2].center,
                                circlesPresets[3].center  //End point
                        ])
                        
                        self.manager.Memory.currentCroppedImage = croppedImage
                        
                        self.manager.state += 1
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 28))
                        
                    }).frame(width: 75, height: 75)
                        .contentShape(Rectangle())
                }
                
                
            }.padding(.bottom, 10)

        }.background(
            Image(uiImage: UIImage(cgImage: self.manager.Memory.currentSnapshot!))
                .edgesIgnoringSafeArea(.all)
        ).gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ val in
            if (selectedCircle == nil) {
                selectedCircle = closestCircle(point: val.startLocation)
                
                circlesPresets[selectedCircle].side = 60
                print("Selected Circle: "+String(selectedCircle))
            } else {
                var x = circlesPresets[selectedCircle!].origin.x + val.translation.width
                
                var y = circlesPresets[selectedCircle!].origin.y + val.translation.height
                
                if (x<0) { x = 0 }
                if (x>UIScreen.main.bounds.width) { x = UIScreen.main.bounds.width }
                if (y<0) { y = 0 }
                if (y>UIScreen.main.bounds.height) { y = UIScreen.main.bounds.height }
                
                circlesPresets[selectedCircle!].center.x = x
                circlesPresets[selectedCircle!].center.y = y
            }
        }).onEnded({ _ in
            if (selectedCircle != nil) {
                print("Circle " + String(selectedCircle) + " new center", circlesPresets[selectedCircle!].center)
                
                circlesPresets[selectedCircle!].origin = circlesPresets[selectedCircle!].center
                circlesPresets[selectedCircle!].side = 20
                selectedCircle = nil
            }
        }))
    }
    
    
    private func closestCircle(point: CGPoint) -> Int {
        var closest: Int?
        var closestDistance: CGFloat = .infinity
        
        for (index, circlePreset) in circlesPresets.enumerated() {
            let distance = CGPointDistance(from: circlePreset.center, to: point)
            if (distance < closestDistance) {
                closest = index
                closestDistance = distance
            }
        }
        
        return closest!
    }
}

private func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
    // Pythagoras ∆x²+∆y²
    return sqrt(pow(from.x-to.x, 2) + pow(from.y-to.y, 2))
}

private struct CirclePreset {
    var origin: CGPoint
    var center: CGPoint
    var side:CGFloat = 20
    
    init(origin: CGPoint) {
        self.origin = origin
        self.center = origin
    }
}

/* #if DEBUG
struct CropPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        CropPhotoView(manager: ContentView())
    }
}
#endif */
