//
//  Station+CoreDataProperties.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//
//

#import "Station+CoreDataProperties.h"

@implementation Station (CoreDataProperties)

+ (NSFetchRequest<Station *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Station"];
}

@dynamic available_bikes;
@dynamic available_docks;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic operative;
@dynamic total_docks;
@dynamic available_bikes_string;
@dynamic available_docks_string;

@end
