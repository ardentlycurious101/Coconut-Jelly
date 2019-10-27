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
    
    @IBOutlet weak var JellyEmoji: TextField!
    @IBOutlet weak var JellyName: TextField!
    @IBOutlet weak var JellyDescription: UITextView!
    @IBOutlet weak var JellyTags: WSTagsField!
    
    
    @IBOutlet weak var StartTime: UIDatePicker!
    @IBOutlet weak var EndTime: UIDatePicker!
    
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    
    @IBOutlet weak var JellyLocation: TextField!
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var JellyCreatorDisplayName: TextField!
    
    @IBOutlet weak var createJellyButton: UIButton!
    
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
        
//         Reference Firestore
//         upon successfull networking call: insert new entry in cloud database
//         else: print error
        
        print("List of Tags Strings:", JellyTags.tags.map({$0.text}))

        let _ = Firestore.firestore().collection("Jellies").addDocument(data: ["emoji" : JellyEmoji.text!, "name" : JellyName.text!, "description": JellyDescription.text!, "tags": JellyTags.tags.map({$0.text}), "startTime" : StartTime.date, "endTime" : EndTime.date, "creatorName": JellyCreatorDisplayName.text!]) { (error) in
            
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
    }
    
    func remindUserToFill(_ textFieldRequiredInput: String) {
        let okay = UIAlertAction.init(title: "OK", style: .default)
        let alert = UIAlertController.init(title: "Missing Jelly Information", message: "Please enter Jelly \(textFieldRequiredInput).", preferredStyle: .alert)
        alert.addAction(okay)
        self.present(alert, animated: true) {}
    }
    
    func configureUI() {
        createJellyButton.layer.cornerRadius = 25
        configureTextFieldUI()
        configureMapView()
        configureImageCollectionView()
        configureTagField()
        configureJellyDescription()
    }
    
    func configureImageCollectionView() {
        ImageCollectionView.layer.cornerRadius = ImageCollectionView.frame.height/10
    }
    
    func configureMapView() {
        MapView.layer.cornerRadius = MapView.frame.height/10
    }
    
    func configureTextFieldUI() {
        JellyEmoji.configureUI()
        JellyName.configureUI()
        JellyCreatorDisplayName.configureUI()
        JellyLocation.configureUI()
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
        
        JellyTags.selectedColor = .red
        JellyTags.layoutMargins = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        JellyTags.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        JellyTags.spaceBetweenLines = 12
        JellyTags.spaceBetweenTags = 5
        JellyTags.placeholder = "Add tags, then press return"
        JellyTags.font = .systemFont(ofSize: 14.0, weight: .regular)

        JellyTags.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        JellyTags.fieldTextColor = .black
        JellyTags.textColor = .white
        JellyTags.tintColor = UIColor(red: 104, green: 203, blue: 240)
        JellyTags.selectedTextColor = .black
        JellyTags.selectedColor = UIColor(red: 228, green: 71, blue: 60)
        JellyTags.delimiter = " "
        JellyTags.isDelimiterVisible = false
        JellyTags.layer.cornerRadius = JellyTags.frame.height/10
        JellyTags.clipsToBounds = true
        
    }

}

extension AddJellyViewController: UITextFieldDelegate {
    
}

extension AddJellyViewController: UITextViewDelegate {
    
    func configureJellyDescription() {
        JellyDescription.contentInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        JellyDescription.text = "Jelly Description"
        JellyDescription.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        JellyDescription.font = .systemFont(ofSize: 14.0, weight: .regular)
        JellyDescription.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        JellyDescription.returnKeyType = .done
        JellyDescription.layer.cornerRadius = JellyDescription.frame.height/10
        JellyDescription.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if let text = textView.text {
            if text == "Jelly Description" {
                JellyDescription.text = ""
                JellyDescription.textColor = .black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text, text.isEmpty {
            JellyDescription.text = "Jelly Description"
            JellyDescription.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
