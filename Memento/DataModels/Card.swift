//
//  Card.swift
//  Memento
//
//  Created by Jonah Kornberg on 11/20/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import Foundation
import RealmSwift
class Card : Object{
    @objc dynamic var side1: String = ""
    @objc dynamic var side2: String = ""
    @objc dynamic var points : Int = 5
    @objc dynamic var id : Int = 0
    @objc dynamic var streak : Int = 0
    var parentSet = LinkingObjects(fromType: cardSet.self, property: "cards")
}
