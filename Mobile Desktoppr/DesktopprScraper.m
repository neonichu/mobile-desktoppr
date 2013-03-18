//
//  DesktopprScraper.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 18.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFNetworking.h"
#import "BBUHTMLParser.h"
#import "DesktopprScraper.h"
#import "DesktopprUser.h"
#import "DesktopprWebService.h"

@implementation DesktopprScraper

-(void)followingUsersForUser:(DesktopprUser*)user withCompletionHandler:(void(^)(NSArray* users, NSError* error))block {
    [self getPath:[NSString stringWithFormat:@"%@/following", user.username]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, NSData* htmlData) {
              NSMutableArray* users = [NSMutableArray array];
              NSArray* followings = [self usersFromHTMLData:htmlData];
              
              __block NSError* lastError;
              __block NSUInteger found = 0;
              for (NSString* following in followings) {
                  [[DesktopprWebService sharedService] infoForUser:following
                                             withCompletionHandler:^(DesktopprUser *user, NSError *error) {
                                                 found++;
                                                 
                                                 if (user) {
                                                     [users addObject:user];
                                                 } else {
                                                     lastError = error;
                                                 }
                                                 
                                                 if (found >= followings.count && block) {
                                                     block([users sortedArrayUsingComparator:^NSComparisonResult(id obj1,
                                                                                                                 id obj2) {
                                                         return [[obj1 username] compare:[obj2 username]];
                                                     }], lastError);
                                                 }
                                             }];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              block(nil, error);
          }];
}

-(id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://www.desktoppr.co/"]];
    return self;
}

-(NSArray*)usersFromHTMLData:(NSData*)htmlData {
    NSMutableArray* users = [NSMutableArray array];
    
    BBUHTMLParser* parser = [BBUHTMLParser parserWithData:htmlData];
    [parser enumerateTagsWithName:@"div" matchingAttributes:@{ @"class": @"user" }
                            block:^(BBUHTMLElement *element, NSError *error) {
                                BBUHTMLElement* a = [[element childrenWithTagName:@"a"] lastObject];
                                [users addObject:[a[@"href"] substringFromIndex:1]];
                            }];
    
    return [users copy];
}

@end
