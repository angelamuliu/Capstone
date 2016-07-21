//
//  PlacesManager.swift
//  Capstone
//
//  Created by Ajayan Subramanian on 7/4/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Handles sorting of places and contains the list of places in memory
*/
class PlacesManager
{
    var places : [Place]
    
    init(places:[Place])
    {
        self.places = places
    }
    
    /**
     Sorts places by location relative to user. Closer location moves to the top
     */
    func sortPlaces(userLocation:CLLocation)
    {
        self.places.sortInPlace({$0.getDistanceFromUser(userLocation) < $1.getDistanceFromUser(userLocation)})
    }
    
    func filterByKeyword(keyword:String) -> [Place]
    {
        let searchTerm = keyword.lowercaseString
        var filteredPlaces : [Place]
        filteredPlaces = []
        for place in places
        {
            if place.containsKeyword(searchTerm)
            {
                filteredPlaces.append(place)
            }
        }
        
        return filteredPlaces
    }
}