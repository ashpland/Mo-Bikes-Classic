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
            washroomAnnotations = makeAnnotations(coordinatesArray: washroomsCoordinates, ofType: SupplementaryLayerType.washroom)
        }
        return washroomAnnotations
    }
    
    public var fountains : Array<MKAnnotation> {
        if (fountainAnnotations == nil) {
            fountainAnnotations = makeAnnotations(coordinatesArray: fountainsCoordinates, ofType: SupplementaryLayerType.fountain)
        }
        return fountainAnnotations
    }
    
    public var bikeways : Array<Bikeway> {
        if (bikewaysArray == nil) {
            bikewaysArray = makeBikeways(rawBikewaysArray: rawBikeways)
        }
        return bikewaysArray
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
    
    private var rawBikeways : Array<KMLParser.RawBikeway> {
        return KMLParser.sharedInstance.getLines(xmlurl: bikewaysKML)!
    }
    
    
    private var washroomAnnotations : Array<MKAnnotation>!
    private var fountainAnnotations : Array<MKAnnotation>!
    private var bikewaysArray: Array<Bikeway>!

    private func makeAnnotations(coordinatesArray: Array<String>, ofType: SupplementaryLayerType) -> Array<MKAnnotation> {
        var annotationArray = [MKAnnotation]()
        
        for coordinateString in coordinatesArray {
            let stringPieces = coordinateString.split(separator: ",")
            let longitude = Double(stringPieces[0])!
            let latitude = Double(stringPieces[1])!

            annotationArray.append(SupplementaryAnnotation(latitude: latitude, longitude: longitude, type: ofType))
        }
        return annotationArray
    }
    
    func makeBikeways(rawBikewaysArray: Array<KMLParser.RawBikeway>) -> Array<Bikeway> {
        var bikewayArray = [Bikeway]()
        
        for rawBikeway in rawBikewaysArray {
            
            let bikewayDescription = String(rawBikeway.descriptionString.split(separator: "<",
                                                                        maxSplits: 1,
                                                                        omittingEmptySubsequences: true)[0])
            var bikewayType: BikewayType
            switch bikewayDescription {
            case "Local Street": bikewayType = BikewayType.local
            case "Shared Lanes": bikewayType = BikewayType.shared
            case "Painted Lanes": bikewayType = BikewayType.painted
            case "Protected Bike Lanes": bikewayType = BikewayType.protected
            default: continue
            }
            
            var lineSegmentArray = [[CLLocationCoordinate2D]]()
            
            for lineSegment in rawBikeway.lineSegmentsArray {
                var coordinatesArray = [CLLocationCoordinate2D]()
                for coordinate in lineSegment.split(separator: " ") {
                    let lon = Double(coordinate.split(separator: ",")[0])!
                    let lat = Double(coordinate.split(separator: ",")[1])!
                    coordinatesArray.append(CLLocationCoordinate2D(latitude: lat,
                                                                   longitude: lon))
                }
                lineSegmentArray.append(coordinatesArray)
            }
            
            bikewayArray.append(
                Bikeway(bikewayType: bikewayType,
                        bikewayLines: lineSegmentArray))
        }
        
        return bikewayArray
    }
    
    
}
