import SpriteKit

class TypeMachine: SKNode {
  let past = SKScene(fileNamed: "PastScene")
  
  private var typeMachine: SKSpriteNode?
  private var text: SKLabelNode?
  private var delete: SKSpriteNode?
  private var paper: SKSpriteNode?
  private var paperComplete: SKSpriteNode?
  private var trail: SKSpriteNode?
    
  private var keyNodes: [String: SKSpriteNode?] = [:]
  let keys = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890^")
  
  let typingSFX = SKAction.playSoundFileNamed("typing.mp3", waitForCompletion: false)
  let deletingSFX = SKAction.playSoundFileNamed("deleting.mp3", waitForCompletion: false)
  let dingSFX = SKAction.playSoundFileNamed("ding.wav", waitForCompletion: false)
  
  var delegate: ZoomProtocol?
  var inventoryItemDelegate: InventoryItemDelegate?
  
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
      trail = (past.childNode(withName: "trail") as? SKSpriteNode)
      trail?.removeFromParent()
      paper = (past.childNode(withName: "paper") as? SKSpriteNode)
      paper?.removeFromParent()
      paperComplete = (past.childNode(withName: "paperComplete") as? SKSpriteNode)
      paperComplete?.removeFromParent()
      
      
      self.isUserInteractionEnabled = true
      
      if let typeMachine, let text, let delete, let trail, let paper, let paperComplete {
        self.addChild(typeMachine)
        self.addChild(text)
        self.addChild(delete)
        self.addChild(trail)
        self.addChild(paper)
        self.addChild(paperComplete)
      }
      text?.text = ""
      text?.fontName = "SpecialElite-Regular"
      text?.fontSize = 30 // Defina o tamanho da fonte desejado
      text?.setScale(0.1) // Dimensione o nó
      
      paperComplete?.isHidden = true
    }
      if UserDefaultsManager.shared.takenPaper == true {
          paper?.isHidden = true
          paperComplete?.isHidden = false
          text?.isHidden = true
          HUD.addOnInv(node: paperComplete)
          paperComplete?.zPosition = 15
          paperComplete?.size = CGSize(width: 30, height: 30)
          CasesPositions(node: paperComplete)
          paperComplete?.isPaused = false
          if let paperComplete {
              inventoryItemDelegate?.select(node: paperComplete)
          }
          
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
    
    if text?.text != "AION" {
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
                  paper?.isHidden = true
                  paperComplete?.isHidden = false
                  text?.isHidden = true
                    UserDefaultsManager.shared.takenPaper = true
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
    }
    switch tapped.name {
    case "paperComplete":
      HUD.addOnInv(node: paperComplete)
      if let paperComplete, HUD.shared.inventario.contains(where: { $0.name == "paperComplete" }) {
        inventoryItemDelegate?.select(node: paperComplete)
      }
      return
    case "delete":
      delete?.run(typingSFX)
      print("deletou")
      if let labelText = text?.text, !labelText.isEmpty {
        text?.text = String(labelText.dropLast())
      }
    case "typeMachine":
<<<<<<< Updated upstream
      delegate?.zoom(isZoom: true, node: typeMachine, ratio: 0.14)
    default:
      delegate?.zoom(isZoom: true, node: typeMachine, ratio: 0.14)
=======
      delegate?.zoom(isZoom: true, node: typeMachine, ratio: 0.15)
    default:
      delegate?.zoom(isZoom: true, node: typeMachine, ratio: 0.15)
>>>>>>> Stashed changes
      print("default")
    }
    
    inventoryItemDelegate?.clearItemDetail()
  }
}
