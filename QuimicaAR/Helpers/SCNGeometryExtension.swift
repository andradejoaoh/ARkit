//
//  SCNGeometryExtension.swift
//  QuimicaAR
//
//  Created by Pedro Henrique Guedes Silveira on 14/02/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import SceneKit

extension SCNGeometry {
    
    class func lineFrom(by vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
        
        let indices: [Int32] = [0,1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
            
        return SCNGeometry(sources: [source], elements: [element])
    }
    
}
