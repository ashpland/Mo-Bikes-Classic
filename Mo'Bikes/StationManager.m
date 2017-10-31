//
//  StationManager.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "StationManager.h"

@implementation StationManager

+ (instancetype)sharedStationManager {
    static StationManager *theStationManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theStationManager = [self new];
    });
    return theStationManager;
}

+(void)updateStationsFromArray:(NSArray<NSDictionary<NSString *,id> *> *)stationArray {
    [[StationManager sharedStationManager] updateStationsFromArray:stationArray];
}

-(void)updateStationsFromArray:(NSArray<NSDictionary<NSString *,id> *> *)stationArray {
    NSLog(@"%@", stationArray);

    // TODO: update core data
    //          - check if object exists
    //              - if yes, update bike/dock values
    //              - if no, create new object
    
    for(NSDictionary<NSString *, id> *stationDict in stationArray) {
        NSString *stationName = [stationDict objectForKey:@"name"];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", stationName]];
        NSError *error = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (!results) {
            NSLog(@"Error fetching Station objects: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
        
        if (results.count == 0 || ![results[0] isEqualToString:stationName]) {
            Station *newStation = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.managedObjectContext];
            
            newStation.name = [stationDict objectForKey:@"name"];
            newStation.total_docks = [[stationDict objectForKey:@"total_slots"] integerValue];
            newStation.available_bikes = [[stationDict objectForKey:@"avl_bikes"] integerValue];
            newStation.available_docks = [[stationDict objectForKey:@"free_slots"] integerValue];
            newStation.operative = [[stationDict objectForKey:@"operative"] boolValue];
            
            NSString *coordinatesString = [stationDict objectForKey:@"coordinates"];
            NSArray *separateCoordinates = [coordinatesString componentsSeparatedByString:@", "];
            
            newStation.latitude = separateCoordinates[0];
            newStation.longitude = separateCoordinates[1];

        }
    }
    
    
    
//    AAAEmployeeMO *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:[self managedObjectContext];
    
    
    
    
}







@end
