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
    private let decoder = NFCMessageDecoder()
    private let writer = NFCWriter()
    private let reader = NFCReader()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func read(_ sender: UIButton) {
        reader.read { message in
            let song = self.decoder.decode(message)
            print(song)
        }
    }
    
    @IBAction func write(_ sender: UIButton) {
        let songName = "Check to Check"
        let artist = "Ella Fitzgerald"
        guard let url = URL(string: "spotify:track:33jt3kYWjQzqn3xyYQ5ZEh") else {
            return
        }
        guard let message = encoder.message(with: [url], and: [songName, artist]) else {
            return
        }
        writer.write(message)
    }

}

