//
//  Player.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

import Foundation

// player representation
// name, the player name
// team, the player team
class Player: Equatable {
    var name: String = "NoName"
    var team = Team(team: [])
    
    
    // comparator function
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
    }
}
