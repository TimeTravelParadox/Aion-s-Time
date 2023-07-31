//
//  Vault.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 18/07/23.
//

import SpriteKit

// classe que cria e implementa o cofre presente na cena do Futuro
class Vault: SKNode, RemoveProtocol2 {
  let future = SKScene(fileNamed: "FutureScene")
  
  var delegate: ZoomProtocol?
  
  private var vault: SKSpriteNode?
  
  // variavel que permite fazer a troca dos numeros do cofre
  private var nums: [Int] = [0, 0, 0]
  // labels do botoes da senha cofre
  private var labels: [SKLabelNode] = []
  // variavel que recebe os botoes do cofre após virarem botoes
  private var buttonsCofre: [SKButtonNodeLabel] = []
  
  var peca2: SKSpriteNode?
  
  var inventoryItemDelegate: InventoryItemDelegate?
  
  let vaultOpening =  SKAction.animate(with: [SKTexture(imageNamed: "cofre0"), SKTexture(imageNamed: "cofre1"), SKTexture(imageNamed: "cofre2"), SKTexture(imageNamed: "cofre3"), SKTexture(imageNamed: "cofre4"), SKTexture(imageNamed: "cofre5"), SKTexture(imageNamed: "cofre6"),  SKTexture(imageNamed: "cofre7"),  SKTexture(imageNamed: "cofre8"),  SKTexture(imageNamed: "cofre9"),  SKTexture(imageNamed: "cofre10"),  SKTexture(imageNamed: "cofre11")],  timePerFrame: 0.1)
  
  let vaultOpeningSound = SKAction.playSoundFileNamed("cofreAbrindo", waitForCompletion: true)
  
  let vaultChoose = SKAction.playSoundFileNamed("escolhaDaSenha", waitForCompletion: false)
  
  // inicializador que adiciona os nodes presentes no cofre
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
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func removePeca() {
    peca2?.removeFromParent()
  }
  
  // funcao que passa os numeros para labels para poder configura-los, alem disso define a senha do cofre, roda a animacao do cofre abrindo e faz aparecer a peca do cofre
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
      
      for child in buttonsCofre {
        child.removeFromParent()
      }
      
    }
  }
  
  // funcao que configura os labels das senhas do cofre, setando fonte, cor, etc e adiciona os numeros da senha em si
  func setupCofre() {
    
    for i in 0..<nums.count {
      let label = SKLabelNode(text: "\(nums[i])")
      label.fontSize = 40
      label.setScale(0.2)
      label.fontColor = .blue
      label.fontName = "Orbitron-Regular"
      labels.append(label)
        
      // imagem que tem ao redor do botao do cofre para aumentar a area de toque
        let imagem = SKSpriteNode()
        imagem.alpha = 0.001
        imagem.size = CGSize(width: 15, height: 15)
        imagem.position.y += 2
      
        let button = SKButtonNodeLabel(imagem: imagem, label: label) {
        
        if self.delegate?.didZoom == true {
          print("Você clicou no numero \(i)")
          self.nums[i] += 1
          label.isPaused = false
          label.run(self.vaultChoose)
          
          if self.nums[i] > 9 {
            self.nums[i] = 0
          }
          self.updateLabel()
        }
        
      }
      
      switch i {
      case 0:
        button.position = CGPoint(x: 239, y: 80)
      case 1:
        button.position = CGPoint(x: 250, y: 68.5)
      case 2:
        button.position = CGPoint(x: 239, y: 56.5)
      default:
        return
      }
      
      // userDefault da peca do cofre 
      if UserDefaultsManager.shared.takenChip == true {
        vault?.isPaused = false
        vault!.texture = SKTexture(imageNamed: "cofre11")
        peca2?.isHidden = false
        HUD.addOnInv(node: peca2)
        CasesPositions(node: peca2)
      } else {
        buttonsCofre.append(button)
        self.addChild(buttonsCofre[i])
      }
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
      
    default:
      return
    }
    inventoryItemDelegate?.clearItemDetail()
  }
  
}
