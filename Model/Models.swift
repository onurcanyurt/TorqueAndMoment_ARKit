//
//  Car.swift
//  cAR
//
//  Created by Onurcan YURT on 7/28/17.
//  Copyright © 2017 Onurcan YURT. All rights reserved.
//

import Foundation
import SceneKit

class Car :SCNNode {
    
    var carNode :SCNNode
    
    private var zVelocityOffset = 0.1
    
    init(node: SCNNode) {
        
        self.carNode = node
        super.init()
        
        setup()
    }
    
    private func setup() {
        
        self.addChildNode(self.carNode)
        
        // add physics
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        self.physicsBody?.categoryBitMask = BodyType.car.rawValue
    }
    
    func accelerate() {
        
        let force = simd_make_float4(0,0,-10.2,0)
        let rotatedForce = simd_mul(self.presentation.simdTransform, force)
        let vectorForce = SCNVector3(rotatedForce.x, rotatedForce.y, rotatedForce.z)
        self.physicsBody?.applyForce(vectorForce, asImpulse: false)
        
    }
    
    func turnRight() {
        
        self.physicsBody?.applyTorque(SCNVector4(0,1.0,0,-1.0), asImpulse: false)
    }
    
    func turnLeft() {
        
        self.physicsBody?.applyTorque(SCNVector4(0,1.0,0,1.0), asImpulse: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

