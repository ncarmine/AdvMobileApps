//
//  Conversoins.swift
//  UnitConverter
//
//  Created by Nathan Carmine 2017.
//  Copyright © 2017 ncarmine. All rights reserved.
//

import UIKit

class Conversions: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var numField: UITextField!
    @IBOutlet weak var conversionLabel: UILabel!
    @IBOutlet weak var unitPicker: UIPickerView!
    
    var unitDictArr = [String: AnyObject]()
    var unitTypes = [String]()
    var conversions = [[NSObject : AnyObject]]()
    
    var currentConversion = [NSObject : AnyObject]()
    
    func getDataFile(resourceName: String, type: String) -> String? {
        guard let pathString = Bundle.main.path(forResource: resourceName, ofType: type) else {
            return nil
        }
        return pathString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let path = getDataFile(resourceName: "conversions", type: "plist") else {
            print("Error loading file")
            return
        }
        
        unitDictArr = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        unitTypes = Array(unitDictArr.keys)
        conversions = unitDictArr[unitTypes[0]]! as! [[NSObject : AnyObject]]
        currentConversion = conversions[0]
    }
    
    func calculateConversion() {
        if (numField?.text?.isEmpty)! {
            conversionLabel?.text = "Enter conversion"
            return
        }
        guard let doubleText = Double((numField?.text!)!) else {
            conversionLabel?.text = "Invalid value"
            return
        }
        let conversionKeys = Array(currentConversion.keys)
        guard let conversionValue = currentConversion[conversionKeys[0]] as? Double else {
            conversionLabel?.text = "Error computing input"
            return
        }
        guard let conversionText = currentConversion[conversionKeys[1]] as? String else {
            conversionLabel?.text = "Error computing input"
            return
        }
        let conversionTextArr = conversionText.components(separatedBy: " to ")
        let unit1 = conversionTextArr[0]
        let unit2 = conversionTextArr[1]
        let unitConversion = doubleText * conversionValue
        conversionLabel?.text = "\(doubleText) \(unit1) = \(unitConversion) \(unit2)"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return unitTypes.count
        } else {
            return conversions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return unitTypes[row]
        } else {
            //Get text for each conversion in the current conversion types
            let conversionKeys = Array(conversions[0].keys)
            return conversions[row][conversionKeys[1]] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            let chosenUnitType = unitTypes[row]
            conversions = unitDictArr[chosenUnitType]! as! [[NSObject : AnyObject]]
            unitPicker.reloadComponent(1)
            unitPicker.selectRow(0, inComponent: 1, animated: true)
        }
        let conversionRow = pickerView.selectedRow(inComponent: 1)
        currentConversion = conversions[conversionRow]
        calculateConversion() //redo conversion as the user is selecting conversion types
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let startingLength = numField.text?.characters.count ?? 0 //Set starting length to 0 if no chars
        let newStrLen = string.characters.count
        let currStrLen = range.length
        let newLength = startingLength + newStrLen - currStrLen //Find how long the next string will be
        
        //Create inverse char set of everything but digits and period
        let inverseAllowedChars = NSCharacterSet(charactersIn: "0123456789.").inverted
        //Separate each char in the new string by the inverse char set
        let components = string.components(separatedBy: inverseAllowedChars)
        //Rejoin the components with no separation
        let filtered = components.joined(separator: "")
        
        //Return true if the new length is <=10 and there are no improper characters in string
        return newLength <= 10 && string == filtered
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        numField.resignFirstResponder()
        calculateConversion()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

