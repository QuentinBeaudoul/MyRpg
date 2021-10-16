//
//  Game.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

//TODO: Bouger l'ensemble de la logique présente dans le main dans une autre classe (class GameSession par exemple)

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
        
        while !isGameOver() {
            
            
            let action = selectAction(forPlayer: playerOne)
            let selectedCharacter = selectTheDoingCharacter(inTeam: playerOne.team, accordingTo: action)
            print("Le personnage sélectionné est \(selectedCharacter.name)")
            let targetCharacter = selectTheReceivingCharacter(currentPlayer: playerOne, accordingTo: action)
            print("Le personnage ciblé est \(targetCharacter.name)")
            
            
        
        }
        uiEndGame()
    }
    
    //private static func startAction()
    
    private static func selectTheReceivingCharacter(currentPlayer player: Player, accordingTo action: Action) -> Character {
        var potentialTargets = ""
        switch action {
        case .attack:
            let otherPlayer = getOtherPlayer(currentPlayer: player)
            potentialTargets = otherPlayer.team.getTeamMembers(forAction: action)
            print("Qui voulez vous attaquer parmis: \(potentialTargets) ?")
            while true {
                if let choice = readLine() {
                    if potentialTargets.contains(choice) {
                        if let target = otherPlayer.team.getSelectedCharacter(byName: choice) {
                            return target
                        }else{
                            print("Le personnage n'existe pas !")
                        }
                    }else{
                        print("'\(choice)' n'est pas une commande valide. Essayez en une autre:")
                    }
                } else {
                    print("Commande invalide. Essayez en une autre:")
                }
            }
        case .heal:
            potentialTargets = player.team.getAllTeamMembers()
            print("Qui voulez vous soigner parmis: \(potentialTargets) ?")
            while true {
                if let choice = readLine() {
                    if potentialTargets.contains(choice) {
                        if let target = player.team.getSelectedCharacter(byName: choice) {
                            return target
                        }else{
                            print("Le personnage n'existe pas !")
                        }
                    } else {
                        print("'\(choice)' n'est pas une commande valide. Essayez en une autre:")
                    }
                } else {
                    print("Commande invalide. Essayez en une autre:")
                }
            }
        }
    }
    
    
    
    private static func getOtherPlayer(currentPlayer player: Player) -> Player {
        if player == playerOne {
            return playerTwo
        } else {
            return playerOne
        }
    }
    
    private static func selectTheDoingCharacter(inTeam team: Team, accordingTo action: Action) -> Character {
        uiMenuSeparator()
        let teamAsString: String = team.getTeamMembers(forAction: action)
        uiDisplayTeam(team: team)
        print("Quel personnage voulez vous utiliser ?")
        while true {
            print("Choisissez un personnage parmis: \(teamAsString)")
            if let choice = readLine() {
                if teamAsString.contains(choice) {
                    if let selectedCharacter = team.getSelectedCharacter(byName: choice) {
                        return selectedCharacter
                    }else {
                        print("\'\(choice)\' n'est pas une commande valide.")
                    }
                } else {
                    print("\'\(choice)\' n'est pas une commande valide.")
                }
            }
        }
    }
    
    private static func selectAction(forPlayer player: Player) -> Action {
        uiMenuSeparator()
        print("\(player.name). À vous de jouer !")
        while true {
            print("Choisissez une action: \(Action.attack) ou \(Action.heal)")
            if let choice = readLine() {
                switch choice {
                case Action.attack.rawValue:
                    return .attack
                case Action.heal.rawValue:
                    if player.team.containsHealer() {
                        return .heal
                    }else {
                        print("L\'équipe de \(player.name) ne contient pas de soigneur !")
                    }
                default:
                    print("\'\(choice)\' n'est pas une commande valide.")
                }
            }
        }
    }
    
    private static func initiatePlayers(){
        uiMenuSeparator()
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
    }
    
    private static func createTeam(for player: Player) {
        uiMenuSeparator()
        print("\(player.name), constitue ton équipe !")
        print("")
        namesSelection(forPlayer: player)
        print("\(player.name), votre équipe est composé des personnages suivant: \(player.team.getAllTeamMembers())")
    }
    
    private static func namesSelection(forPlayer player: Player) {
        for id in 1...3 {
            print("Choisi le nom du personnage \(id): ")
            var isNameNotOk = true
            while isNameNotOk {
                if let name = readLine(), !name.isEmpty {
                    if isNameAvailable(name: name) {
                        player.team.characters.append(Character(name: name))
                        isNameNotOk = false
                    } else {
                        print("Le nom \"\(name)\" est déjà utilisé. Choisissez en un autre: ")
                    }
                }
            }
        }
    }
    
    private static func isNameAvailable(name: String) -> Bool {
        return (playerOne.team.characters + playerTwo.team.characters).filter { character in
            character.name.elementsEqual(name)
        }.isEmpty
    }
    
    private static func isGameOver() -> Bool {
        return playerOne.team.areAllDead() || playerTwo.team.areAllDead()
    }
    
    
    // INTERFACE
    
    private static func uiMenuSeparator(){
        print("---------------------------------------------")
    }
    private static func uiStartGame(){
        print(" --------------")
        print("|Début du jeu !|")
        print(" --------------")
    }
    private static func uiEndGame(){
        print(" --------------")
        print("| Fin du jeu ! |")
        print(" --------------")
    }
    private static func uiDisplayTeam(team: Team) {
        var resultBuilder = ""
        print("Votre équipe:")
        resultBuilder.append("--------------\n")
        for (index, character) in team.characters.enumerated() {
            resultBuilder.append("Nom: \(character.name)\n")
            resultBuilder.append("Est mort: \(character.isDeadDisplayable)\n")
            resultBuilder.append("Nombre de pv: \(character.healthPoint)\n")
            resultBuilder.append("Puissance: \(character.weapon.power)\n")
            resultBuilder.append("Capable de soigner: \(character.isHealerDisplayable)\n")
            resultBuilder.append("--------------\n")
        }
        print(resultBuilder)
    }
}
