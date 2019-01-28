//
//  ViewController.swift
//  Hello-AR
//
//  Created by Onurcan YURT on 6/18/17.
//  Copyright © 2017 Onurcan YURT. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum BodyType : Int {
    case box = 1
    case plane = 2
    case car = 3
}

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var planes = [OverlayPlane]()
    
    private var carNode :SCNNode!
    
    private var car :Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        let carScene = SCNScene(named: "car.dae")
        
        guard let node = carScene?.rootNode.childNode(withName: "car", recursively: true) else {
            return
        }
        
        self.car = Car(node: node)
        
        // self.carNode?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        // self.carNode?.physicsBody?.categoryBitMask = BodyType.car.rawValue
        
        // Set the scene to the view
        sceneView.scene = scene
        
        setupControlPad()
        registerGestureRecognizers()
    }
    
    
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer :UIGestureRecognizer) {
        
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if !hitTestResult.isEmpty {
            
            guard let hitResult = hitTestResult.first else {
                return
            }
            
            self.car.position = SCNVector3(hitResult.worldTransform.columns.3.x,hitResult.worldTransform.columns.3.y + 0.1, hitResult.worldTransform.columns.3.z)
            
            self.sceneView.scene.rootNode.addChildNode(self.car)
            
        }
        
    }
    
    private func turnLeft() {
        
        self.car.turnLeft()
        
        // self.carNode.physicsBody?.applyTorque(SCNVector4(0,1,0,1.0), asImpulse: false)
    }
    
    private func turnRight() {
        
        self.car.turnRight()
        
        // self.carNode.physicsBody?.applyTorque(SCNVector4(0,1,0,-1.0), asImpulse: false)
    }
    
    func accelerate() {
        
        let force = simd_make_float4(0,0,-0.02,0)
        let rotatedForce = simd_mul(self.carNode.presentation.simdTransform,force)
        let vectorForce = SCNVector3(rotatedForce.x, rotatedForce.y, rotatedForce.z)
        self.carNode.physicsBody?.applyForce(vectorForce, asImpulse: false)
    }
    
    private func setupControlPad() {
        
        let leftButton = GameButton(frame: CGRect(x: 0, y: self.sceneView.frame.height - 40, width: 50, height: 50)) {
            
            self.car.turnLeft()
            
            //self.turnLeft()
            
        }
        
        leftButton.setTitle("Left", for: .normal)
        
        let rightButton = GameButton(frame: CGRect(x: 60, y: self.sceneView.frame.height - 40, width: 50, height: 50)) {
            
            self.car.turnRight()
            
            //  self.turnRight()
        }
        
        rightButton.setTitle("Right", for: .normal)
        
        let acceleratorButton = GameButton(frame: CGRect(x: 120, y: self.sceneView.frame.height - 40, width: 60, height: 20)) {
            
            self.car.accelerate()
            
            //self.accelerate()
        }
        
        acceleratorButton.backgroundColor = UIColor.red
        acceleratorButton.layer.cornerRadius = 10.0
        acceleratorButton.layer.masksToBounds = true
        
        self.sceneView.addSubview(leftButton)
        self.sceneView.addSubview(rightButton)
        self.sceneView.addSubview(acceleratorButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !(anchor is ARPlaneAnchor) {
            return
        }
        
        let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
            }.first
        
        if plane == nil {
            return
        }
        
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
}







