//
//  Vault.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 18/07/23.
//

import SpriteKit

// Classe que cria e implementa o cofre presente na cena do Futuro
class Vault: SKNode, RemoveProtocol2 {
  let future = SKScene(fileNamed: "FutureScene")
  
  // Delegado para interação com outras classes
  var delegate: ZoomProtocol?
  
  // Variáveis para representar os nós do cofre
  private var vault: SKSpriteNode?
  var peca2: SKSpriteNode?
  
  // Variáveis relacionadas à senha do cofre
  private var nums: [Int] = [0, 0, 0]
  private var labels: [SKLabelNode] = []
  private var buttonsCofre: [SKButtonNodeLabel] = []
  
  // Delegado para remoção de peças do inventário
  var inventoryItemDelegate: InventoryItemDelegate?
  
  // Animações do cofre
  let vaultOpening = SKAction.animate(with: [SKTexture(imageNamed: "cofre0"), SKTexture(imageNamed: "cofre1"), SKTexture(imageNamed: "cofre2"), SKTexture(imageNamed: "cofre3"), SKTexture(imageNamed: "cofre4"), SKTexture(imageNamed: "cofre5"), SKTexture(imageNamed: "cofre6"),  SKTexture(imageNamed: "cofre7"),  SKTexture(imageNamed: "cofre8"),  SKTexture(imageNamed: "cofre9"),  SKTexture(imageNamed: "cofre10"),  SKTexture(imageNamed: "cofre11")], timePerFrame: 0.1)
  let vaultOpeningSound = SKAction.playSoundFileNamed("cofreAbrindo", waitForCompletion: true)
  let vaultChoose = SKAction.playSoundFileNamed("escolhaDaSenha", waitForCompletion: false)
  
  // Inicializador que adiciona os nós presentes no cofre
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
  
  // Inicializador não implementado
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Função para remover a peça 2 do cofre
  func removePeca() {
    peca2?.removeFromParent()
  }
  
  /// Função para atualizar os labels das senhas do cofre e verificar se a senha está correta
  func updateLabel() {
    for i in 0..<labels.count {
      labels[i].text = "\(nums[i])"
    }
    
    if nums[0] == 1 && nums[1] == 5 && nums[2] == 3 {
      // Se a senha estiver correta, executa a animação de abrir o cofre
      vault?.isPaused = false
      vault?.run(vaultOpening)
      vault?.run(vaultOpeningSound)
      self.run(SKAction.wait(forDuration: 1)){
        self.peca2?.isHidden = false
      }
      
      // Remove os botões do cofre da cena
      for child in buttonsCofre {
        child.removeFromParent()
      }
    }
  }
  
  /// Função para configurar os labels das senhas do cofre
  func setupCofre() {
    for i in 0..<nums.count {
      let label = SKLabelNode(text: "\(nums[i])")
      // Configuração das propriedades do label
      label.fontSize = 40
      label.setScale(0.2)
      label.fontColor = .blue
      label.fontName = "Orbitron-Regular"
      labels.append(label)
      
      // Imagem ao redor do botão do cofre para aumentar a área de toque
      let imagem = SKSpriteNode()
      imagem.alpha = 0.001
      imagem.size = CGSize(width: 15, height: 15)
      imagem.position.y += 2
      
      // Criação dos botões com ação de clique
      let button = SKButtonNodeLabel(imagem: imagem, label: label) {
        // Lógica do clique no botão do cofre
        if self.delegate?.didZoom == true {
          print("Você clicou no número \(i)")
          self.nums[i] += 1
          label.isPaused = false
          label.run(self.vaultChoose)
          
          if self.nums[i] > 9 {
            self.nums[i] = 0
          }
          self.updateLabel()
        }
        
        if self.delegate?.didZoom == false {
          self.delegate?.zoom(isZoom: true, node: self.vault, ratio: 0.3)
        }
      }
      
      // Posicionamento dos botões
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
      
      // Verifica se a peça do cofre já foi pega pelo usuário
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
  
  /// Função para ajustar a posição z dos botões do cofre
  func zPosition() {
    for (_, button) in buttonsCofre.enumerated() {
      button.zPosition = 2
    }
  }
  
  // Função chamada quando o usuário toca na tela
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return } // Se não estiver tocando, termina aqui
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    guard let tapped = tappedNodes.first else { return } // Verifica se algo foi tocado
    
    switch tapped.name {
    case "peca2":
      // Verifica se a peça 2 do cofre foi tocada
      if !UserDefaultsManager.shared.takenChip {
        HUD.addOnInv(node: peca2)
        UserDefaultsManager.shared.takenChip = true
      } else {
        // Caso a peça já tenha sido pega, verifica se ela foi selecionada
        if let itemSelecionado = HUD.shared.itemSelecionado {
          HUD.shared.removeBorder(from: itemSelecionado)
        }
        HUD.shared.addBorder(to: peca2!)
        HUD.shared.itemSelecionado = peca2
        HUD.shared.isSelected = true
        HUD.shared.peca2 = peca2
      }
      
    case "cofre":
      // Clique no cofre
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
