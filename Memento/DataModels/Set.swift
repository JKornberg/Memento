//
//  Set.swift
//  Memento
//
//  Created by Jonah Kornberg on 11/20/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import Foundation
import RealmSwift
class Set : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isActive : Bool = false
    @objc dynamic var dateCreated : Date?
    var duration = RealmOptional<Double>()
    let cards = List<Card>()
}
