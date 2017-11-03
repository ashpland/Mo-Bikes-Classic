//
//  Station+CoreDataClass.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//
//

#import "Station+CoreDataClass.h"

@implementation Station

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

-(NSString *)title {
    return [NSString stringWithFormat:@"%hd bikes - %hd docks", self.available_bikes, self.available_docks];
}

-(NSString *)available_bikes_string {
    if (self.available_bikes == 0 && self.available_docks == 0) {
        return nil;
    } else {
        return [NSString stringWithFormat:@"%d", self.available_bikes];
    }
}

-(NSString *)available_docks_string {
    if (self.available_bikes == 0 && self.available_docks == 0) {
        return nil;
    } else {
        return [NSString stringWithFormat:@"%d", self.available_docks];
    }
}

@end
