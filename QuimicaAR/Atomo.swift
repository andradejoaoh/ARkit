//
//  Atomo.swift
//  QuimicaAR
//
//  Created by João Henrique Andrade on 14/02/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SceneKit

class Atomo: SCNNode {
    var nomeElemento: String?
    var eletronsNaValencia: Int?
    var atomsConnected: [Atomo] = []
    var molecule : Molecule?
    var id = String()
    var idArray = [String]()
    
    
    init(_ nomeElemento: String, _ eletronsNaValencia: Int) {
        
        self.id = UUID().uuidString
        
        super.init()
        let atomoNode = (SCNScene(named: "art.scnassets/sphere.scn")?.rootNode.childNode(withName: "sphere", recursively: false))!
        self.nomeElemento = nomeElemento
        self.eletronsNaValencia = 2
//            JSONHandler.shared.elementos.first(where: {$0.nomeElemento == nomeElemento})?.eletronsNaValencia
        
        self.addChildNode(atomoNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkIfIsConnected(atom: Atomo) -> Atomo? {
       
        if atomsConnected.count != 0 {
            
            for i in atomsConnected {
                if i.id == atom.id {
                    return nil
                } else {
                    atomsConnected.append(atom)
                    return atom
                }
            }
            
        } else {
            atomsConnected.append(atom)
            return atom
        }
        return nil
    }
}
