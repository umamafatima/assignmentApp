//
//  TextEditorViewController.swift
//  AssignmentSampleApp
//
//  Created by Umama Fatmah on 29/08/19.
//  Copyright © 2019 Freshworks. All rights reserved.
//

import UIKit

class TextEditorViewController: UIViewController {

    @IBOutlet var editableTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Actions
    @IBAction func makeBold(_ sender: Any) {
        setUpTrait("bold")
    }
    
    @IBAction func makeItalics(_ sender: Any) {
        setUpTrait("italics")
    }
    
    @IBAction func insertImage(_ sender: Any) {
        var attributedString :NSMutableAttributedString!
        attributedString = NSMutableAttributedString(attributedString:editableTextView.attributedText)
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage.init(named: "1")
        
        let oldWidth = textAttachment.image!.size.width;
        
        //Subtracting 10px to make the image display nicely, accounting
        //for the padding inside the textView
        
        let scaleFactor = oldWidth / (editableTextView.frame.size.width - 10);
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.insert(attrStringWithImage, at: editableTextView.selectedRange.lowerBound)
        editableTextView.attributedText = attributedString;
    }

    func setUpTrait(_ trait : String) {
        let selectedRange = editableTextView.selectedRange
        
        let currentAttributesDict = editableTextView.textStorage.attributes(at: selectedRange.location, effectiveRange: nil)
        
        let currentFont = currentAttributesDict[.font] as? UIFont
        
        let fontDescriptor = currentFont?.fontDescriptor
        let changedFontDescriptor = fontDescriptor?.withSymbolicTraits(trait == "bold" ? .traitBold
            : .traitItalic)
        
        var updatedFont: UIFont? = nil
        if let changedFontDescriptor = changedFontDescriptor {
            updatedFont = UIFont(descriptor: changedFontDescriptor, size: 0.0)
        }
        let dict = [
            NSAttributedString.Key.font: updatedFont
        ]
        
        editableTextView.textStorage.beginEditing()
        editableTextView.textStorage.setAttributes(dict as [NSAttributedString.Key : Any], range: selectedRange)
        editableTextView.textStorage.endEditing()
    }
}
