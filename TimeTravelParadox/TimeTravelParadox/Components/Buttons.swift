//
//  Buttons.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 18/07/23.
//

import SpriteKit

class SKButtonNodeLabel: SKNode {
  
  var label: SKLabelNode?
  var action: (() -> Void)?
  
  init (label: SKLabelNode, action: @escaping () -> Void) {
    
    self.label = label
    self.action = action
    super.init()
    self.isUserInteractionEnabled = true
    
    self.addChild(label)
    
  }
  
  required init? (coder Decoder: NSCoder) {
    super.init(coder: Decoder)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.action?()
  }
  
}

class SKButtonNodeImg: SKNode {
  
  var imagem : SKSpriteNode?
  var action: (() -> Void)?
  
  init (imagem: SKSpriteNode, action: @escaping () -> Void) {
    
    self.imagem = imagem
    self.action = action
    super.init()
    self.isUserInteractionEnabled = true
    
    self.addChild(imagem)
    
  }
  
  required init? (coder Decoder: NSCoder) {
    super.init(coder: Decoder)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.action?()
  }
  
}
