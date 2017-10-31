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

# pragma mark - Adding and Updating Stations

+(void)updateStationsFromArray:(NSArray<NSDictionary<NSString *,id> *> *)stationArray {
    [[StationManager sharedStationManager] updateStationsFromArray:stationArray];
    [[StationManager sharedStationManager] checkWhatsInCoreData];
}

- (void)setCoordinates:(NSString *)coordinatesString forStation:(Station *)newStation {
    NSString *latString = [coordinatesString substringToIndex:9];
    NSString *lonString = [coordinatesString substringFromIndex:(coordinatesString.length - 11)];
    
    newStation.latitude = [NSDecimalNumber decimalNumberWithString:latString];
    newStation.longitude = [NSDecimalNumber decimalNumberWithString:lonString];
}

- (void)updateBikesFor:(Station *)newStation stationDict:(NSDictionary<NSString *,id> *)stationDict {
    newStation.total_docks = [[stationDict objectForKey:@"total_slots"] integerValue];
    newStation.available_bikes = [[stationDict objectForKey:@"avl_bikes"] integerValue];
    newStation.available_docks = [[stationDict objectForKey:@"free_slots"] integerValue];
}

- (NSArray<Station *> *)checkIfExisiting:(NSString *)stationName {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", stationName]];
    
    NSError *error = nil;
    NSArray<Station *> *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        NSLog(@"Error fetching Station objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    return results;
}

-(void)updateStationsFromArray:(NSArray<NSDictionary<NSString *,id> *> *)stationArray {
    
    for(NSDictionary<NSString *, id> *stationDict in stationArray) {
        
        NSString *stationName = [stationDict objectForKey:@"name"];
        bool isOperative = [[stationDict objectForKey:@"operative"] boolValue];
        
        NSArray<Station *> * results = [self checkIfExisiting:stationName];
        bool stationDoesNotExist = results.count == 0;
        
        if (stationDoesNotExist) {
            Station *newStation = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.managedObjectContext];
            newStation.name = stationName;
            
            if (isOperative) {
                newStation.operative = YES;
                [self updateBikesFor:newStation stationDict:stationDict];
                [self setCoordinates:[stationDict objectForKey:@"coordinates"] forStation:newStation];
            }
            else {
                newStation.operative = NO;
            }

        }
        else {
            Station *existingStation = results[0];
            
            if (isOperative) {
                [self updateBikesFor:existingStation stationDict:stationDict];
            } else {
                existingStation.operative = NO;
            }
        }
    }
}

#pragma mark - Getting Stations

+(NSArray<Station *> *)getAllStations {
    return [[StationManager sharedStationManager] getAllStations];
}

-(NSArray<Station *> *)getAllStations {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"operative == YES"]];

    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        NSLog(@"Error fetching Station objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    } else {
        return results;
    }
}

- (void)checkWhatsInCoreData{
    // TODO: Get rid of this eventually

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"operative == NO"]];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    } else {
        //NSLog(@"%@", results);
        NSLog(@"Inoperative Stations: %lu", results.count);
    }
}






@end
