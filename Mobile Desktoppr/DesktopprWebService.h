//
//  DesktopprWebService.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFHTTPClient.h"

@class DesktopprPicture;
@class DesktopprUser;

typedef void(^DesktopprArrayBlock)(NSArray* objects, NSError* error);
typedef void(^DesktopprPictureBlock)(DesktopprPicture* picture, NSError* error);
typedef void(^DesktopprUserBlock)(DesktopprUser* user, NSError* error);

@interface DesktopprWebService : AFHTTPClient

@property (strong) NSString* apiToken;

-(void)infoForUser:(NSString*)username withCompletionHandler:(DesktopprUserBlock)block;
-(void)listOfUsersWithCompletionHandler:(DesktopprArrayBlock)block;
-(void)randomWallpaperWithCompletionHandler:(DesktopprPictureBlock)block;
-(void)randomWallpaperForUser:(NSString*)username withCompletionHandler:(DesktopprPictureBlock)block;
-(void)wallpapersWithCompletionHandler:(DesktopprArrayBlock)block count:(NSInteger)count;
-(void)wallpapersForUser:(NSString*)username count:(NSInteger)count withCompletionHandler:(DesktopprArrayBlock)block;
-(void)whoamiWithCompletionHandler:(DesktopprUserBlock)block;

@end
