//
//  GameViewController.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 10/07/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let view = self.view as! SKView? {
      // Load the SKScene from 'GameScene.sks'
      if let scene = SKScene(fileNamed: "GameScene") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
       
        if let gameScene = scene as? GameScene {
            GameScene.shared = gameScene
        }
       // GameScene.shared = scene as! GameScene
        
        // Present the scene
        view.presentScene(scene)
      }
      
      view.ignoresSiblingOrder = true
      
      
    }
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
