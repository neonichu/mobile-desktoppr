//
//  BBUAbstractPictureActivity.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 18.03.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "ZYActivity.h"

@class DesktopprPicture;

@interface BBUAbstractPictureActivity : ZYActivity

-(void)performActivityWithPicture:(DesktopprPicture*)picture;

@end
