//
//  Work.swift
//  FinalFiftyFeetProject
//
//  Created by Haena Kim on 10/15/16.
//  Copyright © 2016 Haena Kim. All rights reserved.
//

import Foundation
import CoreData


class Work: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    @NSManaged var name: String?
    @NSManaged var date: String?
    @NSManaged var cost: String?
    @NSManaged var longLocation: String?
    @NSManaged var latLocation: String?
    
    
    //    func stringForDate() -> String {
    //
    //        let dateFormatter = NSDateFormatter()
    //        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    //        if let date = date {
    //            return dateFormatter.stringFromDate(date)
    //        } else {
    //            return ""
    //        }
    //    }
    
    func csv() -> String {
        
        let Name = name ?? ""
        //        let Work = work ?? ""
        let Cost = cost ?? ""
        let Date = date ?? ""
        let LongLocation = longLocation ?? ""
        let LatLocation = latLocation ?? ""
        
        return "\(Date),\(Name)," +
        "\(LongLocation),\(LatLocation)," +
        "\(Cost)\n"
    }

}