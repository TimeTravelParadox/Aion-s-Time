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
        qg.qgStatus = true
        past.zPosition = 0
        past.pastStatus = false
        future.zPosition = 0
        future.futureStatus = false
        hud.zPosition = 10
        hud.hideQGButton(isHide: true)
//        self.isUserInteractionEnabled = true
    }

    override func update(_ currentTime: TimeInterval) {
        if !futurePlayingST{
            futurePlayingST = false
        }
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
            qg.qgStatus = true
            past.pastStatus = false
            future.futureStatus = false
            if qg.action(forKey: "qgST") == nil { //evitar camadas de áudio
                qg.run(qg.QGST, withKey: "qgST")
            }
            qg.removeAction(forKey: "pastST")
            qg.removeAction(forKey: "futureST")
        case "travel":
            print("travel", past.zPosition, future.zPosition)
            if past.zPosition > 0  {
                past.zPosition = 0
                qg.zPosition = 0
                
                future.zPosition = 5
                hud.hideQGButton(isHide: false)
                qg.qgStatus = false
                if !futurePlayingST{
                    future.run(future.futureST)
                    futurePlayingST = true
                }

            }else{
                qg.zPosition = 0
                future.zPosition = 0

                past.zPosition = 5
                hud.hideQGButton(isHide: false)
                qg.qgStatus = false

            }
        default:
            return
        }
    }
}
