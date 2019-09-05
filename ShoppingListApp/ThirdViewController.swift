//
//  ThirdViewController.swift
//  ShoppingListApp
//
//  Created by Milan Petrovic on 24/10/18.
//  Copyright © 2018 Milan Petrovic. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var selectedColourView: UIView!
    @IBOutlet weak var colourSlider: UISlider!
    
     let colourArray = [0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff]
    func uiColorFromHex(rgbValue: Int) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue = CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    @IBAction func sliderChanged(_ sender: Any) {
        selectedColourView.backgroundColor = uiColorFromHex(rgbValue: colourArray[Int(colourSlider.value)])
    }
    
    @IBAction func changedClicked(_ sender: UIButton) {
        Colour.sharedInstance.selectedColour = uiColorFromHex(rgbValue: colourArray[Int(colourSlider.value)])
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
