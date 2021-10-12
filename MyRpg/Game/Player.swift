//
//  Player.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

import Foundation

// Classe qui représente le joueur (joueur 1 ou 2)
// composé de deux attributs name et Team (optionnel)
// team représente l'équipe du joueur.
class Player {
    let name: String
    var team: Team?
    
    init(playerName name: String){
        self.name = name
    }
}