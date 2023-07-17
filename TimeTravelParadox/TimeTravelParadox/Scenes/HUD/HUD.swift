import SpriteKit

class HUD: SKNode{
  private let hud = SKScene(fileNamed: "HUDScene")
  private var travel: SKSpriteNode?
  private var qgButton: SKSpriteNode?
  
  func hideQGButton(isHide: Bool){
    qgButton?.isHidden = isHide
  }
  
  override init(){
    super.init()
    if let hud {
      travel = (hud.childNode(withName: "travel") as? SKSpriteNode)
      travel?.removeFromParent()
      qgButton = (hud.childNode(withName: "qgButton") as? SKSpriteNode)
      qgButton?.removeFromParent()
      //            self.isUserInteractionEnabled = true
    }
    if let travel, let qgButton {
      self.addChild(travel)
      self.addChild(qgButton)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
}
