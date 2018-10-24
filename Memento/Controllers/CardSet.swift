//
//  CardSet.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/21/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit

struct CardSet: Hashable{
    static func == (lhs: CardSet, rhs: CardSet) -> Bool {
        return lhs.setId == rhs.setId
    }
    
    var setName = ""
    var isActive = false
    var setId = ""
    init(setName : String, setId : String){
        self.setName = setName
        self.setId = setId
        self.isActive = false
    }
    
}
