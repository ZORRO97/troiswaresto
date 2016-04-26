//
//  Review.swift
//  troiswaresto
//
//  Created by etudiant-11 on 25/04/2016.
//  Copyright © 2016 francois. All rights reserved.
//

import Foundation

class Review {
    var description:String?
    var rating:Double
    var nickname:String?
    var restoId: Int
    init(rating:Double, restoId : Int){
        self.rating = rating
        self.restoId = restoId
    }
}
