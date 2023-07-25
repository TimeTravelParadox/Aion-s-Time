//
//  Computer.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 17/07/23.
//

import SpriteKit

class Computer: SKNode {
  let future = SKScene(fileNamed: "FutureScene")
  
  var inventarioHUD = HUD()
  
  var delegate: ZoomProtocol?
  
  let mouseClick = SKAction.playSoundFileNamed("mouseClick.mp3", waitForCompletion: false)
  
  private var fundoVerde: SKSpriteNode?
  private var pasta1: SKSpriteNode?
  private var pasta2: SKSpriteNode?
  private var pasta3: SKSpriteNode?
  private var enigma: SKSpriteNode?
  private var voltar: SKSpriteNode?
    
var inventoryItemDelegate: InventoryItemDelegate?
  
  private var quadrado: SKSpriteNode?
  
  init(delegate: ZoomProtocol) {
    super.init()
    self.delegate = delegate
    self.zPosition = 1
    if let future {
      fundoVerde = future.childNode(withName: "fundoVerde") as? SKSpriteNode
      fundoVerde?.removeFromParent()
      pasta1 = future.childNode(withName: "pasta1") as? SKSpriteNode
      pasta1?.removeFromParent()
      pasta2 = future.childNode(withName: "pasta2") as? SKSpriteNode
      pasta2?.removeFromParent()
      pasta3 = future.childNode(withName: "pasta3") as? SKSpriteNode
      pasta3?.removeFromParent()
      enigma = future.childNode(withName: "enigma") as? SKSpriteNode
      enigma?.removeFromParent()
      voltar = future.childNode(withName: "voltar") as? SKSpriteNode
      voltar?.removeFromParent()
      
      self.isUserInteractionEnabled = true
    }
    
    if let fundoVerde, let pasta1, let pasta2, let pasta3, let enigma, let voltar{
      
      self.addChild(fundoVerde)
      self.addChild(pasta1)
      self.addChild(pasta2)
      self.addChild(pasta3)
      self.addChild(enigma)
      self.addChild(voltar)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
    
    switch tapped.name {
    case "fundoVerde":
      delegate?.zoom(isZoom: true, node: fundoVerde, ratio: 0.4)
      if delegate?.didZoom == true {
        pasta1?.zPosition = 2
        pasta2?.zPosition = 2
        pasta3?.zPosition = 2
        voltar?.zPosition = -2
        enigma?.zPosition = -2
      } else {
       
        fundoVerde?.zPosition = 2
        pasta1?.zPosition = -2
        pasta2?.zPosition = -2
        pasta3?.zPosition = -2
        voltar?.zPosition = -2
        enigma?.zPosition = -2
      }
      
    case "pasta1", "pasta3":
      if delegate?.didZoom == true {
        fundoVerde?.zPosition = 1
        pasta1?.zPosition = -2
        pasta2?.zPosition = -2
        pasta3?.zPosition = -2
        voltar?.zPosition = 2
        enigma?.zPosition = -2
        pasta1?.isPaused = false
        pasta1?.run(mouseClick)
        pasta3?.isPaused = false
        pasta3?.run(mouseClick)
      } else {
        delegate?.zoom(isZoom: true, node: fundoVerde, ratio: 0.4)
      }
      
    case "voltar":
      if delegate?.didZoom == true {
        fundoVerde?.zPosition = 1
        pasta1?.zPosition = 2
        pasta2?.zPosition = 2
        pasta3?.zPosition = 2
        voltar?.zPosition = -2
        enigma?.zPosition = -2
        voltar?.isPaused = false
        voltar?.run(mouseClick)
      } else {
        delegate?.zoom(isZoom: true, node: fundoVerde, ratio: 0.4)
      }
      
    case "pasta2":
      if delegate?.didZoom == true {
        fundoVerde?.zPosition = -2
        pasta1?.zPosition = -2
        pasta2?.zPosition = -2
        pasta3?.zPosition = -2
        voltar?.zPosition = 3
        enigma?.zPosition = 2
        pasta2?.isPaused = false
        pasta2?.run(mouseClick)
      } else {
        delegate?.zoom(isZoom: true, node: fundoVerde, ratio: 0.4)
      }
      
    case "enigma":
      delegate?.zoom(isZoom: true, node: enigma, ratio: 0.4)
      
    default:
      return
    }
      inventoryItemDelegate?.clearItemDetail()
  }
  
}
