//
//  BBUAbstractPictureActivity.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 18.03.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUAbstractPictureActivity.h"
#import "DesktopprPicture.h"
#import "DesktopprWebService.h"

@interface BBUAbstractPictureActivity ()

@property (strong) DesktopprWebService* webService;

@end

#pragma mark -

@implementation BBUAbstractPictureActivity

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[DesktopprPicture class]]) {
            return YES;
        }
    }
    
    return NO;
}

-(id)initWithWebService:(DesktopprWebService*)webService {
    self = [super init];
    if (self) {
        self.webService = webService;
    }
    return self;
}

-(void)performActivityWithPicture:(DesktopprPicture *)picture {
    [self doesNotRecognizeSelector:_cmd];
}

-(UIViewController*)performWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[DesktopprPicture class]]) {
            [self performActivityWithPicture:(DesktopprPicture*)activityItem];
        }
    }
    
    return nil;
}

@end
