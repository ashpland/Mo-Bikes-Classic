//
//  LocationManager.h
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface LocationManager : CLLocationManager

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
