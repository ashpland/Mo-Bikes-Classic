//
//  StationManager.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

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
    [[StationManager sharedStationManager] checkStationNumber:0 fromArray:stationArray];
}

-(void)checkStationNumber:(NSInteger)index fromArray:(NSArray<NSDictionary<NSString *,id> *> *)stationArray {
    if (index < stationArray.count) {
        NSDictionary<NSString *, id> *stationDict = stationArray[index];
        NSArray<Station *> *checkExistingResults = [self checkIfExisiting:[stationDict objectForKey:@"name"]];
        bool stationDoesNotExist = checkExistingResults.count == 0;
        
        if (stationDoesNotExist)
            [self createNewStation:stationDict];
        
        else /*stationDoesExist*/
            [self updateExistingStation:checkExistingResults[0] withDictionary:stationDict];
        
        [self checkStationNumber:index + 1 fromArray:stationArray];
    }
    else {
        return;
    }
}

-(NSArray<Station *> *)checkIfExisiting:(NSString *)stationName {
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

-(void)createNewStation:(NSDictionary<NSString *, id> *)stationDict {
    Station *newStation = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.managedObjectContext];
    newStation.name = [stationDict objectForKey:@"name"];
    
    bool stationIsOperative = [[stationDict objectForKey:@"operative"] boolValue];
    if (stationIsOperative) {
        newStation.operative = YES;
        [self updateBikesFor:newStation stationDict:stationDict];
        [self setCoordinates:[stationDict objectForKey:@"coordinates"] forStation:newStation];
    }
    else {
        newStation.operative = NO;
    }
}

-(void)updateExistingStation:(Station *)existingStation withDictionary:(NSDictionary<NSString *, id> *)stationDict {
    bool stationIsOperative = [[stationDict objectForKey:@"operative"] boolValue];
    if (stationIsOperative) {
        [self updateBikesFor:existingStation stationDict:stationDict];
    } else {
        existingStation.operative = NO;
    }
}

- (void)updateBikesFor:(Station *)station stationDict:(NSDictionary<NSString *,id> *)stationDict {
    NSLog(@"%@", station.name);
    if (station.total_docks != [[stationDict objectForKey:@"total_slots"] integerValue]) {
        station.total_docks = [[stationDict objectForKey:@"total_slots"] integerValue];
        NSLog(@"  Updated total");
    }
    
    if(station.available_bikes != [[stationDict objectForKey:@"avl_bikes"] integerValue]) {
        station.available_bikes = [[stationDict objectForKey:@"avl_bikes"] integerValue];
        NSLog(@"  Updated bikes");
    }
    
    if(station.available_docks != [[stationDict objectForKey:@"free_slots"] integerValue]){
        station.available_docks = [[stationDict objectForKey:@"free_slots"] integerValue];
        NSLog(@"  Updated docks");
    }
}

//- (void)updateBikesFor:(Station *)station stationDict:(NSDictionary<NSString *,id> *)stationDict {
//    station.total_docks = [[stationDict objectForKey:@"total_slots"] integerValue];
//    station.available_bikes = [[stationDict objectForKey:@"avl_bikes"] integerValue];
//    station.available_docks = [[stationDict objectForKey:@"free_slots"] integerValue];
//}

- (void)setCoordinates:(NSString *)coordinatesString forStation:(Station *)newStation {
    NSString *latString = [coordinatesString substringToIndex:9];
    NSString *lonString = [coordinatesString substringFromIndex:(coordinatesString.length - 11)];
    
    newStation.latitude = [NSDecimalNumber decimalNumberWithString:latString];
    newStation.longitude = [NSDecimalNumber decimalNumberWithString:lonString];
}

//
//-(void)oldupdateStationsFromArray:(NSArray<NSDictionary<NSString *,id> *> *)stationArray {
//
//    for(NSDictionary<NSString *, id> *stationDict in stationArray) {
//
//        NSString *stationName = [stationDict objectForKey:@"name"];
//        bool isOperative = [[stationDict objectForKey:@"operative"] boolValue];
//        NSArray<Station *> * results = [self checkIfExisiting:stationName];
//        bool stationDoesNotExist = results.count == 0;
//
//        if (stationDoesNotExist) {
//            Station *newStation = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.managedObjectContext];
//            newStation.name = stationName;
//
//            if (isOperative) {
//                newStation.operative = YES;
//                [self updateBikesFor:newStation stationDict:stationDict];
//                [self setCoordinates:[stationDict objectForKey:@"coordinates"] forStation:newStation];
//            }
//            else {
//                newStation.operative = NO;
//            }
//
//        }
//        else {
//
//            Station *existingStation = results[0];
//
//            if (isOperative) {
//                [self updateBikesFor:existingStation stationDict:stationDict];
//            } else {
//                existingStation.operative = NO;
//            }
//        }
//    }
//
//}


+(void)clearStationCounts {
    [[StationManager sharedStationManager] clearStationCounts];
}

-(void)clearStationCounts {
    NSArray<Station *> *stationArray = [self getAllStations];
    for (Station *curStation in stationArray) {
        curStation.available_bikes = 0;
        curStation.available_docks = 0;
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






@end
