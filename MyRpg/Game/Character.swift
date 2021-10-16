//
//  Character.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

import Foundation

// Classe qui représente un personage avec un nombre de pv.
// Un nombre max de pv pour éviter l'over heal
// un nom (par défaut "NoName"), une arme aléatoire et
// un attribut isDead pour savoir si le personnage est mort
class Character {
    var healthPoint: Int
    private let maxHealthPoint: Int
    var name = "NoName"
    var weapon: Weapon
    var isDeadDisplayable: String {
        if isDead {
            return "Oui"
        }else {
            return "Non"
        }
    }
    var isDead: Bool {
        healthPoint <= 0
    }
    var isHealerDisplayable: String {
        if isHealer {
            return "Oui"
        }else{
            return "Non"
        }
    }
    var isHealer: Bool {
        weapon.type == WeaponType.support
    }
    
    // init avec un nom
    // le nombre de pv est aléatoire entre 10 et 20
    // le nombre de pv max est calculé sur la base du nombre de pv
    // et une arme aléatoire
    init(name: String){
        healthPoint = Character.randomHealth()
        self.name = name
        maxHealthPoint = healthPoint
        weapon = Weapon()
    }
    
    // fonction qui permet au personnage de se faire soinger par un autre
    // Le soin est calculé en fonction de la puissance de l'arme du soigneur
    // Si la puissance de l'arme du healer dépasse le nombre max de pv
    // du personnage soigné. Alors celui-ci récupère son nombre de pv
    // max
    func heal(who character: Character) -> Character {
        if character.healthPoint + weapon.power <= character.maxHealthPoint {
            character.healthPoint += weapon.power
        }else{
            character.healthPoint = character.maxHealthPoint
        }
        return character
    }
    
    // fonction qui permet au personnage de se faire attaquer par un autre
    // Les dégats sont calculé en fonction de la puissance de l'arme de l'attaquant
    func attack(who character: Character) -> Character {
        character.healthPoint -= weapon.power
        return character
    }
    
    // fonction qui permet au personnage de rammasser une arme (celle du coffre en l'occurence 
    func grabWeapon(weapon: Weapon){
        self.weapon = weapon
    }
    
    func getByName(forName name: String) -> Character?{
        if self.name == name { return self } else { return nil}
    }
    
    //Privates funcs
    private static func randomHealth() -> Int {
        return Int.random(in: 10..<20)
    }
}
