//
//  BBUGalleryViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUGalleryViewController.h"
#import "BBUUserListViewController.h"
#import "DesktopprPhotoSource.h"
#import "MBProgressHUD.h"

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

- (void)enableSeeAll:(BOOL)enabled {
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

- (id)init {
    DesktopprPhotoSource* photoSource = [DesktopprPhotoSource new];
    
    NSArray* barItems = @[
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"earthquake"] style:UIBarButtonItemStylePlain
                                        target:self action:@selector(randomTapped)],
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user"] style:UIBarButtonItemStylePlain
                                        target:self action:@selector(userTapped)],
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list"] style:UIBarButtonItemStylePlain
                                                  target:self action:@selector(browseTapped)],
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gears"] style:UIBarButtonItemStylePlain
                                        target:self action:@selector(settingsTapped)],
    
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL],
    ];
    [barItems[2] setEnabled:NO];
    
    self = [super initWithPhotoSource:photoSource barItems:barItems];
    if (self) {
        self.desktopprPhotoSource = photoSource;
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Home", nil)
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:nil
                                                                                action:NULL];
        // TODO: No upload API exists yet.
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                              target:nil
                                                                                              action:NULL];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    return self;
}

- (void)randomTapped {
    [self enableSeeAll:NO];
    [self.desktopprPhotoSource showRandomPicture];
}

- (void)settingsTapped {
    // TODO: Show settings
}

- (void)userTapped {
    [self enableSeeAll:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.desktopprPhotoSource userListWithCompletionHandler:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        BBUUserListViewController* userList = [[BBUUserListViewController alloc] initWithUsers:objects];
        [self.navigationController pushViewController:userList animated:YES];
    }];
}

#pragma mark - Shake to see random picture

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self randomTapped];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

#pragma mark - Overriden from superclass to fix navigation title

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
