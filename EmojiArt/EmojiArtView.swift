//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Owner on 7/10/19.
//  Copyright © 2019 Owner. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }

}
