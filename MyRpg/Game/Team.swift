//
//  Team.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

import Foundation

// Classe qui représente l'équipe d'un joueur.
// Un tableau de personnage
class Team {
    var characters: [Character]
    
    init(team characters: [Character]){
        self.characters = characters
    }
    
    func getTeamMembersName() -> String{
        var resArray = [String]()
        for character in characters {
            resArray.append(character.name)
        }
        return resArray.joined(separator: ", ")
    }
    
    func isDead() -> Bool{
        return characters.allSatisfy { character in
            character.isDead
        }
    }
}
