//
//  VSComputerGame.swift
//  tic tac toe
//
//  Created by Salil Malik on 25/03/17.
//  Copyright © 2017 Salil Malik. All rights reserved.
//

import UIKit

class VSComputerGame:UIViewController{
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    var playerX = Set<Int>()
    var playerO = Set<Int>()
    var clickedList=Set<Int>()
    var playerMove="x"
    var gameIsActive=false
    var state=[0,0,0,0,0,0,0,0,0]
    let humanValue = -1;
    let computerValue = 1;
    var HUMAN=false;
    var COMPUTER=true;
    var playerList = Set<Int>()
    var value=0;
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title="Tic Tac Toe"
    }
    
    @IBAction func refreshGame(_ sender: Any) {
        newGame()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greenbg")!)
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
        playerMove="x"
        clickedList.removeAll()
        state=[0,0,0,0,0,0,0,0,0]
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.callAI), userInfo: nil, repeats: true)
        self.navigationController?.navigationBar.topItem?.title = "Turn: User - X"
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        let image="xn"
        let player="User - X"
        if !clickedList.contains((sender.tag-1)) && gameIsActive{
            if playerMove=="x"{
                self.navigationController?.navigationBar.topItem?.title = "Turn: Computer - O"
                sender.setBackgroundImage(UIImage(named:image)!, for: .normal)
                clickedList.insert(sender.tag-1);
                state[sender.tag-1]=humanValue;
                playerX.insert(sender.tag-1);
                if((clickedList.count>4)&&(checkWin(board:state, player: HUMAN))){
                    gameIsActive=false
                    self.navigationController?.navigationBar.topItem?.title = player+" Wins"
                }else if clickedList.count==9{
                    gameIsActive=false
                    self.navigationController?.navigationBar.topItem?.title = "It's a draw"
                }
                playerMove="y"
            }
        }
        
    }
    func checkWin(board:Array<Int>,player:Bool)->Bool{
        let value = player == HUMAN ? humanValue : computerValue;
        for x in 0...7 {
            if (value == board[winningCombinations[x][0]] &&
                board[winningCombinations[x][0]] == board[winningCombinations[x][1]] &&
                board[winningCombinations[x][1]] == board[winningCombinations[x][2]]) {
                return true;
            }
        }
        return false;
    }
    
    func callAI(){
        if playerMove == "y" && gameIsActive == true{
            aiturn(board: state,depth: 0,player: COMPUTER)
        }
    }
    func aiturn(board:Array<Int>,depth:Int,player:Bool)->Int{
        
        if checkWin(board:board, player: !player){
            return -10 - depth;
        }
        if(!board.contains(0)){
            return 0;
        }
        let value = player == HUMAN ? humanValue : computerValue;
        var max = -10000;
        var index = 0;
        
        for x in 0...8 {
            if(board[x]==0){
                var newboard=board;
                newboard[x] = value;
                let moveval = -aiturn(board: newboard,depth: depth+1,player: !player)
                if(moveval>max){
                    max = moveval
                    index = x
                }
                
            }
        }
        if depth==0{
            let image="on"
            let player="Computer - O";
            self.navigationController?.navigationBar.topItem?.title = "Turn: User - X"
            let buttonValue = self.view.viewWithTag(index+1) as! UIButton
            buttonValue.setBackgroundImage(UIImage(named:image)!, for: .normal)
            clickedList.insert(index);
            playerO.insert(index);
            state[index]=computerValue;
            if(checkWin(board: state, player: COMPUTER)){
                gameIsActive=false
                self.navigationController?.navigationBar.topItem?.title = player+" Wins"
            }
            playerMove="x"
        }
        return max;
    }
}
