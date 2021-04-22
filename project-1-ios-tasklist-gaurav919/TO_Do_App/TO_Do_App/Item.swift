//
//  Item.swift
//  TO_Do_App
//
//  Created by Gaurav Aryal on 2/18/20.
//  Copyright © 2020 Gaurav Aryal. All rights reserved.
//

import UIKit
import os.log
class Item: NSObject, NSCoding {
    
    // Mark: Properties
    // Mark: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    //MARK: TYPES
    struct PropertyKey {
        static let name = "name"
        static let date = "date"
        static let dateobject = "dateobject"
        static let completed = "completed"
    }
    var name: String
    var date: String
    var completed: Bool
    var dateobject : Date
    init?(name: String, date: String, dateobject: Date, completed: Bool){
        guard !name.isEmpty else {
            return nil
        }
        self.name = name
        self.date = date
        self.dateobject = dateobject
        self.completed = completed
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(date, forKey: PropertyKey.date)
         aCoder.encode(dateobject, forKey: PropertyKey.dateobject)
        aCoder.encode(completed, forKey: PropertyKey.completed)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String else { return nil }
        guard let dateobject = aDecoder.decodeObject(forKey: PropertyKey.dateobject) as? Date else { return nil }
         guard let completed = aDecoder.decodeObject(forKey: PropertyKey.completed) as? Bool else { return nil }
        
        self.init(name: name, date: date, dateobject: dateobject, completed: completed)
    }
}

