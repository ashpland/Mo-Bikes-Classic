//
//  DownloadManager.m
//  Mo'Bikes
//
//  Created by Andrew on 2017-10-30.
//  Copyright © 2017 hearthedge. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

+ (instancetype)sharedDownloadManager {
    static DownloadManager *theDownloadManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theDownloadManager = [self new];
    });
    return theDownloadManager;
}

+ (void)downloadJsonAtURL:(NSString *)urlString {
    [[DownloadManager sharedDownloadManager] downloadJsonAtURL:urlString];
}

- (void)downloadJsonAtURL:(NSString *)urlString {
    
}






@end

