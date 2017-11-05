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

+ (void)downloadJsonAtURL:(NSString *)urlString withCompletion:(void (^)(NSArray *jsonArray))whenDownloaded {
    DownloadManager *sharedDownloadManager = [DownloadManager sharedDownloadManager];
    
    //if we want to download directions, do another data request
    
    
    [sharedDownloadManager downloadJsonAtURL:urlString withCompletion:^(NSData *downloadedData){
        NSArray *returnArray = [sharedDownloadManager processJSON:downloadedData];
        whenDownloaded(returnArray);
    }];
}

- (void)downloadJsonAtURL:(NSString *)urlString withCompletion:(void (^)(NSData *downloadedData))whenDownloaded {
    NSURL *urlToDownload = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3

    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:urlToDownload
                                            completionHandler:^(NSData *returnDownloadedData,
                                                                NSURLResponse *response,
                                                                NSError *error){
                                                if (returnDownloadedData) {
                                                    whenDownloaded(returnDownloadedData);
                                                }
                                                
    }];
    
    [dataTask resume];
    
}

- (NSArray *)processJSON:(NSData *)jsonData {
    NSError *jsonError = nil;
    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&jsonError];
    
    if (jsonError) {
        NSLog(@"jsonError: %@", jsonError.localizedDescription);
    }
    
    return [parsedJSON objectForKey:@"result"];
    
    
}





@end

