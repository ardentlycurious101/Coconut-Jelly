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
    
    var testData = ["brian", "dionigi", "raymond", "boyfriend", "lover", "best friend"]
    
    // MARK:- Variables
    
    let regionInMeters: Double = 1000
    var locationAdded: Bool = false
    var emojiWC = 1
    var nameWC = 40
    var descriptionWC = 140
    var tagWC = 10
    var imageWC = 10
    var creatorNameWC = 40
    
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: Jelly Description View
    
    @IBOutlet weak var TitleAddJellyVC: UILabel!
    @IBOutlet weak var JellyEmoji: TextField!
    @IBOutlet weak var JellyName: TextField!
    @IBOutlet weak var JellyDescription: UITextView!
    @IBOutlet weak var JellyTags: WSTagsField!
    
    @IBOutlet weak var JellyEmojiWordCount: UILabel!
    @IBOutlet weak var JellyNameWordCount: UILabel!
    @IBOutlet weak var JellyDescriptionWordCount: UILabel!
    @IBOutlet weak var JellyTagsWordCount: UILabel!
    @IBOutlet weak var JellyCollectionViewWordCount: UILabel!
    @IBOutlet weak var JellyCreatorNameWordCount: UILabel!
    
    @IBOutlet weak var StartTime: UIDatePicker!
    @IBOutlet weak var EndTime: UIDatePicker!
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    var images : [UIImage] = [UIImage(named: "green camera")!]
    
    // MARK: Jelly Location View
    
    @IBOutlet weak var JellyLocationButton: Button!
    @IBAction func addLocationButtonTapped(_ sender: Any) {
        locationAdded = true
    }
    @IBOutlet weak var MapAndImageView: UIView!
    @IBOutlet weak var MapView: MKMapView!
    
    @IBOutlet weak var PinImageView: UIImageView!
    @IBOutlet weak var ContentView: UIView!
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    // MARK: Creator Display Name View
    
    @IBOutlet weak var JellyCreatorDisplayName: TextField!
    
    // MARK: Create Jelly Button View
    
    @IBOutlet weak var createJellyButton: UIButton!
    @IBAction func CreateJellyTapped(_ sender: Any) {
        
//    // check if all fields are filled
//        guard let emoji = JellyEmoji.text,
//                emoji.isSingleEmoji else {
//            remindUserToFill("emoji")
//            return
//        }
//
//        guard let name = JellyName.text,
//                !name.isEmpty,
//                name.count < 41 else {
//            remindUserToFill("name")
//            return
//        }
//        guard let description = JellyDescription.text,
//                !description.isEmpty,
//                description.count < 141 else {
//            remindUserToFill("description")
//            return
//        }
//
//        // TODO: Create guard statement for tags
//        guard JellyTags.tags.map({$0.text}).count > 0,
//                JellyTags.tags.map({$0.text}).count < 11 else {
//            alertUserTagError()
//            return
//        }
//
//        // TODO: Create guard statement for end time >start time
//        guard StartTime.date < EndTime.date,
//                StartTime.date > Date() else {
//            print("alertUserInvalidTime() function")
//            alertUserInvalidTime()
//            return
//        }
//
//        guard images.count < 11 else {
//            alertUserImagesError()
//            return
//        }
//
//        guard locationAdded == true else {
//            remindUserToFill("location")
//            return
//        }
//
//        guard let creatorDisplayName = JellyCreatorDisplayName.text,
//                !creatorDisplayName.isEmpty,
//                creatorDisplayName.count < 41 else {
//            remindUserToFill("creator display name")
//            return
//        }
        
        // MARK:- Reference Firebase Storage
        
        // create unique identifier
        let JellyIdentifier = UUID().uuidString
        
        // get a reference to the storage service
        let storage = Storage.storage()
        
        // create a storage reference
        let storageRef = storage.reference()
        
        // create a child reference
        let imageReferencePath = String("JellyImages/\(JellyIdentifier)/")
        
//        var downloadURLs: [URL] = []

        for index in 1..<images.count {
            // translate images into data
            if let data = images[index].jpegData(compressionQuality: 0.8) {
                
                let imageCountFileName = String(index) + ".jpeg"
                let imagesRef = storageRef.child("JellyImages/\(JellyIdentifier)/\(imageCountFileName)")
                
                // upload task
                let _ = imagesRef.putData(data, metadata: nil) { (metadata, error) in
                    
                    guard error == nil else {
                        self.alertUserFailedToUploadImage()
                        return
                    }
                }
            }
        }
        
        print("this is images count: \(images.count)")
//        print("this is imagesRef: \(imagesRef)")
            
        // MARK:- Reference Cloud Firestore
        // upon successfull networking call: insert new entry in cloud database
        // else: print error
        
        let _ = Firestore.firestore().collection("Jellies").addDocument(data: ["ID" : JellyIdentifier, "emoji" : JellyEmoji.text!, "name" : JellyName.text!, "description": JellyDescription.text!, "tags": JellyTags.tags.map({$0.text}), "startTime" : StartTime.date, "endTime" : EndTime.date, "geopoint": GeoPoint(latitude: MapView.centerCoordinate.latitude, longitude: MapView.centerCoordinate.longitude), "referencePath" : imageReferencePath,"creatorName": JellyCreatorDisplayName.text!]) { (error) in

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
                self.clearAllFields()
                self.resetWordCount()
                self.MapView.reloadInputViews()
                self.images = []
            }
        }

    }

    // MARK:- View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDelegation()
        scrollView.keyboardDismissMode = .interactive
        configureTextFieldDelegation()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK:- Delegate Methods Extensions

extension AddJellyViewController: UITextViewDelegate {
    
    func configureJellyDescription() {
        configureJellyDescriptionUI()
        JellyDescription.delegate = self
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if let text = textView.text {
            if text == "Jelly Description" {
                JellyDescription.text = ""
                JellyDescription.textColor = .white
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        descriptionWC = 140 - textView.text!.count
        JellyDescriptionWordCount.text! = String(descriptionWC)
        
        if descriptionWC < 0 {
            JellyDescriptionWordCount.textColor = .red
        } else {
            JellyDescriptionWordCount.textColor = .lightGray
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
    }
    
}

extension AddJellyViewController: UITextFieldDelegate {
    
    func configureTextFieldDelegation() {
        JellyEmoji.delegate = self
        JellyName.delegate = self
        JellyCreatorDisplayName.delegate = self
    }
    
    // MARK: Text field did change
    
    @IBAction func emojiDidChange(_ sender: Any) {
           if let textField = sender as? UITextField {
               emojiWC = 1 - textField.text!.count
               JellyEmojiWordCount.text = String(emojiWC)
           }

           if emojiWC < 0 {
               JellyEmojiWordCount.textColor = .red
           } else {
               JellyEmojiWordCount.textColor = .lightGray
           }
       }
       
       @IBAction func nameDidChange(_ sender: Any) {
           if let textField = sender as? UITextField {
               nameWC = 40 - textField.text!.count
               JellyNameWordCount.text = String(nameWC)
           }
           
           if nameWC < 0 {
               JellyNameWordCount.textColor = .red
           } else {
               JellyNameWordCount.textColor = .lightGray
           }
       }
       
       @IBAction func creatorNameDidChange(_ sender: Any) {
           if let textField = sender as? UITextField {
               creatorNameWC = 40 - textField.text!.count
               JellyCreatorNameWordCount.text = String(creatorNameWC)
           }
           
           if creatorNameWC < 0 {
               JellyCreatorNameWordCount.textColor = .red
           } else {
               JellyCreatorNameWordCount.textColor = .lightGray
           }
       }

}

extension AddJellyViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        if images.count == 1 {
            images.append(image)
        } else if images.count > 1 {
            images.insert(image, at: 1)
        }
        
        // TODO: update collection view
        updateCollectionView()
    }
}

extension AddJellyViewController: UINavigationControllerDelegate { }

extension AddJellyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
//        if indexPath.row == 0 {
//            cell.configureDefaultImage()
//        } else {
//            cell.configureUI()
            cell.handleSelectedImage(for: images[indexPath.row])
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = testData[indexPath.row]
        print(text + ": \(indexPath.row)")
        
        if indexPath.row == 0 {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = ["public.image"]
            
            self.present(imagePicker, animated: true)
        } else if indexPath.row > 0 {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            
            cell.isDeleting = !cell.isDeleting
            
            if cell.isDeleting {
                cell.DeleteIcon.isUserInteractionEnabled = true
                let tap = DeleteTapGestureRecognizer(target: self, action: #selector(self.deleteIconTapped))
                tap.indexPath = indexPath
                tap.numberOfTapsRequired = 1
                cell.DeleteIcon.addGestureRecognizer(tap)
            } else {
                cell.DeleteIcon.isUserInteractionEnabled = false
            }
        }
    }
    
}

extension AddJellyViewController: MapViewCenter {
    
    func getMapViewCenter(_ centerCoordinate: CLLocationCoordinate2D) {
        print("we finally here -- we got hired as interns!")
        let center = centerCoordinate
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters/4, longitudinalMeters: regionInMeters/4)
        MapView.setRegion(region, animated: true)
    }
    
}

// MARK:- Helper Functions

extension AddJellyViewController {
    
    // MARK: Tap gesture recognizer
    
    @objc func deleteIconTapped(sender: DeleteTapGestureRecognizer) {
        let indexPath = sender.indexPath!
        images.remove(at: indexPath.row)
        ImageCollectionView.deleteItems(at: [indexPath])
        updateCollectionViewImageCount()
    }
    
    func configureDelegation() {
        JellyDescription.delegate = self
        JellyTags.delegate = self
    }
    
    // MARK: Configure UI for collection view, map view, text field, buttons
    
    func configureUI() {
        createJellyButton.layer.cornerRadius = 25
        ContentView.backgroundColor = GlobalBackgroundColor
        
        configureTextFieldUI()
        configureDatePickerUI()
        configureButtonUI()
        configureMapAndImageView()
        configureImageCollectionView()
        configureTagField()
        configureJellyDescription()
    }

    func configureImageCollectionView() {
        ImageCollectionView.layer.cornerRadius = ImageCollectionView.frame.height/10
        let layout = ImageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: ImageCollectionView.frame.height, height: ImageCollectionView.frame.height)
    }
    
    func configureMapAndImageView() {
        MapAndImageView.layer.cornerRadius = MapView.frame.height/10
        MapAndImageView.clipsToBounds = true
    }
    
    func configureTextFieldUI() {
        JellyEmoji.configureUI()
        JellyName.configureUI()
        JellyCreatorDisplayName.configureUI()
    }
    
    func configureButtonUI() {
        JellyLocationButton.configureUI()
    }
    
    func configureJellyDescriptionUI() {
        JellyDescription.contentInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        JellyDescription.text = "Jelly Description"
        JellyDescription.backgroundColor = GlobalBackgroundColor
        JellyDescription.font = UIFont(name: "Futura-Medium", size: 17.0)
        JellyDescription.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        JellyDescription.returnKeyType = .done
        JellyDescription.layer.cornerRadius = JellyDescription.frame.height/10
        JellyDescription.layer.borderWidth = 1.0
        JellyDescription.layer.borderColor = UIColor(patternImage: UIImage(named: "gradient")!).cgColor
    }
    
    func configureDatePickerUI() {
        StartTime.backgroundColor = GlobalBackgroundColor
        EndTime.backgroundColor = GlobalBackgroundColor
        
        StartTime.setValue(false, forKey: "highlightsToday")
        EndTime.setValue(false, forKey: "highlightsToday")
        
        StartTime.setValue(UIColor.white, forKey: "textColor")
        EndTime.setValue(UIColor.white, forKey: "textColor")
    }
    
    // MARK: Collection View for images
    
    func updateCollectionView() {
        updateCollectionViewImageCount()
        
        // Update collection view's cell
        ImageCollectionView.reloadData()
    }
    
    func updateCollectionViewImageCount() {
        imageWC = 10 - (images.count - 1)

        JellyCollectionViewWordCount.text = String(imageWC)
        if imageWC < 0 {
            JellyCollectionViewWordCount.textColor = .red
        } else {
            JellyCollectionViewWordCount.textColor = .lightGray
        }
    }
    
    // MARK: Reset VC after Jelly created
    
    func clearAllFields() {
        JellyEmoji.text = ""
        JellyName.text = ""
        configureJellyDescription()
        JellyTags.removeTags()
        
        StartTime.date = Date()
        EndTime.date = Date()
        
        JellyCreatorDisplayName.text = ""
    }
    
    func resetWordCount() {
        emojiWC = 1
        nameWC = 40
        descriptionWC = 140
        tagWC = 10
        imageWC = 10
        creatorNameWC = 40
        locationAdded = false
        
        JellyEmojiWordCount.text = String(emojiWC)
        JellyNameWordCount.text = String(nameWC)
        JellyDescriptionWordCount.text = String(descriptionWC)
        JellyTagsWordCount.text = String(tagWC)
        JellyCreatorNameWordCount.text = String(creatorNameWC)
    }
    
    // MARK: Configure UI
    
    func configureTagField() {
        
        JellyTags.selectedColor = .red
        JellyTags.layoutMargins = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        JellyTags.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        JellyTags.spaceBetweenLines = 12
        JellyTags.spaceBetweenTags = 5
        JellyTags.placeholder = "Add tags, then press return"
        JellyTags.placeholderColor = UIColor.lightGray.withAlphaComponent(0.7)
        JellyTags.font = UIFont(name: "Futura-Medium", size: 17.0)

//        JellyTags.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        JellyTags.backgroundColor = GlobalBackgroundColor
        JellyTags.fieldTextColor = .white
        JellyTags.textColor = .black
        JellyTags.tintColor = UIColor(patternImage: UIImage(named: "gradient")!)
        JellyTags.selectedTextColor = .black
        JellyTags.selectedColor = UIColor(red: 228, green: 71, blue: 60)
        JellyTags.delimiter = " "
        JellyTags.isDelimiterVisible = false
        JellyTags.layer.cornerRadius = JellyTags.frame.height/10
        JellyTags.layer.borderWidth = 1.0
        JellyTags.layer.borderColor = UIColor(patternImage: UIImage(named: "gradient")!).cgColor
        JellyTags.clipsToBounds = true
        
        JellyTags.onDidAddTag = { field, tag in
            self.changeTagWordCountLabel()
        }
        
        JellyTags.onDidRemoveTag = { field, tag in
            self.changeTagWordCountLabel()
        }
    }
    
    func changeTagWordCountLabel() {
        tagWC = 10 - JellyTags.tags.map({$0.text}).count
        JellyTagsWordCount.text = String(tagWC)
        
        if tagWC < 0 {
            JellyTagsWordCount.textColor = .red
        } else {
            JellyTagsWordCount.textColor = .lightGray
        }
    }
    
    // MARK: Alert User
    
    func alertUserFailedToUploadImage() {
        let alert = UIAlertController(title: nil, message: "Error Uploading Images", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true) {}
    }
    
    func remindUserToFill(_ textFieldRequiredInput: String) {
        let okay = UIAlertAction.init(title: "OK", style: .default)
        let alert = UIAlertController.init(title: "Invalid/Missing Jelly Information", message: "Please enter Jelly \(textFieldRequiredInput) with valid length.", preferredStyle: .alert)
        alert.addAction(okay)
        self.present(alert, animated: true) {}
    }
    
    func alertUserInvalidTime() {
        let okay = UIAlertAction.init(title: "OK", style: .default)
        let alert = UIAlertController.init(title: "Invalid time information", message: "Please enter valid time. End time must be later than start time.", preferredStyle: .alert)
        alert.addAction(okay)
        self.present(alert, animated: true) {}
    }
    
    func alertUserTagError() {
        let okay = UIAlertAction.init(title: "OK", style: .default)
        let alert = UIAlertController.init(title: "Invalid number of tags", message: "Please enter valid number of tags, i.e. 1-10 tags.", preferredStyle: .alert)
        alert.addAction(okay)
        self.present(alert, animated: true) {}
    }
    
    func alertUserImagesError() {
        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: "Images Error", message: "Please select not more than 10 images.", preferredStyle: .alert)
        alert.addAction(OK)
        self.present(alert, animated: true)
    }
    
    // MARK: Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? UINavigationController {
            if segue.identifier == "SearchLocationSegue" {
                slideInTransitioningDelegate.direction = .bottom
                controller.transitioningDelegate = slideInTransitioningDelegate
                controller.modalPresentationStyle = .custom
                let targetController = controller.topViewController as? SearchLocationViewController
                targetController?.centerDelegate = self
            }
        }
    }
}

class DeleteTapGestureRecognizer: UITapGestureRecognizer {
    var indexPath: IndexPath?
}
