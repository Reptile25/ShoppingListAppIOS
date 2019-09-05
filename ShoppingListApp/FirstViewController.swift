//
//  FirstViewController.swift
//  ShoppingListApp
//
//  Created by Milan Petrovic on 17/10/18.
//  Copyright © 2018 Milan Petrovic. All rights reserved.
//

import UIKit
import SQLite3

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeArray[row] as String
    }
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var qtyTextField: UITextField!
    
    
    @IBAction func addClicked(_ sender: Any) {
        var itemName: String?
        var itemPrice: Double?
        var itemType: String?
        var itemQty: Int?
        
        itemName = itemNameTextField.text
        itemPrice = NSString(string: priceTextField.text!).doubleValue
        itemType = typeArray[typePickerView.selectedRow(inComponent: 0)]
        itemQty = NSString(string: qtyTextField.text!).integerValue
        
        
        if (itemNameTextField.text! == ""){
            let alertController = UIAlertController (title: "Insert Failed", message: "Item Name cannot be empty", preferredStyle:.alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (priceTextField.text! == "") {
            let alertController = UIAlertController (title: "Insert Failed", message: "Item Price cannot be empty", preferredStyle:.alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (itemPrice! <= 0.001) {
            let alertController = UIAlertController (title: "Insert Failed", message: "Item Price must be more than 0", preferredStyle:.alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (qtyTextField.text! == "") {
            let alertController = UIAlertController (title: "Insert Failed", message: "Quantity cannot be empty", preferredStyle:.alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (itemQty! == 0) {
            let alertController = UIAlertController (title: "Insert Failed", message: "Quantity cannot be 0", preferredStyle:.alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            print(itemType!)
            insertQuery(itemName: itemName!, price: itemPrice!, type: itemType!, qty: itemQty!)
            let s = Shopping(item: itemName!, price: itemPrice!, type: itemType!, qty: itemQty!)
            appDelegate.shoppingArray.append(s);
            
            //statusLabel.text = "Record Added"
            let alertController = UIAlertController (title: "Record Added!!!", message: "Data has been added to List", preferredStyle:.alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            
            itemNameTextField.text = ""
            priceTextField.text = ""
            qtyTextField.text = ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db: OpaquePointer? = nil
    var typeArray: [String] = ["Groceries", "Electronics", "Clothing", "Other"]
    
    func insertQuery(itemName:String, price:Double, type:String, qty:Int) {
        let insertSQL = "INSERT INTO shoppinglist(itemName, itemPrice, itemType, Quantity) VALUES ('\(itemName)', \(price), '\(type)', '\(qty)')"
        print(insertSQL)
        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK {
            print("Successfully Opened connection to Database")
            if (sqlite3_prepare_v2(db, insertSQL, -1, &queryStatement, nil) == SQLITE_OK) {
                if sqlite3_step(queryStatement) == SQLITE_DONE {
                    print("Record Inserted!")
                    //statusLabel.text = "Record Inserted!!!"
                    
                }
                else{
                    print("Fail to Insert...")
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                print("Insert statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
        }
    }


}

