//
//  UserDefaultsManager.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 26/07/23.
//

import Foundation


// Define uma enumeração para representar as diferentes chaves do UserDefaults.
enum UserDefaultsKey: String, CaseIterable {
    case peca1Taken
    case takenPaper
    case takenPolaroid
    case takenCrumpledPaper
    case takenChip
    case hologramComplete1
    case hologramComplete2
    case hologramComplete3
    case initializedQG
    case theEND
}

class UserDefaultsManager {
    // MARK: - Singleton Pattern
    
    // Instância única da classe UserDefaultsManager usando o padrão Singleton.
    static let shared = UserDefaultsManager()
    
    
    var peca1Taken: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.peca1Taken.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.peca1Taken.rawValue)
        }
    }
    
    var takenPaper: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.takenPaper.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.takenPaper.rawValue)
        }
    }
    
    var takenPolaroid: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.takenPolaroid.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.takenPolaroid.rawValue)
        }
    }
    
    var takenCrumpledPaper: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.takenCrumpledPaper.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.takenCrumpledPaper.rawValue)
        }
    }
    
    var takenChip: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.takenChip.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.takenChip.rawValue)
        }
    }
    
    var hologramComplete1: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.hologramComplete1.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.hologramComplete1.rawValue)
        }
    }
    
    var hologramComplete2: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.hologramComplete2.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.hologramComplete2.rawValue)
        }
    }
    
    var hologramComplete3: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.hologramComplete3.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.hologramComplete3.rawValue)
        }
    }
    
    var initializedQG: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.initializedQG.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.initializedQG.rawValue)
        }
    }
    
    var theEnd: Bool {
        get {
            //o `as` checa se é um bool e se o valor existe
            return getValue(forKey: UserDefaultsKey.theEND.rawValue) as? Bool ?? false
        }
        set {
            saveValue(newValue, forKey: UserDefaultsKey.theEND.rawValue)
        }
    }
    
    // Construtor privado para garantir que não possam ser criadas outras instâncias.
    private init() {}
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard //padrao de inicializacao do userDefaults
    
    // MARK: - Public Methods
    
    /// Função para salvar um novo valor na chave especificada.
    func saveValue(_ value: Any, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    /// Função para obter o valor armazenado na chave especificada.
    func getValue(forKey key: String) -> Any? {
        return userDefaults.object(forKey: key)
    }
    
    /// Função para remover o valor associado à chave especificada.
    func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    /// Função para remover todos os valores armazenados nas chaves enumeradas.
    func removeAllValues() {
        UserDefaultsKey.allCases.forEach { userDefaultsKey in
            removeValue(forKey: userDefaultsKey.rawValue)
        }
    }
}
