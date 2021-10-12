//
//  Game.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

import Foundation
@main
class MyRpg {
    private static let playerOne = Player()
    private static let playerTwo = Player()
    
    static func main() {
        uiStartGame()
        initiatePlayers()
        createTeam(for: playerOne)
        createTeam(for: playerTwo)
        
        
    }
    private static func uiStartGame(){
        print("--------------")
        print("|Début du jeu !|")
        print("--------------")
    }
    private static func initiatePlayers(){
        print("Choisissez le nom du joueur 1: ")
        if let name = readLine() {
            playerOne.name = name
        }
        print("Choisissez le nom du joueur 2: ")
        if let name = readLine() {
            playerTwo.name = name
        }
        print("Les joueurs s'appellent respectivement \(playerOne.name) et \(playerTwo.name) !")
        print("")
        menuSeparator()
    }
    
    private static func createTeam(for player: Player) {
        print("\(player.name), constitue ton équipe !")
        print("")
        var characters = [Character]()
        namesSelection(&characters)
        let team = Team(team: characters)
        player.team = team
        print("\(player.name), votre équipe est composé des personnages suivant: \(team.getTeamMembersName())")
        menuSeparator()
    }
    
    private static func namesSelection(_ characters: inout [Character]) {
        for id in 1...3 {
            print("Choisi le nom du personnage \(id): ")
            var isNameNotOk = true
            while isNameNotOk {
                if let name = readLine() {
                    if isNameAvailable(name: name, characters: characters) {
                        characters.append(Character(name: name))
                        isNameNotOk = false
                    } else {
                        print("Le nom \"\(name)\" est déjà utilisé. Choisissez en un autre: ")
                    }
                }
            }
            
        }
    }
    
    private static func isNameAvailable(name: String? = nil, characters: [Character]) -> Bool {
        if let unwrapName = name {
            for character in characters {
                if character.name.contains(unwrapName) {
                    return false
                }
            }
            if let team = playerOne.team {
                return team.getTeamMembersName().contains(unwrapName) == false
            }else{
                return true
            }
        } else {
            return false
        }
    }
    
    fileprivate static func menuSeparator(){
        print("---------------------------------------------")
    }
}
