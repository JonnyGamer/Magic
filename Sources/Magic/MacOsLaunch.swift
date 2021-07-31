//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 7/31/21.
//


//import Cocoa
//import SpriteKit
//import GameplayKit

#if os(macOS)
public class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene.init(size: .init(width: 1000, height: 1000))
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
}
#endif
