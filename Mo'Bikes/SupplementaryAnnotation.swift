//
//  SupplementaryAnnotation.swift
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-31.
//  Copyright © 2017 hearthedge. All rights reserved.
//

import UIKit
import MapKit

@objc class SupplementaryAnnotation: NSObject, MKAnnotation {

    public var coordinate : CLLocationCoordinate2D
    public var layerType : SupplementaryLayerType
    
    init(latitude: Double, longitude: Double, type: SupplementaryLayerType) {
        coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        layerType = type
    }
}

public enum SupplementaryLayerType {
    case fountain
    case washroom
}
