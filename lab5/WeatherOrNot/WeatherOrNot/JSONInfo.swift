//
//  JSONInfo.swift
//  WeatherOrNot
//
//  Created by Nathan Carmine
//  Copyright © 2017 ncarmine. All rights reserved.
//

import Foundation

class JSONInfo: NSObject {
    private(set) var json: JSON?
    
    override init() {
        super.init()
        setJSON()
        //print("JSON RETRIEVED")
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let setJSON = aDecoder.decodeObject(forKey: "json") as? JSON {
            json = setJSON
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(json as AnyObject, forKey: "json")
    }
    
    func setJSON() {
        if let JSONfile = Bundle.main.path(forResource: "sample_report", ofType: "json") {
            do {
                let dataFromFile = try NSData(contentsOfFile: JSONfile, options: .mappedIfSafe)
                json = JSON(data: dataFromFile as Data)
            } catch let error {
                print(error)
                print("nil json 01")
                json = nil
            }
        }
        else {
            print("nil json 02")
            json = nil
        }
    }
}
