//
//  AddItemViewController.swift
//  MediaList
//
//  Created by Nathan Carmine
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var URLField: UITextField!
    
    var addedName = String()
    var addedURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "savegue" {
            if !(nameField.text?.isEmpty)! && !(URLField.text?.isEmpty)! {
                addedName = nameField.text!
                addedURL = URLField.text!
            }
        }
    }

}
