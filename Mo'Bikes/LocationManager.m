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
        self.locationManager.desiredAccuracy =
        kCLLocationAccuracyNearestTenMeters;
        //self.locationManager.delegate = self;
    }
    [self.locationManager startUpdatingLocation];
    
    CLLocation *curPos = self.locationManager.location;
    NSString *latitude = [[NSNumber numberWithDouble:curPos.coordinate.latitude] stringValue];
    NSString *longitude = [[NSNumber numberWithDouble:curPos.coordinate.longitude] stringValue];
  
     NSLog(@"Lat: %@", latitude);
     NSLog(@"Long: %@", longitude);
    
    
}



- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", @"Core location has a position.");
}


- (void) locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"Core location can't get a fix.");
}

@end
