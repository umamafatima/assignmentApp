//
//  ViewController.swift
//  AssignmentSampleApp
//
//  Created by Umama Fatmah on 28/08/19.
//  Copyright © 2019 Freshworks. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var photosCollectionView: UICollectionView?
    
    // MARK: - Properties
    var imageArr : [Dictionary<String, Any>] = []
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let itemsInRow = 3
    
    //MARK:- UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initDataSource()
        configureCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        photosCollectionView?.layoutSubviews()
    }
    
    //MARK:- CALL THIS METHOD FOR DEADLOCK
    func createDeadLockInSwift() {
        let queue = DispatchQueue(label: "label")
        queue.async {
            queue.sync {
                // outer block is waiting for this inner block to complete,
                // inner block won't start before outer block finishes
                // => deadlock
            }
            // this will never be reached
        }
    }
    
    //MARK:- Initial Setup Methods
    private func initDataSource() {
        imageArr = [["name":"1","type":0],["name":"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4","type":1],["name":"2","type":0],["name":"3","type":0],["name":"4","type":0],["name":"5","type":0],["name":"6","type":0],["name":"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4","type":1],["name":"","type":2]]
    }
    
    private func configureCollectionView() {
        
        photosCollectionView?.delegate = self
        photosCollectionView?.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
        cell.imageView?.image = UIImage.init(named : "file")
        cell.avPlayerLayer?.removeFromSuperlayer()
        cell.pdfView?.removeFromSuperview()

        let dict = imageArr[indexPath.row]
        let dataType = dict["type"] as? Int
        if dataType == 0 {
            cell.setImageWithName(dict["name"] as? String ?? "")
        }else if dataType == 1 {
            cell.playVideoWithUrl(dict["name"] as? String ?? "")
        }else if dataType == 2 {
            cell.loadPdf()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PhotosCollectionViewCell {
            cell.avPlayer?.pause()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    // FIXME: - fix updating width/height when rotating screen
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = CGFloat(itemsInRow)
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}


