//
//  ViewController.swift
//  tic tac toe
//
//  Created by Salil Malik on 19/03/17.
//  Copyright © 2017 Salil Malik. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController,GADBannerViewDelegate {
    
    @IBOutlet var myBanner: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blackbg")!)
        let request=GADRequest()
        myBanner.adUnitID = "ca-app-pub-6648630816442895/1722645107"
        myBanner.rootViewController = self
        myBanner.delegate = self
        myBanner.load(request)
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

