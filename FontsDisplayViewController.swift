//
//  FontsDisplayViewController.swift
//  Elegant-Code-Pro
//
//  Created by Josef Pan on 19/5/20.
//  Copyright © 2020 Josef Pan. All rights reserved.
//

import Cocoa

/// The 2nd VC to display all fonts in a window which is started by class **ViewController**
class FontsDisplayViewController: NSViewController {
    // MARK: Properties
    var fontFamily: String?
    var fontFamilyMembers: [[Any]] = []
    // MARK: Outlets
    @IBOutlet var fontsTextView: NSTextView!
    // MARK: Required functions
    override func viewDidLoad() {   //--------------------------------------------------------------------------------⚓️
        super.viewDidLoad()
    }       // No actions, just stub
    override func viewWillAppear() {    //--------------------------------------------------------------------------✅⚓️
        super.viewWillAppear()
        self.intializeTextView(); self.showFonts()
    }   // ✅, some init actions
    // MARK: Actions
    @IBAction func closeWindow(_ sender: Any) { //--------------------------------------------------------------------🚙
        view.window?.close()
    }
}
//----------------------------------------------------------------------------------------------------------------------
extension FontsDisplayViewController {  // Private local functions
    private func intializeTextView(){   //----------------------------------------------------------------------------🧡
        fontsTextView.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        fontsTextView.enclosingScrollView?.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        fontsTextView.isEditable = false
        fontsTextView.enclosingScrollView?.autohidesScrollers = true
    }
    
    private func showFonts() {  //------------------------------------------------------------------------------------🧡
        guard let fontFamily = fontFamily else { return }
        var fontPostscriptNames = ""
        var lengths:[Int] = []
        for member in fontFamilyMembers {
            guard let postscript = member[0] as? String else { continue }
            fontPostscriptNames += "\(postscript)\n"
            lengths.append(postscript.count)
        }
        let attributedString = NSMutableAttributedString(string: fontPostscriptNames)
        for (index, member) in fontFamilyMembers.enumerated() {
            guard let weight = member[2] as? Int, let traits = member[3] as? UInt else { continue }
            guard let font = NSFontManager.shared.font(withFamily: fontFamily,
                                                       traits: NSFontTraitMask(rawValue: traits),
                                                       weight: weight,
                                                       size: 19.0) else { continue }
            var location = 0
            let loopScope = index > 0 ? index : 0
            for i in 0..<loopScope {
                location += lengths[i] + 1
            }
            let range = NSMakeRange(location, lengths[index])
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
            fontsTextView.textStorage?.setAttributedString(attributedString)
        }
    }
}   // Private local functions
