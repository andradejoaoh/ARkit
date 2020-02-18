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
    var numeroDeLigacoes: Int?
    var ligacoes: Int = 0
    init(_ nomeElemento: String) {
        super.init()
        let atomoNode = (SCNScene(named: "art.scnassets/sphere.scn")?.rootNode.childNode(withName: "sphere", recursively: false))!
        self.nomeElemento = nomeElemento
        self.numeroDeLigacoes = JSONHandler.shared.elementos.first(where: {$0.nomeElemento == nomeElemento})?.numeroDeLigacoes
        atomoNode.physicsBody?.categoryBitMask = 1
        atomoNode.physicsBody?.contactTestBitMask = 1
        atomoNode.physicsBody?.collisionBitMask = 0
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        self.addChildNode(atomoNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
