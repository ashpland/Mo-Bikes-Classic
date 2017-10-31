//
//  StationMarker.m
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "StationMarker.h"

@implementation StationMarker

- (instancetype _Nullable )initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle {
        self = [super init];
        if (self) {
            _coordinate = aCoordinate;
            _title = aTitle;
       
        }
        return self;
    }

@end
