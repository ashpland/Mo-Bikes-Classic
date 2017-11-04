//
//  Directions.swift
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-11-03.
//  Copyright © 2017 hearthedge. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Directions: NSObject {

    var lines : Array<Array<CLLocationCoordinate2D>>
    
    init(directionLines: Array<Array<CLLocationCoordinate2D>>) {
   
        lines = directionLines
    }
    
    func makeMKPolylines() -> Array<MKPolyline> {
        var polylineArray = [MKPolyline]()
        for lineArray in lines {
            let newDirectionsPolyline = DirectionsPolyline(coordinates: lineArray, count: lineArray.count)
        
            polylineArray.append(newDirectionsPolyline)
        }
        return polylineArray
    }
    
}


@objc class DirectionsPolyline: MKPolyline {
}

