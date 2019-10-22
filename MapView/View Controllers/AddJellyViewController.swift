//
//  AddJelly.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import WSTagsField

class AddJellyViewController: UIViewController {
    
    @IBOutlet weak var JellyEmoji: UITextField!
    @IBOutlet weak var JellyName: UITextField!
    @IBOutlet weak var JellyDescription: UITextField!
    @IBOutlet weak var JellyTags: WSTagsField!
    
    @IBOutlet weak var StartTime: UIDatePicker!
    @IBOutlet weak var EndTime: UIDatePicker!
    
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    
    @IBOutlet weak var MapView: MKMapView!
    
    @IBOutlet weak var createJellyButton: UIButton!
    @IBOutlet weak var JellyCreatorDisplayName: UITextField!
    
    
    @IBAction func CreateJellyTapped(_ sender: Any) {
        
        // check if all fields are filled
        guard let emoji = JellyEmoji.text, emoji.count == 1 else {
            remindUserToFill("emoji")
            return
        }
        guard let name = JellyName.text, !name.isEmpty else {
            remindUserToFill("name")
            return
        }
        guard let description = JellyDescription.text, !description.isEmpty else {
            remindUserToFill("description")
            return
        }
        // TODO: Create guard statement for tags
        // TODO: Create guard statement for start time
//        guard let startTime =
        // TODO: Create guard statement for end time
        // TODO: Create guard statement for address
        // TODO: Create guard statement for coordinates from mapview
        
        guard let creatorDisplayName = JellyCreatorDisplayName.text, !creatorDisplayName.isEmpty else {
            remindUserToFill("display name")
            return
        }
        
        // reference Firestore
        // upon successfull networking call: insert new entry in cloud database
        // else: print error

        let _ = Firestore.firestore().collection("Jellies").addDocument(data: ["emoji" : JellyEmoji.text!, "name" : JellyName.text!, "startTime" : StartTime.date, "endTime" : EndTime.date]) { (error) in
            
            if let error = error {
                
                // debug
                print("there's an error when saving data: \(error.localizedDescription).")
                
                // inform user data saving error
                let alert = UIAlertController.init(title: "Error", message: "An error occurred when trying to save Jelly due to \(error.localizedDescription)", preferredStyle: .alert)
                let okay = UIAlertAction.init(title: "OK", style: .default)
                alert.addAction(okay)
                
                self.present(alert, animated: true)
                
            } else {
                print("successfully saved data to cloud database.")
                
                // present alert to inform user that jelly was successfully created and saved to database
                let alert = UIAlertController.init(title: "Success!", message: "Successfully created and saved a new Jelly.", preferredStyle: .alert)
                let okay = UIAlertAction.init(title: "OK", style: .default)
                alert.addAction(okay)
                self.present(alert, animated: true)
                
                // clear all text fields
                self.clearAllTextFields()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTagField()
    }
    
    func remindUserToFill(_ textFieldRequiredInput: String) {
        let okay = UIAlertAction.init(title: "OK", style: .default)
        let alert = UIAlertController.init(title: "Missing Jelly Information", message: "Please enter Jelly \(textFieldRequiredInput).", preferredStyle: .alert)
        alert.addAction(okay)
        self.present(alert, animated: true) {}
    }
    
    func configureUI() {
        createJellyButton.layer.cornerRadius = 25
    }
    
    func clearAllTextFields() {
        JellyEmoji.text = ""
        JellyName.text = ""
        JellyDescription.text = ""
        
        StartTime.date = Date()
        EndTime.date = Date()
        
        JellyCreatorDisplayName.text = ""
    }
    
    func configureTagField() {
        
//        JellyTags.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        JellyTags.selectedColor = .red
        JellyTags.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        JellyTags.spaceBetweenLines = 10
        JellyTags.spaceBetweenTags = 5
        JellyTags.placeholder = "Add tags"
        JellyTags.font = .systemFont(ofSize: 14.0)
        
        
//        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
//        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        tagsField.spaceBetweenLines = 50.0
//        tagsField.spaceBetweenTags = 25.0
//        tagsField.font = .systemFont(ofSize: 12.0)
//        tagsField.backgroundColor = .white
//        tagsField.tintColor = .green
//        tagsField.textColor = .black
//        tagsField.fieldTextColor = .blue
//        tagsField.selectedColor = .black
//        tagsField.selectedTextColor = .red
//        tagsField.delimiter = ","
//        tagsField.isDelimiterVisible = true
//        tagsField.placeholderColor = .green
//        tagsField.placeholderAlwaysVisible = true
//        tagsField.keyboardAppearance = .dark
//        tagsField.returnKeyType = .next
//        tagsField.acceptTagOption = .space
    }

}

extension AddJellyViewController: UITextFieldDelegate {

}
