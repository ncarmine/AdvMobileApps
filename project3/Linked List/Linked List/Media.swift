//
//  Media.swift
//  Linked List
//
//  Created by Nathan Carmine
//  Copyright © 2017 ncarmine. All rights reserved.
//

import Foundation
import Firebase

class Media {
    var category: String
    var linkDict: [String: String]
    
    init(newCat: String, linkPairs: [String: String]) {
        category = newCat
        linkDict = linkPairs
    }
    
    init(snapshot: FIRDataSnapshot) {
        category = snapshot.key
        linkDict = snapshot.value as! [String : String]
    }
}
