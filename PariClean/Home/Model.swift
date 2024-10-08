//
//  Model.swift
//  PariClean
//
//  Created by Владимир Кацап on 13.08.2024.
//

import Foundation


struct AlcoSigar: Codable {
    var number: Int
    var reason: String
    var time: String
    var day: String
    
    init(number: Int, reason: String, time: String, day: String) {
        self.number = number
        self.reason = reason
        self.time = time
        self.day = day
    }
}


struct User: Codable {
    var name: String
    var exp: String
    var image: Data
    
    init(name: String, exp: String, image: Data) {
        self.name = name
        self.exp = exp
        self.image = image
    }
}
