//
//  EditItemViewController.swift
//  Linked List
//
//  Created by Nathan Carmine
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var URLField: UITextField!
    
    var oldName: String?
    var newName: String?
    var editURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if oldName != nil {
            nameField.text = oldName
        }
        if editURL != nil {
            URLField.text = editURL
        }
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
        if segue.identifier == "editsave" {
            if !(nameField.text?.isEmpty)! && !(URLField.text?.isEmpty)! {
                newName = nameField.text!
                editURL = URLField.text!
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
