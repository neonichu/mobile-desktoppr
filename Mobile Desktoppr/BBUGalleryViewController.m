//
//  BBUGalleryViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUGalleryViewController.h"
#import "DesktopprPhotoSource.h"

@interface FGalleryViewController ()

- (void)showThumbnailViewWithAnimation:(BOOL)animation;
- (void)hideThumbnailViewWithAnimation:(BOOL)animation;

@end

#pragma mark -

@interface BBUGalleryViewController ()

@property (strong) DesktopprPhotoSource* desktopprPhotoSource;
@property (strong) NSString* thumbnailNavigationTitle;

@end

#pragma mark -

@implementation BBUGalleryViewController

- (id)init {
    DesktopprPhotoSource* photoSource = [DesktopprPhotoSource new];
    
    self = [super initWithPhotoSource:photoSource];
    if (self) {
        self.desktopprPhotoSource = photoSource;
    }
    return self;
}

- (void)showThumbnailViewWithAnimation:(BOOL)animation {
    self.thumbnailNavigationTitle = self.navigationItem.title;
    self.navigationItem.title = [NSLocalizedString(@"Pictures by ", nil)
                                 stringByAppendingString:self.desktopprPhotoSource.username];
    
    [super showThumbnailViewWithAnimation:animation];
}

- (void)hideThumbnailViewWithAnimation:(BOOL)animation {
    self.navigationItem.title = self.thumbnailNavigationTitle;
    
    [super hideThumbnailViewWithAnimation:animation];
}

@end
