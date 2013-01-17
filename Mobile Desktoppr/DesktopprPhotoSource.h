//
//  DesktopprPhotoSource.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "FGalleryViewController.h"

@interface DesktopprPhotoSource : NSObject <FGalleryViewControllerDelegate>

@property (strong) NSString* username;

-(void)showRandomPicture;
-(void)userListWithCompletionHandler:(void(^)(NSArray* objects, NSError* error))block;

@end
