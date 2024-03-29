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
    
    /* filters items for the search functionality */
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
    
    /* filters items for the image search tag functionality */
    func filterByTags(imageTags:[String]) -> [Place]
    {
        var filteredPlaces : [Place]
        filteredPlaces = []
        let imageTagSet = NSSet(array: imageTags)
        for place in places
        {
            let placeTagsSet = NSSet(array: place.tags!)
            if(placeTagsSet.intersectsSet(imageTagSet as Set<NSObject>))
            {
                print("Match found:" + place.name)
                filteredPlaces.append(place)
            }
        }
        
        return filteredPlaces
    }
}