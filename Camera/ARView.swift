//
//  ARView.swift
//  Camera
//
//  Created by Jia Chen Yee on 5/5/25.
//

import Foundation
import ARKit
import SceneKit
import SwiftUI

struct ARView: UIViewRepresentable {
    
    var gameManager: GameManager
    
    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView()
        
        let configuration = ARWorldTrackingConfiguration()
        
        let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: .main)
        configuration.detectionImages = referenceImages!
        
        configuration.isLightEstimationEnabled = true
        configuration.environmentTexturing = .automatic
        
        view.delegate = gameManager
        
        view.session.run(configuration)
        
        return view
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    
    static func dismantleUIView(_ uiView: ARSCNView, coordinator: GameManager) {
        uiView.session.pause()
    }
    
    func makeCoordinator() -> GameManager {
        return gameManager
    }
}
