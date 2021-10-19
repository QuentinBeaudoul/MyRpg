//
//  GameSession.swift
//  MyRpg
//
//  Created by Quentin Beaudoul on 19/10/2021.
//

import Foundation

// Game session representation
// players, representing two players
// roundCount, the number of round that need to end a game
class GameSession {
    private let players = [Player(), Player()]
    private var roundCount = 0
    
    // init func representing the progress of the game
    init() {
        uiStartGame()
        initiatePlayers()
        for player in players {
            createTeam(for: player)
        }
        
        while !isGameOver() {
            roundCount += 1
            
            for player in players {

                if player.team.areAllDead() {
                    let otherPlayer = getOtherPlayer(currentPlayer: player)
                    uiEndGameStatistics(andTheWinnerIs: otherPlayer, loser: player)
                    break
                }
                
                let action = selectAction(forPlayer: player)
                let selectedCharacter = selectTheDoingCharacter(inTeam: player.team, accordingTo: action)
                print("Le personnage sélectionné est \(selectedCharacter.name)")
                
                //Logique du coffre d'arme
                if oneInSixChance() {
                    let chest = Chest()
                    uiRandomChest(chest: chest)
                    weaponSwitchChoice(forCharacter: selectedCharacter, chest: chest)
                }
                
                
                let targetCharacter = selectTheReceivingCharacter(currentPlayer: player, accordingTo: action)
                print("Le personnage ciblé est \(targetCharacter.name)")
                actionDone(characterDoing: selectedCharacter, targetCharacter: targetCharacter, forAction: action)
                uiSummaryAction(characterDoing: selectedCharacter, targetCharacter: targetCharacter, forAction: action)
            }
        }
        uiEndGame()
    }
    
    // func reprensenting the random chest event.
    // with the character in parameter can grab or not a weapon contained in a chest.
    // if the player choose "oui" the character weapon is set to the new weapon
    // if the player choose "non" the character keep its weapon
    private func weaponSwitchChoice(forCharacter character: Character, chest: Chest){
        let insideWeapon = chest.insideWeapon
        while true {
            print("Voulez vous changer d'arme pour le personnage \(character.name) ? (répondre par \"oui\" ou par \"non\")")
            if let choice = readLine() {
                if choice.elementsEqual("oui") {
                    if character.isHealer && insideWeapon.type == .dps {
                        print("\(character.name) ramasse l'arme. Il ne peut plus soigner.")
                    } else if !character.isHealer && insideWeapon.type == .support {
                        print("\(character.name) rammase l'arme. Il peut désormait soigner son équipe.")
                    }else {
                        print("\(character.name) rammase l'arme.")
                    }
                    print("La puissance de \(character.name) est désormait de \(character.weapon.power).")
                    character.grabWeapon(weapon: insideWeapon)
                    return
                }else if choice.elementsEqual("non") {
                    print("\(character.name) préfère garder son arme.")
                    return
                }else {
                    print("\(choice) n'est pas une commande valide. Répondez par \"oui\" ou par \"non\"")
                }
            } else {
                print("Commande invalide. Répondez par \"oui\" ou par \"non\"")
            }
        }
    }
    
    // return true if the Int.random(in: 1..<6) == 3
    // One in six chance in other words
    // representing the chance that a chest can appear
    private func oneInSixChance() -> Bool {
        return Int.random(in: 1..<6) == 3 ? true : false
    }
    
    // representing the character action to another character depending of the chosen action
    // if action is ".attack" the doing character will attack the target character
    // if action is ".heal" the doing character will heal the target chraracter
    private func actionDone(characterDoing: Character, targetCharacter: Character, forAction action: Action) {
        switch action {
        case .attack:
            characterDoing.attack(who: targetCharacter)
        case .heal:
            characterDoing.heal(who: targetCharacter)
        }
    }
    
    // representing the choice of the target character depending of the player and the action in parameters
    // if action is ".attack" the player can select a character in the opposite team
    // if action is ".heal" the player can select a character in his team
    // the character selection is made by name
    private func selectTheReceivingCharacter(currentPlayer player: Player, accordingTo action: Action) -> Character {
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
    
    
    // return the opposite player depending of the player in parameter
    private func getOtherPlayer(currentPlayer player: Player) -> Player {
        if player == players[0] {
            return players[1]
        } else {
            return players[0]
        }
    }
    
    // retrun the character selected by the player depending of the action
    // selection made by name
    private func selectTheDoingCharacter(inTeam team: Team, accordingTo action: Action) -> Character {
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
    
    // return an action chosen by the player
    // ".heal" action can be chosen only if the player has a healer in his team. Otherwise, a error message is rised.
    private func selectAction(forPlayer player: Player) -> Action {
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
    
    // representing the player name selection
    private func initiatePlayers(){
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
    
    // representing the team creation process for a given player
    private func createTeam(for player: Player) {
        uiMenuSeparator()
        print("\(player.name), constitue ton équipe !")
        print("")
        namesSelection(forPlayer: player)
        print("\(player.name), votre équipe est composé des personnages suivant: \(player.team.getAllTeamMembers())")
    }
    
    // representing the name selection for a given player
    // team are composed of 3 characters
    // each name has to be unique.
    private func namesSelection(forPlayer player: Player) {
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
    
    // return true if the given name in parameter isnt already used in teams
    private func isNameAvailable(name: String) -> Bool {
        return (players[0].team.characters + players[1].team.characters).filter { character in
            character.name.elementsEqual(name)
        }.isEmpty
    }
    
    // return true if at least one player hase no more character available in his team
    private func isGameOver() -> Bool {
        return  players[0].team.areAllDead() || players[1].team.areAllDead()
    }
    
    
    // INTERFACE
    
    private func uiMenuSeparator(){
        print("---------------------------------------------")
    }
    private func uiStartGame(){
        print(" --------------")
        print("|Début du jeu !|")
        print(" --------------")
    }
    private func uiEndGame(){
        print(" --------------")
        print("| Fin du jeu ! |")
        print(" --------------")
    }
    private func uiDisplayTeam(team: Team) {
        var resultBuilder = ""
        print("")
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
    private func uiSummaryAction(characterDoing: Character, targetCharacter: Character, forAction action: Action){
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
        print("")
    }
    private func uiEndGameStatistics(andTheWinnerIs winner: Player, loser: Player) {
        
        print("Statistiques de la partie.")
        
        uiDisplayTeam(team: winner.team)
        uiDisplayTeam(team: loser.team)
        
        print("")
        print("Le joueur \(winner.name) gagne en \(roundCount) tours. Félicitation !")
    }
    private func uiRandomChest(chest: Chest){
        let weapon = chest.insideWeapon
        print("")
        print("Un coffre vient d'apparaitre !")
        print("Le coffre contient une arme:")
        print(" ----------------------------")
        print("|        puissance: \(weapon.power)       |")
        print("|        type: \(weapon.type)          |")
        print(" ----------------------------")
    }
}
