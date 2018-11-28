//
//  Card+CoreDataProperties.swift
//  
//
//  Created by Jonah Kornberg on 11/14/18.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var side1: String?
    @NSManaged public var side2: String?
    @NSManaged public var ownerSet: Set?

}
