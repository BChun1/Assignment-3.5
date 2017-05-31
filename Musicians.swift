//
//  Musicians.swift
//  Assignment 3.5
//
//  Created by Brian Chun on 4/28/17.
//  Copyright © 2017 Brian Chun. All rights reserved.
//

import UIKit

class Musicians: NSObject, NSCoding {
    let firstName: String
    let lastName: String
    let year: Int
    
    init(firstName: String, lastName: String, year: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.year = year
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let firstName = aDecoder.decodeObject(forKey: "firstName") as? String,
            let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
            else { return nil }
        
        self.init(firstName: firstName, lastName: lastName, year: aDecoder.decodeInteger(forKey: "year"))
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.year, forKey: "year")
    }
    
    override var description: String {
        return "\(firstName) \(lastName) Year of Death: \(year)"
    }
}

