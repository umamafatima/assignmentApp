//
//  PhotosCollectionViewCell.swift
//  AssignmentSampleApp
//
//  Created by Umama Fatmah on 28/08/19.
//  Copyright © 2019 Freshworks. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import WebKit

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView?
    
    var avPlayer : AVPlayer?
    var avPlayerLayer : AVPlayerLayer?
    
    var pdfView : WKWebView?
    
    //MARK:- Lifecycle
    override func awakeFromNib() {
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if avPlayerLayer != nil {
            avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        }
        if pdfView != nil {
            pdfView?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        }
    }
    
    //MARK:- Functions
    func updateUI() {
        imageView?.contentMode = .scaleAspectFill
    }
    
    func setImageWithName(_ imageName : String) {
        imageView?.image = UIImage.init(named: imageName)
    }
    
    func playVideoWithUrl(_ url : String) {
        
        let item = AVPlayerItem(url: URL(string: url)!)
        
        avPlayer = AVPlayer(playerItem: item)
        avPlayer?.actionAtItemEnd = .none
        
        avPlayerLayer = AVPlayerLayer(player:avPlayer)
        avPlayerLayer?.videoGravity = .resizeAspectFill
        
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        imageView?.layer.addSublayer(avPlayerLayer ?? AVPlayerLayer())
        
        avPlayer?.play()
    }
    
    func loadPdf() {
        
        if let pdfURL = Bundle.main.url(forResource: "DocumentsReq", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            
            do {
                let data = try Data(contentsOf: pdfURL)
                let url = Bundle.main.bundleURL
                pdfView = WKWebView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
                pdfView?.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL:url)
                addSubview(pdfView ?? UIView())
            }
            catch {
                // catch errors here
            }
        }
    }
}
