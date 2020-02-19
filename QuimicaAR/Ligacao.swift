//
//  Ligacao.swift
//  QuimicaAR
//
//  Created by João Henrique Andrade on 18/02/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import SceneKit
class Ligacao: SCNNode {
    var atomos: (Atomo,Atomo)?
    
    init(_ primeiroAtomo: Atomo, _ segundoAtomo: Atomo) {
        super.init()
        atomos = (primeiroAtomo, segundoAtomo)
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        
        let node1Pos = SCNVector3ToGLKVector3(primeiroAtomo.worldPosition)
        let node2Pos = SCNVector3ToGLKVector3(segundoAtomo.worldPosition)
        
        let height = GLKVector3Distance(node1Pos, node2Pos)
        let posicao = SCNVector3(x: primeiroAtomo.position.x + 0.05, y: primeiroAtomo.position.y, z: primeiroAtomo.position.z)
        
        let cilinderNode = SCNNode(geometry: SCNCylinder(radius: 0.005, height: CGFloat(height)))
        cilinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        self.geometry = cilinderNode.geometry
        self.position = posicao
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
