//
//  Station+CoreDataProperties.h
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//
//

#import "Station+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Station (CoreDataProperties)

+ (NSFetchRequest<Station *> *)fetchRequest;

@property (nonatomic) int16_t available_bikes;
@property (nonatomic) int16_t available_docks;
@property (nullable, nonatomic, copy) NSDecimalNumber *latitude;
@property (nullable, nonatomic, copy) NSDecimalNumber *longitude;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) BOOL operative;
@property (nonatomic) int16_t total_docks;

@end

NS_ASSUME_NONNULL_END
