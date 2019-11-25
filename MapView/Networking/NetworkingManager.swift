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

class NetworkingManager {
    
    func getJelliesWithinRegion(within map: MKMapView, completion: @escaping (Bool, Any?, Error?) -> Void) {
        
        DispatchQueue.global(qos: .default).async {
            
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
                
                // perform networking call to retrieve all the keys from firestore
                // Map the Firebase promises into an array
                
                // Map the Firebase promises into an array
//                let videoPromises = jelliesToFetch.map(id => {
//                  return databaseRef.child('videos').child(id).on('value', s => s)
//                })
                let firestoreRef = Firestore.firestore().collection("Jellies")
//                var result: [[String : Any]]!
                var results: [Any] = []

                for jelly in jelliesToFetch {
                    let _ = firestoreRef.whereField("ID", isEqualTo: jelly).getDocuments(completion: { (snapshot, error) in
                        if error != nil {
                            print("Error getting documents!")
                            return
                        } else {
                            print("successfully retrieve documents!")
                            for document in snapshot!.documents {
                                print(document.data())
                                print("\n\n\n")
                                
                                let data = document.data()
                                results.append(data)
                            }
                        }
                    })
                }
                                 
                print("this is results' count: \(results.count)")

                // Wait for all the async requests mapped into
                // the array to complete
//                Promise.all(videoPromises)
//                  .then(videos => {
//                    // do something with the data
//                  })
//                  .catch(err => {
//                    // handle error
//                  })
//
//                // Wait for all the async requests mapped into
//                // the array to complete
//                Promise.all(videoPromises)
//                  .then(videos => {
//                    // do something with the data
//                  })
//                  .catch(err => {
//                    // handle error
//                  })
//
                // execute completion handler
                
                completion(true, jelliesToFetch, nil)
            })
        }

    }

    // retrieve all the locations from firestore

    // decode JSON into Core Data Entities

}

