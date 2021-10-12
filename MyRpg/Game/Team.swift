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
    let characters: [Character]
    
    init(team characters: [Character]){
        self.characters = characters
    }
}
