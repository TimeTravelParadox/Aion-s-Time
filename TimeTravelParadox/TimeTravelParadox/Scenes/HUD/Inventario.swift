////
////  Inventario.swift
////  TimeTravelParadox
////
////  Created by Victor Hugo Pacheco Araujo on 18/07/23.
////
//
//import SpriteKit
//
//class Inventario: SKNode {
//  let hud = SKScene(fileNamed: "HUDScene")
//
//  var delegate: ZoomProtocol?
//
//  private var inventarioHUD: SKSpriteNode?
//  private var inventario: [SKSpriteNode] = []
//  var isSelected : Bool = false
//  var itemSelecionado : SKSpriteNode?
//
//  init(delegate: ZoomProtocol) {
//    super.init()
//    self.delegate = delegate
//    self.zPosition = 1
//
//    if let hud {
//      inventarioHUD = hud.childNode(withName: "inventarioHUD") as? SKSpriteNode
//      inventarioHUD?.removeFromParent()
//
//      //self.isUserInteractionEnabled = true
//    }
//
//    if let inventarioHUD {
//      self.addChild(inventarioHUD)
//    }
//
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  func adicionarNoInv(item: SKSpriteNode, acao: SKAction) {
//
//    item.removeFromParent()
//
//    let button = SKButtonNodeImg(imagem: item) {
//
//      item.run(acao)
//      if let itemSelecionado = self.itemSelecionado {
//        self.removeBorder(from: itemSelecionado)
//      }
//
//      self.addBorder(to: item)
//      self.itemSelecionado = item
//      self.isSelected = true
//
//    }
//
//    item.size = CGSize(width: 20, height: 20)
//
//    switch inventario.count {
//    case 0:
//      item.position = CGPoint(x: 60, y: 160)
//    case 1:
//      item.position = CGPoint(x: 110, y: 160)
//    case 2:
//      item.position = CGPoint(x: 160, y: 160)
//    case 3:
//      item.position = CGPoint(x: 210, y: 160)
//    case 4:
//      item.position = CGPoint(x: 260, y: 160)
//    default:
//      return
//    }
//
//    addChild(button)
//    inventario.append(item)
//
//  }
//
//  func addBorder(to node: SKSpriteNode) {
//    // Calcula o retângulo da borda com base no tamanho do sprite node
//    let borderRect = CGRect(x: -node.size.width/2, y: -node.size.height/2,
//                            width: node.size.width, height: node.size.height)
//
//    // Cria um shape node com a forma de um retângulo
//    let borderNode = SKShapeNode(rect: borderRect)
//
//    // Define as propriedades da borda
//    borderNode.strokeColor = .white
//    if delegate?.didZoom == true{
//      borderNode.lineWidth = 1
//    }else{
//      borderNode.lineWidth = 2
//    }
//    // Adiciona o shape node à cena
//    node.addChild(borderNode)
//  }
//
//  func removeBorder(from node: SKSpriteNode) {
//    // Percorre os nós filhos do sprite node
//    for childNode in node.children {
//      // Verifica se o nó filho é um shape node
//      if let shapeNode = childNode as? SKShapeNode {
//        // Remove o shape node da cena
//        shapeNode.removeFromParent()
//      }
//    }
//  }
//
//}
