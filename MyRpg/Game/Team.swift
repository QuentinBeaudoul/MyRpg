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
    
    var charactersNames: [String] {
        return extractAliveCharactersNamesFromArray(array: characters)
    }
    
    init(team characters: [Character]){
        self.characters = characters
    }
    
    private func extractAliveCharactersNamesFromArray(array: [Character]) -> [String] {
        var resArray = [String]()
        for character in array {
            if !character.isDead {
                resArray.append(character.name)
            }
        }
        return resArray
    }
    
    private func getTeamMembersName() -> String{
        return charactersNames.joined(separator: ", ")
    }
    private func getTeamHealersName() -> String {
        let filtredTeam = characters.filter { character in
            character.isHealer
        }
        var healersNames = [String]()
        for healer in filtredTeam {
            healersNames.append(healer.name)
        }
        return healersNames.joined(separator: ", ")
    }
    
    func getTeamMembers(forAction action: Action) -> String {
        switch action {
        case .attack:
            return getTeamMembersName()
        case .heal:
            return getTeamHealersName()
        }
    }
    func getTeamMembers(forAction action: Action) -> [Character] {
        switch action {
        case .attack:
            return characters
        case .heal:
            return characters.filter { character in
                character.isHealer
            }
        }
    }
    func getAllTeamMembers() -> String {
        return charactersNames.joined(separator: ", ")
    }
    
    func containsHealer() -> Bool {
        return characters.contains { character in
            character.isHealer && !character.isDead
        }
    }
    
    func getSelectedCharacter(byName name: String) -> Character? {
        for character in characters {
            if let chosenOne = character.getByName(forName: name) {
                return chosenOne
            }
        }
        return nil
    }
    
    func areAllDead() -> Bool{
        return characters.allSatisfy { character in
            character.isDead
        }
    }
}
