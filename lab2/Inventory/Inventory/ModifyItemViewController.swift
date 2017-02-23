//
//  ModifyItemViewController.swift
//  Inventory
//
//  Created by Nathan Carmine 2017
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class ModifyItemViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    var name = String()
    var oldAmount = NSNumber()
    var newAmount: NSNumber?
    
    @IBAction func doneDismiss(_ sender: Any) {
        if !(amountTextField.text?.isEmpty)! {
            if let amount = Int(amountTextField.text!) as NSNumber? {
                newAmount = amount
                performSegue(withIdentifier: "modifySegue", sender: nil)
            } else {
                okAlert(title: "Invalid Field", message: "Please enter a valid number for \"Amount\"")
                
            }
        } else {
            okAlert(title: "Empty Field", message: "Please enter an amount of inventory for \(name)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = name
        amountTextField.placeholder = String(describing: oldAmount)
    }
    
    func okAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
