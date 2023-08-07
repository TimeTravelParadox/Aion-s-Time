import SpriteKit

import SpriteKit

/// Uma classe que representa o passado no jogo.
class Past: SKNode, InventoryItemDelegate {
    // Propriedades de cada gaveta no cenário.
    lazy var drawer1: Drawer = Drawer(drawerSize: .small, spriteNode: past?.childNode(withName: "smallerDrawer1") as! SKSpriteNode)
    lazy var drawer2: Drawer = Drawer(drawerSize: .large, spriteNode: past?.childNode(withName: "largerDrawer") as! SKSpriteNode)
    lazy var drawer3: Drawer = Drawer(drawerSize: .small, spriteNode: past?.childNode(withName: "smallerDrawer2") as! SKSpriteNode)
    
    // Outras propriedades da classe.
    var clock: Clock?
    var typeMachine: TypeMachine?
    var shelf: Shelf?
    var table: SKSpriteNode?
    private let past = SKScene(fileNamed: "PastScene")
    private var pastBG: SKSpriteNode?
    private var flame: SKSpriteNode?
    private var fireplace: SKSpriteNode?
    private var fadeflame: SKSpriteNode?
    private var mirror: SKSpriteNode?
    var light: SKLightNode?
    var lamp: SKSpriteNode?
    var lightLamp: SKLightNode?
    var dialogueMirror = true
    
    // Propriedade do item Paper no inventário.
    lazy var paper: Paper = Paper(parentNode: self)
    
    // Delegates de zoom e Dialogo
    var delegate: ZoomProtocol?
    var delegateDialogue: CallDialogue?
    
    // Ações e sons para animações.
    let flaming = SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "flame1"), SKTexture(imageNamed: "flame2"), SKTexture(imageNamed: "flame3"), SKTexture(imageNamed: "flame4"), SKTexture(imageNamed: "flame5")], timePerFrame: 0.16))
    let sizzleSFX = SKAction.playSoundFileNamed("sizzle.mp3", waitForCompletion: true)
    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas
    let clockOpeningSFX = SKAction.playSoundFileNamed("clockOpeningSFX.mp3", waitForCompletion: true)
    
    // Método para girar a cena do passado.
    
    
    // Inicializador da classe.
    init(delegate: ZoomProtocol, delegateDialogue: CallDialogue) {
        self.delegate = delegate
        self.delegateDialogue = delegateDialogue
        self.table = past?.childNode(withName: "table") as? SKSpriteNode
        self.clock = Clock(delegate: delegate, delegateDialogue: delegateDialogue)
        self.typeMachine = TypeMachine(delegate: delegate, delegateDialogue: delegateDialogue)
        self.shelf = Shelf(delegate: delegate, delegateDialogue: delegateDialogue)
        
        // Inicialização das demais propriedades da classe.
        super.init()
        
        shelf?.inventoryItemDelegate = self
        clock?.inventoryItemDelegate = self
        typeMachine?.inventoryItemDelegate = self
        paper.inventoryItemDelegate = self
        
        self.zPosition = 1
        if let past, let clock, let typeMachine, let shelf {
            pastBG = (past.childNode(withName: "pastBG") as? SKSpriteNode)
            pastBG?.removeFromParent()
            flame = (past.childNode(withName: "flame") as? SKSpriteNode)
            flame?.removeFromParent()
            fireplace = (past.childNode(withName: "fireplace") as? SKSpriteNode)
            fireplace?.removeFromParent()
            fadeflame = (past.childNode(withName: "fadeflame") as? SKSpriteNode)
            fadeflame?.removeFromParent()
            light = (past.childNode(withName: "light") as? SKLightNode)
            light?.removeFromParent()
            lightLamp = (past.childNode(withName: "lightLamp") as? SKLightNode)
            lightLamp?.removeFromParent()
            mirror = (past.childNode(withName: "mirror") as? SKSpriteNode)
            mirror?.removeFromParent()
            lamp = (past.childNode(withName: "lamp") as? SKSpriteNode)
            lamp?.removeFromParent()
            
            self.isUserInteractionEnabled = true
            
            if let pastBG, let flame, let light, let fireplace, let fadeflame, let mirror, let lamp, let lightLamp{
                self.addChild(pastBG)
                self.addChild(flame)
                self.addChild(light)
                self.addChild(fireplace)
                self.addChild(fadeflame)
                self.addChild(mirror)
                self.addChild(lamp)
                self.addChild(lightLamp)
            }
            
            flame?.isPaused = false
            flame?.run(flaming)
            self.isPaused = false
            
            self.addChild(clock)
            clock.delegate = delegate
            self.addChild(typeMachine)
            typeMachine.delegate = delegate
            self.addChild(shelf)
            shelf.delegate = delegate
            flame?.lightingBitMask = 1
            self.removeAction(forKey: "futureST")
        }
        
        self.addChild(drawer1.spriteNode)
        self.addChild(drawer2.spriteNode)
        self.addChild(drawer3.spriteNode)
        
        light?.categoryBitMask = 1
        light?.falloff = 1
        light?.ambientColor = .orange
        light?.lightColor = .orange
        light?.shadowColor = UIColor(white: 0, alpha: 0.5)
        light?.isHidden = true
        fadeflame?.alpha = 0.5
        
        lightLamp?.categoryBitMask = 1
        lightLamp?.falloff = 1
        lightLamp?.ambientColor = .orange
        lightLamp?.lightColor = .orange
        lightLamp?.shadowColor = UIColor(white: 0, alpha: 1)
        lightLamp?.isHidden = true
        if let table {
            table.removeFromParent()
            self.addChild(table)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Método para tratar toques na cena.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
        switch tapped.name {
        case "pastBG":
            // Faz alguma ação ao tocar no plano de fundo (background).
            delegate?.zoom(isZoom: false, node: pastBG, ratio: 0) // Chama o delegate para fazer o zoom da cena para o plano de fundo.
            print("plano de fundo")
            // Deselecionar o item
            if HUD.shared.isSelected {
                if HUD.shared.itemSelecionado != nil {
                    HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!) // Remove a borda do item selecionado, se houver.
                }
            }
            mirror?.texture = SKTexture(imageNamed: "mirror") // Atualiza a textura do espelho.
            delegateDialogue?.dialogue(node: pastBG, text: "", ratio: 1, isHidden: true) // Exibe um diálogo relacionado ao plano de fundo.
        case "flame":
            // Faz alguma ação ao tocar na chama (flame).
            flame?.run(sizzleSFX)
        case "table":
            // Faz alguma ação ao tocar na mesa (table).
            delegate?.zoom(isZoom: true, node: table, ratio: 0.4) // Chama o delegate para fazer o zoom da cena para a mesa.
            print("mesa")
        case "smallerDrawer1":
            // Faz alguma ação ao tocar na primeira gaveta menor (smallerDrawer1).
            verification(drawer: drawer1, tapped: tapped) // Chama o método de verificação para a gaveta.
            print("smallerDrawer1")
        case "largerDrawer":
            // Faz alguma ação ao tocar na gaveta maior (largerDrawer).
            verification(drawer: drawer2, tapped: tapped) // Chama o método de verificação para a gaveta.
            print("largerDrawer")
        case "smallerDrawer2":
            // Faz alguma ação ao tocar na segunda gaveta menor (smallerDrawer2).
            verification(drawer: drawer3, tapped: tapped) // Chama o método de verificação para a gaveta.
            print("smallerDrawer2")
        case "mirror":
            // Faz alguma ação ao tocar no espelho (mirror).
            if dialogueMirror {
                delegateDialogue?.dialogue(node: mirror, text: "dialogueMirror", ratio: 0.3, isHidden: false) // Exibe um diálogo relacionado ao espelho, se ainda não tiver sido exibido.
                dialogueMirror = false
            }
            delegate?.zoom(isZoom: true, node: mirror, ratio: 0.3) // Chama o delegate para fazer o zoom da cena para o espelho.
            mirror?.texture = SKTexture(imageNamed: "mirrorZoom") // Atualiza a textura do espelho.
        case "itemDetail":
            // Faz alguma ação ao tocar no item detalhado (itemDetail).
            GameScene.shared.itemDetail?.interact() // Chama o método de interação do item detalhado.
            return
        default:
            break
        }
        clearItemDetail() // Remove o item detalhado da cena.
    }

    /// Método necessário para implementar o delegate InventoryItemDelegate.
    func clearItemDetail() {
        GameScene.shared.itemDetail?.removeFromParent() // Remove o item detalhado da cena.
        GameScene.shared.itemDetail = nil
    }

    /// Método para posicionar o papel amassado (crumpledPaper) dentro da gaveta.
    private func positionCrumpledPaper(drawer: Drawer) {
        // Defina as coordenadas x e y desejadas para a posição do crumpledPaper
        let desiredX: CGFloat = 0
        let desiredY: CGFloat = -20

        let relativePosition = CGPoint(x: desiredX, y: desiredY)
        let absolutePosition = drawer.spriteNode.convert(relativePosition, to: self)

        paper.position = absolutePosition // Define a posição do papel amassado.
        paper.zPosition = 3 // Define a ordem de renderização do papel amassado.
    }

    /// Método para verificar ações ao tocar nas gavetas.
    func verification(drawer: Drawer, tapped: SKNode) {
        if delegate?.didZoom == true && tapped == drawer.spriteNode {
            drawer.toggle(completion: { [weak self] in
                guard let self = self else { return }
                switch paper.mode {
                case .onDrawer:
                    if drawer.isOpened == true {
                        if drawer.drawerSize == .large { // Verifica se a gaveta é a largerOpenDrawer
                            self.addChild(self.paper) // Adiciona o papel amassado à cena.
                            self.positionCrumpledPaper(drawer: drawer) // Posiciona o papel amassado dentro da gaveta.
                        }
                    } else {
                        if drawer.drawerSize == .large { // Verifica se a gaveta é a largerOpenDrawer
                            self.paper.removeFromParent() // Remove o papel amassado da cena.
                        }
                    }
                case .onInv:
                    break // Sai do switch
                }
            })
        } else {
            delegate?.zoom(isZoom: true, node: table, ratio: 0.4) // Chama o delegate para fazer o zoom da cena para a mesa.
        }
    }

    /// Método do delegate InventoryItemDelegate para selecionar um item e exibi-lo no detalhe.
    func select(node: SKSpriteNode) {
        guard GameScene.shared.itemDetail == nil else {
            return
        }
        GameScene.shared.itemDetail = ItemDetail(item: node) // Cria um item detalhado.
        GameScene.shared.itemDetail?.position = CGPoint(x: GameScene.shared.cameraPosition.x, y: GameScene.shared.cameraPosition.y)
        addChild(GameScene.shared.itemDetail!) // Adiciona o item detalhado à cena.
        GameScene.shared.itemDetail?.isHidden = false // Exibe o item detalhado.
    }
    ///faz girar a polaroid
    func spin() {
        pastBG?.run(SKAction.rotate(byAngle: -.pi/6, duration: 0.2))
    }
}
