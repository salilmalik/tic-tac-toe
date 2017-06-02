//
//  Game.swift
//  tic tac toe
//
//  Created by Salil Malik on 19/03/17.
//  Copyright © 2017 Salil Malik. All rights reserved.
//

import UIKit

class Game: UIViewController {
    let winningCombinations = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    var playerX = Set<Int>()
    var playerO = Set<Int>()
    var clickedList=Set<Int>()
    var playerMove="x"
    var gameIsActive=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greenbg")!)
        newGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title="Tic Tac Toe"
    }
    @IBAction func refreshGame(_ sender: Any) {
        newGame()
    }
    func newGame(){
        gameIsActive=true
        for index in 1...9 {
            let tile = self.view.viewWithTag(index) as! UIButton
            tile.isEnabled = true
            tile.setTitle("",for: UIControlState.normal)
            tile.setBackgroundImage(nil, for: .normal)
        }
        playerX.removeAll()
        playerO.removeAll()
        clickedList.removeAll()
        playerMove="x"
        
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        var image="xn"
        var player="Player X"
        if !clickedList.contains(sender.tag) && gameIsActive{
            if playerMove=="x"{
                self.navigationController?.navigationBar.topItem?.title = "Turn: Player O"
                sender.setBackgroundImage(UIImage(named:image)!, for: .normal)
                clickedList.insert(sender.tag);
                playerX.insert(sender.tag);
                if((clickedList.count>4)&&(checkWin(playerXorO: playerX))){
                    gameIsActive=false
                    self.navigationController?.navigationBar.topItem?.title = player+" Wins"
                }else if clickedList.count==9{
                    gameIsActive=false
                    self.navigationController?.navigationBar.topItem?.title = "It's a draw"
                }
                else{
                    playerMove="y"
                }
            }else {
                image="on"
                player="Player O";
                self.navigationController?.navigationBar.topItem?.title = "Turn: Player X"
                sender.setBackgroundImage(UIImage(named:image)!, for: .normal)
                clickedList.insert(sender.tag);
                playerO.insert(sender.tag);
                if((clickedList.count>4)&&(checkWin(playerXorO: playerO))){
                    gameIsActive=false
                    self.navigationController?.navigationBar.topItem?.title = player+" Wins"
                }else{
                    playerMove="x"
                }
            }
        }
        
    }
    func checkWin(playerXorO:Set<Int>)->Bool{
        for winningCombination in winningCombinations  {
            if playerXorO.contains(winningCombination[0]) && playerXorO.contains(winningCombination[1]) && playerXorO.contains(winningCombination[2]) {
                return true;
            }
        }
        return false;
    }
}
