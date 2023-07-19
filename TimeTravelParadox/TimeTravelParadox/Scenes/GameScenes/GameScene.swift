import SpriteKit

class GameScene: SKScene, ZoomProtocol{
  
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
  }
  
  func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat){
    if isZoom {
      self.didZoom = isZoom
      self.cameraPosition = node?.position ?? self.cameraNode.position
      self.cameraNode.position = self.cameraPosition
      self.cameraNode.run(SKAction.scale(to: ratio, duration: 0))
      fade?.fade(camera: cameraNode.position)
    } else {
      self.didZoom = isZoom
      self.cameraNode.position = node?.position ?? self.cameraNode.position
      self.cameraNode.run(SKAction.scale(to: 1, duration: 0))
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
