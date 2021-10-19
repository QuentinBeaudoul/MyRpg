//
//  Weapon.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

import Foundation

// Classe Weapon qui représente l'arme d'un personnage.
// Elle a deux attribus power (qui représente la puissance de l'arme)
// et type (qui représente le type de l'arme. Support, qui peut soigner.
// Dps, qui peut infliger des dégats.
class Weapon {
    let power: Int
    let type: WeaponType
    
    // init avec une puissance aléatoire allant de 1 à 5
    // et un type aléatoire .dps ou .support
    init(){
        power = Weapon.randomPower()
        type = WeaponType.getRandomWeaponType()
    }
    
    // retourne un nombre aléatoire entre 1 et 5
    static private func randomPower() -> Int {
        return Int.random(in: 4..<8)
    }
    
}
// enum qui représente tous les types d'arme possible pour une arme
enum WeaponType: CaseIterable {
    case support, dps
    
    // retourne un type d'arme aléatoire
    static func getRandomWeaponType() -> WeaponType {
        return WeaponType.allCases.randomElement() ?? .dps
    }
}
