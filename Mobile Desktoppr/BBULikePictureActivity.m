//
//  BBULikePictureActivity.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 18.03.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBULikePictureActivity.h"
#import "DesktopprWebService.h"

@implementation BBULikePictureActivity

-(UIImage *)activityImage {
    return [UIImage imageNamed:@"heart"];
}

-(NSString *)activityTitle {
    return NSLocalizedString(@"Like", nil);
}

-(void)performActivityWithPicture:(DesktopprPicture *)picture {
    [self.webService likeWallpaper:picture];
}

@end
