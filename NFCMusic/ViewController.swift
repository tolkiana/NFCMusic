//
//  ViewController.swift
//  NFCMusic
//
//  Created by Nelida Velazquez on 7/18/19.
//  Copyright © 2019 Detroit Labs LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let encoder = NFCMessageEncoder()
    private let writer = NFCWriter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func read(_ sender: UIButton) {
        
    }
    
    @IBAction func write(_ sender: UIButton) {
        let songName = "Check to Check"
        guard let url = URL(string: "spotify:track:33jt3kYWjQzqn3xyYQ5ZEh") else {
            return
        }
        guard let message = encoder.message(with: url, and: songName) else {
            return
        }
        writer.write(message)
    }

}

