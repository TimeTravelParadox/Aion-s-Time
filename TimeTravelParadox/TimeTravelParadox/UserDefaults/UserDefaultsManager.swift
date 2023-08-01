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
    
    //tem que ser a unica instancia da classe UserDefaultsManager
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
    
    private init() {}
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard //padrao de inicializacao do userDefaults
    
    // MARK: - Public Methods
    
    //função de salvar um novo valor na chave
    func saveValue(_ value: Any, forKey key: String) { //salvar
        userDefaults.set(value, forKey: key)
    }
    
    //função de pegar o valor armazenado na chave
    func getValue(forKey key: String) -> Any? { //acessar o valor
        return userDefaults.object(forKey: key)
    }
    
    //função de remover o valor
    func removeValue(forKey key: String) { //remover o valor
        userDefaults.removeObject(forKey: key)
    }
    
    //função de setar todos os valores 
    func removeAllValues() {
        UserDefaultsKey.allCases.forEach { userDefaultsKey in
            removeValue(forKey: userDefaultsKey.rawValue)
        }
    }
}
