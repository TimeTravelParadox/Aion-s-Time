//
//  Buttons.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 18/07/23.
//

import SpriteKit

// Classe para criar um botão com a aparência de um nó de imagem (SKSpriteNode) e um nó de rótulo (SKLabelNode) e associar uma ação a ele.
class SKButtonNodeLabel: SKNode {
  
  var imagem: SKSpriteNode?
  var label: SKLabelNode?
  var action: (() -> Void)?
  
  // Inicializador que recebe a imagem, o rótulo e a ação do botão.
  init(imagem: SKSpriteNode, label: SKLabelNode, action: @escaping () -> Void) {
    self.imagem = imagem
    self.label = label
    self.action = action
    super.init()
    
    // Habilita a interação do nó para que os toques sejam detectados.
    self.isUserInteractionEnabled = true
    
    // Adiciona a imagem e o rótulo como nós filhos.
    self.addChild(imagem)
    self.addChild(label)
  }
  
  required init?(coder Decoder: NSCoder) {
    super.init(coder: Decoder)
  }
  
  // Função que é chamada quando o usuário toca no botão.
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Executa a ação associada ao botão, se existir.
    self.action?()
  }
}
