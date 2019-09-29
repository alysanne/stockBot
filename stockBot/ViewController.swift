//
//  ViewController.swift
//  stockBot
//
//  Created by Fernández Pintos, Natalia (Associate Software Developer) on 28/09/2019.
//  Copyright © 2019 Natalia Fernández. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var stockLabel: UILabel!
    var stockFound = false
    
    func responseHandler(_ data: Data?, _ error: Error?) {
        if error != nil {
            stockLabel.text = "stockbot is confused, it hurt itself in its confusion!"
            return
        }

        let stringHtml = String(data: data!, encoding: .utf8)
        let found = stringHtml!.contains("Currently in stock")

        if found == true {
            stockFound = true
            stockLabel.text = "iPhone in stock! 📱"
        }
    }
    
    func checkStock(for url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            DispatchQueue.main.async {
                self.responseHandler(data, error)
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://www.johnlewis.com/apple-iphone-11-pro-ios-5-8-inch-4g-lte-sim-free-256gb/space-grey/p4531036"
//        let url = "https://www.johnlewis.com/apple-iphone-11-pro-max-ios-6-5-inch-4g-lte-sim-free-256gb/gold/p4531044"

        
        self.checkStock(for: url)
        
        if self.stockFound == true {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
            self.checkStock(for: url)
            print("Checked!")
            if self.stockFound == true {
                timer.invalidate()
            }
        }
    }
}

