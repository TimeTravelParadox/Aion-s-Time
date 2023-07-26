//
//  UserDefaultsManager.swift
//  TimeTravelParadox
//
//  Created by Mirelle Sine on 26/07/23.
//

import Foundation

enum UserDefaultsKey: String, CaseIterable {
    case peca1Taken
    case takenPaper
    case takenPolaroid
    case takenCrumpledPaper
    case takenChip
    case hologramComplete1
    case hologramComplete2
    case hologramComplete3
}

class UserDefaultsManager {
    // MARK: - Singleton Pattern
    
    static let shared = UserDefaultsManager() //tem que ser a unica instancia da classe UserDefaultsManager
    
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
    
    private init() {} // Private initializer to enforce singleton pattern
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard //padrao de inicializacao do userDefaults
    
    // MARK: - Public Methods
    
    func saveValue(_ value: Any, forKey key: String) { //salvar
        userDefaults.set(value, forKey: key)
    }
    
    func getValue(forKey key: String) -> Any? { //acessar o valor
        return userDefaults.object(forKey: key)
    }
    
    func removeValue(forKey key: String) { //remover o valor
        userDefaults.removeObject(forKey: key)
    }
    
    func removeAllValues() {
        UserDefaultsKey.allCases.forEach { userDefaultsKey in
            removeValue(forKey: userDefaultsKey.rawValue)
        }
    }
}
