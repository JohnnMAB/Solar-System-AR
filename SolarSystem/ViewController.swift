//
//  ViewController.swift
//  SolarSystem
//
//  Created by Jhonathan Matos on 10/01/23.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    
    private func planet(geometry: SCNGeometry, diffuse: UIImage?, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet
    }
    
    private func rotation(time: TimeInterval) -> SCNAction {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(rotation)
        return forever
    }
    
    private func prepareElements() {
        // Sun
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun")
        sun.position = SCNVector3(0, 0, -1)
        self.sceneView.scene.rootNode.addChildNode(sun)
        let action = self.rotation(time: 8)
        sun.runAction(action)
        
        // Earth
        let earthParent = SCNNode()
        let earth = planet(geometry: SCNSphere(radius: 0.2), diffuse:  UIImage(named: "earthDay"), specular: UIImage(named: "earthSpecular"), emission: UIImage(named: "earthEmission"), normal: UIImage(named: "earthNormal"), position: SCNVector3(1.2 ,0 , 0))
        earthParent.position = SCNVector3(0, 0, -1)
        earthParent.addChildNode(earth)
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        let earthForever = self.rotation(time: 14)
        let earthRotation = self.rotation(time: 8)
        earth.runAction(earthRotation)
        earthParent.runAction(earthForever)
        
        // Venus
        let venusParent = SCNNode()
        let venus = planet(geometry: SCNSphere(radius: 0.1), diffuse: UIImage(named: "venus_surface"), specular: nil, emission: UIImage(named: "venus_atmosphere"), normal: nil, position: SCNVector3(0.5, 0, 0))
        venusParent.addChildNode(venus)
        venusParent.position = SCNVector3(0, 0, -1)
        self.sceneView.scene.rootNode.addChildNode(venusParent)
        let venusForever = self.rotation(time: 10)
        let venusRotation = self.rotation(time: 9)
        venus.runAction(venusRotation)
        venusParent.runAction(venusForever)
        
        // Moon
        let moonParent = SCNNode()
        let moon = planet(geometry: SCNSphere(radius: 0.05), diffuse: UIImage(named: "moon"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.3))
        let moonForever = self.rotation(time: 1)
        moonParent.addChildNode(moon)
        moonParent.position = SCNVector3(1.2, 0, 0)
        moonParent.runAction(moonForever)
        earth.addChildNode(moon)
        earthParent.addChildNode(moonParent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareElements()
    }
    

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
