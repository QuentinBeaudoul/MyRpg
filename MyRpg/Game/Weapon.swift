//
//  Weapon.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

import Foundation

// character weapon representation
// init with two params
// power: weapon power
// type: weapon type (dps or support)
class Weapon {
    let power: Int
    let type: WeaponType
    
    init(){
        power = Weapon.randomPower()
        type = WeaponType.getRandomWeaponType()
    }
    
    // return a random number between 4 and 8
    // used to generate a random weapon power
    static private func randomPower() -> Int {
        return Int.random(in: 4..<8)
    }
    
}
// weapon type representation
enum WeaponType: CaseIterable {
    case support, dps
    
    // return a random weapon type
    // used to init a Weapon
    static func getRandomWeaponType() -> WeaponType {
        return WeaponType.allCases.randomElement() ?? .dps
    }
}
