import SpriteKit

class GameScene: SKScene, ZoomProtocol{
    
    static let shared = GameScene()
    
    private var past: Past?
    private var future: Future?
    private let hud = HUD()
    private let qg = QG()
    
    private var fade: Fade?
    
    let cameraNode = SKCameraNode()
    var cameraPosition = CGPoint(x: 0, y: 0)
    
    var didZoom = false
    
    func setupCamera(){
        cameraNode.position = cameraPosition
        addChild(cameraNode)
        camera = cameraNode
        GameScene.shared.camera = camera
    }
    
    // Função para reposicionar o inventário
    func positionNodeRelativeToCamera(_ node: SKSpriteNode, offsetX: CGFloat, offsetY: CGFloat) {
        if let camera = camera {
            let cameraPositionInScene = convert(camera.position, to: self)
            let newPosition = CGPoint(x: cameraPositionInScene.x + offsetX, y: cameraPositionInScene.y + offsetY)
            node.position = newPosition
        }
    }
    
    func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat){
        guard didZoom != isZoom else {
            return
        }
        if isZoom {
            // Deselecionar o item
            if HUD.shared.isSelected {
                if HUD.shared.itemSelecionado != nil {
                    HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!)
                }
            }
            self.didZoom = isZoom
            self.cameraPosition = node?.position ?? self.cameraNode.position
            self.cameraNode.position = self.cameraPosition
            self.cameraNode.run(SKAction.scale(to: ratio, duration: 0))
            
//            HUD.shared.inventarioHUD?.size = CGSize(width: 320, height: 50)
//            positionNodeRelativeToCamera(HUD.shared.inventarioHUD!, offsetX: 80*ratio, offsetY: 145*ratio)
            hud.reposiconarInvIn(ratio: ratio)
            for (index, item) in HUD.shared.inventario.enumerated() {
                item.size = CGSize(width: 30*ratio, height: 30*ratio)
                switch index {
                case 0:
                    self.positionNodeRelativeToCamera(item, offsetX: -50*ratio, offsetY: 144*ratio)
                case 1:
                    self.positionNodeRelativeToCamera(item, offsetX: 0, offsetY: 144*ratio)
                case 2:
                    self.positionNodeRelativeToCamera(item, offsetX: 50*ratio, offsetY: 144*ratio)
                case 3:
                    self.positionNodeRelativeToCamera(item, offsetX: 100*ratio, offsetY: 144*ratio)
                case 4:
                    self.positionNodeRelativeToCamera(item, offsetX: 150*ratio, offsetY: 144*ratio)
                default:
                    return
                }
            }
            fade?.fade(camera: cameraNode.position)
        } else {
            // Deselecionar o item
            if HUD.shared.isSelected && HUD.shared.itemSelecionado != nil {
                HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!)
            }
            self.didZoom = isZoom
            self.cameraNode.position = node?.position ?? self.cameraNode.position
            self.cameraNode.run(SKAction.scale(to: 1, duration: 0))
            HUD.shared.inventarioHUD?.size = CGSize(width: 320, height: 50)
            HUD.shared.inventarioHUD?.position = CGPoint(x: 80, y: 145)
            hud.reposiconarInvOut()
            for (index, item) in HUD.shared.inventario.enumerated() {
                item.size = CGSize(width: 30, height: 30)
                switch index {
                case 0:
                    self.positionNodeRelativeToCamera(item, offsetX: -50, offsetY: 144)
                case 1:
                    self.positionNodeRelativeToCamera(item, offsetX: 0, offsetY: 144)
                case 2:
                    self.positionNodeRelativeToCamera(item, offsetX: 50, offsetY: 144)
                case 3:
                    self.positionNodeRelativeToCamera(item, offsetX: 100, offsetY: 144)
                case 4:
                    self.positionNodeRelativeToCamera(item, offsetX: 150, offsetY: 144)
                default:
                    return
                }
            }
            fade?.fade(camera: cameraNode.position)
            print("zoom out")
        }
    }
    
    var futurePlayingST = false
    
    override func didMove(to view: SKView) {
        self.past = Past(delegate: self)
        if let past {
            addChild(past)
            past.zPosition = 0
        }
        
        self.future = Future(delegate: self)
        if let future {
            addChild(future)
            future.zPosition = 0
        }
        
        self.fade = Fade()
        if let fade {
            addChild(fade)
            fade.zPosition = 25
        }
        
        setupCamera()
        
        addChild(hud)
        addChild(qg)
        
        qg.zPosition = 15
        hud.zPosition = 20
        hud.hideQGButton(isHide: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
        switch tapped.name {
        case "qgButton":
            qg.zPosition = 15
            past?.zPosition = 0
            future?.zPosition = 0
            hud.hideQGButton(isHide: true)
            
        case "travel":
            if past?.zPosition ?? 0 > 0  {
                past?.zPosition = 0
                qg.zPosition = 0
                future?.zPosition = 10
                hud.hideQGButton(isHide: false)
                
            }else{
                qg.zPosition = 0
                future?.zPosition = 0
                past?.zPosition = 10
                hud.hideQGButton(isHide: false)
                
            }
        default:
            return
        }
    }
}
