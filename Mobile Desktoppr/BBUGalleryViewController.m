//
//  BBUGalleryViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "BBUGalleryViewController.h"
#import "BBUSettingsViewController.h"
#import "BBUUserListViewController.h"
#import "DesktopprPhotoSource.h"
#import "MBProgressHUD.h"
#import "UIAlertView+BBU.h"

static NSString* const kUsedBefore = @"org.vu0.usedBefore";

@interface FGalleryViewController ()

- (void)arrangeThumbs;
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

- (void)backTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enableSeeAll:(BOOL)enabled {
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

- (void)initialize {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                          target:self
                                                                                          action:@selector(saveTapped)];
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
        
        [self initialize];
    }
    return self;
}

-(id)initWithUser:(DesktopprUser*)user {
    DesktopprPhotoSource* photoSource = [[DesktopprPhotoSource alloc] initWithUser:user];
    
    NSArray* barItems = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                      target:self action:@selector(backTapped)],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
    ];
    
    self = [super initWithPhotoSource:photoSource barItems:barItems];
    if (self) {
        self.desktopprPhotoSource = photoSource;
        
        self.toolbarItems = nil;
        
        [self initialize];
    }
    return self;
}

- (void)randomTapped {
    [self enableSeeAll:NO];
    [self.desktopprPhotoSource showRandomPicture];
}

- (void)saveTapped {
    [self writeCurrentPictureToAssetGroup:nil];

    // TODO: Finish code for writing to custom assets group
#if 0
    NSString* const albumName = NSLocalizedString(@"Homescreenr", nil);
    
    __block BOOL done = NO;
    
    ALAssetsLibrary* library = [ALAssetsLibrary new];
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
            [self writeCurrentPictureToAssetGroup:group];
            
            done = YES;
            *stop = YES;
        }
    } failureBlock:^(NSError *error) {
        [UIAlertView bbu_showAlertWithError:error];
    }];
    
    if (done) {
        return;
    }
    
    [library addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
        [self writeCurrentPictureToAssetGroup:group];
    } failureBlock:^(NSError *error) {
        [UIAlertView bbu_showAlertWithError:error];
    }];
#endif
}

- (void)settingsTapped {
    BBUSettingsViewController* settings = [BBUSettingsViewController new];
    [self.navigationController pushViewController:settings animated:YES];
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

- (void)writeCurrentPictureToAssetGroup:(ALAssetsGroup*)group {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIImage* currentPicture = [self->_photoViews[self.currentIndex] imageView].image;
    if (!currentPicture) {
        return;
    }
    // TODO: Make image fit device size and pixel-ratio to not waste space

    UIImageWriteToSavedPhotosAlbum(currentPicture,
                                   self,
                                   @selector(writingCompletedWithImage:error:contextInfo:),
                                   (__bridge void *)(group));
}

- (void)writingCompletedWithImage:(UIImage*)image error:(NSError*)error contextInfo:(void*)contextInfo {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (error) {
        [UIAlertView bbu_showAlertWithError:error];
        return;
    }
    
    ALAssetsGroup* group = (__bridge ALAssetsGroup *)(contextInfo);
    if (group.editable) {
        // TODO: Finish code for writing to custom assets group
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kUsedBefore]) {
        [UIAlertView bbu_showInfoWithMessage:NSLocalizedString(@"The image was saved to your photo library, you can set it "
                                                               "as wallpaper from there.", nil)];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUsedBefore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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

#pragma mark - Overriden from superclass to fix navigation title and content size

- (void)arrangeThumbs {
    [super arrangeThumbs];
    
    _thumbsView.contentSize = CGSizeMake(_thumbsView.contentSize.width, _thumbsView.contentSize.height - 75.0);
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
