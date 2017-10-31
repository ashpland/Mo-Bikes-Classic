//
//  StationMarker.h
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StationMarker : MKPinAnnotationView

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString * title;


- (instancetype _Nullable )initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle;

@end
