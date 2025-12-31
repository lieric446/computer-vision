//
//  ARViewModel.swift
//  IphoneHeightDetection
//
//  Created by Eric Li on 12/30/25.
//

import Combine
import ARKit
import Vision
import SwiftUI

class ARViewModel: NSObject, ObservableObject, ARSessionDelegate {
    @Published var height: String = "Calculating..."
    @Published var personRect: CGRect = .zero // Normalized 0..1 coordinates
    
    private var isProcessing = false

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard !isProcessing else { return }
        isProcessing = true
        
        // 1. Use Vision to find the person's bounding box
        let handler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: .right, options: [:])
        let request = VNDetectHumanRectanglesRequest { [weak self] request, error in
            guard let results = request.results as? [VNHumanObservation], let primaryPerson = results.first else {
                self?.isProcessing = false
                return
            }
            
            // Vision coordinates are bottom-left origin; we need to flip for SwiftUI
            let normalizedRect = CGRect(x: primaryPerson.boundingBox.origin.x,
                                        y: 1 - primaryPerson.boundingBox.origin.y - primaryPerson.boundingBox.height,
                                        width: primaryPerson.boundingBox.width,
                                        height: primaryPerson.boundingBox.height)
            
            DispatchQueue.main.async {
                self?.personRect = normalizedRect
                self?.calculateHeight(frame: frame, session: session, at: normalizedRect)
                self?.isProcessing = false
            }
        }
        request.upperBodyOnly = false
        
        try? handler.perform([request])
    }
    
    private func calculateHeight(frame: ARFrame, session: ARSession, at rect: CGRect) {
        // Find the top-center of the detected person
        let topCenter = CGPoint(x: rect.midX, y: rect.minY)
        
        // FIXED: raycastQuery is NOT optional, so we don't use 'if let'
        let query = frame.raycastQuery(from: topCenter, allowing: .estimatedPlane, alignment: .vertical)
        
        // Perform the raycast
        let results = session.raycast(query)
        
        if let closestResult = results.first {
            // LiDAR distance from camera to the head point
            // For a true height, we measure the Y-distance from the detected floor
            let worldTransform = closestResult.worldTransform
            let headY = worldTransform.columns.3.y
            
            // Simple assumption: The lowest plane detected is the floor at Y=0
            // In a pro app, you'd subtract the actual floor plane Y value
            let heightInMeters = abs(headY)
            self.height = String(format: "%.2f m", heightInMeters)
        }
    }
}
