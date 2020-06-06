//
//  ViewController.swift
//  Elegant-Code-Pro-Test
//
//  Created by Josef Pan on 18/5/20.
//  Copyright © 2020 Josef Pan. All rights reserved.
//

import Cocoa

/// The 1st VC with 2 *PopupButtons*, 1 *Label* and 1 *Button*
class ViewController: NSViewController {
    // MARK: Properties
    var selectedFontFamily: String?
    var fontFamilyMembers: [[Any]] = []
    // MARK: Outlets
    @IBOutlet weak var fontFamiliesPopup: NSPopUpButton!
    @IBOutlet weak var fontTypesPopup: NSPopUpButton!
    @IBOutlet weak var sampleLabel: NSTextField!
    
    override func viewDidLoad() {   //--------------------------------------------------------------------------------⚓️
        super.viewDidLoad()
    }                   // No actions, just stub
    
    override func viewWillAppear() {    //----------------------------------------------------------------------------⚓️
        super.viewWillAppear()
        self.initializeUI(); self.populateFontFamilies()
    }                // ✅, some init actions
    
    override var representedObject: Any? {  //------------------------------------------------------------------------⚓️
        didSet {
        // Update the view, if already loaded.
        }
    }          // No actions, just stub
    
    /// Action when button  **Display All** is pressed
    @IBAction func displayAllFonts(_ sender: Any) { //----------------------------------------------------------------🚙
        let storyboardName = NSStoryboard.Name(stringLiteral: "Main")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "fontsDisplayStoryboardID")
        guard let fontsDisplayWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController
            else { return }
        guard let fontsDisplayVC = fontsDisplayWindowController.contentViewController as? FontsDisplayViewController
            else { return }
        fontsDisplayVC.fontFamily = selectedFontFamily
        fontsDisplayVC.fontFamilyMembers = fontFamilyMembers
        fontsDisplayWindowController.showWindow(nil)
    }
    /// Action when button  **First Popupbutton** is pressed
    @IBAction func handleFontFamilySelection(_ sender: Any) {   //----------------------------------------------------🚙
        guard let fontFamily = fontFamiliesPopup.titleOfSelectedItem else { return }
        selectedFontFamily = fontFamily
        guard let members = NSFontManager.shared.availableMembers(ofFontFamily: fontFamily) else { return }
        fontFamilyMembers.removeAll(); fontFamilyMembers = members; updateFontTypesPopup()
        view.window?.title = fontFamily
    }
    /// Action when button  **Second Popupbutton** is pressed
    @IBAction func handleFontTypeSelection(_ sender: Any) {     //----------------------------------------------------🚙
        let selectedMember = fontFamilyMembers[ fontTypesPopup.indexOfSelectedItem ]
        guard let postscriptName = selectedMember[0] as? String else { return }
        guard let weight = selectedMember[2] as? Int else { return }
        guard let traits = selectedMember[3] as? UInt else { return }
        guard let fontfamily = selectedFontFamily else { return }
        let font = NSFontManager.shared.font(withFamily: fontfamily,
                                             traits: NSFontTraitMask(rawValue: traits),
                                             weight: weight,
                                             size: 19.0)
        sampleLabel.font = font
        sampleLabel.stringValue = postscriptName
    }
    
}

extension ViewController {          // Private local functions
    
    private func initializeUI(){    //--------------------------------------------------------------------------------🧡
        fontFamiliesPopup.removeAllItems(); fontTypesPopup.removeAllItems()
        sampleLabel.stringValue = ""; sampleLabel.alignment = .center
    }
    
    private func populateFontFamilies() {   //------------------------------------------------------------------------🧡
        fontFamiliesPopup.removeAllItems()
        fontFamiliesPopup.addItems(withTitles: NSFontManager.shared.availableFontFamilies)
        handleFontFamilySelection(self)
    }
    
    private func updateFontTypesPopup() {   //------------------------------------------------------------------------🧡
        fontTypesPopup.removeAllItems()
        fontFamilyMembers.forEach{ if let fontType = $0[1] as? String { fontTypesPopup.addItem(withTitle: fontType) } }
    }
}   // Private local functions
