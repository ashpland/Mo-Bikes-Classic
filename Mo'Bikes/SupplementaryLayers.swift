//
//  SupplementaryLayers.swift
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-31.
//  Copyright © 2017 hearthedge. All rights reserved.
//

import Foundation
import MapKit

class SupplementaryLayers: NSObject {
    static let sharedInstance = SupplementaryLayers();
    
    let fountainsKML = Bundle.main.url(forResource: "drinking_fountains", withExtension: "kml")!
    let washroomsKML = Bundle.main.url(forResource: "public_washrooms", withExtension: "kml")!
    let bikewaysKML = Bundle.main.url(forResource: "bikeways", withExtension: "kml")!

    public var washrooms : Array<String> {
        return KMLParser.sharedInstance.getPoints(xmlurl: washroomsKML)!
    }
    public var fountains : Array<String> {
        return KMLParser.sharedInstance.getPoints(xmlurl: fountainsKML)!
    }
    
    var washroomsCoordinates : Array<String> {
        return KMLParser.sharedInstance.getPoints(xmlurl: washroomsKML)!
    }
    var fountainsCoordinates : Array<String> {
        return KMLParser.sharedInstance.getPoints(xmlurl: fountainsKML)!
    }
    
    
    
    func makeAnnotations(coordinatesArray: Array<String>) -> Array<MKAnnotation> {
        var annotationArray = [MKAnnotation]()
        
        for coordinateString in coordinatesArray {
            let stringPieces = coordinateString.split(separator: ",")
            let longitude = Float(stringPieces[0])
            
//            let newAnnotation = MKPointAnnotation()
        }
        
        return annotationArray
    }
    
    
    
    
    
    
}
