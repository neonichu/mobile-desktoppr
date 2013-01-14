//
//  DesktopprWebService.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFNetworking.h"
#import "DesktopprPicture.h"
#import "DesktopprWebService.h"

@implementation DesktopprWebService

-(id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.desktoppr.co/1"]];
    if (self) {
        NSAssert([self registerHTTPOperationClass:[AFJSONRequestOperation class]], @"Could not register");
    }
    return self;
}

-(void)wallpapersForUser:(NSString*)username withCompletionHandler:(DesktopprArrayBlock)block {
    [self getPath:[NSString stringWithFormat:@"users/%@/wallpapers", username]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (block) {
                  NSMutableArray* pictures = [NSMutableArray array];
                  NSDictionary* response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                  for (NSDictionary* pictDict in response[@"response"]) {
                      [pictures addObject:[[DesktopprPicture alloc] initWithDictionary:pictDict]];
                  }
                  block(pictures, nil);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (block) {
                  block(nil, error);
              }
          }];
}

@end
