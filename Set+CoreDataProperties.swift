//
//  Set+CoreDataProperties.swift
//  
//
//  Created by Jonah Kornberg on 11/14/18.
//
//

import Foundation
import CoreData


extension Set {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }

    @NSManaged public var title: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension Set {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
