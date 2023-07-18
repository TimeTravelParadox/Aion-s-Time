import SpriteKit

class TypeMachine: SKNode {
    let past = SKScene(fileNamed: "PastScene")
    
    private var typeMachine: SKSpriteNode?
    private var text: SKLabelNode?
    private var delete: SKSpriteNode?
    private var keyNodes: [String: SKSpriteNode?] = [:]
    let keys = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890^")
    
    let typingSFX = SKAction.playSoundFileNamed("typing.mp3", waitForCompletion: false)
    let deletingSFX = SKAction.playSoundFileNamed("deleting.mp3", waitForCompletion: false)
    let dingSFX = SKAction.playSoundFileNamed("ding.wav", waitForCompletion: false)
    
    var delegate: ZoomProtocol?
    
    init(delegate: ZoomProtocol) {
        self.delegate = delegate
        super.init()
        self.zPosition = 1
        if let past {
            typeMachine = (past.childNode(withName: "typeMachine") as? SKSpriteNode)
            typeMachine?.removeFromParent()
            text = (past.childNode(withName: "text") as? SKLabelNode)
            text?.removeFromParent()
            
            let keyNames = keys.map { String($0) }
            removeAndAddChild(nodeNames: keyNames)
            
            delete = (past.childNode(withName: "delete") as? SKSpriteNode)
            delete?.removeFromParent()
            
            self.isUserInteractionEnabled = true
            
            if let typeMachine, let text, let delete {
                self.addChild(typeMachine)
                self.addChild(text)
                self.addChild(delete)
            }
            text?.text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func removeAndAddChild(nodeNames: [String]) {
        for name in nodeNames {
            if let spriteNode = past!.childNode(withName: name) as? SKSpriteNode {
                spriteNode.removeFromParent()
                keyNodes[name] = spriteNode
                self.addChild(spriteNode)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return }
        
        if text?.text != "AION"{
            for (key, spriteNode) in keyNodes {
                if tapped == spriteNode {
                    if delegate?.didZoom == true{
                        spriteNode?.isPaused = false
                        spriteNode?.run(typingSFX)
                        if delegate?.didZoom == true {
                            if text!.text!.count < 4 {
                                text?.text = (text?.text ?? "") + key
                                if text?.text == "AION"{
                                    spriteNode?.isPaused = false
                                    spriteNode?.run(dingSFX)
                                    
                                }
                            } else {
                                spriteNode?.isPaused = false
                                spriteNode?.run(deletingSFX)
                                text?.text = ""
                            }
                        }
                    }
                }
            }
        }else{
            typeMachine?.isPaused = false
            typeMachine?.run(dingSFX)
        }
        switch tapped.name {
        case "delete":
            delete?.run(typingSFX)
            print("deletou")
            if let labelText = text?.text, !labelText.isEmpty {
                text?.text = String(labelText.dropLast())
            }
        case "typeMachine":
            delegate?.zoom(isZoom: true, node: typeMachine, ratio: 0.3)
        default:
            print("default")
        }
    }
}
