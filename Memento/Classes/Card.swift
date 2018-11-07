//
//  Cards.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/25/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//
import UIKit
class Card:Codable{

    var hashValue: Int{
        return cardId
    }
    var side1 : String = ""
    var side2 : String = ""
    var cardId : Int = 0
    init(side1: String, side2: String, cardId : Int)
    {
        self.side1 = side1
        self.side2 = side2
        self.cardId = cardId
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.cardId == rhs.cardId
    }
}


