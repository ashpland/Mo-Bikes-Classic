//
//  MapViewDelegate.h
//  Mo'Bikes
//
//  Created by Andrew on 2017-11-02.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station+CoreDataClass.h"

@import MapKit;

@interface MapViewDelegate : NSObject <MKMapViewDelegate>

@property (strong, nonatomic) UISegmentedControl *bikesDocksSegmentedControl;

@property (strong, nonatomic) UIColor *normalStationColor;
@property (strong, nonatomic) UIColor *lowStationColor;
@property (assign, nonatomic) BOOL hasCurrentData;

- (void)setStationMarkerPropertiesFor:(MKMarkerAnnotationView *)newStationMarkerView withStation:(Station *)station;

@end
