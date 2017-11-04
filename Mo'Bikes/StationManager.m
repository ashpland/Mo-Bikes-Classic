//
//  StationManager.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#import "StationManager.h"
#import "APIManager.h"

@interface StationManager()

@property (strong, nonatomic) NSArray<NSDictionary<NSString *,id> *> *stationArray;

@end

@implementation StationManager

+ (instancetype)sharedStationManager {
    static StationManager *theStationManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theStationManager = [self new];
        theStationManager.isWaitingForWriteToFinish = NO;
        [[NSNotificationCenter defaultCenter] addObserver:theStationManager
                                                 selector:NSSelectorFromString(@"managedObjectContextDidSave")
                                                     name:NSManagedObjectContextDidSaveNotification object:nil];
    });
    return theStationManager;
}

+(void)removeObservers{
    [[StationManager sharedStationManager] removeObservers];
}

-(void)removeObservers{
    NSLog(@"Observers Removed");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


# pragma mark - Adding and Updating Stations

+(void)updateStationsFromArray:(NSArray<NSDictionary<NSString *,id> *> *)stationArray {
    StationManager *stationManager = [StationManager sharedStationManager];
    stationManager.stationArray = stationArray;
    [stationManager checkStationNumber:0];
}

-(void)managedObjectContextDidSave {
    NSLog(@"MOC Save");
    if (self.isWaitingForWriteToFinish) {
        self.isWaitingForWriteToFinish = NO;
        [self checkStationNumber:0];
    }
}

-(void)checkStationNumber:(NSInteger)index {
    if (index < self.stationArray.count) {
        NSDictionary<NSString *, id> *stationDict = self.stationArray[index];
        NSArray<Station *> *checkExistingResults = [self checkIfExisiting:[stationDict objectForKey:@"name"]];
        bool stationDoesNotExist = checkExistingResults.count == 0;
        
        if (stationDoesNotExist) {
            [self createNewStation:stationDict];
            self.isWaitingForWriteToFinish = YES;
            [self.managedObjectContext save:nil];
            return;
        }
        
        else /*stationDoesExist*/ {
            bool didChangeSomething = [self updateExistingStation:checkExistingResults[0] withDictionary:stationDict];
            if (didChangeSomething) {
                self.isWaitingForWriteToFinish = YES;
                [self.managedObjectContext save:nil];
                return;
            }
        }
        
        [self checkStationNumber:index + 1];
    }
    else {
        [APIManager endUpdateData];
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

-(bool)updateExistingStation:(Station *)existingStation withDictionary:(NSDictionary<NSString *, id> *)stationDict {
    bool didChangeSomething = NO;
    bool stationIsNowOperative = [[stationDict objectForKey:@"operative"] boolValue];
    
    if (stationIsNowOperative) {
        didChangeSomething = [self updateBikesFor:existingStation stationDict:stationDict];
        if (existingStation.operative != YES) {
            existingStation.operative = YES;
            didChangeSomething = YES;
        }
    } else {
        if (existingStation.operative != NO) {
            existingStation.operative = NO;
            didChangeSomething = YES;
        }
    }
    return didChangeSomething;
}

- (bool)updateBikesFor:(Station *)station stationDict:(NSDictionary<NSString *,id> *)stationDict {
    
    bool didChangeSomething = NO;
    
    if (station.total_docks != [[stationDict objectForKey:@"total_slots"] integerValue]) {
        station.total_docks = [[stationDict objectForKey:@"total_slots"] integerValue];
        didChangeSomething = YES;
    }

    if(station.available_bikes != [[stationDict objectForKey:@"avl_bikes"] integerValue]) {
        station.available_bikes = [[stationDict objectForKey:@"avl_bikes"] integerValue];
        didChangeSomething = YES;
    }

    if(station.available_docks != [[stationDict objectForKey:@"free_slots"] integerValue]){
        station.available_docks = [[stationDict objectForKey:@"free_slots"] integerValue];
        didChangeSomething = YES;
    }
    
    return didChangeSomething;
}

//- (void)updateBikesFor:(Station *)station stationDict:(NSDictionary<NSString *,id> *)stationDict {
//    NSLog(@"%@", station.name);
//    station.total_docks = [[stationDict objectForKey:@"total_slots"] integerValue];
//    station.available_bikes = [[stationDict objectForKey:@"avl_bikes"] integerValue];
//    station.available_docks = [[stationDict objectForKey:@"free_slots"] integerValue];
//}



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
