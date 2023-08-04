import SpriteKit

/// Classe que representa uma máquina de escrever na cena do jogo.
class TypeMachine: SKNode {
    let past = SKScene(fileNamed: "PastScene") // instancia da scena PastScene
    
    // Nodes
    private var typeMachine: SKSpriteNode?
    private var text: SKLabelNode?
    private var delete: SKSpriteNode?
    private var paper: SKSpriteNode?
    var paperComplete: SKSpriteNode?
    private var trail: SKSpriteNode?
    
    // Variáveis de referencia para a máquina de escrever
    private var keyNodes: [String: SKSpriteNode?] = [:]
    let keys = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890^")
    
    
    // Sound effect
    let typingSFX = SKAction.playSoundFileNamed("typing.mp3", waitForCompletion: false)
    let deletingSFX = SKAction.playSoundFileNamed("deleting.mp3", waitForCompletion: false)
    let dingSFX = SKAction.playSoundFileNamed("ding.mp3", waitForCompletion: false)
    
    //Delegates
    var delegate: ZoomProtocol?
    var delegateDialogue: CallDialogue?
    var inventoryItemDelegate: InventoryItemDelegate?
    
    // MARK: - Initializers
    
    /// Inicializador da classe TypeMachine.
    /// - Parameters:
    ///   - delegate: O delegado que implementa o protocolo ZoomProtocol.
    ///   - delegateDialogue: O delegado que implementa o protocolo CallDialogue.

    init(delegate: ZoomProtocol, delegateDialogue: CallDialogue) {
        self.delegate = delegate
        self.delegateDialogue = delegateDialogue
        super.init()
        self.zPosition = 1
        if let past {
            typeMachine = (past.childNode(withName: "typeMachine") as? SKSpriteNode)
            typeMachine?.removeFromParent()
            text = (past.childNode(withName: "text") as? SKLabelNode)
            text?.removeFromParent()
            
            let keyNames = keys.map { String($0) }
            removeAndAddChild(nodeNames: keyNames)
            
            delete = (past.childNode(withName: "delete") as? SKSpriteNode)
            delete?.removeFromParent()
            trail = (past.childNode(withName: "trail") as? SKSpriteNode)
            trail?.removeFromParent()
            paper = (past.childNode(withName: "paper") as? SKSpriteNode)
            paper?.removeFromParent()
            paperComplete = (past.childNode(withName: "paperComplete") as? SKSpriteNode)
            paperComplete?.removeFromParent()
            
            
            self.isUserInteractionEnabled = true
            
            if let typeMachine, let text, let delete, let trail, let paper, let paperComplete {
                self.addChild(typeMachine)
                self.addChild(text)
                self.addChild(delete)
                self.addChild(trail)
                self.addChild(paper)
                self.addChild(paperComplete)
            }
            text?.text = ""
            text?.fontName = "SpecialElite-Regular"
            text?.fontSize = 30 // Defina o tamanho da fonte desejado
            text?.setScale(0.1) // Dimensione o nó
            
            paperComplete?.isHidden = true
        }
        if UserDefaultsManager.shared.takenPaper == true {
            paper?.isHidden = true
            paperComplete?.isHidden = false
            text?.isHidden = true
            HUD.addOnInv(node: paperComplete)
            paperComplete?.zPosition = 15
            paperComplete?.size = CGSize(width: 30, height: 30)
            CasesPositions(node: paperComplete)
            paperComplete?.isPaused = false
            if let paperComplete {
                inventoryItemDelegate?.select(node: paperComplete)
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Remove and add child
    
    /// Metodo que percorre o array nodeNames, remove e adiciona em pastscene
    /// - Parameters:
    ///   - nodeNames: Recebe um array que representa a tecla que vai ser adicionada.

    func removeAndAddChild(nodeNames: [String]) {
        for name in nodeNames {
            if let spriteNode = past!.childNode(withName: name) as? SKSpriteNode {
                spriteNode.removeFromParent()
                keyNodes[name] = spriteNode
                self.addChild(spriteNode)
            }
        }
    }
    
    // MARK: - Touch Handling
    
    /// Método chamado quando ocorre o toque na tela.
    /// - Parameters:
    ///   - touches: Conjunto de objetos `UITouch` representando os toques na tela.
    ///   - event: Objeto `UIEvent` contendo informações sobre o evento de toque.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return }
        
        // Verifica se o texto na máquina de escrever não é "AION".
        if text?.text != "AION" {
            for (key, spriteNode) in keyNodes {
                // Verifica se o nó tocado é uma das teclas da máquina de escrever.
                if tapped == spriteNode {
                    // Verifica se o zoom está ativado.
                    if delegate?.didZoom == true {
                        // Executa o som de digitação na tecla tocada.
                        spriteNode?.isPaused = false
                        spriteNode?.run(typingSFX)
                        
                        // Verifica se o zoom está ativado.
                        if delegate?.didZoom == true {
                            if text!.text!.count < 4 {
                                // Adiciona a letra digitada ao texto exibido na máquina de escrever.
                                text?.text = (text?.text ?? "") + key
                                // Verifica se o texto completo foi digitado ("AION").
                                if text?.text == "AION" {
                                    spriteNode?.isPaused = false
                                    spriteNode?.run(dingSFX)
                                    paper?.isHidden = true
                                    delegateDialogue?.dialogue(node: typeMachine, texture: SKTexture(imageNamed: "dialogueTypemachine"), ratio: 0.15, isHidden: false)
                                    paperComplete?.isHidden = false
                                    text?.isHidden = true
                                    UserDefaultsManager.shared.takenPaper = true
                                }
                            } else {
                                // Caso o texto exceda 4 caracteres, remove a última letra.
                                spriteNode?.isPaused = false
                                spriteNode?.run(deletingSFX)
                                text?.text = ""
                            }
                        }
                    }
                }
            }
        }
        
        // Verifica qual nó foi tocado.
        switch tapped.name {
        case "paperComplete":
            // Adiciona o papel completo no inventário caso ainda não esteja.
            HUD.addOnInv(node: paperComplete)
            // Seleciona o nó no inventário.
            if let paperComplete, HUD.shared.inventario.contains(where: { $0.name == "paperComplete" }) {
                inventoryItemDelegate?.select(node: paperComplete)
            }
            return
        case "delete":
            // Executa o som de deleção ao tocar no botão de delete.
            delete?.run(typingSFX)
            // Deleta a última letra digitada do texto exibido na máquina de escrever.
            if let labelText = text?.text, !labelText.isEmpty {
                text?.text = String(labelText.dropLast())
            }
        case "typeMachine":
            // Realiza o zoom ao tocar na máquina de escrever.
            delegate?.zoom(isZoom: true, node: typeMachine, ratio: 0.15)
        default:
            // Realiza o zoom ao tocar em outros elementos da cena.
            delegate?.zoom(isZoom: true, node: typeMachine, ratio: 0.15)
            print("default")
        }
        
        // Limpa o item selecionado no inventário.
        inventoryItemDelegate?.clearItemDetail()
    }
}
