//
//  Character.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

import Foundation

// Character representation
// healthPoint: The current health points of a character
// maxHealthPoint: The max health points than the character can have
// name: character name
// weapon: the character weapon
class Character {
    var healthPoint: Int
    private let maxHealthPoint: Int
    var name = "NoName"
    var weapon: Weapon
    
    // a computed propery which retrun the string "Oui" if isDead is true, "Non" otherwise.
    // used to display character infos in the user interface
    var isDeadDisplayable: String {
        if isDead {
            return "Oui"
        }else {
            return "Non"
        }
    }
    
    // return true if the character health points are above 0
    var isDead: Bool {
        healthPoint <= 0
    }
    
    //return the "Oui" string if the caracter is a healer. "Non" otherwise
    // used to display character infos in the user interface
    var isHealerDisplayable: String {
        return isHealer ? "Oui" : "Non"
    }
    
    // return true if the weapon type is equal to ".support" which mean the character is able to heal.
    var isHealer: Bool {
        weapon.type == WeaponType.support
    }
    
    // character init method
    // custom character name in parameter
    // a random health points
    // a random Weapon
    // the max health is set here
    init(name: String){
        healthPoint = Character.randomHealth()
        self.name = name
        maxHealthPoint = healthPoint
        weapon = Weapon()
    }
    
    // action to heal another character
    // heal the character in parameter an amount equal to the power of the healer weapon
    // set character health to maxhealth if the current healt + weapon power are above the character maxhealth
    func heal(who character: Character){
        if character.healthPoint + weapon.power <= character.maxHealthPoint {
            character.healthPoint += weapon.power
        }else{
            character.healthPoint = character.maxHealthPoint
        }
    }
    
    // action to attack another character depending of the attacker weapon power.
    // if health points are below 0 after the attack. healthpoints is set to 0
    // displayablility question
    func attack(who character: Character) {
        character.healthPoint -= weapon.power
        if character.healthPoint < 0 {
            character.healthPoint = 0
        }
    }
    
    // action for a character to grab the weapon in parameter
    func grabWeapon(weapon: Weapon){
        self.weapon = weapon
    }
    
    // return the current character if it name fit to the name in parameter
    func getByName(forName name: String) -> Character?{
        if self.name == name { return self } else { return nil}
    }
    
    //Privates funcs
    // return a random int between 10 and 20
    // used to set caracters healthpoints
    private static func randomHealth() -> Int {
        return Int.random(in: 10..<20)
    }
}
