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
        let posicaoX = (primeiroAtomo.childNodes[0].worldPosition.x + segundoAtomo.childNodes[0].worldPosition.x)/2
        let posicaoY = (primeiroAtomo.childNodes[0].worldPosition.y + segundoAtomo.childNodes[0].worldPosition.y)/2
        let posicaoZ = (primeiroAtomo.childNodes[0].worldPosition.z + segundoAtomo.childNodes[0].worldPosition.z)/2
        let posicao = SCNVector3(x: posicaoX, y: posicaoY, z: posicaoZ)
        let cilinderNode = SCNNode(geometry: SCNCylinder(radius: 0.005, height: CGFloat(height)))
        cilinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        self.geometry = cilinderNode.geometry
        self.worldPosition = posicao
        self.eulerAngles.z = .pi/2
//        self.look(at: SCNVector3(x:(segundoAtomo.position.x + .pi/2), y: (segundoAtomo.position.y + .pi/2), z: segundoAtomo.position.z ))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
