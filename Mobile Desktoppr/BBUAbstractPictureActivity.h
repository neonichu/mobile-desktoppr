//
//  BBUAbstractPictureActivity.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 18.03.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "ZYActivity.h"

@class DesktopprPicture;
@class DesktopprWebService;

@interface BBUAbstractPictureActivity : ZYActivity

-(id)initWithWebService:(DesktopprWebService*)webService;
-(void)performActivityWithPicture:(DesktopprPicture*)picture;
-(DesktopprWebService*)webService;

@end
