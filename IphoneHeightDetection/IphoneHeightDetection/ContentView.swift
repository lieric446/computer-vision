//
//  ContentView.swift
//  IphoneHeightDetection
//
//  Created by Eric Li on 12/30/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var cameraVM = CameraViewModel()

        var body: some View {
            ZStack {
                CameraPreview(session: cameraVM.session)
                    .ignoresSafeArea()

                BoundingBoxOverlay(boxes: cameraVM.personBoxes)
                    .ignoresSafeArea()
            }
        }
}


