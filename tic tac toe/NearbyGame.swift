//
//  NearbuyGame.swift
//  tic tac toe
//
//  Created by Salil Malik on 28/03/17.
//  Copyright © 2017 Salil Malik. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class NearbyGame: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    @IBOutlet var selfb: UIButton!
    
    @IBOutlet var secondb: UIButton!
    
    var peerID: MCPeerID!
    var appDelegate:AppDelegate!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
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
    var value=0;
    var px : String = "";
    var po : String = "";
    var turn : String = ""
    var dataDictionary : [String:Any] = [:];
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title="Tic Tac Toe"
    }
    
    @IBOutlet var connectButton: UIButton!
    
    @IBAction func refreshGame(_ sender: Any) {
        newGame()
        sendData()
    }
    
    @IBAction func Connect(_ sender: Any) {
        let mcBrowser = MCBrowserViewController(serviceType: "ttt-sm", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func advertiseSelf(advertise:Bool) {
        if advertise {
            mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ttt-sm", discoveryInfo: nil, session: mcSession)
            mcAdvertiserAssistant!.start()
        } else {
            mcAdvertiserAssistant!.stop()
            mcAdvertiserAssistant = nil
        }
    }
    
    override func viewDidLoad() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.delegate = self
        advertiseSelf(advertise: true)
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greenbg")!)
        newGame()
        gameIsActive=false;
    }
    
    func newGame(){
        gameIsActive=true
        for index in 1...9 {
            let tile = self.view.viewWithTag(index) as! UIButton
            tile.isEnabled = true
            tile.setTitle("",for: UIControlState.normal)
            tile.setBackgroundImage(nil, for: .normal)
            clickedList.removeAll()
        }
        playerX.removeAll()
        playerO.removeAll()
        state=[0,0,0,0,0,0,0,0,0]
    }
    
    func checkWin(playerXorO:Set<Int>)->Bool{
        for winningCombination in winningCombinations  {
            if playerXorO.contains(winningCombination[0]) && playerXorO.contains(winningCombination[1]) && playerXorO.contains(winningCombination[2]) {
                return true;
            }
        }
        return false;
    }
    
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            newGame()
            px = self.peerID.displayName;
            po = peerID.displayName;
            self.navigationController?.navigationBar.topItem?.title = "Turn: " + px
            turn = px;
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        }
    }
    
    func showWinOrDrawAlert(result:String){
        var alertMessage = ""
        if (result == "draw"){
            alertMessage = "Draw"
        }else if (result == "PXWins"){
            alertMessage = "Player X Wins"
        }
        else{
            alertMessage = "Player Y Wins"
        }
        let alert = UIAlertController(title: "Game Over", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        newGame()
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        if mcSession.connectedPeers.count>0{
            if !clickedList.contains(sender.tag) && gameIsActive{
                if turn == px{
                    let image="xn"
                    self.navigationController?.navigationBar.topItem?.title = "Turn: " + po
                    sender.setBackgroundImage(UIImage(named:image)!, for: .normal)
                    clickedList.insert(sender.tag);
                    playerX.insert(sender.tag-1);
                    state[sender.tag-1] = 1;
                    sendData()
                    if((clickedList.count>4)&&(checkWin(playerXorO: playerX))){
                        gameIsActive=false
                        self.navigationController?.navigationBar.topItem?.title = px+" Wins"
                        showWinOrDrawAlert(result: "PXWins")
                    }else if clickedList.count==9{
                        gameIsActive=false
                        self.navigationController?.navigationBar.topItem?.title = "It's a draw"
                        showWinOrDrawAlert(result: "draw")
                    }
                }else {
                    let image="on"
                    self.navigationController?.navigationBar.topItem?.title = "Turn: " + px
                    sender.setBackgroundImage(UIImage(named:image)!, for: .normal)
                    clickedList.insert(sender.tag);
                    playerO.insert(sender.tag-1);
                    state[sender.tag-1]  = -1;
                    sendData()
                    if((clickedList.count>4)&&(checkWin(playerXorO: playerO))){
                        gameIsActive=false
                        print("PO Wins")
                        showWinOrDrawAlert(result: "POWins")
                        self.navigationController?.navigationBar.topItem?.title = po + " Wins"
                    }else if clickedList.count==9{
                        gameIsActive=false
                        showWinOrDrawAlert(result: "draw")
                        self.navigationController?.navigationBar.topItem?.title = "It's a draw"
                    }
                }
            }
        }
    }
    
    func sendData(){
        dataDictionary["turn"]=turn;
        dataDictionary["playerX"]=playerX;
        dataDictionary["playerO"]=playerO;
        dataDictionary["gameIsActive"]=gameIsActive;
        dataDictionary["clickedList"]=clickedList;
        dataDictionary["state"]=state;
        let dataExample: Data = NSKeyedArchiver.archivedData(withRootObject: dataDictionary)
        gameIsActive=false;
        do {
            try self.mcSession.send(dataExample, toPeers: self.mcSession.connectedPeers, with: MCSessionSendDataMode.reliable)
        }catch{
            print("Unable to successfully convert NSData to NSDictionary")
        }
    }
    
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ttt-sm", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]
        DispatchQueue.main.async {
            self.turn = dictionary?["turn"] as! String
            self.clickedList = dictionary?["clickedList"] as! Set<Int>;
            self.gameIsActive = dictionary?["gameIsActive"] as! Bool;
            self.playerO = dictionary?["playerO"] as! Set<Int>
            self.playerX = dictionary?["playerX"] as! Set<Int>
            self.state = dictionary?["state"] as! [Int]
            for index in 0...8 {
                if self.state[index] == 1{
                    let button = self.view.viewWithTag(index+1) as! UIButton
                    button.setBackgroundImage(UIImage(named:"xn"), for: .normal)
                }
                else if self.state[index] == -1{
                    let button = self.view.viewWithTag(index+1) as! UIButton
                    button.setBackgroundImage(UIImage(named:"on"), for: .normal)
                }
            }
            if((self.clickedList.count>4)&&(self.checkWin(playerXorO: self.playerX))){
                self.gameIsActive=false
                self.navigationController?.navigationBar.topItem?.title = self.px+" Wins"
                print("PX Wins")
                self.showWinOrDrawAlert(result: "PXWins")
            }else if self.clickedList.count==9{
                self.gameIsActive=false
                print("draw")
                self.navigationController?.navigationBar.topItem?.title = "It's a draw"
                self.showWinOrDrawAlert(result: "draw")
            }else if((self.clickedList.count>4)&&(self.checkWin(playerXorO: self.playerO))){
                self.gameIsActive=false
                self.navigationController?.navigationBar.topItem?.title = self.px+" Wins"
                print("PO Wins")
                self.showWinOrDrawAlert(result: "POWins")
            }
        }
    }
}
