//
//  BBUSyncPictureActivity.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 18.03.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUSyncPictureActivity.h"
#import "DesktopprWebService.h"

@implementation BBUSyncPictureActivity

-(UIImage *)activityImage {
    return [UIImage imageNamed:@"sync"];
}

-(NSString *)activityTitle {
    return NSLocalizedString(@"Sync", nil);
}

-(void)performActivityWithPicture:(DesktopprPicture *)picture {
    [[DesktopprWebService sharedService] selectWallpaper:picture];
}

@end
