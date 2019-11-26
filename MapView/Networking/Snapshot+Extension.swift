//
//  QueryDocumentSnapshot+Extensions.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/25/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation
import Firebase

extension QueryDocumentSnapshot {
    
    func decoded<T: Decodable>() -> T {
        let jsonData = try! JSONSerialization.data(withJSONObject: data(), options: [])
        let object = try! JSONDecoder().decode(T.self, from: jsonData)
        return object
    }
    
}

extension QuerySnapshot {
    
    func decoded<T: Decodable>() -> [T] {
        let object: [T] = documents.map({ (snapshot) -> T in
            return snapshot.decoded()
        })
        return object
    }
    
}
