//
//  ItemDetail.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 21/07/23.
//

import SpriteKit

class ItemDetail: SKNode {
    
    var item: SKSpriteNode
    //var text: SKSpriteNode
    init(item: SKSpriteNode ,scene: SKScene) {
        self.item = item
        
        // Expandir esse nó para ocupar a tela
        
        super.init()
        
        let node = SKNode()
        node.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        node.addChild(item)
        //node.addChild(text)
        switch item.name{
        case "polaroid":
            item.size = CGSize(width: 100, height: 100)
            item.position = CGPoint(x: 0, y: 0)
        default:
            return
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return } // se nao estiver em toque acaba aqui
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard let tapped = tappedNodes.first else { return } // ter ctz que algo esta sendo tocado
        
//        switch tapped.name{
//        case "polaroid":
//            polaroid?.size = CGSize(width: 100, height: 100)
//            polaroid?.position = CGPoint(x: 0, y: 0)
//        }
    }
    
    func spin(camera: CGPoint) {
        let spinPolaroid = SKAction.rotate(byAngle: .pi, duration: 0.2)
        item.run(spinPolaroid)
        
        
        
        
        
        item.isPaused = false
        //    self.fade1?.run(animateFade1)
        //    self.fade2?.run(animateFade2)
        
    }
    
}

