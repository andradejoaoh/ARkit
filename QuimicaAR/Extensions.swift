//
//  Extensions.swift
//  QuimicaAR
//
//  Created by Pedro Henrique Guedes Silveira on 17/02/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    
    func length() -> Float {
    return sqrtf(x*x + y*y + z*z)
        }
    
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func absoluteSubtract (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(abs(left.x - right.x), abs(left.y - right.y), abs(left.z - right.z))
    }
    
    static func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
    
    static func lineEulerAngles(vector: SCNVector3) -> SCNVector3 {
        let height = vector.length()
        let lxz = sqrtf(vector.x * vector.x + vector.z * vector.z)
        let pitchB = vector.y < 0 ? Float.pi - asinf(lxz/height) : asinf(lxz/height)
        let pitch = vector.z == 0 ? pitchB : sign(vector.z) * pitchB

        var yaw: Float = 0
        if vector.x != 0 || vector.z != 0 {
            let inner = vector.x / (height * sinf(pitch))
            if inner > 1 || inner < -1 {
                yaw = Float.pi / 2
            } else {
                yaw = asinf(inner)
            }
        }
        return SCNVector3(CGFloat(pitch), CGFloat(yaw), 0)
    }
}
