//
//  AddItemViewController.swift
//  Inventory
//
//  Created by Nathan Carmine 2017
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var addedItem: (name: String, amount: NSNumber)?
    
    @IBAction func doneDismiss(_ sender: Any) {
        if !(nameTextField.text?.isEmpty)! && !(amountTextField.text?.isEmpty)! {
            if let amount = Int(amountTextField.text!) as NSNumber? {
                addedItem = (nameTextField.text!, amount)
                performSegue(withIdentifier: "addSegue", sender: nil)
            } else {
                okAlert(title: "Invalid Field", message: "Please enter a valid number for \"Amount\"")
                
            }
        } else {
            okAlert(title: "Empty Fields", message: "Please enter an item name and amount of inventory")
        }
    }
    
    func okAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "addSegue" {
//            if let amount = Int(amountTextField.text!) as NSNumber? {
//                addedItem = (nameTextField.text!, amount)
//            }
//        }
//    }
}
