import SpriteKit

class Past: SKNode, DrawerDelegate {
    //criar uma variavel da classe da drawer
    var drawer1: Drawer?
    var drawer2: Drawer?
    var drawer3: Drawer?
    var clock: Clock?
    
    private let past = SKScene(fileNamed: "PastScene")
    private var pastBG: SKSpriteNode?
    
    private let crumpledPaper = SKSpriteNode(imageNamed: "crumpledPaper")
    private let paper = SKSpriteNode(imageNamed: "paper")
    
    var delegate: ZoomProtocol?
    
    var minuteRotate: CGFloat = 0 // variável para saber o grau dos minutos
    var hourRotate: CGFloat = 0 // variável para saber o grau das horas
    
    let pastST = SKAction.repeatForever(SKAction.playSoundFileNamed("pastST.mp3", waitForCompletion: true))
    let clockOpeningSFX = SKAction.playSoundFileNamed("clockOpeningSFX.mp3", waitForCompletion: true)
    
    func spin() {
        pastBG?.run(SKAction.rotate(byAngle: -.pi/6, duration: 0.2))
    }
    
    init(delegate: ZoomProtocol){
        self.delegate = delegate
        //fazer o mesmo abaixo
        self.drawer1 = Drawer(drawerSize: .small, spriteNode: past?.childNode(withName: "smallerDrawer1") as? SKSpriteNode)
        self.drawer2 = Drawer(drawerSize: .large, spriteNode: past?.childNode(withName: "largerDrawer") as? SKSpriteNode)
        self.drawer3 = Drawer(drawerSize: .small, spriteNode: past?.childNode(withName: "smallerDrawer2") as? SKSpriteNode)
        self.clock = Clock(delegate: delegate)
        super.init()
        
        self.zPosition = 1
        if let past, let clock {
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
            
            self.removeAction(forKey: "futureST")
        }
        
        if let drawer1 {
            addChild(drawer1)
            drawer1.delegate = self
            drawer1.zoomDelegate = delegate
        }
        
        if let drawer2 {
            addChild(drawer2)
            drawer2.delegate = self
            drawer2.zoomDelegate = delegate
        }
        
        if let drawer3 {
            addChild(drawer3)
            drawer3.delegate = self
            drawer3.zoomDelegate = delegate
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
        default:
            return
        }
    }
    
    func addCrumpledPaperIfNeeded(to drawer: Drawer) {
        if drawer.drawerSize == .large { // Verifica se a gaveta é a largerOpenDrawer
            drawer.spriteNode?.addChild(self.crumpledPaper)
            positionCrumpledPaper()
        }
    }
    
    private func positionCrumpledPaper() {
        // Defina as coordenadas x e y desejadas para a posição do crumpledPaper
        let desiredX: CGFloat = 0
        let desiredY: CGFloat = -20
        
        crumpledPaper.position = CGPoint(x: desiredX, y: desiredY)
        crumpledPaper.zPosition = 3
    }
    
    func removeCrumpledPaperIfNeeded(to drawer: Drawer) {
        if drawer.drawerSize == .large { // Verifica se a gaveta é a largerOpenDrawer
            crumpledPaper.removeFromParent()
        }
    }
}

