//
//  DocumentInfoViewController.swift
//  EmojiArt
//
//  Created by Owner on 7/15/19.
//  Copyright © 2019 Owner. All rights reserved.
//

import UIKit

class DocumentInfoViewController: UIViewController {
    
    // Uncomment
    /*var document: EmojiArtDocument? {
        didSet {
            updateUI()
        }
    }*/
    
    private var shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    @IBOutlet weak var topLevelView: UIStackView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var thumbnailAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func done(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let fittedSize = topLevelView?.sizeThatFits(UIView.layoutFittingCompressedSize) {
            preferredContentSize = CGSize(width: fittedSize.width + 30, height: fittedSize.height + 30)
        }
    }
    
    private func updateUI() {
        // Uncomment
        /*if sizeLabel != nil, createdLabel != nil,
        let url = document?.fileURL,
            let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
            sizeLabel.text = "\(attributes[.size] ?? 0) bytes"
            if let created = attributes[.creationDate] as? Date {
                createdLabel.text = shortDateFormatter.string(from: created)
            }
        }
        
        if thumbnailImageView != nil, thumbnailAspectRatio != nil, let thumbnail = document?.thumbnail {
            thumbnailImageView.image = thumbnail
            thumbnailImageView.removeConstraint(thumbnailAspectRatio)
                 thumbnailAspectRatio = NSLayoutConstraint(
                 item: thumbnailImageView,
                 attribute: .width,
                 relatedBy: .equal,
                 toItem: thumbnailImageView,
                 attribute: .height,
                 multiplier: thumbnail.size.width / thumbnail.size.height,
                 constant: 0
            )
            thumbnailImageView.addConstraint(thumbnailAspectRatio)
        }*/
        
        if presentationController is UIPopoverPresentationController {
            thumbnailImageView?.isHidden = true
            doneButton?.isHidden = true
            view.backgroundColor = .clear
        }
    }
    
}
