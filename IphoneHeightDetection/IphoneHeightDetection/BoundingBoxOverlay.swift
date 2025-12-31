//
//  BoundingBoxOverlay.swift
//  IphoneHeightDetection
//
//  Created by Eric Li on 12/30/25.
//


import SwiftUI

struct BoundingBoxOverlay: View {
    let boxes: [CGRect]

    var body: some View {
        GeometryReader { geo in
            ForEach(boxes, id: \.self) { box in
                Rectangle()
                    .stroke(Color.green, lineWidth: 3)
                    .frame(
                        width: box.width * geo.size.width,
                        height: box.height * geo.size.height
                    )
                    .position(
                        x: box.midX * geo.size.width,
                        y: (1 - box.midY) * geo.size.height
                    )
            }
        }
    }
}
