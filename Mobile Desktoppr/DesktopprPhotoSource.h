//
//  DesktopprPhotoSource.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "FGalleryViewController.h"

@class DesktopprUser;

@interface DesktopprPhotoSource : NSObject <FGalleryViewControllerDelegate>

@property (strong) NSString* username;

-(id)initWithUser:(DesktopprUser*)user;
-(void)showRandomPicture;
-(void)userListWithCompletionHandler:(void(^)(NSArray* objects, NSError* error))block;

@end
