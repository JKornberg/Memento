//
//  CardSet.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/21/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class CardSet: Codable{
    static func == (lhs: CardSet, rhs: CardSet) -> Bool {
        return lhs.setId == rhs.setId
    }
    
    var setName = ""
    var isActive = false
    var setId : Int?
    var cards : [Card] = [Card]()
    init(setName : String, cards: [Card]){
        self.setName = setName
        self.isActive = false
        self.cards = cards
    }
    
}
