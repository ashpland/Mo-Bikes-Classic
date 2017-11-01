//
//  Bikeway.swift
//  Mo'Bikes
//
//  Created by Andrew on 2017-11-01.
//  Copyright © 2017 hearthedge. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Bikeway: NSObject {
    var type : BikewayType
    var lines : Array<Array<CLLocationCoordinate2D>>
    
    init(bikewayType: BikewayType, bikewayLines: Array<Array<CLLocationCoordinate2D>>) {
        type = bikewayType
        lines = bikewayLines
    }
    
    func makeMKPolylines() -> Array<MKPolyline> {
        var polylineArray = [MKPolyline]()
        for lineArray in lines {
            polylineArray.append(MKPolyline(coordinates: lineArray, count: lineArray.count))
        }
        return polylineArray
    }
    
    override var description: String {
        
        
        return "Type: \(type)\n\(lines)"
    }
}

enum BikewayType {
    case local
    case shared
    case painted
    case protected
}
