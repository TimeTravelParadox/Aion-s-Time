import SpriteKit

class Past: SKNode, InventoryItemDelegate {
    //criar uma variavel da classe da drawer
    lazy var drawer1: Drawer = Drawer(drawerSize: .small, spriteNode: past?.childNode(withName: "smallerDrawer1") as! SKSpriteNode)
    lazy var drawer2: Drawer = Drawer(drawerSize: .large, spriteNode: past?.childNode(withName: "largerDrawer") as! SKSpriteNode)
    lazy var drawer3: Drawer = Drawer(drawerSize: .small, spriteNode: past?.childNode(withName: "smallerDrawer2") as! SKSpriteNode)
    
    var clock: Clock?
    var typeMachine: TypeMachine?
    var shelf: Shelf?
    var table: SKSpriteNode?
    private let past = SKScene(fileNamed: "PastScene")
    private var pastBG: SKSpriteNode?
    private var flame: SKSpriteNode?
    private var fireplace: SKSpriteNode?
    private var fadeflame: SKSpriteNode?
    var light: SKLightNode?
    
    private lazy var paper: Paper = Paper(parentNode: self)
    
    var delegate: ZoomProtocol?
    

    
    let flaming =  SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "flame1"), SKTexture(imageNamed: "flame2"), SKTexture(imageNamed: "flame3"), SKTexture(imageNamed: "flame4"), SKTexture(imageNamed: "flame5")], timePerFrame: 0.16))
    let sizzleSFX = SKAction.playSoundFileNamed("sizzle.mp3", waitForCompletion: true)
    
    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas
    
    let clockOpeningSFX = SKAction.playSoundFileNamed("clockOpeningSFX.mp3", waitForCompletion: true)
    
    func spin() {
        pastBG?.run(SKAction.rotate(byAngle: -.pi/6, duration: 0.2))
    }
    
    init(delegate: ZoomProtocol) {
        self.delegate = delegate
        //fazer o mesmo abaixo
        self.table = past?.childNode(withName: "table") as? SKSpriteNode
        self.clock = Clock(delegate: delegate)
        self.typeMachine = TypeMachine(delegate: delegate)
        self.shelf = Shelf(delegate: delegate)
        
        
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
            
            self.isUserInteractionEnabled = true
            
            if let pastBG, let flame, let light, let fireplace, let fadeflame{
                self.addChild(pastBG)
                self.addChild(flame)
                self.addChild(light)
                self.addChild(fireplace)
                self.addChild(fadeflame)
            }
            
            flame?.isPaused = false
            flame?.run(flaming)
            self.isPaused = false
            
            //fazer o mesmo
            self.addChild(clock)
            clock.delegate = delegate
            self.addChild(typeMachine)
            typeMachine.delegate = delegate
            self.addChild(shelf)
            shelf.delegate = delegate
            flame?.lightingBitMask = 1
            self.removeAction(forKey: "futureST")
        }
        
//        pastBG?.size = CGSize(width: 844, height: 420)
//        pastBG?.position = CGPoint(x: 0, y: 0)
        
        self.addChild(drawer1.spriteNode)
        self.addChild(drawer2.spriteNode)
        self.addChild(drawer3.spriteNode)
        
        
        light?.categoryBitMask = 1 // Identificador para a luz (você pode usar outros números de acordo com suas necessidades)
        light?.falloff = 1
        light?.ambientColor = .orange
        light?.lightColor = .orange
        light?.shadowColor = UIColor(white: 0, alpha: 0.5)
        light?.isHidden = true
        fadeflame?.alpha = 0.5
        if let table {
            table.removeFromParent()
            self.addChild(table)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
        
        switch tapped.name {
        case "pastBG":
            delegate?.zoom(isZoom: false, node: pastBG, ratio: 0)
            print("plano de fundo")
            // Deselecionar o item
            if HUD.shared.isSelected {
                if HUD.shared.itemSelecionado != nil {
                    HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!)
                }
            }
        case "flame":
            flame?.run(sizzleSFX)
        case "table":
            print("mesa")
        case "smallerDrawer1":
            verification(drawer: drawer1, tapped: tapped)
            print("smallerDrawer1")
        case "largerDrawer":
            verification(drawer: drawer2, tapped: tapped)
            print("largerDrawer")
        case "smallerDrawer2":
            verification(drawer: drawer3, tapped: tapped)
            print("smallerDrawer2")
            
        case "itemDetail":
            GameScene.shared.itemDetail?.interact()
            return
        default:
            break
        }
        
        clearItemDetail()
    }
    //  implementando delegate
    func clearItemDetail() {
        GameScene.shared.itemDetail?.removeFromParent()
        GameScene.shared.itemDetail = nil
    }
    
    private func positionCrumpledPaper(drawer: Drawer) {
        // Defina as coordenadas x e y desejadas para a posição do crumpledPaper
        let desiredX: CGFloat = 0
        let desiredY: CGFloat = -20
        
        let relativePosition = CGPoint(x: desiredX, y: desiredY)
        let absolutePosition = drawer.spriteNode.convert(relativePosition, to: self)
        
        
        paper.position = absolutePosition
        paper.zPosition = 3
    }
    
    
    func verification(drawer: Drawer, tapped: SKNode) {
        if delegate?.didZoom == true && tapped == drawer.spriteNode {
            drawer.toggle(completion: { [weak self] in
                guard let self else {
                    return
                }
                
                switch paper.mode {
                case .onDrawer:
                    if drawer.isOpened == true {
                        if drawer.drawerSize == .large { // Verifica se a gaveta é a largerOpenDrawer
                            
                            self.addChild(self.paper)
                            self.positionCrumpledPaper(drawer: drawer)
                        }
                    } else {
                        if drawer.drawerSize == .large { // Verifica se a gaveta é a largerOpenDrawer
                            self.paper.removeFromParent()
                        }
                    }
                case .onInv:
                    break //sai do switch
                }
                
            })
        } else {
            delegate?.zoom(isZoom: true, node: table, ratio: 0.5)
        }
    }
    
    func select(node: SKSpriteNode) {
        guard GameScene.shared.itemDetail == nil else {
            return
        }
        GameScene.shared.itemDetail = ItemDetail(item: node)
        GameScene.shared.itemDetail?.position = CGPoint(x: GameScene.shared.cameraPosition.x, y: GameScene.shared.cameraPosition.y)
        addChild(GameScene.shared.itemDetail!)
        GameScene.shared.itemDetail?.isHidden = false
    }
}
