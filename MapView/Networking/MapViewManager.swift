//
//  MapViewManager.swift
//  MapView
//
//  Created by Elina Lua Ming on 12/1/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation

class MapViewManager {
    
    private init() {}
    static let shared = MapViewManager()
    
    var unfilteredJellies: [Jelly] = []
    var filteredJellies: [Jelly] = []
    
    func prepareAnnotations(for jelly: Jellies) {
                
        // create Jelly
        let jelly = Jelly(for: jelly)
        
        // append Jelly onto array
        unfilteredJellies.append(jelly)

    }
    
}
