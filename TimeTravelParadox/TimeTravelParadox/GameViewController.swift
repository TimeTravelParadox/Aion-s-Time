//
//  GameViewController.swift
//  TimeTravelParadox
//
//  Created by Victor Hugo Pacheco Araujo on 10/07/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    // Esta função é chamada quando a view do controlador é carregada na memória.
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Carrega a cena de 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Define o modo de escala da cena para preencher a tela
                scene.scaleMode = .aspectFill
                
                // Verifica se a cena é do tipo GameScene e, se for, armazena-a em GameScene.shared
                if let gameScene = scene as? GameScene {
                    GameScene.shared = gameScene
                }
                
                // Apresenta a cena na view
                view.presentScene(scene)
            }
            
            // Define se a ordem de renderização dos nós na view deve ser ignorada.
            view.ignoresSiblingOrder = true
        }
    }
    
    // Define as orientações de interface suportadas pelo controlador do jogo.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    // Define se a barra de status (status bar) está oculta.
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
