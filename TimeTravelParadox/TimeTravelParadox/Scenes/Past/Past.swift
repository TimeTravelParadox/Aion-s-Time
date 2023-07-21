import SpriteKit

class Past: SKNode {
    //criar uma variavel da classe da drawer
    lazy var drawer1: Drawer = Drawer(drawerSize: .small, spriteNode: past?.childNode(withName: "smallerDrawer1") as! SKSpriteNode)
    lazy var drawer2: Drawer = Drawer(drawerSize: .large, spriteNode: past?.childNode(withName: "largerDrawer") as! SKSpriteNode)
    lazy var drawer3: Drawer = Drawer(drawerSize: .small, spriteNode: past?.childNode(withName: "smallerDrawer2") as! SKSpriteNode)
    
    var clock: Clock?
    var typeMachine: TypeMachine?
    var shelf: Shelf?
    var hiddenPolaroid: Shelf?
    var table: SKSpriteNode?
    private let past = SKScene(fileNamed: "PastScene")
    private var pastBG: SKSpriteNode?
    
    private let crumpledPaper = SKSpriteNode(imageNamed: "crumpledPaper")
    private let paper = SKSpriteNode(imageNamed: "paper")
    private var takenPaper: Bool = false
    
    var delegate: ZoomProtocol?
    
    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas
    
    let pastST = SKAction.repeatForever(SKAction.playSoundFileNamed("pastST.mp3", waitForCompletion: true))
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
        self.hiddenPolaroid = Shelf(delegate: delegate)
        
        super.init()
        
        self.zPosition = 1
        if let past, let clock, let typeMachine, let shelf, let hiddenPolaroid{
            pastBG = (past.childNode(withName: "pastBG") as? SKSpriteNode)
            pastBG?.removeFromParent()
            
            self.isUserInteractionEnabled = true
            
            if let pastBG{
                self.addChild(pastBG)
            }
            self.isPaused = false
            
            //fazer o mesmo
            self.addChild(clock)
            clock.delegate = delegate
            self.addChild(typeMachine)
            typeMachine.delegate = delegate
            self.addChild(shelf)
            shelf.delegate = delegate
            self.addChild(hiddenPolaroid)
            hiddenPolaroid.delegate = delegate
            
            self.removeAction(forKey: "futureST")
        }
        
        self.addChild(drawer1.spriteNode)
        self.addChild(drawer2.spriteNode)
        self.addChild(drawer3.spriteNode)
        crumpledPaper.name = "crumpledPaper"
        
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
        case "crumpledPaper":
            HUD.addOnInv(node: crumpledPaper)
            takenPaper = true
            print("crumpledpapper")
        default:
            return
        }
    }
    
    
    private func positionCrumpledPaper(drawer: Drawer) {
        // Defina as coordenadas x e y desejadas para a posição do crumpledPaper
        let desiredX: CGFloat = 0
        let desiredY: CGFloat = -20
        
        let relativePosition = CGPoint(x: desiredX, y: desiredY)
        let absolutePosition = drawer.spriteNode.convert(relativePosition, to: self)
        
        
        crumpledPaper.position = absolutePosition
        crumpledPaper.zPosition = 3
    }
    
    
    func verification(drawer: Drawer, tapped: SKNode) {
        if delegate?.didZoom == true && tapped == drawer.spriteNode {
            drawer.toggle(completion: { [weak self] in
                guard let self else {
                    return
                }
                guard takenPaper == false else {
                    return
                }
                if drawer.isOpened == true {
                    if drawer.drawerSize == .large { // Verifica se a gaveta é a largerOpenDrawer
                        
                        self.addChild(self.crumpledPaper)
                        self.positionCrumpledPaper(drawer: drawer)
                    }
                } else {
                    if drawer.drawerSize == .large { // Verifica se a gaveta é a largerOpenDrawer
                        
                    }
                }
            })
        } else {
            delegate?.zoom(isZoom: true, node: table, ratio: 0.5)
        }
    }
}


