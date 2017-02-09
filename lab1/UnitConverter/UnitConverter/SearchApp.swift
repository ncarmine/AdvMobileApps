//
//  SecondViewController.swift
//  UnitConverter
//
//  Created by Nathan Carmine on 2017.
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class SearchApp: UIViewController {
    
    @IBAction func openSearch(_ sender: Any) {
        //Presumably, anyone with a niche third-party browser would prefer to open that first
        if (UIApplication.shared.canOpenURL(URL(string: "opera://")!)) {
            //Presumably, anyone with a niche third-party browser would prefer Duck Duck Go
            UIApplication.shared.open(URL(string: "opera-https://duckduckgo.com/?q=unit+conversions")!, options: [:], completionHandler: nil)
        } else if (UIApplication.shared.canOpenURL(URL(string: "firefox://")!)) {
            UIApplication.shared.open(URL(string: "firefox://open-url?url=https://duckduckgo.com/?q=unit+conversions")!, options: [:], completionHandler: nil)
        //Third party browser. Not as niche
        } else if (UIApplication.shared.canOpenURL(URL(string: "googlechrome://")!)) {
            //You're using Google services already, right?
            UIApplication.shared.open(URL(string: "googlechrome://www.google.com/search?q=unit%20conversions")!, options: [:], completionHandler: nil)
        } else {
            //I'm unsure how to access the user set search engine for Safari
            UIApplication.shared.open(URL(string: "https://www.google.com/search?q=unit%20conversions")!, options: [:], completionHandler: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

