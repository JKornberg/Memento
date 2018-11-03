//
//  CardSet.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/21/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

class CardSet: Hashable{
    static func == (lhs: CardSet, rhs: CardSet) -> Bool {
        return lhs.setId == rhs.setId
    }
    var hashValue: Int{
        return setId
    }
    
    var setName = ""
    var isActive = false
    var setId = 0
    var cards = [Card]()
    init(setName : String, setId : Int){
        self.setName = setName
        self.setId = setId
        self.isActive = false
    }
    
}
