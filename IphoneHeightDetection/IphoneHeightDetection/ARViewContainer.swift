//
//  ARViewContainer.swift
//  IphoneHeightDetection
//
//  Created by Eric Li on 12/30/25.
//


import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARViewModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        
        // LiDAR & Occlusion setup
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        config.frameSemantics.insert(.personSegmentationWithDepth)
        
        arView.session.delegate = viewModel
        arView.session.run(config)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
