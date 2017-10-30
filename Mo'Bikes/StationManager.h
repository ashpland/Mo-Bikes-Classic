//
//  StationManager.h
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Station+CoreDataClass.h"

@interface StationManager : NSObject

@property (strong, nonatomic) NSFetchedResultsController<Station *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedStationManager;
+ (void)updateStationsFromArray:(NSArray<NSDictionary<NSString *, id> *> *)stationArray;

@end
