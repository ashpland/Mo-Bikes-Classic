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
            let newBikewayPolyline = BikewayPolyline(coordinates: lineArray, count: lineArray.count)
            newBikewayPolyline.bikewayType = self.type
            polylineArray.append(newBikewayPolyline)
        }
        return polylineArray
    }
    
    override var description: String {

        return "Type: \(type)\n\(lines)"
    }
}

@objc public enum BikewayType : Int {
    case local
    case shared
    case painted
    case protected
}

@objc class BikewayPolyline: MKPolyline {
    public var bikewayType : BikewayType = BikewayType.local
}
