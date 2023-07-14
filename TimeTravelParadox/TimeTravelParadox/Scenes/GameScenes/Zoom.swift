import SpriteKit

class Zoom: SKScene{
    let cameraNode = SKCameraNode()
    var cameraPosition = CGPoint(x: 0, y: 0)

    func setupCamera(){
        cameraNode.position = cameraPosition
        addChild(cameraNode)
        camera = cameraNode
    }

    func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat){
            if isZoom{
                cameraPosition = node?.position ?? cameraNode.position
                cameraNode.position = cameraPosition
                cameraNode.run(SKAction.scale(to: ratio, duration: 0))
            }else{
                cameraNode.position = CGPoint(x: (view?.bounds.width ?? 0)/2, y: (view?.bounds.height ?? 0)/2)
                cameraNode.run(SKAction.scale(to: 1, duration: 0))
            }
            cameraNode.isPaused = false
            cameraNode.run(SKAction.scale(to: 0.5, duration: 0))
        }

    override init(){
        super.init()
        self.zPosition = 11
        setupCamera()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}


