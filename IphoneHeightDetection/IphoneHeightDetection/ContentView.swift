//
//  ContentView.swift
//  IphoneHeightDetection
//
//  Created by Eric Li on 12/30/25.
//

//import SwiftUI
//import AVFoundation
//
//struct ContentView: View {
//    @StateObject private var cameraVM = CameraViewModel()
////    @StateObject private var viewModel = ARCameraViewModel()
//
//    var body: some View {
//        ZStack {
//            CameraPreview(session: cameraVM.session)
//                .ignoresSafeArea()
//
//            BoundingBoxOverlay(boxes: cameraVM.personBoxes)
//                .ignoresSafeArea()
//        }
//    }
//}u

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ARViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                // The AR Stream
                ARViewContainer(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                
                // The UI Overlay
                if viewModel.personRect != .zero {
                    let screenRect = CGRect(
                        x: viewModel.personRect.origin.x * geo.size.width,
                        y: viewModel.personRect.origin.y * geo.size.height,
                        width: viewModel.personRect.width * geo.size.width,
                        height: viewModel.personRect.height * geo.size.height
                    )
                    
                    // The Bounding Box
                    Rectangle()
                        .stroke(Color.yellow, lineWidth: 2)
                        .frame(width: screenRect.width, height: screenRect.height)
                        .position(x: screenRect.midX, y: screenRect.midY)
                    
                    // The Height Label at Top Left of Box
                    Text(viewModel.height)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .padding(6)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .position(x: screenRect.minX + 30, y: screenRect.minY - 15)
                }
            }
        }
    }
}

