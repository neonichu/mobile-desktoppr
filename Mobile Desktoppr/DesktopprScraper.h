//
//  DesktopprScraper.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 18.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFHTTPClient.h"

@class DesktopprUser;
@class DesktopprWebService;

@interface DesktopprScraper : AFHTTPClient

-(id)initWithWebService:(DesktopprWebService*)webService;
-(void)followingUsersForUser:(DesktopprUser*)user withCompletionHandler:(void(^)(NSArray* users, NSError* error))block;

@end