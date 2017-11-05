//
//  DirectionsManager.h
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-11-04.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyMKPolyline.h"



@class Directions;

@interface DirectionsManager : NSObject

+ (instancetype)sharedDirectionsManager;
+ (void)updateDirectionsFromArray:(NSArray<NSDictionary<NSString *, id> *> *)directionsArray;
+ (MKPolyline *)getAllDirecions;

//@property NSArray<MyMKPolyline *> *directionsArray;
@property MKPolyline *directionsPolyline;





@end
