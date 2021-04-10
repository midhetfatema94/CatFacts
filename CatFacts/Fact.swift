//
//  Fact.swift
//  CatFacts
//
//  Created by Midhet Sulemani on 4/11/21.
//

import Foundation

struct Fact {
    var id: String
    var fact: String
    
    init(details: [String: Any]) {
        id = details["_id"] as? String ?? ""
        fact = details["text"] as? String ?? ""
    }
}
