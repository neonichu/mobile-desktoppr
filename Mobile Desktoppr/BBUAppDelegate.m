//
//  BBUAppDelegate.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUAppDelegate.h"
#import "DesktopprPhotoSource.h"
#import "FGalleryViewController.h"

@interface BBUAppDelegate ()

@property (strong) FGalleryViewController* galleryVC;
@property (strong) DesktopprPhotoSource* photoSource;

@end

#pragma mark -

@implementation BBUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.photoSource = [[DesktopprPhotoSource alloc] init];
    self.galleryVC = [[FGalleryViewController alloc] initWithPhotoSource:self.photoSource];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.galleryVC];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
