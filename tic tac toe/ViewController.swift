//
//  ViewController.swift
//  tic tac toe
//
//  Created by Salil Malik on 19/03/17.
//  Copyright © 2017 Salil Malik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController")
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blackbg")!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title="Tic Tac Toe"
    }
    
    
}

