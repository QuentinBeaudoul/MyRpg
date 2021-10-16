//
//  Game.swift
//  MonRpg
//
//  Created by Quentin Beaudoul on 12/10/2021.
//

//TODO: Bouger l'ensemble de la logique présente dans le main dans une autre classe (class GameSession par exemple) et faire en sorte que les joueurs n'ait pas le même nom
//


import Foundation
@main
class MyRpg {
    private static let players = [Player(), Player()]
    private static var roundCount = 0
    static func main() {
        uiStartGame()
        initiatePlayers()
        for player in players {
            createTeam(for: player)
        }
        
        while !isGameOver() {
            roundCount += 1
            for player in players {
                let action = selectAction(forPlayer: player)
                let selectedCharacter = selectTheDoingCharacter(inTeam: player.team, accordingTo: action)
                print("Le personnage sélectionné est \(selectedCharacter.name)")
                var targetCharacter = selectTheReceivingCharacter(currentPlayer: player, accordingTo: action)
                print("Le personnage ciblé est \(targetCharacter.name)")
                targetCharacter = actionDone(characterDoing: selectedCharacter, targetCharacter: targetCharacter, forAction: action)
                uiSummaryAction(characterDoing: selectedCharacter, targetCharacter: targetCharacter, forAction: action)
            }
        }
        uiEndGame()
    }
    
    private static func actionDone(characterDoing: Character, targetCharacter: Character, forAction action: Action) -> Character {
        switch action {
        case .attack:
            return characterDoing.attack(who: targetCharacter)
        case .heal:
            return characterDoing.heal(who: targetCharacter)
        }
    }
    
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
        if player == players[0] {
            return players[1]
        } else {
            return players[0]
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
        for (index, player) in players.enumerated() {
            print("Choisissez le nom du joueur \(index + 1): ")
            if let name = readLine() {
                player.name = name
            }
        }
        print("Les joueurs s'appellent respectivement \(players[0].name) et \(players[1].name) !")
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
        return (players[0].team.characters + players[1].team.characters).filter { character in
            character.name.elementsEqual(name)
        }.isEmpty
    }
    
    private static func isGameOver() -> Bool {
        return players[0].team.areAllDead() || players[1].team.areAllDead()
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
        for character in team.characters {
            resultBuilder.append("Nom: \(character.name)\n")
            resultBuilder.append("Est mort: \(character.isDeadDisplayable)\n")
            resultBuilder.append("Nombre de pv: \(character.healthPoint)\n")
            resultBuilder.append("Puissance: \(character.weapon.power)\n")
            resultBuilder.append("Capable de soigner: \(character.isHealerDisplayable)\n")
            resultBuilder.append("--------------\n")
        }
        print(resultBuilder)
    }
    private static func uiSummaryAction(characterDoing: Character, targetCharacter: Character, forAction action: Action){
        switch action {
        case .attack:
            print("\(characterDoing.name) attaque \(targetCharacter.name). Il lui inflige \(characterDoing.weapon.power) points de dégat !")
            if targetCharacter.isDead {
                print("\(targetCharacter.name) est mort.")
            }else{
                print("Il reste \(targetCharacter.healthPoint) points de vie à \(targetCharacter.name).")
            }
        case .heal:
            print("\(characterDoing.name) soigne \(targetCharacter.name). Il lui rend \(characterDoing.weapon.power) points de vie !")
            print("\(targetCharacter.name) a désormait \(targetCharacter.healthPoint) points de vie.")
        }
    }
}
