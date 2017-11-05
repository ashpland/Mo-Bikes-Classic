//
//  MyMKPolyline.h
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-11-04.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyMKPolyline : MKPolyline

+ (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString;

@end
