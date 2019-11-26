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
                
                // Perform networking call to retrieve all the keys from firestore
                // Map the Firebase promises into an array
                
                // Map the Firebase promises into an array

                let firestoreRef = Firestore.firestore().collection("Jellies")
                var results: [Any] = []

                for jelly in jelliesToFetch {
                    let _ = firestoreRef.whereField("ID", isEqualTo: jelly).getDocuments(completion: { (snapshot, error) in
                        if error != nil {
                            print("Error getting documents!")
                            completion(false, nil, error)
                            return
                        } else {
                            print("successfully retrieve documents!")
                            for document in snapshot!.documents {
                                let data = document.data()
                                
                                // create Jellies asynchronously
                                createJellies(with: data)
                                
                                    // write Jellies to CoreData
                                    
                                    // render Jellies on Map
                                
                                results.append(data)
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

    
    
//    let persistentManager = PersistentManager.shared
//    let jelly = Jellies(context: persistentManager.context)
    
}

