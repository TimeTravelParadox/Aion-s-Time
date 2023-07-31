//
//  Fade.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 19/07/23.
//

import SpriteKit

class Fade: SKNode{
  
  private var fadeScene = SKScene(fileNamed: "Fade")
  
  var fade1: SKSpriteNode?
  var fade2: SKSpriteNode?
  
  override init() {
    super.init()
    
    fade1 = fadeScene?.childNode(withName: "fade1") as? SKSpriteNode
    fade1?.removeFromParent()
    fade2 = fadeScene?.childNode(withName: "fade2") as? SKSpriteNode
    fade2?.removeFromParent()
    
    if let fade1, let fade2 {
      self.addChild(fade1)
      self.addChild(fade2)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func fade(camera: CGPoint) {
    
    let animateFade1 = SKAction.sequence([
      SKAction.move(to: camera, duration: 0.2), // move o fade de cima até a metade da câmera
      SKAction.move(to: CGPoint(x: 0, y: 195), duration: 0.2) // volta o fade para o mesmo lugar
    ])
    
    let animateFade2 = SKAction.sequence([
      SKAction.move(to: camera, duration: 0.2), // move o fade de baixo até a metade da câmera
      SKAction.move(to: CGPoint(x: 0, y: -195), duration: 0.2) // volta o fade para o mesmo lugar
    ])
    
    fade1?.isPaused = false
    fade2?.isPaused = false
    self.fade1?.run(animateFade1)
    self.fade2?.run(animateFade2)
    
  }
  
}
