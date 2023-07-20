import SpriteKit

class Future: SKNode{

  private let futureScene = SKScene(fileNamed: "FutureScene")
  private var futureBG: SKSpriteNode?
  
  var computer: Computer?
  var vault: Vault?
  var hologram: Hologram?
  
  let futureST = SKAction.repeatForever(SKAction.playSoundFileNamed("futureST.mp3", waitForCompletion: true))
  
  var delegate: ZoomProtocol?
  
  init(delegate: ZoomProtocol){
    super.init()
    self.delegate = delegate
    self.computer = Computer(delegate: delegate)
    self.vault = Vault(delegate: delegate)
    self.hologram = Hologram(delegate: delegate)
    vault?.setupCofre()
    vault?.zPosition()
    
    if let futureScene, let computer, let vault, let hologram {
      futureBG = (futureScene.childNode(withName: "futureBG") as? SKSpriteNode)
      futureBG?.removeFromParent()
      
      self.isUserInteractionEnabled = true
 
      if let futureBG{
        self.addChild(futureBG)
      }
      
      self.addChild(computer)
      computer.delegate = delegate
      self.addChild(vault)
      vault.delegate = delegate
      self.addChild(hologram)
      hologram.delegate = delegate
      
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
      delegate?.zoom(isZoom: false, node: futureBG, ratio: 0)
      print("futuro plano de fundo")
    default:
      return
    }
  }
  
  
}
