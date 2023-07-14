import SpriteKit

class Future: SKNode{
    private let futureScene = SKScene(fileNamed: "FutureScene")
    private var futureBG: SKSpriteNode?
    
    let futureST = SKAction.repeatForever(SKAction.playSoundFileNamed("futureST.mp3", waitForCompletion: true))

    
    override init(){
        super.init()
        self.zPosition = 0
        if let futureScene {
            futureBG = (futureScene.childNode(withName: "futureBG") as? SKSpriteNode)
            futureBG?.removeFromParent()
            self.isUserInteractionEnabled = true

        }
        if let futureBG{
            self.addChild(futureBG)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return }

        switch tapped.name {
        case "futureBG":
            print("futuro plano de fundo")
        default:
            return
        }
    }
}

