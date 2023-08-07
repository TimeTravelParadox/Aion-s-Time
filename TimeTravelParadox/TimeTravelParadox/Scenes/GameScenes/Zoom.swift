import SpriteKit

/// Protocolo para fornecer funcionalidade de zoom.
protocol ZoomProtocol {
    /// Propriedade que indica se o zoom está ativo ou não.
    var didZoom: Bool { get set }
    
    /// Função para aplicar o efeito de zoom em um nó (node) da cena.
    ///
    /// - Parameters:
    ///   - isZoom: Indica se o zoom está ativo (true) ou inativo (false).
    ///   - node: O nó (node) da cena no qual o zoom será aplicado.
    ///   - ratio: A proporção do zoom a ser aplicado.
    func zoom(isZoom: Bool, node: SKSpriteNode?, ratio: CGFloat)
}

/// Protocolo para remoção de uma peça (item).
protocol RemoveProtocol {
    /// Função para remover uma peça (item).
    func removePeca()
}

/// Protocolo para remoção de outra peça (item).
protocol RemoveProtocol2 {
    /// Função para remover outra peça (item).
    func removePeca()
}

/// Protocolo para habilitar/desabilitar viagem (travel).
protocol ToggleTravel {
    /// Função para desativar a viagem (travel).
    func desativarTravel()
    
    /// Função para ativar a viagem (travel).
    func ativarTravel()
}

/// Protocolo para chamar diálogo (dialogue).
protocol CallDialogue {
    /// Função para chamar diálogo (dialogue).
    ///
    /// - Parameters:
    ///   - node: O nó (node) da cena relacionado ao diálogo.
    ///   - texture: A textura (imagem) a ser usada no diálogo.
    ///   - ratio: A proporção do diálogo.
    ///   - isHidden: Indica se o diálogo está oculto (true) ou visível (false).
    func dialogue(node: SKSpriteNode?, text: String, ratio: CGFloat, isHidden: Bool)
}

/// Função para definir a posição de cada nó (node) do inventário na cena.
///
/// - Parameter node: O nó (node) para o qual a posição será definida.
func CasesPositions(node: SKSpriteNode?) {
    for (index, item) in HUD.shared.inventario.enumerated() {
        let maior = max(item.size.width, item.size.height)
        let widthMaior = maior == item.size.width ? true : false
        if widthMaior {
            item.size = CGSize(width: 25, height: (25 * item.size.height) / item.size.width)
        } else {
            item.size = CGSize(width: (25 * item.size.width) / item.size.height, height: 25)
        }
        switch index {
        case 0:
            node?.position = CGPoint(x: -94, y: -128.5)
        case 1:
            node?.position = CGPoint(x: -47, y: -128.5)
        case 2:
            node?.position = CGPoint(x: 0, y: -128.5)
        case 3:
            node?.position = CGPoint(x: 47, y: -128.5)
        case 4:
            node?.position = CGPoint(x: 94, y: -128.5)
        default:
            return
        }
    }
}

