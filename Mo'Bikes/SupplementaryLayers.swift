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
    
    public var washrooms : Array<MKAnnotation> {
        if (washroomAnnotations == nil) {
            washroomAnnotations = makeAnnotations(coordinatesArray: washroomsCoordinates)
        }
        return washroomAnnotations
    }
    
    public var fountains : Array<MKAnnotation> {
        if (fountainAnnotations == nil) {
            fountainAnnotations = makeAnnotations(coordinatesArray: fountainsCoordinates)
        }
        return fountainAnnotations
    }
    
    
    private let fountainsKML = Bundle.main.url(forResource: "drinking_fountains", withExtension: "kml")!
    private let washroomsKML = Bundle.main.url(forResource: "public_washrooms", withExtension: "kml")!
    private let bikewaysKML = Bundle.main.url(forResource: "bikeways", withExtension: "kml")!
    
    private var washroomsCoordinates : Array<String> {
        return KMLParser.sharedInstance.getPoints(xmlurl: washroomsKML)!
    }
    private var fountainsCoordinates : Array<String> {
        return KMLParser.sharedInstance.getPoints(xmlurl: fountainsKML)!
    }
    
    private var washroomAnnotations : Array<MKAnnotation>!
    private var fountainAnnotations : Array<MKAnnotation>!

    
    
    
    
    
    
    
    
    private class SupplementaryAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        
        init(latitude: Double, longitude: Double) {
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        }
    }
    
    private func makeAnnotations(coordinatesArray: Array<String>) -> Array<MKAnnotation> {
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
