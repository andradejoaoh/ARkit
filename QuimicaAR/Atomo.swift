//
//  Atomo.swift
//  QuimicaAR
//
//  Created by João Henrique Andrade on 14/02/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SceneKit

class Atomo: SCNNode, Codable {
    var nomeElemento: String?
    var eletronsNaValencia: Int?
    
    init(_ nomeElemento: String, _ eletronsNaValencia: Int) {
        super.init()
        self.nomeElemento = nomeElemento
        self.eletronsNaValencia = JSONHandler.shared.elementos.first(where: {$0.nomeElemento == nomeElemento})?.eletronsNaValencia
        self.addChildNode((SCNScene(named: "art.scnassets/sphere.scn")?.rootNode.childNode(withName: "sphere", recursively: false))!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
