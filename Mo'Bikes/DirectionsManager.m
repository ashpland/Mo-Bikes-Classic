//
//  DirectionsManager.m
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-11-04.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "DirectionsManager.h"
#import "Mo_Bikes-Swift.h"


@implementation DirectionsManager

+ (instancetype)sharedDirectionsManager{
    static DirectionsManager *theDirectionsManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theDirectionsManager = [self new];
        
    });
    //theDirectionsManager = [self new];
    return theDirectionsManager;
}

+ (void)updateDirectionsFromArray:(NSArray<NSDictionary<NSString *, id> *> *)directionsArray{
    [[DirectionsManager sharedDirectionsManager] updateDirectionsFromArray:directionsArray];
}

+ (MKPolyline*)getAllDirecions{
    return [[DirectionsManager sharedDirectionsManager] getAllDirections];
}

-(void)updateDirectionsFromArray:(NSArray<NSDictionary<NSString *,id> *> *)directionsArray{
    
    
    self.directionsPolyline = [[MyMKPolyline alloc] init];

    
    //self.directionsArray = [MKPolyline
    self.directionsPolyline = [MyMKPolyline polylineWithEncodedString:@"s{xkHjynnVCGvEoIbAeBnBmD_MmTGEx@yA`DyFhAqBvD}GtCiFxFcKkCmE_@q@SYQOsAg@yAe@SGL_@Le@\\_D"];
    
    self.directionsPolyline.title = [NSString stringWithFormat:@"directionsPolyline"];
   
    
    //if we want to use Core Data, we can store the results through this method
    
    //parse the data and store an arrray of directions to the Supplmentary layers property
    
    
}


-(MKPolyline*)getAllDirections {
    
   // return self.directionsArray;
    return self.directionsPolyline;
}

@end
