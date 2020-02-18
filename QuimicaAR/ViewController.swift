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
    
    var moleculeConection: [SCNNode] = []
    
    var molecules: [Molecule] = []
    
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
                    shapeNode?.name = "hidrogenio"
                case .oxigenio:
                    shapeNode = Atomo("carbono", 4)
                    shapeNode?.name = "oxigenio"
                case .carbono:
                    shapeNode = Atomo("carbono", 4)
                    shapeNode?.name = "carbono"
                case .fluor:
                    shapeNode = Atomo("carbono", 4)
                    shapeNode?.name = "fluor"
                case .nitrogenio:
                    shapeNode = Atomo("carbono", 4)
                    shapeNode?.name = "nitrogenio"
                }
            }
            guard let eletronsInValencia = shapeNode?.eletronsNaValencia else { return nil }
                        
            for _ in 0..<eletronsInValencia {
                let line = SCNNode()
                moleculeConection.append(line)
            }
                
        guard let shape = shapeNode else {return nil}
            node.addChildNode(shape)
            return node
            }
            return nil
        }

        func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
            
            guard let firstAtom = contact.nodeA.parent as? Atomo else {return}
            guard let secondAtom = contact.nodeB.parent as? Atomo else {return}
            
            let firstAtomNode = contact.nodeA
            let secondAtomNode = contact.nodeB
            
            let molecule = createMolecule(firstAtom: firstAtom)
            molecule.addAtom(atom: secondAtom)
            
            if checkMolecule(firstAtom: firstAtom, secondAtom: secondAtom) == true {
                
                molecule.addConnection(atomA: firstAtom, AtomB: secondAtom)
                guard let firstEletronsInValencia = firstAtom.eletronsNaValencia else {return}
                guard let secondEletronsInValencia = secondAtom.eletronsNaValencia else {return }
                if firstEletronsInValencia > 0, secondEletronsInValencia > 0 {
                    let atomConection = lineNode(fromPosition: firstAtomNode.position, fromWorldPosition: firstAtomNode.worldPosition, toPosition: secondAtomNode.position, toWorldPosition: secondAtomNode.worldPosition)
                    atomConection.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                    sceneView.scene.rootNode.addChildNode(atomConection)

                }
                
                
            }
            

//            atomConection.geometry?.firstMaterial?.diffuse.contents = UIColor.white
//            sceneView.scene.rootNode.addChildNode(atomConection)
//            for i in moleculeConection.indices {
//                line = moleculeConection[i].lineNode(from: firstAtom.position, to: secondAtom.position)
//                guard let line = line else { return }
//            firstAtom.addChildNode(line)
//            moleculeConection.remove(at:i)
    }
    
    func createMolecule(firstAtom: Atomo) -> Molecule {
        
        let molecule = Molecule(atom: firstAtom)
        molecules.append(molecule)
        return molecule
        
    }
    
    func checkMolecule(firstAtom: Atomo, secondAtom: Atomo) -> Bool {
        
        var check: Bool = false
        
        if firstAtom.molecule?.id == secondAtom.molecule?.id {
            check = true
        }
        return check
        
    }

    
//    func createMolecule() -> Molecule {
//        if molecules.count == 0 {
//            let molecule = Molecule()
//            molecules.append(molecule)
//            return molecule
//        } else {
//            for i in molecules {
//                
//            }
//        }
//    }
//    
//    func checkMolecule(molecule: Molecule) -> Bool{
//        var check = false
//        for i in molecules {
//            if i.id == molecule.id {
//                check = true
//            }
//        }
//        return check
//    }

    
    func lineNode(fromPosition: SCNVector3, fromWorldPosition: SCNVector3, toPosition:SCNVector3, toWorldPosition: SCNVector3, radius: CGFloat = 0.02) -> SCNNode {
        let vector = SCNVector3.absoluteSubtract(left: fromWorldPosition, right: toWorldPosition)
        let height = vector.length()
        let cylinder = SCNCylinder(radius: radius, height: CGFloat(height))
        cylinder.radialSegmentCount = 4
        let node = SCNNode(geometry: cylinder)
        node.position = (toPosition + fromPosition) / 2
        node.worldPosition = (toWorldPosition + fromWorldPosition) / 2
        node.eulerAngles = SCNVector3.lineEulerAngles(vector: vector)
        return node
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

