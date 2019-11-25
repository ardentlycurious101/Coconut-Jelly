//
//  NetworkingManager.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/21/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation
import Firebase
import MapKit
import GeoFire

    // TODO:- callback function

    // download Jellies from Cloud Firestore
func getJelliesFromCloud(_ edgeCoordinates: [CLLocationCoordinate2D] , completion: (Bool, Any?, Error?) -> Void) {
   
    let minLat: Double = edgeCoordinates[2].latitude
    let maxLat: Double = edgeCoordinates[0].latitude
    let minLong: Double = edgeCoordinates[2].longitude
    let maxLong: Double = edgeCoordinates[3].longitude
    
//        DispatchQueue.global().async {
////         reference Firebase

    let collectionRef = Firestore.firestore().collection("Jellies")
    let orderedNames = collectionRef.order(by: "name", descending: false)
    
    let jelliesLatitudeQuery = collectionRef
        .whereField("geopoint.Latitude", isGreaterThan: minLat)
        .whereField("geopoint.Latitude", isLessThan: maxLat)

    let jelliesLongitudeQuery = collectionRef
        .whereField("geopoint.Longitude", isGreaterThan: minLong)
        .whereField("geopoint.Longitude", isLessThan: maxLong)

//    let jelliesCreatorNameFilter = collectionRef.whereField("tags", arrayContains: "powerlifting")
//    jelliesCreatorNameFilter.getDocuments { (snapshot, error) in
//        if let error = error {
//            print("error getting latitude documents")
//        } else {
//            let documents = snapshot!.documents
//            documents.forEach({print($0.data())})
//        }
//    }
    
//    jelliesLatitudeQuery.getDocuments { (snapshot, error) in
//        if let error = error {
//            print("error getting latitude documents")
//        } else {
////            let documents = snapshot!.documents
////            documents.forEach({print($0.data())})
//            for document in snapshot!.documents {
//                if let coords = document.get("geopoint") {
//                    let point = coords as! GeoPoint
//                    let lat = point.latitude
//                    let long = point.longitude
//                    print("lat: \(lat), long: \(long)")
//                }
//            }
//        }
//    }
    
    orderedNames.getDocuments { (snapshot, error) in
        if let error = error {
            print("error getting documents ordered by names")
        } else {
            let documents = snapshot!.documents
            documents.forEach({print($0.data())})
        }
    }

    
            do {
                // retrieve data from cloud within the given mapview latitude and longitude range
                
                // retrieve images from cloud storage if there exists a reference path
                
                // serialize JSON: convert firestore data into Jellies in Core Data
                
                // append all Jellies into an array
                
                // return array of Jellies
                
                
                // update UI with jellies
//                DispatchQueue.main.async {
//                    completion(true, jellies, nil)
//                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
            }
//        }
    }
    
func retrieveDataFromCloud() -> [Jellies] {
    
    
    
    let jellies: [Jellies] = []
    
    return jellies

}

func serializeJSON(_ data: Data) {
    
}
