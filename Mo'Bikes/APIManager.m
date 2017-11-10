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


static double refreshInterval = 10.0;


@interface APIManager ()


@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) NSDate *lastUpdate;

@end

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
    
    NSLog(@"startUpdateData");
    
    if ([self enoughtTimeHasPassed]) {

        NSLog(@"enoughTimeHasPassed");

        self.lastUpdate = [NSDate date];
        
        [self setNewTimer];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatingStationData" object:nil];
        
        [DownloadManager downloadJsonAtURL:@"https://vancouver-ca.smoove.pro/api-public/stations"
                            withCompletion:^(NSArray *stationArray)
         {
             [StationManager updateStationsFromArray:stationArray];
         }];
    }
}

- (bool)enoughtTimeHasPassed {
    
    if (self.lastUpdate) {
        return fabs([self.lastUpdate timeIntervalSinceNow]) > refreshInterval;
    } else {
        return YES;
    }
    
}

- (void)setNewTimer {
    NSLog(@"setNewTimer");
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshInterval
                                                         target:self
                                                       selector:@selector(startUpdateData)
                                                       userInfo:nil
                                                        repeats:NO];
}


+ (void)stopUpdateData {
    [[APIManager sharedAPIManager].refreshTimer invalidate];
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
