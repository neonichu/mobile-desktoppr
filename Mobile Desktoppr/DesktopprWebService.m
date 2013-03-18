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
#import "NSData+Base64.h"
#import "SSKeychain.h"

static NSString* const kDesktopprServiceName = @"desktoppr.co";

@interface DesktopprWebService ()

@property (strong) NSString* apiToken;

@end

#pragma mark -

@implementation DesktopprWebService

+(instancetype)sharedService {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark -

-(void)addBasicAuthUsername:(NSString*)username password:(NSString*)password toRequest:(NSMutableURLRequest*)request {
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
}

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
        
        self.apiToken = [SSKeychain passwordForService:kDesktopprServiceName account:kDesktopprServiceName];
    }
    return self;
}

-(BOOL)isLoggedIn {
    return self.apiToken != nil;
}

-(void)likeWallpaper:(DesktopprPicture*)wallpaper {
    [self performActionWithName:@"like" onWallpaper:wallpaper];
}

-(void)listOfUsersWithCompletionHandler:(DesktopprArrayBlock)block {
    // FIXME: Hardcoded just one user here, because API lacks user listing.
    [self infoForUser:@"keithpitt" withCompletionHandler:^(DesktopprUser *user, NSError *error) {
        if (user) {
            block(@[ user ], nil);
        } else {
            block(nil, error);
        }
    }];
}

-(void)loginWithUsername:(NSString *)username password:(NSString *)password withCompletionHandler:(DesktopprUserBlock)block {
    NSMutableURLRequest* request = [self requestWithMethod:@"GET" path:@"user/whoami" parameters:nil];
    [self addBasicAuthUsername:username password:password toRequest:request];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            jsonData = jsonData[@"response"];
            
            DesktopprUser* user = [[DesktopprUser alloc] initWithDictionary:jsonData];
            self.apiToken = user.api_token;
            
            if (self.apiToken) {
                [SSKeychain setPassword:self.apiToken forService:kDesktopprServiceName account:kDesktopprServiceName];
            }
            
            block(user, nil);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
    [self enqueueHTTPRequestOperation:operation];
}

-(void)logout {
    self.apiToken = nil;
    
    [SSKeychain deletePasswordForService:kDesktopprServiceName account:kDesktopprServiceName];
}

-(void)performActionWithName:(NSString*)name onWallpaper:(DesktopprPicture*)wallpaper {
    [self getPath:[NSString stringWithFormat:@"user/wallpapers/%@/%@", wallpaper.id, name]
       parameters:nil
          success:NULL
          failure:NULL];
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

-(void)selectWallpaper:(DesktopprPicture*)wallpaper {
    [self performActionWithName:@"selection" onWallpaper:wallpaper];
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
                      id next = responseObject[@"pagination"][@"next"];
                      if (next == [NSNull null]) {
                          block(pictures, nil);
                          return;
                      }
                      NSInteger nextPage = [next integerValue];
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
