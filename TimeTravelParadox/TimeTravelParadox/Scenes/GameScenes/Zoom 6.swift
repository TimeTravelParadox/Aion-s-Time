import SpriteKit

protocol ZoomProtocol{
  var didZoom: Bool { get set }
  func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat)
}

protocol removeFromParent{
    func removeClock()
}
