//
//  Shelf.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 18/07/23.
//

import SpriteKit

class Shelf: SKNode {
    // Referência à cena 'PastScene' carregada a partir do arquivo.
    let past = SKScene(fileNamed: "PastScene")
    
    // Delegate para lidar com o zoom.
    var delegate: ZoomProtocol?
    
    // Delegate para gerenciar diálogos.
    var delegateDialogue: CallDialogue?
    
    // Delegate para interações com o inventário.
    var inventoryItemDelegate: InventoryItemDelegate?
    
    // Contador para controlar o passo do diálogo da polaroid.
    var dialogueStep = 0
    
    // Flag para indicar se o diálogo da polaroid já foi mostrado.
    var polaroidDialogue = true
    
    // Referências aos nós do SpriteKit representando o prateleira e a polaroid.
    var hiddenPolaroid: SKSpriteNode?
    var shelf: SKSpriteNode?
    var polaroid: SKSpriteNode?
    
    // Referência ao nó do SpriteKit representando o ponto de ancoragem da prateleira.
    var anchorShelf: SKSpriteNode?
    
    // Ação para expandir o nó da prateleira.
    let expand = SKAction.resize(toWidth: 400, height: 400, duration: 1)
    
    // Ação para fazer a prateleira tremer.
    let shake = SKAction.sequence([
        SKAction.rotate(byAngle: -.pi/12, duration: 0.5),
        SKAction.rotate(byAngle: .pi/6, duration: 0.5),
        SKAction.rotate(byAngle: -.pi/12, duration: 0.5)
    ])
    
    // Inicializador da classe Shelf.
    init(delegate: ZoomProtocol, delegateDialogue: CallDialogue) {
        self.delegate = delegate
        self.delegateDialogue = delegateDialogue
        super.init()
        self.zPosition = 1
        
        // Carrega os nós do SpriteKit (shelf, polaroid, hiddenPolaroid e anchorShelf) da cena 'PastScene'.
        if let past {
            shelf = (past.childNode(withName: "shelf") as? SKSpriteNode)
            shelf?.removeFromParent()
            polaroid = (past.childNode(withName: "polaroid") as? SKSpriteNode)
            polaroid?.removeFromParent()
            anchorShelf = (past.childNode(withName: "anchorShelf") as? SKSpriteNode)
            anchorShelf?.removeFromParent()
            hiddenPolaroid = (past.childNode(withName: "hiddenPolaroid") as? SKSpriteNode)
            hiddenPolaroid?.removeFromParent()
            self.isUserInteractionEnabled = true
        }
        
        // Adiciona os nós (shelf, polaroid, hiddenPolaroid e anchorShelf) como filhos deste nó Shelf.
        if let shelf, let polaroid, let hiddenPolaroid, let anchorShelf {
            self.addChild(shelf)
            self.addChild(polaroid)
            self.addChild(hiddenPolaroid)
            self.addChild(anchorShelf)
            
            // Define as propriedades iniciais para a exibição correta dos nós.
            polaroid.isHidden = true
            polaroid.isPaused = false
            hiddenPolaroid.isPaused = false
        }
        isPaused = false
        
        // Se a polaroid já foi coletada (valor true em 'takenPolaroid' no UserDefaults),
        // mostra a polaroid no inventário.
        if UserDefaultsManager.shared.takenPolaroid == true {
            hiddenPolaroid?.isHidden = true
            polaroid?.isHidden = false
            HUD.addOnInv(node: polaroid)
            polaroid?.zPosition = 15
            polaroid?.size = CGSize(width: 30, height: 30)
            CasesPositions(node: polaroid)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return }
        
        // Limpa os detalhes do item do inventário.
        inventoryItemDelegate?.clearItemDetail()
        
        // Verifica qual nó foi tocado e executa a ação correspondente.
        switch tapped.name {
        case "shelf":
            delegate?.zoom(isZoom: true, node: shelf, ratio: 0.5)
            print("shelf")
        case "hiddenPolaroid":
            // Se a polaroid estiver escondida e o zoom estiver ativado e a polaroid ainda não tiver sido coletada:
            if delegate?.didZoom == true && UserDefaultsManager.shared.takenPolaroid == false {
                polaroid?.isHidden = false
                hiddenPolaroid?.isHidden = true
                
                // Adiciona a polaroid ao inventário e marca como coletada no UserDefaults.
                let moveToInventary = SKAction.run {
                    HUD.addOnInv(node: self.polaroid)
                    UserDefaultsManager.shared.takenPolaroid = true
                }
                
                // Se o diálogo da polaroid ainda não tiver sido mostrado, exibe o diálogo.
                if polaroidDialogue {
                    GameScene.shared.past?.isUserInteractionEnabled = false
                    print("dialogo polaroid")
                    self.run(SKAction.wait(forDuration: 1)) { [self] in
                        delegateDialogue?.dialogue(node: self.shelf, texture: SKTexture(imageNamed: "dialoguePolaroid01"), ratio: 0.5, isHidden: false)
                    }
                    dialogueStep = 1
                }
                
                let sequence = SKAction.sequence([expand, shake, moveToInventary])
                polaroid?.run(sequence)
                self.polaroid?.zPosition = 3
            } else {
                delegate?.zoom(isZoom: true, node: shelf, ratio: 0.5)
            }
            print("hiddenPolaroid")
        case "polaroid":
            // Se a polaroid estiver no inventário, a interação do item do inventário é acionada.
            if let polaroid, HUD.shared.inventario.contains(where: { $0.name == "polaroid" }) {
                inventoryItemDelegate?.select(node: polaroid)
            }
        default:
            return
        }
    }
}
