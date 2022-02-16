//
//  WelcomeViewController.swift
//  PlatziTweets
//
//  Created by mac1 on 01/07/20.
//  Copyright © 2020 mac1. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet weak var loginButton: UIButton!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    
    private func setupUI(){
        loginButton.layer.cornerRadius = 25
    }
}
