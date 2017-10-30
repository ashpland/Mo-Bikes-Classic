//
//  DownloadManager.h
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject


# pragma mark - init and setup

+ (instancetype)sharedDownloadManager;
+ (void)downloadJsonAtURL:(NSString *)urlString;

@end
