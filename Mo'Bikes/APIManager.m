//
//  APIManager.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-11-02.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "APIManager.h"
#import "StationManager.h"
#import "DownloadManager.h"
#import "DirectionsManager.h"

@implementation APIManager

+ (instancetype)sharedAPIManager {
    static APIManager *theAPIManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theAPIManager = [self new];
    });
    return theAPIManager;
}

+ (void)updateData {
    [[APIManager sharedAPIManager] updateData];
}
+(void) getDirectionsData {
    [[APIManager sharedAPIManager] getDirectionsData];
}

- (void)updateData {
    [StationManager clearStationCounts];
    
    [DownloadManager downloadJsonAtURL:@"https://vancouver-ca.smoove.pro/api-public/stations"
                        withCompletion:^(NSArray *stationArray)
     {
         [StationManager updateStationsFromArray:stationArray];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             
             [self.mapView addAnnotations:[StationManager getAllStations]];
         });
         
     }];
}

-(void) getDirectionsData {
    
    
    //right now its a static origin and destination
    [DownloadManager downloadJsonAtURL:@"https://maps.googleapis.com/maps/api/directions/json?origin=49.284580,-123.124858&destination=49.282059,-123.108498&mode=bicycling&alternatives=true&key=AIzaSyDmbD4twopBCAyHCK_dir13OpL0VCnYa1g" withCompletion:^(NSArray *directionsArray){
        
        [DirectionsManager  updateDirectionsFromArray:directionsArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //draw lines on self.mapView using directionsmanager get alldirections method
            [self.mapView addOverlay:[DirectionsManager getAllDirecions]];
            
        });
        
    } ];
}



@end
