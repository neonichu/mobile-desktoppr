//
//  DesktopprPhotoSource.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "FGalleryViewController.h"

typedef void(^BBUTitleTapAction)(NSString* title);

@class DesktopprUser;

@interface DesktopprPhotoSource : NSObject <FGalleryViewControllerDelegate>

@property (copy) BBUTitleTapAction titleTapAction;
@property (readonly) NSString* username;

-(id)initWithUser:(DesktopprUser*)user;
-(NSArray*)pictures;
-(void)showRandomPicture;
-(void)switchToUser:(DesktopprUser*)user;
-(DesktopprUser*)user;

@end
