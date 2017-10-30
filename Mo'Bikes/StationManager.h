//
//  StationManager.h
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationManager : NSObject

+ (instancetype)sharedStationManager;
+ (void)updateStationsFromArray:(NSArray<NSDictionary<NSString *, id> *> *)stationArray;

@end
