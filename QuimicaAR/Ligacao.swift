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

        self.position.x = Float(-0.05)

        if primeiroAtomo.worldPosition.x < segundoAtomo.position.x {
            self.position.x = Float(0.05)
        }
        let deltaY = abs(primeiroAtomo.worldPosition.y - segundoAtomo.worldPosition.y)
        let deltaX = abs(primeiroAtomo.worldPosition.x - primeiroAtomo.worldPosition.x)
        let hiptenusa = sqrt(deltaX*deltaX + deltaY*deltaY)
        
        let cilinderNode = SCNNode(geometry: SCNCylinder(radius: 0.005, height: CGFloat(height)))
        cilinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        self.geometry = cilinderNode.geometry
        self.eulerAngles.z = .pi/2
//        self.eulerAngles.y = segundoAtomo.eulerAngles.y
//        self.eulerAngles = SCNVector3(Float.pi / 2,
//                                      acos((primeiroAtomo.position.z-segundoAtomo.position.z)/height),
//        atan2((primeiroAtomo.position.y-segundoAtomo.position.y),(primeiroAtomo.position.x-segundoAtomo.position.x)))
//        self.look(at: SCNVector3(x:(segundoAtomo.position.x), y: (segundoAtomo.position.y + .pi/2), z: segundoAtomo.position.z ))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
