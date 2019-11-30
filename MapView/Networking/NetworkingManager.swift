//
//  NetworkingManager.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/24/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import GeoFire
import Firebase
import MapKit
import CoreData

class NetworkingManager {
    
    func getJelliesWithinRegion(within map: MKMapView, completion: @escaping (Bool, Any?, Error?) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let ref = Database.database().reference().child("Jellies")
            let geoFire = GeoFire(firebaseRef: ref)
            var jelliesToFetch: [String] = []
            
            // perform networking call to get region of map, get all geolocations in region from geofire
        
            let regionQuery = geoFire.query(with: map.region)
            let _ = regionQuery.observe(.keyEntered, with: { (key, location) in
                let key = String(describing: key)
                jelliesToFetch.append(key)
            })
            
            // query finished executing
        
            regionQuery.observeReady({
        
                // Perform networking call to retrieve all the keys from firestore
                // Map the Firebase promises into an array
                
                // Map the Firebase promises into an array

                let firestoreRef = Firestore.firestore().collection("Jellies")

                for jelly in jelliesToFetch {
                    let _ = firestoreRef.whereField("id", isEqualTo: jelly).getDocuments(completion: { (snapshot, error) in
                        if error != nil {
                            print("Error getting documents!")
                            completion(false, nil, error)
                            return
                        } else {
                            print("successfully retrieve documents!")
                            
                            for document in snapshot!.documents {
                                let data = document.data()

                                // create Jellies asynchronously with completion handler to update UI
                                createJellies(with: data)
                                
                                    // write Jellies to CoreData
                                    
                                    // render Jellies on Map
                                
                            }
                        }
                    })
                }
                completion(true, jelliesToFetch, nil)
            })
        }

    }

    // retrieve all the locations from firestore

    // decode JSON into Core Data Entities

}

func createJellies(with data: [String : Any]) {
    
    guard let id = data["id"] else {
        print("id is nil")
        return
    }
    
    guard let emoji = data["emoji"] else {
        print("emoji is nil")
        return
    }

    guard let title = data["name"] else {
        print("title is nil")
        return
    }

    guard let tags = data["tags"] as? [String] else {
        print("tags is nil")
        return
    }

    guard let description = data["description"] else {
        print("description is nil")
        return
    }

    guard let startTime = data["startTime"] else {
        print("startTime is nil")
        return
    }

    guard let endTime = data["endTime"] else {
        print("endTime is nil")
        return
    }

    guard let referencePath = data["referencePath"] else {
        print("referencePath is nil")
        return
    }

    guard let geopoint = data["geopoint"] else {
        print("geopoint is nil")
        return
    }
    
    guard let creatorName = data["creatorName"] else {
        print("creatorName is nil")
        return
    }

    // If no fields are nil, create Jelly in Core Data
    let persistentManager = PersistentManager.shared
    let jelly = Jellies(context: persistentManager.context)
    let jelliesTag = JelliesTags(tags: tags)
    
        jelly.id = UUID(uuidString: id as! String)!
        jelly.emoji = emoji as? String
        jelly.title = title as? String
        jelly.tags = jelliesTag
        jelly.jellyDescription = description as? String
        jelly.creatorName = creatorName as? String

        // Convert time into Date from Firebase
        let startTimestamp = startTime as? Timestamp
        let start = startTimestamp?.dateValue()
        jelly.startTime = start

        let endTimestamp = endTime as? Timestamp
        let end = endTimestamp?.dateValue()
        jelly.endTime = end
        
        // Get latitude and longitude from geopoint
        let coordinates = geopoint as! GeoPoint
        jelly.latitude = coordinates.latitude
        jelly.longitude = coordinates.longitude

        // Get images from Storage using reference path
        let refPath = referencePath as! String
        getImageFromStorage(with: refPath) { (success, image, error) in
            if success {
                if jelly.images != nil {
                    var images = jelly.value(forKey: "images") as! [Data]
                    images.append(image!)
                    jelly.setValue(images, forKey: "images")
                    persistentManager.save()
                } else {
                    jelly.images = [image!]
                    persistentManager.save()
                }
            } else {
                print("Error fetching image(s): \(error!).Oops!!!")
            }
        }
        persistentManager.save()
    
    DispatchQueue.main.async {
        
        //render jellies on map
        renderJelliesOnMap()
        
    }
}

func renderJelliesOnMap() {
    
}

func getImageFromStorage(with refPath: String, completion: @escaping (Bool, Data?, Error?) -> Void) {
    let storageRef = Storage.storage().reference(withPath: refPath)
    
    storageRef.listAll { (result, error) in
        if let error = error {
            print("error listing all items in cloud storage folder: \(error.localizedDescription)")
            return
        }
        
        for item in result.items {
            item.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("error downloading image: \(error.localizedDescription)")
                    completion(false, data, error)
                } else {
                    completion(true, data, error)
                }
            }
        }
    }
}

