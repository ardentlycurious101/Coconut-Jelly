//
//  TagManager.swift
//  MapView
//
//  Created by Elina Lua Ming on 12/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation

class TagManager {
    
    private init() {}
    static let shared = TagManager()
    private var filterSwitch: Bool = false
    
    // array containing all tags of jellies within region
    var Tags: [String] = []
    
    var sortedTags: [String] {
        get {
            return Array(Set(Tags.compactMap { return $0})).sorted(by: { $0 < $1 })
        }
    }
    
    private var TagDictionary: [String : Bool] = [:]

    func setDictionary(key: String, value: Bool) {
        TagDictionary[key] = value
    }
    
    func getDictionary() -> [String : Bool] {
        return TagDictionary
    }
    
    func checkTagDictionary(for key: String) {
        if TagDictionary[key] == true {
            TagDictionary[key] = false
        } else {
            TagDictionary[key] = true
        }
    }
    
    func changeFilterSwitchState(isOn: Bool) {
        if isOn {
            filterSwitch = true
            // reload map with
            if MapViewManager.shared.filteredJellies.count == 0 {
                NotificationCenter.default.post(name: .useAllJellies, object: nil)
            } else {
                NotificationCenter.default.post(name: .filteredJellyAdded, object: nil)
            }
        } else {
            filterSwitch = false
            NotificationCenter.default.post(name: .useAllJellies, object: nil)
        }
    }
    
}
