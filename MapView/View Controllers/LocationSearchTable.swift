//
//  LocationSearchTable.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/29/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {

    var matchingItems: [MKMapItem] = []
    var MapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil
    var searchBar: UISearchBar? = nil
    var selectedItem: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

}

extension LocationSearchTable {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem?.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        // fill search bar with name of location
        searchBar?.text = selectedItem.name
        
        // rename uibutton from add jelly vc
//        JellyLocationButton?.titleLabel?.text = selectedItem.name
        dismiss(animated: true, completion: nil)
    }

}

extension LocationSearchTable: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // make API Calls
        guard let mapView = MapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
        
        // notes:
//        The guard statement unwraps the optional values for mapView and the search bar text.
//
//        MKLocalSearchRequest: A search request is comprised of a search string, and a map region that provides location context. The search string comes from the search bar text, and the map region comes from the mapView.
//
//        MKLocalSearch performs the actual search on the request object. startWithCompletionHandler() executes the search query and returns a MKLocalSearchResponse object which contains an array of mapItems. You stash these mapItems inside matchingItems, and then reload the table.
    }
    
}







