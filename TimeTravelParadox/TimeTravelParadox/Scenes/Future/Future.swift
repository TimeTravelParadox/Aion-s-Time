import SpriteKit

class Future: SKNode, InventoryItemDelegate {
    // Referência à cena 'Past' para acesso a elementos compartilhados.
    var pastScene: Past?
    
    // Referência à cena 'FutureScene' carregada a partir de um arquivo.
    private let futureScene = SKScene(fileNamed: "FutureScene")
    
    // Referências aos nós do SpriteKit representando o plano de fundo do futuro, a mesa, o monitor esquerdo e a janela.
    private var futureBG: SKSpriteNode?
    private var mesa: SKSpriteNode?
    private var monitorEsquerda: SKSpriteNode?
    private var janela: SKSpriteNode?
    
    // Instâncias dos objetos Computer, Vault e Hologram para gerenciamento das interações.
    var computer: Computer?
    var vault: Vault?
    var hologram: Hologram?
    
    // Delegates para zoom e diálogos.
    var delegate: ZoomProtocol?
    var delegateDialogue: CallDialogue?
    
    // Inicializador da classe Future.
    init(delegate: ZoomProtocol, pastScene: Past, delegateDialogue: CallDialogue) {
        super.init()
        self.delegate = delegate
        self.delegateDialogue = delegateDialogue
        self.pastScene = pastScene
        self.computer = Computer(delegate: delegate)
        self.vault = Vault(delegate: delegate)
        self.hologram = Hologram(delegate: delegate, delegateRemove: pastScene.clock!, delegateRemove2: vault!, delegateDialogue: delegateDialogue)
        vault?.setupCofre()
        vault?.zPosition()
        self.zPosition = 1
        
        // Carrega os nós do SpriteKit (futureBG, mesaFuturo, monitorEsquerda e janela) da cena 'FutureScene'.
        if let futureScene, let computer, let vault, let hologram {
            futureBG = (futureScene.childNode(withName: "futureBG") as? SKSpriteNode)
            futureBG?.removeFromParent()
            mesa = futureScene.childNode(withName: "mesaFuturo") as? SKSpriteNode
            mesa?.removeFromParent()
            monitorEsquerda = futureScene.childNode(withName: "monitorEsquerda") as? SKSpriteNode
            monitorEsquerda?.removeFromParent()
            janela = futureScene.childNode(withName: "janela") as? SKSpriteNode
            janela?.removeFromParent()
            
            self.isUserInteractionEnabled = true
            
            // Adiciona os nós (mesaFuturo, monitorEsquerda, futureBG e janela) como filhos deste nó Future.
            if let mesa, let monitorEsquerda, let futureBG, let janela {
                self.addChild(mesa)
                self.addChild(monitorEsquerda)
                self.addChild(futureBG)
                self.addChild(janela)
            }
            
            // Adiciona os objetos Computer, Vault e Hologram como filhos deste nó Future.
            self.addChild(computer)
            computer.delegate = delegate
            self.addChild(vault)
            vault.delegate = delegate
            self.addChild(hologram)
            hologram.delegate = delegate
            
            // Define os delegates de interação de inventário para os objetos Computer, Vault e Hologram.
            computer.inventoryItemDelegate = self
            vault.inventoryItemDelegate = self
            hologram.inventoryItemDelegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Método acionado quando toques são detectados neste nó.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return }
        
        // Verifica qual nó foi tocado e executa a ação correspondente.
        switch tapped.name {
        case "futureBG":
            delegate?.zoom(isZoom: false, node: futureBG, ratio: 0)
            print("futuro plano de fundo")
            // Deseleciona o item do inventário
            if HUD.shared.isSelected {
                if HUD.shared.itemSelecionado != nil {
                    HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!)
                }
            }
        case "itemDetail":
            // Interage com o item do inventário.
            GameScene.shared.itemDetail?.interact()
            return
        case "mesaFuturo", "monitorEsquerda", "janela":
            // Faz o zoom do nó futuroBG ao tocar na mesa, monitor esquerdo ou janela.
            delegate?.zoom(isZoom: false, node: futureBG, ratio: 0)
            print("futuro plano de fundo")
        default:
            break
        }
        clearItemDetail()
    }
    
    // Método para limpar os detalhes do item do inventário.
    func clearItemDetail() {
        GameScene.shared.itemDetail?.removeFromParent()
        GameScene.shared.itemDetail = nil
    }
    
    // Método para selecionar um nó do inventário.
    func select(node: SKSpriteNode) {
        // Verifica se já existe um item selecionado e cria um novo ItemDetail.
        guard GameScene.shared.itemDetail == nil else {
            return
        }
        GameScene.shared.itemDetail = ItemDetail(item: node)
        GameScene.shared.itemDetail?.position = CGPoint(x: GameScene.shared.cameraPosition.x, y: GameScene.shared.cameraPosition.y)
        addChild(GameScene.shared.itemDetail!)
    }
}
