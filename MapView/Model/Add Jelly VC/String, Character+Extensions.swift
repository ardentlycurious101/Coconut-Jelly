//
//  String, Character+Extensions.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        return unicodeScalars.count == 1 && unicodeScalars.first?.properties.isEmojiPresentation ?? false
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmojiPresentation ?? false
//            unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }
    
    var isEmoji: Bool {
//        print(unicodeScalars.count)
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}

extension String {
    var isSingleEmoji: Bool {
        return count == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        return !isEmpty && !contains { !$0.isEmoji }
    }
    
    var emojiString: String {
        return emojis.map { String($0) }.reduce("", +)
    }
    
    var emojis: [Character] {
        return filter { $0.isEmoji }
    }
    
    var emojiScalars: [UnicodeScalar] {
        return filter{ $0.isEmoji }.flatMap { $0.unicodeScalars }
    }
}
