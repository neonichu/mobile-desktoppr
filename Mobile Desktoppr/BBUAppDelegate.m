//
//  BBUAppDelegate.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "AFNetworkActivityIndicatorManager.h"
#import "BBUAppDelegate.h"
#import "BBUGalleryViewController.h"
#import "DropboxSDK.h"

@interface BBUAppDelegate ()

@property (strong) BBUGalleryViewController* galleryVC;

@end

#pragma mark -

@implementation BBUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.applicationSupportsShakeToEdit = YES;
    
    self.galleryVC = [BBUGalleryViewController new];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.galleryVC];
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];
    [[UIToolbar appearance] setTintColor:[UIColor lightGrayColor]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    DBSession* dbSession = [[DBSession alloc] initWithAppKey:@"2ylkrgxugq07kug"
                                                   appSecret:@"8vox0l7f0yi7jbj"
                                                        root:kDBRootDropbox];
    [DBSession setSharedSession:dbSession];
    //[[DBSession sharedSession] unlinkAll];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            UIViewController* frontmostViewController = [[(UINavigationController*)self.window.rootViewController
                                                          viewControllers] lastObject];
            if (frontmostViewController == self.galleryVC) {
                [self.galleryVC performSelector:@selector(uploadPicture) withObject:nil afterDelay:0.5];
            }
        }
        return YES;
    }
    
    return NO;
}

@end
