//
//  DesktopprWebService.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFNetworking.h"
#import "DesktopprPicture.h"
#import "DesktopprUser.h"
#import "DesktopprWebService.h"

@implementation DesktopprWebService

-(void)getPath:(NSString *)path parameters:(NSDictionary *)parameters
       success:(void (^)(AFHTTPRequestOperation *, id))success
       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    if (self.apiToken) {
        path = [path stringByAppendingFormat:@"?auth_token=%@", self.apiToken];
    }
    [super getPath:path
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
               success(operation, JSON);
           }
           failure:failure];
}

-(void)infoForUser:(NSString *)username withCompletionHandler:(DesktopprUserBlock)block {
    [self userInfoAtPath:[@"users/" stringByAppendingString:username] withCompletionHandler:block];
}

-(id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://api.desktoppr.co/1"]];
    if (self) {
        NSAssert([self registerHTTPOperationClass:[AFJSONRequestOperation class]], @"Could not register");
    }
    return self;
}

-(void)randomWallpaperAtPath:(NSString*)path withCompletionHandler:(DesktopprPictureBlock)block {
    [self getPath:path
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (block) {
                  block([[DesktopprPicture alloc] initWithDictionary:responseObject[@"response"]], nil);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (block) {
                  block(nil, error);
              }
          }];
}

-(void)randomWallpaperForUser:(NSString *)username withCompletionHandler:(DesktopprPictureBlock)block {
    [self randomWallpaperAtPath:[NSString stringWithFormat:@"users/%@/wallpapers/random", username]
          withCompletionHandler:block];
}

-(void)randomWallpaperWithCompletionHandler:(DesktopprPictureBlock)block {
    [self randomWallpaperAtPath:@"wallpapers/random" withCompletionHandler:block];
}

-(void)userInfoAtPath:(NSString*)path withCompletionHandler:(DesktopprUserBlock)block {
    [self getPath:path
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (block) {
                  block([[DesktopprUser alloc] initWithDictionary:responseObject[@"response"]], nil);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (block) {
                  block(nil, error);
              }
          }];
}

-(void)wallpapersAtPath:(NSString*)path page:(NSInteger)page addedToArray:(NSMutableArray*)pictures count:(NSInteger)count
  withCompletionHandler:(DesktopprArrayBlock)block {
    [self getPath:path
       parameters:@{ @"page": @(page) }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (block) {
                  for (NSDictionary* pictDict in responseObject[@"response"]) {
                      [pictures addObject:[[DesktopprPicture alloc] initWithDictionary:pictDict]];
                  }
                  
                  if (pictures.count >= count) {
                      block(pictures, nil);
                  } else {
                      NSInteger nextPage = [responseObject[@"pagination"][@"next"] integerValue];
                      [self wallpapersAtPath:path page:nextPage addedToArray:pictures count:count withCompletionHandler:block];
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (block) {
                  block(nil, error);
              }
          }];
}

-(void)wallpapersAtPath:(NSString*)path count:(NSInteger)count withCompletionHandler:(DesktopprArrayBlock)block {
    [self wallpapersAtPath:path page:1 addedToArray:[NSMutableArray array] count:count withCompletionHandler:block];
}

-(void)wallpapersForUser:(NSString*)username count:(NSInteger)count withCompletionHandler:(DesktopprArrayBlock)block {
    [self wallpapersAtPath:[NSString stringWithFormat:@"users/%@/wallpapers", username]
                     count:count
     withCompletionHandler:block];
}

-(void)wallpapersWithCompletionHandler:(DesktopprArrayBlock)block count:(NSInteger)count {
    [self wallpapersAtPath:@"wallpapers" count:count withCompletionHandler:block];
}

-(void)whoamiWithCompletionHandler:(DesktopprUserBlock)block {
    [self userInfoAtPath:@"user/whomai" withCompletionHandler:block];
}

@end
