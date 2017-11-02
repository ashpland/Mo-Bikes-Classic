//
//  LocationManager.m
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

-(void) getLocation {
    
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    
    [self.locationManager startUpdatingLocation];
    
}

@end
