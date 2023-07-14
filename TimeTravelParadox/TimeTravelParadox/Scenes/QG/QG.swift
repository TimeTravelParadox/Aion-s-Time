import SpriteKit

class QG: SKNode{
    let past = SKScene(fileNamed: "QGScene")
    let hud = HUD()
    
    var QGBG: SKSpriteNode?
    
    let QGST = SKAction.repeatForever(SKAction.playSoundFileNamed("QGST.mp3", waitForCompletion: true))
    var qgStatus = false
    
    override init(){
        super.init()
        self.zPosition = 1
        if let past {
            QGBG = (past.childNode(withName: "QGBG") as? SKSpriteNode)
            QGBG?.removeFromParent()
                        
            self.isUserInteractionEnabled = true
        }
        if let QGBG{
            self.addChild(QGBG)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
