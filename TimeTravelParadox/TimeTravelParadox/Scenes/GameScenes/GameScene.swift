import SpriteKit
import AVFoundation
import UIKit

// MARK: - GameScene

/// Classe responsável por gerenciar a cena principal do jogo.
class GameScene: SKScene, ZoomProtocol, CallDialogue{
    
    //MARK: PROPERTIES
    // Referência compartilhada à cena do jogo.
    static var shared = GameScene()
    
    // Referência às classes de outras cenas
    var past: Past?
    var future: Future?
    let hud = HUD()
    var qg: QG?
    var fade: Fade?
    var creditos = Creditos()
    
    //haptics
    let simpleFeedbackGenerator = UINotificationFeedbackGenerator()

    
    //Delegate
    var itemDetail: ItemDetail?
    
    // Variável de estado
    var isTravelingSFXPlaying = false
    var isBackToQGSFXPlaying = false
    var zooming = true
    var didZoom = false
    
    // Variáveis responsável pelo controle das músicas
    var audioPlayerPastST: AVAudioPlayer?
    var audioPlayerQGST: AVAudioPlayer?
    var audioPlayerFutureST: AVAudioPlayer?
    
    // Referencias dos nodes
    private var dialogue: SKSpriteNode?
    var textDialogue: SKLabelNode?
    var invisible: SKSpriteNode?
    let cameraNode = SKCameraNode()
    
    /// Váriáveis responsáveis pela SKAction que reproduz os sons de SPRITEKIT
    let zoomSound = SKAction.playSoundFileNamed("zoomSound", waitForCompletion: false)
    let travelingSFX = SKAction.playSoundFileNamed("traveling.mp3", waitForCompletion: true)
    let backToQGSFX = SKAction.playSoundFileNamed("backToQG.mp3", waitForCompletion: true)
    
    /// Variável resposável pela posição da camera
    var cameraPosition = CGPoint(x: 0, y: 0)
    
    // armazena um cgfloat
    var ratio: CGFloat = 1
    
    /// Método para configurar a câmera da cena.
    func setupCamera() {
        // Configura a câmera como um nó da cena
        addChild(cameraNode)
        camera = cameraNode
        GameScene.shared.camera = camera
    }
    
    // Função para reposicionar o inventário
    func positionNodeRelativeToCamera(_ node: SKSpriteNode, offsetX: CGFloat, offsetY: CGFloat) {
        if let camera = camera {
            let cameraPositionInScene = convert(camera.position, to: self)
            let newPosition = CGPoint(x: cameraPositionInScene.x + offsetX, y: cameraPositionInScene.y + offsetY)
            node.position = newPosition
        }
    }
    
    /// Método para posicionar um nó em relação à posição da câmera.
    /// - Parameters:
    ///   - node: O nó que será posicionado em relação à câmera.
    ///   - offsetX: Deslocamento horizontal em relação à posição da câmera.
    ///   - offsetY: Deslocamento vertical em relação à posição da câmera.
    ///   - isZoom: Variável de estado responsável para ver se o zoom já foi ativado.
    ///   - ratio: Razão da escala do zoom da camera
    func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat){
        guard didZoom != isZoom else {
            return
        }
        
        // Responsável para esperar o zoom e evitar bug da animação
        if zooming{
            zooming = false // muda o estado da variável
            if isZoom {
                // Deselecionar o item
                if HUD.shared.isSelected {
                    if HUD.shared.itemSelecionado != nil {
                        HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!)
                    }
                }
                self.didZoom = isZoom
                self.cameraPosition = node?.position ?? self.cameraNode.position // posição da camera passa a ser a do node
                self.cameraNode.position = self.cameraPosition
                self.cameraNode.run(SKAction.scale(to: ratio, duration: 0)) // muda a escala da camera de acordo com ratio
                GameScene.shared.cameraPosition = self.cameraNode.position
                GameScene.shared.ratio = ratio
                hud.reposiconarInvIn(ratio: ratio)
                // muda a posição dos itens e inventário de acordo com a escala do zoom
                for (index, item) in HUD.shared.inventario.enumerated() {
                    let maior = max((item.size.width), (item.size.height))
                    let widthMaior = maior == item.size.width ? true : false
                    if widthMaior {
                        item.size = CGSize(width: 25*GameScene.shared.ratio, height: (25*(item.size.height))/(item.size.width)*GameScene.shared.ratio)
                    }else{
                        item.size = CGSize(width: (25*(item.size.width))/(item.size.height)*GameScene.shared.ratio, height: 25*GameScene.shared.ratio)
                    }
                    switch index {
                    case 0:
                        self.positionNodeRelativeToCamera(item, offsetX: -94*ratio, offsetY: -128.5*ratio)
                    case 1:
                        self.positionNodeRelativeToCamera(item, offsetX: -47*ratio, offsetY: -128.5*ratio)
                    case 2:
                        self.positionNodeRelativeToCamera(item, offsetX: 0*ratio, offsetY: -128.5*ratio)
                    case 3:
                        self.positionNodeRelativeToCamera(item, offsetX: 47*ratio, offsetY: -128.5*ratio)
                    case 4:
                        self.positionNodeRelativeToCamera(item, offsetX: 94*ratio, offsetY: -128.5*ratio)
                    default:
                        return
                    }
                }
                // chama nodes responsáveis por simular o efeito de piscada
                fade?.fade(camera: cameraNode.position)
                // despausa o node
                node?.isPaused = false
                node?.run(zoomSound)
                hud.hideTravelQG(isHide: true)
            } else {
                
                // Deselecionar o item
                if HUD.shared.isSelected && HUD.shared.itemSelecionado != nil {
                    HUD.shared.removeBorder(from: HUD.shared.itemSelecionado!)
                }
                self.didZoom = isZoom
                
                self.cameraNode.position = CGPoint(x: 0, y: 0)
                self.cameraNode.run(SKAction.scale(to: 1, duration: 0))
                GameScene.shared.cameraPosition = self.cameraNode.position
                GameScene.shared.ratio = 1
                HUD.shared.inventarioHUD?.size = CGSize(width: 260, height: 50)
                HUD.shared.inventarioHUD?.position = CGPoint(x: 0, y: -135)
                hud.reposiconarInvOut()
                for (index, item) in HUD.shared.inventario.enumerated() {
                    let maior = max((item.size.width), (item.size.height))
                    let widthMaior = maior == item.size.width ? true : false
                    if widthMaior {
                        item.size = CGSize(width: 25, height: (25*(item.size.height))/(item.size.width))
                    }else{
                        item.size = CGSize(width: (25*(item.size.width))/(item.size.height), height: 25)
                    }
                    switch index {
                    case 0:
                        self.positionNodeRelativeToCamera(item, offsetX: -94, offsetY: -128.5)
                    case 1:
                        self.positionNodeRelativeToCamera(item, offsetX: -47, offsetY: -128.5)
                    case 2:
                        self.positionNodeRelativeToCamera(item, offsetX: 0, offsetY: -128.5)
                    case 3:
                        self.positionNodeRelativeToCamera(item, offsetX: 47, offsetY: -128.5)
                    case 4:
                        self.positionNodeRelativeToCamera(item, offsetX: 94, offsetY: -128.5)
                    default:
                        return
                    }
                }
                fade?.fade(camera: cameraNode.position)
                node?.isPaused = false
                node?.run(zoomSound)
                print("zoom out")
                hud.hideTravelQG(isHide: false)
                
            }
            // evitar bug de animação em cima da outra
            self.run(SKAction.wait(forDuration: 0.4)){
                self.zooming = true
            }
        }
    }
    // MARK: - Dialogue Handling

    /// Método para exibir e ocultar diálogos na cena.
    /// - Parameters:
    ///   - node: O nó associado ao diálogo.
    ///   - texture: A textura que será utilizada no diálogo.
    ///   - ratio: A escala que será aplicada ao diálogo.
    ///   - isHidden: Indica se o diálogo será exibido ou ocultado.

    func dialogue(node: SKSpriteNode?, text: String, ratio: CGFloat, isHidden: Bool){
        let callDialogue = !isHidden
        textDialogue?.fontColor = .white
        textDialogue?.fontName = "FiraCode-SemiBold"
        textDialogue?.position = CGPoint(x: (node?.position.x ?? 0) + (-240 * ratio), y: (node?.position.y ?? 0) + (-55*ratio))
        dialogue?.position = node?.position ?? CGPoint(x: 0, y: 0)
        dialogue?.size = CGSize(width: 731.976, height: 132.228)
        dialogue?.size = CGSize(width: (dialogue?.size.width ?? 0) * ratio, height: (dialogue?.size.height ?? 0) * ratio)
//        textDialogue?.position = dialogue?.position ?? CGPoint(x: 0, y: 0)
        textDialogue?.fontSize = 20
        textDialogue?.setScale(ratio)
        textDialogue?.numberOfLines = 2
        textDialogue?.preferredMaxLayoutWidth = ((dialogue?.size.width ?? 0) - 150 * ratio) / ratio
        textDialogue?.lineBreakMode = .byWordWrapping
        textDialogue?.text = NSLocalizedString(text, comment: "")
        dialogue?.texture = SKTexture(imageNamed: "dialogue")
        if callDialogue {
            textDialogue?.isHidden = false
            hud.isHidden = true
            dialogue?.isHidden = false
            if UserDefaultsManager.shared.peca1Taken{
                past?.clock?.peca1?.isHidden = true
            }
            if UserDefaultsManager.shared.takenPolaroid{
                past?.shelf?.polaroid?.isHidden = true
            }
            if UserDefaultsManager.shared.takenChip{
                future?.vault?.peca2?.isHidden = true
            }
            if UserDefaultsManager.shared.takenPaper{
                past?.typeMachine?.paperComplete?.isHidden = true
            }
            if UserDefaultsManager.shared.takenCrumpledPaper{
                past?.paper.crumpledPaper.isHidden = true
            }
            past?.isUserInteractionEnabled = false
            future?.isUserInteractionEnabled = false
            qg?.isUserInteractionEnabled = false
        }else{
            textDialogue?.isHidden = true
            hud.isHidden = false
            dialogue?.isHidden = true
            if UserDefaultsManager.shared.peca1Taken{
                past?.clock?.peca1?.isHidden = false
            }
            if UserDefaultsManager.shared.takenPolaroid{
                past?.shelf?.polaroid?.isHidden = false
            }
            if UserDefaultsManager.shared.takenChip{
                future?.vault?.peca2?.isHidden = false
            }
            if UserDefaultsManager.shared.takenPaper{
                past?.typeMachine?.paperComplete?.isHidden = false
            }
            if UserDefaultsManager.shared.takenCrumpledPaper{
                past?.paper.crumpledPaper.isHidden = false
            }
            past?.isUserInteractionEnabled = true
            future?.isUserInteractionEnabled = true
            qg?.isUserInteractionEnabled = true
        }
    }
    
    var futurePlayingST = false
    
    override func didMove(to view: SKView) {
        dialogue = self.childNode(withName: "dialogue") as? SKSpriteNode
        textDialogue = self.childNode(withName: "text") as? SKLabelNode
        invisible = self.childNode(withName: "invisible") as? SKSpriteNode
        dialogue?.isHidden = true
        textDialogue?.isHidden = true
        textDialogue?.color = .red
        invisible?.isHidden = true
        if invisible?.parent != nil {
            invisible?.removeFromParent()
        }
        
        self.past = Past(delegate: self, delegateDialogue: self)
        if let past {
            addChild(past)
            past.zPosition = 0
        }
        // MARK: referencias das trilhas sonoras
        // trilha sonora do passado
        if let audioURLPastST = Bundle.main.url(forResource: "pastST", withExtension: "mp3") {
            do {
                audioPlayerPastST = try AVAudioPlayer(contentsOf: audioURLPastST)
                audioPlayerPastST?.numberOfLoops = -1 // reproduz em ciclo infinito
                audioPlayerPastST?.volume = 0
                audioPlayerPastST?.prepareToPlay()
            } catch {
                print("Erro ao carregar o arquivo de som A: \(error)")
            }
        }
        //trilha sonora do qg
        if let audioURLQGST = Bundle.main.url(forResource: "QGST", withExtension: "mp3") {
            do {
                audioPlayerQGST = try AVAudioPlayer(contentsOf: audioURLQGST)
                audioPlayerQGST?.numberOfLoops = -1 // reproduz em ciclo infinito
                audioPlayerQGST?.volume = 0
                audioPlayerQGST?.prepareToPlay()
            } catch {
                print("Erro ao carregar o arquivo de som A: \(error)")
            }
        }
        // trilha sonora do futuro
        if let audioURLFutureST = Bundle.main.url(forResource: "futureST", withExtension: "mp3") {
            do {
                audioPlayerFutureST = try AVAudioPlayer(contentsOf: audioURLFutureST)
                audioPlayerFutureST?.numberOfLoops = -1 // reproduz em ciclo infinito
                audioPlayerFutureST?.volume = 0
                audioPlayerFutureST?.prepareToPlay()
            } catch {
                print("Erro ao carregar o arquivo de som A: \(error)")
            }
        }
        //play()
        audioPlayerQGST?.play() // toca a música assim que inicia
        fadeInAudioPlayer(audioPlayerQGST)
        
        self.future = Future(delegate: self, pastScene: past!, delegateDialogue: self)
        if let future {
            addChild(future)
            future.zPosition = 0
        }
        
        self.qg = QG(delegateHUD: hud, delegateDialogue: self)
        if let qg {
            addChild(qg)
            qg.zPosition = 20
        }
        
        
        self.fade = Fade()
        if let fade {
            addChild(fade)
            fade.zPosition = 25
        }
        
        setupCamera()
        
        addChild(hud)
        addChild(creditos)
        if let invisible {
            addChild(invisible)
        }
        
        hud.zPosition = 14
        hud.fundoBotaoViajar?.zPosition = 12
        hud.travel?.zPosition = 13
        hud.fadeHUD?.isHidden = true
        creditos.zPosition = 0
        hud.hideQGButton(isHide: true)
        hud.hideResetButton(isHide: true)
        
        
        if UserDefaultsManager.shared.theEnd == true {
            
            
            creditos.zPosition = 21
            creditos.setScale(0.9)
            past?.zPosition = 0
            qg?.zPosition = 0
            future?.zPosition = 0
            hud.hideFundoBotaoViajar(isHide: true)
            hud.fundoBotaoViajar?.zPosition = 1
            hud.hideResetButton(isHide: false)
            hud.fadeHUD?.isHidden = true
            hud.hideQGButton(isHide: true)
            hud.hideTravelQG(isHide: true)
            audioPlayerQGST?.pause()
            audioPlayerPastST?.pause()
            audioPlayerFutureST?.pause()
            past?.light?.isHidden = true
            
            
        }
        
    }
    
    // MARK: - Touch Handling

    /// Método chamado quando ocorre um toque na tela.
    /// - Parameters:
    ///   - touches: Conjunto de objetos `UITouch` representando os toques na tela.
    ///   - event: Objeto `UIEvent` contendo informações sobre o evento de toque.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Verifica se há pelo menos um toque registrado na tela
        guard let touch = touches.first else { return }

        // Obtem a posição do toque na cena
        let location = touch.location(in: self)

        // Obtem os nós tocados na posição atual
        let tappedNodes = nodes(at: location)

        // Verifica se há algum nó tocado
        guard let tapped = tappedNodes.first else { return }
        switch tapped.name {
        case "dialogue", "text":
            // lógica responsável pelos dialogos e passar de um dialogo para o outro
            if qg?.dialogueStep == 1 || qg?.dialogueStep == 2{
                if qg?.dialogueStep == 1{
                    dialogue(node: qg?.QGBG, text:"dialogueQG02", ratio: 1, isHidden: false)
                    qg?.dialogueStep = 2
                }else {
                    dialogue(node: qg?.QGBG, text:"dialogueQG03", ratio: 1, isHidden: false)
                    qg?.dialogueStep = 3
                    run(SKAction.wait(forDuration: 2.5)){
                        self.qg?.display?.removeAllActions()
                        self.qg?.display?.removeAllActions()
                        self.qg?.display?.texture = SKTexture(imageNamed: "display27")
                      
                      self.qg?.novaMissao?.position = CGPoint(x: -27.5, y: 25)
                      self.qg?.novaMissao?.text = NSLocalizedString("viagemDisponivel", comment: "")
                      self.qg?.novaMissao?.fontColor = .green
                      self.qg?.novaMissao?.fontSize = 15
                      self.qg?.novaMissao?.fontName = "FiraCode-SemiBold"
                      
                        self.hud.ativarTravel()
                        UserDefaultsManager.shared.initializedQG = true
                    }
                    
                }
            } else if past?.shelf?.dialogueStep == 1{
                dialogue(node: past?.shelf?.shelf, text: "dialoguePolaroid02", ratio: 0.5, isHidden: false)
                past?.shelf?.dialogueStep = 2
                
            } else if future?.hologram?.dialogueStep == 1 || future?.hologram?.dialogueStep == 2 || future?.hologram?.dialogueStep == 3{
                if future?.hologram?.dialogueStep == 1{
                    dialogue(node: future?.hologram?.monitorDireita, text: "dialogueHologram02", ratio: 0.3, isHidden: false)
                    future?.hologram?.dialogueStep = 2
                }else if future?.hologram?.dialogueStep == 2{
                    dialogue(node: future?.hologram?.monitorDireita, text: "dialogueHologram03", ratio: 0.3, isHidden: false)
                    future?.hologram?.dialogueStep = 3
                }else if future?.hologram?.dialogueStep == 3{
                    
                    hud.isHidden = false
                    dialogue?.isHidden = true
                  textDialogue?.isHidden = true
                    zoom(isZoom: false, node: future?.hologram?.monitorDireita, ratio: 0)
                    creditos.zPosition = 21
                    creditos.setScale(0.9)
                    past?.zPosition = 0
                    qg?.zPosition = 0
                    future?.zPosition = 0
                    hud.hideQGButton(isHide: true)
                    hud.hideTravelQG(isHide: true)
                    audioPlayerQGST?.pause()
                    audioPlayerPastST?.pause()
                    audioPlayerFutureST?.pause()
                    past?.light?.isHidden = true
                    
                    hud.hideResetButton(isHide: false)
                    future?.hologram?.dialogueStep = 4
                }
            }
            else{
                dialogue?.isHidden = true
              textDialogue?.isHidden = true
                past?.isUserInteractionEnabled = true
                qg?.isUserInteractionEnabled = true
                future?.isUserInteractionEnabled = true
                hud.isHidden = false
                
                if UserDefaultsManager.shared.peca1Taken{
                    past?.clock?.peca1?.isHidden = false
                }
                if UserDefaultsManager.shared.takenPolaroid{
                    past?.shelf?.polaroid?.isHidden = false
                }
                if UserDefaultsManager.shared.takenChip{
                    future?.vault?.peca2?.isHidden = false
                }
                if UserDefaultsManager.shared.takenPaper{
                    past?.typeMachine?.paperComplete?.isHidden = false
                }
                if UserDefaultsManager.shared.takenCrumpledPaper{
                    past?.paper.crumpledPaper.isHidden = false
                }
                
                
                
            }
            
        case "reset", "resetLabel":
            
            UserDefaultsManager.shared.removeAllValues()
            let cenaReset = SKScene(fileNamed: "GameScene")
            cenaReset?.scaleMode = .aspectFill
            if let gameScene = cenaReset as? GameScene {
                GameScene.shared = gameScene
            }
            HUD.shared = HUD()
            self.audioPlayerFutureST?.pause()
            self.audioPlayerQGST?.pause()
            self.audioPlayerPastST?.pause()
            self.view?.presentScene(cenaReset)
            
        case "qgButton":
            simpleFeedbackGenerator.notificationOccurred(.success) // Novamente, você pode usar .error, .warning, .success

            hud.qgButton?.alpha = 0.5
            self.run(SKAction.wait(forDuration: 0.2)){
                self.hud.qgButton?.alpha = 1
            }
            
            if isBackToQGSFXPlaying{
                return
            }
            scene?.run(backToQGSFX)
            invisible?.isHidden = false
            scene?.run(SKAction.wait(forDuration: 1.9)){
                
                self.hud.hideResetButton(isHide: true)
                self.invisible?.isHidden = true
                self.qg?.zPosition = 20
                self.past?.zPosition = 0
                self.future?.zPosition = 0
                self.hud.hideQGButton(isHide: true)
                self.fadeInAudioPlayer(self.audioPlayerQGST)
                self.audioPlayerQGST?.play()
                self.audioPlayerPastST?.pause()
                self.audioPlayerFutureST?.pause()
                self.past?.light?.isHidden = true
                
                self.hud.hideFundoBotaoViajar(isHide: false)
                
                self.hud.fadeHUD?.isHidden = true
                
            }
            isBackToQGSFXPlaying = false
        case "travel", "fundoBotaoViajar":
            simpleFeedbackGenerator.notificationOccurred(.success) // Novamente, você pode usar .error, .warning, .success

            hud.travel?.alpha = 0.5
            self.run(SKAction.wait(forDuration: 0.2)){
                self.hud.travel?.alpha = 1
            }
            if isTravelingSFXPlaying {
                return
            }
            
            // marca o estado do som tocando
            isTravelingSFXPlaying = true
            
            scene?.run(travelingSFX)
            invisible?.isHidden = false
            scene?.run(SKAction.wait(forDuration: 1.35)) {
                if self.past?.zPosition ?? 0 > 0  {
                    
                    self.hud.hideResetButton(isHide: true)
                    self.invisible?.isHidden = true
                    self.past?.zPosition = 0
                    self.qg?.zPosition = 0
                    self.future?.zPosition = 10
                    self.hud.hideQGButton(isHide: false)
                    self.audioPlayerQGST?.pause()
                    self.audioPlayerPastST?.pause()
                    self.fadeInAudioPlayer(self.audioPlayerFutureST)
                    self.audioPlayerFutureST?.play() //play()
                    self.past?.light?.isHidden = true
                    
                    self.hud.fadeHUD?.isHidden = false
                    self.hud.hideFundoBotaoViajar(isHide: true)
                    
                } else {
                    
                    self.hud.hideResetButton(isHide: true)
                    self.invisible?.isHidden = true
                    self.qg?.zPosition = 0
                    self.future?.zPosition = 0
                    self.past?.zPosition = 10
                    self.hud.hideQGButton(isHide: false)
                    self.audioPlayerQGST?.pause()
                    self.fadeInAudioPlayer(self.audioPlayerPastST)
                    self.audioPlayerPastST?.play() //play()
                    self.audioPlayerFutureST?.pause()
                    self.past?.light?.isHidden = false
                    
                    self.hud.fadeHUD?.isHidden = false
                    
                    self.hud.hideFundoBotaoViajar(isHide: true)
                    
                }
                
                // marca som finalizado
                self.isTravelingSFXPlaying = false
            }
            
        default:
            return
        }
    }
    // MARK: - Sound Management

    /// Método para aplicar fade-in no áudio.
    /// - Parameters:
    ///   - audioPlayer: O player de áudio que será aplicado o efeito de fade-in.

    func fadeInAudioPlayer(_ audioPlayer: AVAudioPlayer?) {
        let fadeDuration: TimeInterval = 10.0
        let fadeSteps: Int = 1000
        let fadeStepDuration: TimeInterval = fadeDuration / TimeInterval(fadeSteps)
        let maxVolume: Float = 0.2 // voluke final
        
        // inicia o fade in
        DispatchQueue.global(qos: .userInteractive).async {
            for step in 0...fadeSteps {
                // Calcule o novo volume com base na etapa atual do fade-in
                let volume = Float(step) / Float(fadeSteps) * maxVolume
                
                // Atualize o volume do áudio no thread principal
                DispatchQueue.main.async {
                    audioPlayer?.volume = volume
                }
                
                // Espere o próximo passo do fade-in
                Thread.sleep(forTimeInterval: fadeStepDuration)
            }
        }
    }
}
