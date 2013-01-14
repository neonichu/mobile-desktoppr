//
//  DesktopprWebService.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void(^DesktopprArrayBlock)(NSArray* pictures, NSError* error);

@interface DesktopprWebService : AFHTTPClient

-(void)wallpapersForUser:(NSString*)username withCompletionHandler:(DesktopprArrayBlock)block;

@end
