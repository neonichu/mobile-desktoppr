//
//  BBUAppDelegate.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUAppDelegate.h"
#import "BBUGalleryViewController.h"

@interface BBUAppDelegate ()

@property (strong) BBUGalleryViewController* galleryVC;

@end

#pragma mark -

@implementation BBUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.galleryVC = [[BBUGalleryViewController alloc] init];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.galleryVC];
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];
    [[UIToolbar appearance] setTintColor:[UIColor lightGrayColor]];
    
    return YES;
}

@end
