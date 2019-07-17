//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Owner on 7/10/19.
//  Copyright © 2019 Owner. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var emojis = "😍🐢🐠🐧🦉🐴🐼🐵🐰🎩🌼☁️🌍⛪️🖨🚗💊🤡🏃‍♀️🐋🐳🦋🐌🐅🐄🦏🐑".map {String($0)}
    // uncomment this
    //var document: EmojiArtDocument?
    private var imageFetcher: ImageFetcher!
    private var suppressBadURLWarnings = false
    private var documentObserver: NSObjectProtocol?
    private var emojiArtViewObserver: NSObjectProtocol?
    
    @IBOutlet var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    @IBOutlet weak var emojiArtView: EmojiArtView! /*{
        didSet {
            emojiArtView.delegate = self
        }
    }
 */
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
            emojiCollectionView.dragDelegate = self
            emojiCollectionView.dropDelegate = self
        }
    }
    
    // in an action called close, put these (video 13,14)
    // change its paramter: add: ? = nil (to make it optional with a default value of nil)
    /*
     if let observer = emojiArtViewObserver {
        NotificationCenter.default.removeObserver(observer)
     
     }
     
     if document?.emojiArt != nil {
        document.thumbnail = emojiArtView.snapshot
     }
     
     dismiss(animated: true) {
     self.docuemnt?.close { success in
     if let observer = self.documentObserver {
        NotificationCenter.default.removeObserver(observer)
     }
     */
    
    @IBAction func close(bySegue: UIStoryboardSegue) {
        // Uncomment after implementing close action abovee (video 13,14)
        //close()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Uncomment during watching videos 13,14 (it just listens to changes and reports them)
        /*
         documentObserver = NotificationCenter.default.addObserver(
            forName: UIDocument.stateChangedNotification,
            object: document,
            queue: OperationQueue.main,
            using: { notificatiion in
                print("documentState changed to: \(self.document!.documentState)")
            }
         )
         
         document?.open { success in
             if success {
                self.title = self.document.localizedName
                self.emojiArt = self.document?.emojiArt
                self.emojiArtViewObserver = NotificationCenter.default.addObserver(
                    forName: .EmojiArtViewDidChange,
                    object: self.emojiArtView,
                    queue: OperationQueue.main,
                    using: { notification in
                        self.documentChanged()
                    }
                )
             }
         }
         */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Document Info" {
            if let destination = segue.destination.contents as? DocumentInfoViewController {
                // Uncomment
                //document?.thumbnail = emojiArtView.snapshot
                //destination.document = document
                if let ppc = destination.popoverPresentationController {
                    ppc.delegate = self
                }
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    // formerly known as save() action
    func documentChanged() {
        // Uncomment
        /*
        document?.emojiArt = emojiArt
        if document?.emojiArt != nil {
            document?.updateChangeCount(.done)
        }
         */
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let emojiCell = emojiCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell {
            let emojiAttributedString = NSAttributedString(string: emojiCell.emojiLabel?.text ?? "")
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: emojiAttributedString))
            dragItem.localObject = emojiAttributedString
            return [dragItem]
        }
        return []
    }
    
    private func presentBadUrlWarning() {
        let alert = UIAlertController(
            title: "Image Transfer Failed",
            message: "Couldn't transfer image from its source",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Keep Warning",
            style: .default))
        
        alert.addAction(UIAlertAction(
            title: "Stop Warning",
            style: .destructive,
            handler: { action in
                self.suppressBadURLWarnings = true
            }
        ))
        
        present(alert, animated: true)
    }
}

extension EmojiArtViewController: UIDropInteractionDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate/*, EmojiArtViewDelegate*/ {
    
    // EmojiArtView Delegate
    
    /*func emojiArtViewDidChange(_ sender: EmojiArtView) {
        //documentChanged()
    }*/
    
    // Drag and Drop Dele
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtView.backgroundImage = image
            }
        }
        
        session.loadObjects(ofClass: NSURL.self, completion: {nsurls in
            if let url = nsurls.first as? URL {
                //self.imageFetcher.fetch(url)
                DispatchQueue.global(qos: .userInitiated).async{
                    if let imageData = try? Data(contentsOf: url.imageURL), let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.emojiArtView.backgroundImage = image
                        }
                    }
                    else if !self.suppressBadURLWarnings {
                        self.presentBadUrlWarning()
                    }
                }
            }
        })
        
        session.loadObjects(ofClass: UIImage.self, completion: {images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        
        // Configure the cell...
        if let emojiCell = cell as? EmojiCollectionViewCell {
            emojiCell.emojiLabel.text = emojis[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath { // the source is my collection view
                if let emojiAttributedString = item.dragItem.localObject as? NSAttributedString {
                    collectionView.performBatchUpdates({
                        emojis.remove(at: sourceIndexPath.item)
                        emojis.insert(emojiAttributedString.string, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
            else { // the source is anywhere else
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let attributedString = provider as? NSAttributedString {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.emojis.insert(attributedString.string, at: insertionIndexPath.item)
                            })
                        }
                        else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
}
