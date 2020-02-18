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
    let mat = SCNMaterial()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.scene.physicsWorld.contactDelegate = self
        
        mat.diffuse.contents  = UIColor.white
        mat.specular.contents = UIColor.white
        
        JSONHandler.shared.readAtomos()
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
                    shapeNode = Atomo("hidrogenio")
                    shapeNode?.name = "hidrogenio"
                case .oxigenio:
                    shapeNode = Atomo("oxigenio")
                    shapeNode?.name = "oxigenio"
                case .carbono:
                    shapeNode = Atomo("carbono")
                    shapeNode?.name = "carbono"
                case .fluor:
                    shapeNode = Atomo("fluor")
                    shapeNode?.name = "fluor"
                case .nitrogenio:
                    shapeNode = Atomo("nitrogenio")
                    shapeNode?.name = "nitrogenio"
                }
            }
            guard let shape = shapeNode else {return nil}

            node.addChildNode(shape)
            return node
        }
        return nil
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        guard let firstNode = contact.nodeA.parent as? Atomo else {return}
        guard let secondNode = contact.nodeB.parent as? Atomo else {return}
        if (firstNode.ligacoes.count < firstNode.numeroDeLigacoes ?? 0) && (secondNode.ligacoes.count < firstNode.numeroDeLigacoes ?? 0) && (firstNode.ligacoes.contains(secondNode) == false) && (secondNode.ligacoes.contains(firstNode) == false) {
            firstNode.ligacoes.append(secondNode)
            secondNode.ligacoes.append(firstNode)
            let nodeLinha: SCNNode = createCilider(nodeA: contact.nodeA, posA: contact.nodeB.worldPosition, posB: contact.nodeA.worldPosition)
            nodeLinha.eulerAngles.z = .pi/2
            firstNode.addChildNode(nodeLinha)
        }
        return
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        for child in sceneView.scene.rootNode.childNodes {
            guard let atomoNode = child as? Atomo else {return}
            for ligacao in atomoNode.ligacoes {
                let posA = SCNVector3ToGLKVector3(ligacao.worldPosition)
                let posB = SCNVector3ToGLKVector3(atomoNode.worldPosition)
                let distance = GLKVector3Distance(posA, posB)
                if distance > 0.09 && ligacao.childNodes.count > 2 {
                    ligacao.childNodes.last?.removeFromParentNode()
                }
            }
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
    
    func createCilider(nodeA: SCNNode, posA: SCNVector3, posB: SCNVector3) -> SCNNode {
        let node1Pos = SCNVector3ToGLKVector3(posA)
        let node2Pos = SCNVector3ToGLKVector3(posB)

        let height = GLKVector3Distance(node1Pos, node2Pos)
        let cilindroPosition = SCNVector3(x: nodeA.position.x + 0.05, y: nodeA.position.y, z: nodeA.position.z)
        
        let cilinderNode = SCNNode(geometry: SCNCylinder(radius: 0.005, height: CGFloat(height)))
        cilinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        cilinderNode.worldPosition = cilindroPosition
        cilinderNode.physicsBody?.categoryBitMask = 0
        cilinderNode.physicsBody?.contactTestBitMask = 0
        cilinderNode.physicsBody?.collisionBitMask = 0
        return cilinderNode
    }
}

