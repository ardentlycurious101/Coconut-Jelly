//
//  JellyViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 12/5/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import MapKit

protocol Injectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}

class JellyViewController: UIViewController {
    
    @IBOutlet weak var jellyEmoji: UILabel!
    @IBOutlet weak var jellyTitle: UILabel!
    @IBOutlet weak var jellyTags: UILabel!
    @IBOutlet weak var jellyDescription: UILabel!
    @IBOutlet weak var jellyTime: UILabel!
    @IBOutlet weak var jellyLocation: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var jellyCreatorName: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var creatorNameView: UIView!
    
    @IBAction func mapButtonTapped(_ sender: Any) {
        let regionDistance:CLLocationDistance = 1000
        let coordinates = jelly.coordinate
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = jelly.title
        mapItem.openInMaps(launchOptions: options)
    }
    
    private var jelly: Jelly!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
    }
    
    
    func configureLabels() {
        configureDetailsLabels()
        configureTimeLabel()
        configureLocation()
    }
    
    func configureDetailsLabels() {
        jellyEmoji.text = jelly.emoji
        jellyTitle.text = jelly.title!
        jellyTags.text = jelly.combineTags()
        jellyDescription.text = jelly.description
        jellyCreatorName.text = jelly.creatorName
    }
    
    func configureTimeLabel() {
        // separate start date time components
        let start = getDateTimeComponents(for: jelly.startTime)
        let end = getDateTimeComponents(for: jelly.endTime)
        
        // if same date
        if start[0] == end[0] {
            jellyTime.text = start[0] + "\n" + start[1] + " to " + end[1]
        } else {
            jellyTime.text = start[0] + "\n" + start[1] + " to \n" + end[0] + "\n" + end[1]
        }
    }
    
    func getDateTimeComponents(for jellyDateTime: Date) -> [String] {
        
        // initialize formatter
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        // format time
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: jellyDateTime)
        
        // format date
        let template = "EEEEdMMM"
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)
        formatter.dateFormat = format
        let date = formatter.string(from: jellyDateTime)

        return [date, time]
    }
    
    func configureLocation() {
        
        let region = MKCoordinateRegion(center: jelly.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        mapView.setRegion(region, animated: true)
        mapView.centerCoordinate = jelly.coordinate
        mapView.isUserInteractionEnabled = false
        
        jellyLocation.text = ""
        
    }
    
    
    func configureUI() {
        
        // adjust corner radius
        titleView.layer.cornerRadius = titleView.frame.height/10
        titleView.clipsToBounds = true
        
        tagView.layer.cornerRadius = tagView.frame.height/10
        tagView.clipsToBounds = true
        
        descriptionView.layer.cornerRadius = descriptionView.frame.height/10
        descriptionView.clipsToBounds = true
        
        timeView.layer.cornerRadius = timeView.frame.height/10
        timeView.clipsToBounds = true
        
        locationView.layer.cornerRadius = locationView.frame.height/10
        locationView.clipsToBounds = true
        
        mapView.layer.cornerRadius = mapView.frame.height/10
        mapView.clipsToBounds = true
        
        imagesView.layer.cornerRadius = imagesView.frame.height/10
        imagesView.clipsToBounds = true
         
//        collectionView.layer.cornerRadius = collectionView.frame.height/10
//        collectionView.clipsToBounds = true
          
        creatorNameView.layer.cornerRadius = creatorNameView.frame.height/10
        creatorNameView.clipsToBounds = true

    }
    
}

extension JellyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jelly.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jellyImageCell", for: indexPath) as! CollectionViewCell
        
        cell.handleSelectedImage(for: (jelly.images[indexPath.row]))
        
        return cell
    }
    
    
}


