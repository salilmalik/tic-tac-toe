//
//  NearbuyGame.swift
//  tic tac toe
//
//  Created by Salil Malik on 28/03/17.
//  Copyright © 2017 Salil Malik. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class NearbuyGame: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
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
    var  playerList = Set<Int>()
    var value=0;
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title="Tic Tac Toe"
    }
    @IBAction func refreshGame(_ sender: Any) {
        newGame()
    }
    
    @IBAction func Connect(_ sender: Any) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    func advertiseSelf(advertise:Bool) {
        if advertise {
            mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
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
        newGame()
    }
    
    func newGame(){
        gameIsActive=true
        for index in 1...9 {
            print(index)
            let tile = self.view.viewWithTag(index) as! UIButton
            tile.isEnabled = true
            tile.setTitle("",for: UIControlState.normal)
        }
        playerX.removeAll()
        playerO.removeAll()
        playerMove="x"
    }
    
    func checkWin(playerXorO:Set<Int>)->Bool{
        for winningCombination in winningCombinations  {
            if playerXorO.contains(winningCombination[0]) && playerXorO.contains(winningCombination[1]) && playerXorO.contains(winningCombination[2]) {
                return true;
            }
        }
        return false;
    }
    
    
   
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
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
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
       func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("actionnnnn")
    }
}
