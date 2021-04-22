//
//  TableViewController.swift
//  TO_Do_App
//
//  Created by Gaurav Aryal on 2/17/20.
//  Copyright © 2020 Gaurav Aryal. All rights reserved.
//

import UIKit
import os.log

class TableViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
//MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var doneToggle: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var item:Item?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        //navigationItem.leftBarButtonItem = editButtonItem
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        
      
        if let item = item {
                   navigationItem.title = item.name
                   nameTextField.text   = item.name
                    dateLabel.text = item.date
                    datePicker.date = item.dateobject ?? Foundation.Date()
                    doneToggle.isOn = item.completed
           }
       
        updateSaveButtonState()
        // Set up views if editing an existing Meal.
      
    }
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    private func updateSaveButtonState() {
        //Disable the save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
    }
    // Mark: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TableViewController is not inside a navigation controller.")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        var date = dateLabel.text ?? ""
        var dateobject = datePicker.date
        let completed = doneToggle.isOn
        item = Item(name: name, date: date, dateobject: datePicker.date , completed: completed )
        
        
    }
    @IBAction func datePickerChanged(_ sender: Any) {
        //let date = Date()
        var strDate : String?
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        //strDate = dateFormatter.string(from: date)
        strDate = dateFormatter.string(from: datePicker.date)
        dateLabel.text = strDate
       
        item?.dateobject = datePicker.date
        nameTextField.resignFirstResponder()
        }
   
    func textFieldDidBeginEditing(_ textField:UITextField){
        //Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

//MARK: actions
}

