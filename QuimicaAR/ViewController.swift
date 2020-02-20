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
    var ligacoes: [Ligacao] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.scene.physicsWorld.contactDelegate = self

        
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
                case .hidrogenio, .hidrogenio1, .hidrogenio2, .hidrogenio3:
                    shapeNode = Atomo("hidrogenio")
                    shapeNode?.name = "hidrogenio"
                case .oxigenio:
                    shapeNode = Atomo("oxigenio")
                    shapeNode?.name = "oxigenio"
                case .carbono, .carbono1, .carbono2, .carbono3:
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
        if (firstNode.ligacoes < firstNode.numeroDeLigacoes ?? 0) && (secondNode.ligacoes < firstNode.numeroDeLigacoes ?? 0) {
            let noRotacao = SCNNode()
            let ligacao = Ligacao(firstNode, secondNode)
            firstNode.ligacoes += 1
            secondNode.ligacoes += 1
            ligacoes.append(ligacao)
            noRotacao.addChildNode(ligacao)
            contact.nodeA.addChildNode(noRotacao)
            noRotacao.eulerAngles.y = rotacionar(primeiroAtomo: firstNode, segundoAtomo: secondNode)
        }
        return
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        for ligacao in ligacoes {
            guard let firstAtomo = ligacao.atomos?.0 else {return}
            guard let secondAtomo = ligacao.atomos?.1 else {return}
            let firstPosition = SCNVector3ToGLKVector3(firstAtomo.worldPosition)
            let secondPosition = SCNVector3ToGLKVector3(secondAtomo.worldPosition)
            let distance = GLKVector3Distance(firstPosition, secondPosition)
            if distance > 0.13 {
                ligacao.atomos?.0.ligacoes -= 1
                ligacao.atomos?.1.ligacoes -= 1
                ligacao.parent?.removeFromParentNode()
                ligacao.removeFromParentNode()
                ligacoes.removeAll{ $0 == ligacao }
            }
            
        }
        
    }
    
    func rotacionar(primeiroAtomo: Atomo, segundoAtomo: Atomo) -> Float{
        let primeiroAtomoPos = primeiroAtomo.worldPosition
        let segundoAtomoPos = segundoAtomo.worldPosition
        
        let deltaX = primeiroAtomoPos.x - segundoAtomoPos.x
        let deltaY = primeiroAtomoPos.y - segundoAtomoPos.y
        let angulo = atan2(deltaY, deltaX)
        return angulo
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

