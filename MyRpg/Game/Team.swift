//
//  Team.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

import Foundation

// player team representation
// characters array representing the characters team
class Team {
    var characters: [Character]
    
    // computed property used to display alive team members name in ui
    var charactersNames: [String] {
        return extractAliveCharactersNamesFromArray()
    }
    
    init(team characters: [Character]){
        self.characters = characters
    }
    
    // return a string array representing alive team members name
    private func extractAliveCharactersNamesFromArray() -> [String] {
        var resArray = [String]()
        for character in characters {
            if !character.isDead {
                resArray.append(character.name)
            }
        }
        return resArray
    }
    
    // return a string representing all alive members separate by ","
    // used in ui
    private func getTeamMembersName() -> String{
        return charactersNames.joined(separator: ", ")
    }
    
    // return a string representing all healers name in the team
    // used in ui
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
    
    // return concatened string of team names depending of the action
    // if action is .attack the method return all members able to attack
    // if action is .heal the method return all members able to heal
    func getTeamMembers(forAction action: Action) -> String {
        switch action {
        case .attack:
            return getTeamMembersName()
        case .heal:
            return getTeamHealersName()
        }
    }
    
    // return an array of Character depending of the action
    // if action is .attack the method return all characters abble to attack
    // if action is .heal the method return all characters able to heal
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
    
    // return all team members without any filter separate with a ","
    func getAllTeamMembers() -> String {
        return charactersNames.joined(separator: ", ")
    }
    
    // return true if the characters array contains at least one healer and it is not dead
    func containsHealer() -> Bool {
        return characters.contains { character in
            character.isHealer && !character.isDead
        }
    }
    
    // return a character found by its name. Nil otherwise
    func getSelectedCharacter(byName name: String) -> Character? {
        for character in characters {
            if let chosenOne = character.getByName(forName: name) {
                return chosenOne
            }
        }
        return nil
    }
    
    // return true if all characters in the array are dead
    func areAllDead() -> Bool{
        return characters.allSatisfy { character in
            character.isDead
        }
    }
}
