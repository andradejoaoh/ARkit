//
//  ViewController.swift
//  QuimicaAR
//
//  Created by João Henrique Andrade on 13/02/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate{

    @IBOutlet var sceneView: ARSCNView!
    
    var moleculeConection: [SCNGeometry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackingCards = ARReferenceImage.referenceImages(inGroupNamed: "Cartas Elementos", bundle: Bundle.main) {
            configuration.trackingImages = trackingCards
            configuration.maximumNumberOfTrackedImages = 4
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            plane.cornerRadius = 2
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
        
            var shapeNode: Atomo?
            if let elemento = Elemento(rawValue: imageAnchor.referenceImage.name ?? "hidrogenio"){
                switch elemento {
                case .hidrogenio:
                    shapeNode = Atomo("carbono", 4)
                case .oxigenio:
                    shapeNode = Atomo("carbono", 4)
                case .carbono:
                    shapeNode = Atomo("carbono", 4)

                case .fluor:
                    shapeNode = Atomo("carbono", 4)
                case .nitrogenio:
                    shapeNode = Atomo("carbono", 4)
                }
                
                guard let eletronsInValencia = shapeNode?.eletronsNaValencia else { return nil }
                
                for _ in 0..<eletronsInValencia {
                    let line = SCNGeometry()
                    moleculeConection.append(line)
                }
                
                
            }
            

            guard let shape = shapeNode else {return nil}
            node.addChildNode(shape)
            return node
        }
        return nil
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        let firstAtom = contact.nodeA
        let secondAtom = contact.nodeB
        for i in moleculeConection {
            var index:Int = 0
            let line = i.lineFrom(by: firstAtom.position, to: secondAtom.position)
            firstAtom.geometry = line
            moleculeConection.remove(at:index)
            index += 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
