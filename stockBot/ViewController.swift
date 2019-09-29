//
//  ViewController.swift
//  stockBot
//
//  Created by Fernández Pintos, Natalia (Associate Software Developer) on 28/09/2019.
//  Copyright © 2019 Natalia Fernández. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var modeButton: UIButton!
    @IBOutlet var stockLabel: UILabel!
    @IBOutlet var stockbotLabel: UILabel!

    var stockFound = false

    var viewIsDark = true
    
    func makeViewDark() {
        viewIsDark = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func makeViewLight() {
        viewIsDark = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if viewIsDark {
            return .lightContent
        } else {
            return .default
        }
    }
    
    @IBAction func changeMode(_ sender: UIButton) {
        if sender.currentTitle == "Light Mode" {
            sender.setTitle("Dark Mode", for: .normal)
            mainView.backgroundColor = .white
            stockbotLabel.textColor = .black
            stockLabel.textColor = .black
            makeViewLight()
            return
        }
        sender.setTitle("Light Mode", for: .normal)
        mainView.backgroundColor = .black
        stockbotLabel.textColor = .white
        stockLabel.textColor = .white
        makeViewDark()
    }
    
    
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

