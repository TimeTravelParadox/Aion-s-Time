import SpriteKit

class GameScene: SKScene{
    private let past = Past()
    private let future = Future()
    private let hud = HUD()
    private let qg = QG()

    let cameraNode = SKCameraNode()
    
    var futurePlayingST = false
    
    override func didMove(to view: SKView) {
        addChild(past)
        addChild(future)
        addChild(hud)
        addChild(qg)

        qg.zPosition = 6
        past.zPosition = 0
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
            past.zPosition = 0
            future.zPosition = 0
            hud.hideQGButton(isHide: true)
        case "travel":
            print("travel", past.zPosition, future.zPosition)
            if past.zPosition > 0  {
                past.zPosition = 0
                qg.zPosition = 0
                
                future.zPosition = 5
                hud.hideQGButton(isHide: false)

            }else{
                qg.zPosition = 0
                future.zPosition = 0

                past.zPosition = 5
                hud.hideQGButton(isHide: false)

            }
        default:
            return
        }
    }
}
