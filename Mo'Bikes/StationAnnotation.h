//
//  StationAnnotation.h
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-10-31.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface StationAnnotation : MKAnnotationView

@property (nonatomic) UIImage *stationImage;
@property (nonatomic) NSString* title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
