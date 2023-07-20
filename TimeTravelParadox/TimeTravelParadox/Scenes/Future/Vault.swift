//
//  Vault.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 18/07/23.
//

import SpriteKit

class Vault: SKNode {
  let future = SKScene(fileNamed: "FutureScene")
  
  var delegate: ZoomProtocol?
  
  private var vault: SKSpriteNode?
  
  private var nums: [Int] = [0, 0, 0, 0, 0]
  private var labels: [SKLabelNode] = []
  private var buttonsCofre: [SKButtonNodeLabel] = []
  
  let vaultOpening =  SKAction.animate(with: [SKTexture(imageNamed: "cofre0"), SKTexture(imageNamed: "cofre1"), SKTexture(imageNamed: "cofre2"), SKTexture(imageNamed: "cofre3"), SKTexture(imageNamed: "cofre4")], timePerFrame: 0.4)
  
  let vaultOpeningSound = SKAction.playSoundFileNamed("cofreAbrindo", waitForCompletion: true)
  
  let vaultChoose = SKAction.playSoundFileNamed("escolhaDaSenha", waitForCompletion: false)
  
  init(delegate: ZoomProtocol) {
    super.init()
    self.delegate = delegate
    self.zPosition = 1
    
    if let future {
      vault = future.childNode(withName: "cofre") as? SKSpriteNode
      vault?.removeFromParent()
      
      self.isUserInteractionEnabled = true
    }
    
    if let vault {
      self.addChild(vault)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateLabel() {
    for i in 0..<labels.count {
      labels[i].text = "\(nums[i])"
    }
    
    if nums[0] == 1 && nums[1] == 1 && nums[2] == 1 && nums[3] == 1 && nums[4] == 1 {
      
      vault?.isPaused = false
      vault?.run(vaultOpening)
      vault?.run(vaultOpeningSound)
      
      // Remover os botões da cena
      for child in self.children {
        if let button = child as? SKButtonNodeLabel {
          button.removeFromParent()
        }
      }
    }
  }
  
  func setupCofre() {
    
    for i in 0..<nums.count {
      let label = SKLabelNode(text: "\(nums[i])")
      label.fontSize = 14
      label.fontColor = .black
      labels.append(label)
      
      let button = SKButtonNodeLabel(label: label) {
        if self.delegate?.didZoom == true {
          print("Você clicou no num\(i)")
          self.nums[i] += 1
          if self.nums[i] > 9 {
            self.nums[i] = 0
          }
          self.updateLabel()
        }
        
      }
      
      switch i {
      case 0:
        button.position = CGPoint(x: 180, y: 35)
      case 1:
        button.position = CGPoint(x: 203, y: 35)
      case 2:
        button.position = CGPoint(x: 226, y: 35)
      case 3:
        button.position = CGPoint(x: 249, y: 35)
      case 4:
        button.position = CGPoint(x: 272, y: 35)
      default:
        return
      }
      
      buttonsCofre.append(button)
      self.addChild(button)
      
    }
  }
  
  func zPosition() {
    for (_, button) in buttonsCofre.enumerated() {
      button.zPosition = 2
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
    
    switch tapped.name {
    case "cofre":
      delegate?.zoom(isZoom: true, node: vault, ratio: 0.5)
      
      if delegate?.didZoom == true {
        for (_, button) in buttonsCofre.enumerated() {
          button.zPosition = 2
        }
      } else {
        delegate?.zoom(isZoom: true, node: vault, ratio: 0.5)
      }
      
    case "label":
      delegate?.zoom(isZoom: true, node: vault, ratio: 0.5)
      
    default:
      return
    }
    
  }
  
}
