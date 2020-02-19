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

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, SCNSceneRendererDelegate{
    
    @IBOutlet var sceneView: ARSCNView!
    
    var moleculeConection: [SCNNode] = []
    
    var molecules: [Molecule] = []
    
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
        guard let firstAtom = contact.nodeA.parent as? Atomo else {return}
        guard let secondAtom = contact.nodeB.parent as? Atomo else {return}
        
        let firstAtomNode = contact.nodeA
        let secondAtomNode = contact.nodeB
        
        if !firstAtom.checkIfAtomsIsConnected(checkedAtom: secondAtom), !secondAtom.checkIfAtomsIsConnected(checkedAtom: firstAtom) {
            guard let molecule = createMolecule(firstAtom: firstAtom, secondAtom: secondAtom) else { return }
            
            if checkMolecule(firstAtom: firstAtom, secondAtom: secondAtom) {
                
                if molecule.checkIfCanConnected(atomA: firstAtom, atomB: secondAtom) {
                    molecule.addConnection(atomA: firstAtom, AtomB: secondAtom)
                    let atomConection = lineNode(fromPosition: firstAtomNode.position, fromWorldPosition: firstAtomNode.worldPosition,toPosition: secondAtomNode.position, toworldPosition: secondAtomNode.worldPosition)
                    atomConection.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//                    sceneView.scene.rootNode.addChildNode(atomConection)
                    firstAtomNode.addChildNode(atomConection)
                }
            }

        }
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
            
//        guard let firstAtom = contact.nodeA.parent as? Atomo else {return}
//        guard let secondAtom = contact.nodeB.parent as? Atomo else {return}
//        
//        let firstAtomNode = contact.nodeA
//        let secondAtomNode = contact.nodeB
//            
//        guard let molecule = firstAtom.molecule else {return}
//        molecule.removeAtom(atom: secondAtom)
//        molecule.removeAtom(atom: firstAtom)
//        
////        self.molecules.removeAll{ $0 == molecule }
//        
//        firstAtomNode.enumerateChildNodes { (node, stop) in
//            node.removeFromParentNode()
//        }
//        
//        secondAtomNode.enumerateChildNodes { (node, stop) in
//            node.removeFromParentNode()
//        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        <#code#>
    }
    
    
    func createMolecule(firstAtom: Atomo, secondAtom: Atomo) -> Molecule? {
        
        
        switch (firstAtom.checkIfHaveMolecule(), secondAtom.checkIfHaveMolecule()) {
        case (false, false):
            let molecule = Molecule(atom: firstAtom)
            firstAtom.molecule = molecule
            molecule.atoms.append(secondAtom)
            secondAtom.molecule = molecule
            return molecule
        case (true, false):
            guard let molecule = firstAtom.molecule else { return Molecule(atom: firstAtom) }
            secondAtom.molecule = molecule
            molecule.atoms.append(secondAtom)
            return molecule
        case (false, true):
            guard let molecule = secondAtom.molecule else { return Molecule(atom: secondAtom)}
            firstAtom.molecule = molecule
            molecule.atoms.append(firstAtom)
            return molecule
        case (true,true):
            return nil
        }
    }
    
    func checkMolecule(firstAtom: Atomo, secondAtom: Atomo) -> Bool {
        
        var check: Bool = false
        
        if firstAtom.molecule?.id == secondAtom.molecule?.id {
            check = true
        }
        return check

    }
    
    func lineNode(fromPosition: SCNVector3, fromWorldPosition: SCNVector3, toPosition:SCNVector3, toworldPosition: SCNVector3, radius: CGFloat = 0.02) -> SCNNode {
        let vector = SCNVector3.absoluteSubtract(left: fromWorldPosition, right: toworldPosition)
        let height = vector.length()
        let cylinder = SCNCylinder(radius: radius, height: CGFloat(height))
        cylinder.radialSegmentCount = 4
        let node = SCNNode(geometry: cylinder)
        node.position.x += 0.05
//        node.position = (toPosition + fromPosition) / 2
//        node.worldPosition = (toworldPosition + fromWorldPosition) / 2
        node.eulerAngles = SCNVector3.lineEulerAngles(vector: vector)
        setupPhysicsBody(node: node)
        
        return node
    }
    
    func setupPhysicsBody(node: SCNNode) {
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.contactTestBitMask = 0
        node.physicsBody?.collisionBitMask = 0
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

