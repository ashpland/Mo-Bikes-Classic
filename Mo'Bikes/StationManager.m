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
    [[StationManager sharedStationManager] checkWhatsInCoreData];
}

-(void)updateStationsFromArray:(NSArray<NSDictionary<NSString *,id> *> *)stationArray {
    
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
        
        if (results.count == 0) {

            Station *newStation = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.managedObjectContext];
            
            bool operative = [[stationDict objectForKey:@"operative"] boolValue];
            
            if (operative) {
                newStation.name = [stationDict objectForKey:@"name"];
                newStation.total_docks = [[stationDict objectForKey:@"total_slots"] integerValue];
                newStation.available_bikes = [[stationDict objectForKey:@"avl_bikes"] integerValue];
                newStation.available_docks = [[stationDict objectForKey:@"free_slots"] integerValue];
                newStation.operative = YES;
                
                NSString *coordinatesString = [stationDict objectForKey:@"coordinates"];
                
                NSString *latString = [coordinatesString substringToIndex:9];
                NSString *lonString = [coordinatesString substringFromIndex:(coordinatesString.length - 11)];
                
                newStation.latitude = [NSDecimalNumber decimalNumberWithString:latString];
                newStation.longitude = [NSDecimalNumber decimalNumberWithString:lonString];
            } else {
                newStation.operative = NO;
                newStation.name = [stationDict objectForKey:@"name"];
            }

        } else {
            //don't create new, just update
            
            //TODO: get this to update existing entries
        }
    }
}

+(NSArray<Station *> *)getAllStations {
    return [[StationManager sharedStationManager] getAllStations];
}

-(NSArray<Station *> *)getAllStations {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching Station objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    } else {
        return results;
    }

}

// TODO: Get rid of this eventually
- (void)checkWhatsInCoreData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    } else {
        //NSLog(@"%@", results);
        NSLog(@"CoreData Count: %lu", results.count);
    }
}






@end
