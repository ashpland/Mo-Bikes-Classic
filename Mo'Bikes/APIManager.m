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

@implementation APIManager

+ (instancetype)sharedAPIManager {
    static APIManager *theAPIManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theAPIManager = [self new];
    });
    return theAPIManager;
}

+ (void)startUpdateData {
    [[APIManager sharedAPIManager] startUpdateData];
}

- (void)startUpdateData {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatingStationData" object:nil];

    [DownloadManager downloadJsonAtURL:@"https://vancouver-ca.smoove.pro/api-public/stations"
                        withCompletion:^(NSArray *stationArray)
     {
         [StationManager updateStationsFromArray:stationArray];
     }];
}

+ (void)endUpdateData {
    [[APIManager sharedAPIManager] endUpdateData];
}

- (void)endUpdateData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotations:[StationManager getAllStations]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedUpdatingStationData" object:nil];
    });
}



@end
