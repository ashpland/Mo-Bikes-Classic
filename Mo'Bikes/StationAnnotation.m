//
//  StationAnnotation.m
//  Mo'Bikes
//
//  Created by Sanjay Shah on 2017-10-31.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "StationAnnotation.h"
#import "Station+CoreDataClass.h"

@implementation StationAnnotation

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.annotation = [Station new];
    }
    return self;
}

@end
