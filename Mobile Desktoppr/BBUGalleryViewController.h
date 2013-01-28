//
//  BBUGalleryViewController.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "FGalleryViewController.h"

@class DesktopprUser;

@interface BBUGalleryViewController : FGalleryViewController

-(id)initWithUser:(DesktopprUser*)user;
-(void)uploadPicture;

@end
