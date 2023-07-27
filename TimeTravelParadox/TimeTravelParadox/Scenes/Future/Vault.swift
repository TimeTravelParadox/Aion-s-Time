//
//  Vault.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 18/07/23.
//

import SpriteKit

class Vault: SKNode, RemoveProtocol2 {
  
  let future = SKScene(fileNamed: "FutureScene")
  
  var delegate: ZoomProtocol?
  
  private var vault: SKSpriteNode?
  
  private var nums: [Int] = [0, 0, 0]
  private var labels: [SKLabelNode] = []
  private var buttonsCofre: [SKButtonNodeLabel] = []
  
  var peca2: SKSpriteNode?
  
  var inventoryItemDelegate: InventoryItemDelegate?
  
  let vaultOpening =  SKAction.animate(with: [SKTexture(imageNamed: "cofre0"), SKTexture(imageNamed: "cofre1"), SKTexture(imageNamed: "cofre2"), SKTexture(imageNamed: "cofre3"), SKTexture(imageNamed: "cofre4"), SKTexture(imageNamed: "cofre5"), SKTexture(imageNamed: "cofre6"),  SKTexture(imageNamed: "cofre7"),  SKTexture(imageNamed: "cofre8"),  SKTexture(imageNamed: "cofre9"),  SKTexture(imageNamed: "cofre10"),  SKTexture(imageNamed: "cofre11")],  timePerFrame: 0.1)
  
  let vaultOpeningSound = SKAction.playSoundFileNamed("cofreAbrindo", waitForCompletion: true)
  
  let vaultChoose = SKAction.playSoundFileNamed("escolhaDaSenha", waitForCompletion: false)
  
  init(delegate: ZoomProtocol) {
    super.init()
    self.delegate = delegate
    self.zPosition = 1
    
    if let future {
      vault = future.childNode(withName: "cofre") as? SKSpriteNode
      vault?.removeFromParent()
      peca2 = future.childNode(withName: "peca2") as? SKSpriteNode
      peca2?.removeFromParent()
      
      self.isUserInteractionEnabled = true
    }
    
    if let vault, let peca2 {
      self.addChild(vault)
      self.addChild(peca2)
    }
    
    peca2?.isHidden = true
      
      if UserDefaultsManager.shared.takenChip == true {
          vault?.isPaused = false
          vault!.texture = SKTexture(imageNamed: "cofre12")
          peca2?.isHidden = false
          HUD.addOnInv(node: peca2)
          
      }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func removePeca() {
    peca2?.removeFromParent()
  }
  
  func updateLabel() {
    for i in 0..<labels.count {
      labels[i].text = "\(nums[i])"
    }
    
    if nums[0] == 1 && nums[1] == 5 && nums[2] == 3 {
      
      vault?.isPaused = false
      vault?.run(vaultOpening)
      vault?.run(vaultOpeningSound)
      self.run(SKAction.wait(forDuration: 1)){
        self.peca2?.isHidden = false
      }
      
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
      label.fontName = "Orbitron-Regular"
      label.fontSize = 40
      label.setScale(0.22)
      label.fontColor = .blue
      labels.append(label)
      
      let button = SKButtonNodeLabel(label: label) {
        
        if self.delegate?.didZoom == true {
          print("Você clicou no numero \(i)")
          self.nums[i] += 1
          label.isPaused = false
          label.run(self.vaultChoose)
          //label.name = "label"
          
          if self.nums[i] > 9 {
            self.nums[i] = 0
          }
          self.updateLabel()
        }
        
      }
      
      switch i {
      case 0:
        button.position = CGPoint(x: 239, y: 79.5)
      case 1:
        button.position = CGPoint(x: 250, y: 68.5)
      case 2:
        button.position = CGPoint(x: 239, y: 56.5)
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
  
  func removerPeca2(){
    peca2?.removeFromParent()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
    
    switch tapped.name {
    case "peca2":
      if !UserDefaultsManager.shared.takenChip {
        HUD.addOnInv(node: peca2)
          UserDefaultsManager.shared.takenChip = true
        
      }else{
        if let itemSelecionado = HUD.shared.itemSelecionado {
          HUD.shared.removeBorder(from: itemSelecionado)
        }
        HUD.shared.addBorder(to: peca2!)
        HUD.shared.itemSelecionado = peca2
        HUD.shared.isSelected = true
        HUD.shared.peca2 = peca2
      }
      
    case "cofre":
      delegate?.zoom(isZoom: true, node: vault, ratio: 0.3)
      
      if delegate?.didZoom == true {
        zPosition()
      } else {
        delegate?.zoom(isZoom: true, node: vault, ratio: 0.3)
      }
      
    case "label":
      if delegate?.didZoom == true {
        
      } else {
        delegate?.zoom(isZoom: true, node: vault, ratio: 0.3)
      }
      
    default:
      return
    }
    inventoryItemDelegate?.clearItemDetail()
  }
  
}
