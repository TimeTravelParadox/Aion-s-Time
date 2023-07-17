import SpriteKit

class GameScene: SKScene, ZoomProtocol{
  
  private var past: Past?
  private var future: Future?
  private let hud = HUD()
  private let qg = QG()
  
  let cameraNode = SKCameraNode()
  var cameraPosition = CGPoint(x: 0, y: 0)
  
  var didZoom = false
  
  func setupCamera(){
    cameraNode.position = cameraPosition
    addChild(cameraNode)
    camera = cameraNode
  }
  
  func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat){
    if isZoom {
      self.didZoom = isZoom
      cameraPosition = node?.position ?? cameraNode.position
      cameraNode.position = cameraPosition
      cameraNode.run(SKAction.scale(to: ratio, duration: 0))
    }else{
      self.didZoom = isZoom
      cameraNode.position = node?.position ?? cameraNode.position
      cameraNode.run(SKAction.scale(to: 1, duration: 0))
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
    
    setupCamera()
    
    addChild(hud)
    addChild(qg)
  
    qg.zPosition = 15
    hud.zPosition = 20
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
