import SpriteKit

protocol ZoomProtocol{
    
    func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat)
}

class GameScene: SKScene, ZoomProtocol{
    private var past: Past?
    private let future = Future()
    private let hud = HUD()
    private let qg = QG()
    
    let cameraNode = SKCameraNode()
    var cameraPosition = CGPoint(x: 0, y: 0)

    func setupCamera(){
        cameraNode.position = cameraPosition
        addChild(cameraNode)
        camera = cameraNode
    }
    
    func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat){
            if isZoom{
                cameraPosition = node?.position ?? cameraNode.position
                cameraNode.position = cameraPosition
                cameraNode.run(SKAction.scale(to: ratio, duration: 0))
            }else{
                cameraNode.position = CGPoint(x: (view?.bounds.width ?? 0)/2, y: (view?.bounds.height ?? 0)/2)
                cameraNode.run(SKAction.scale(to: 1, duration: 0))
            }
            cameraNode.isPaused = false
            cameraNode.run(SKAction.scale(to: 0.5, duration: 0))
        }

    
    var futurePlayingST = false
    
    override func didMove(to view: SKView) {
        self.past = Past(delegate: self)
        if let past {
            addChild(past)
            past.zPosition = 0
        }
      
        addChild(future)
        addChild(hud)
        addChild(qg)
        setupCamera()

        qg.zPosition = 6

        future.zPosition = 0
        hud.zPosition = 10
        hud.hideQGButton(isHide: true)
//        self.isUserInteractionEnabled = true
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
        switch tapped.name {
        case "qgButton":
            qg.zPosition = 5
            past?.zPosition = 0
            future.zPosition = 0
            hud.hideQGButton(isHide: true)
        case "travel":
            
            print("travel", past?.zPosition, future.zPosition)
            if past?.zPosition ?? 0 > 0  {
                past?.zPosition = 0
                qg.zPosition = 0
                
                future.zPosition = 5
                hud.hideQGButton(isHide: false)

            }else{
                qg.zPosition = 0
                future.zPosition = 0

                past?.zPosition = 5
                hud.hideQGButton(isHide: false)

            }
        default:
            return
        }
    }
}
