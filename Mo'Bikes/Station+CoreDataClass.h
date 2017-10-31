//
//  Station+CoreDataClass.h
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@interface Station : NSManagedObject <MKAnnotation>

@end

NS_ASSUME_NONNULL_END

#import "Station+CoreDataProperties.h"
