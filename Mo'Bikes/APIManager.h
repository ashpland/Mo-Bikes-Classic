//
//  APIManager.h
//  Mo'Bikes
//
//  Created by Andrew on 2017-11-02.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;


@interface APIManager : NSObject

@property (nonatomic, strong) MKMapView *mapView;

+ (instancetype)sharedAPIManager;
+ (void)startUpdateData;
+ (void)stopUpdateData;
+ (void)endUpdateData;

@end
