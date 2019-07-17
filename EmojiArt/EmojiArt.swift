//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Owner on 7/17/19.
//  Copyright © 2019 Owner. All rights reserved.
//

import Foundation

struct EmojiArt {
    
    var url: URL
    var emojis = [EmojiInfo]()
    
    struct EmojiInfo {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
}
