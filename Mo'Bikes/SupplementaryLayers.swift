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

    public var washrooms : Array<MKAnnotation> {
        return makeAnnotations(coordinatesArray: washroomsCoordinates)
    }
    public var fountains : Array<MKAnnotation> {
        return makeAnnotations(coordinatesArray: fountainsCoordinates)
    }
    
    var washroomsCoordinates : Array<String> {
        return KMLParser.sharedInstance.getPoints(xmlurl: washroomsKML)!
    }
    var fountainsCoordinates : Array<String> {
        return KMLParser.sharedInstance.getPoints(xmlurl: fountainsKML)!
    }
    
    class SupplementaryAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        
        init(latitude: Double, longitude: Double) {
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        }
    }
    
    func makeAnnotations(coordinatesArray: Array<String>) -> Array<MKAnnotation> {
        var annotationArray = [MKAnnotation]()
        
        for coordinateString in coordinatesArray {
            let stringPieces = coordinateString.split(separator: ",")
            let longitude = Double(stringPieces[0])!
            let latitude = Double(stringPieces[1])!

            annotationArray.append(SupplementaryAnnotation(latitude: latitude, longitude: longitude))
        }
        return annotationArray
    }
    
    
    
    
    
    
}
