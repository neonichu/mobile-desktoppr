//
//  BBUGalleryViewController.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 17.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "AFNetworkActivityIndicatorManager.h"
#import "BBUGalleryViewController.h"
#import "BBUSettingsViewController.h"
#import "BBUUserListViewController.h"
#import "DesktopprPhotoSource.h"
#import "DropboxSDK.h"
#import "MBProgressHUD.h"
#import "UIAlertView+BBU.h"

#define SCREENSHOT_MODE     0

static NSString* const kUsedBefore = @"org.vu0.usedBefore";

@interface FGalleryViewController ()

- (void)arrangeThumbs;
- (void)showThumbnailViewWithAnimation:(BOOL)animation;
- (void)hideThumbnailViewWithAnimation:(BOOL)animation;

@end

#pragma mark -

@interface BBUGalleryViewController () <DBRestClientDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong) UIBarButtonItem* addButton;
@property (strong) DesktopprPhotoSource* desktopprPhotoSource;
@property (nonatomic, strong) DBRestClient* dropboxClient;
@property (strong) NSString* thumbnailNavigationTitle;

@end

#pragma mark -

@implementation BBUGalleryViewController

- (void)addTapped {
    self.addButton.enabled = NO;
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [self uploadPicture];
    }
}

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
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped)],
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
    [barItems[3] setEnabled:NO];
    
    self.addButton = barItems[0];
    
#if SCREENSHOT_MODE
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    photoSource = nil;
    
    for (UIBarButtonItem* barItem in barItems) {
        barItem.enabled = NO;
    }
#else
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
#endif
    
    self = [super initWithPhotoSource:photoSource barItems:barItems];
    if (self) {
        self.desktopprPhotoSource = photoSource;
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Home", nil)
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:nil
                                                                                action:NULL];
        
        [self initialize];
    }
    
#if SCREENSHOT_MODE
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.useThumbnailView = NO;
#endif
    
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

- (void)uploadPicture {
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
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

#pragma mark - UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];
    
    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                      stringByAppendingFormat:@"/%@.jpg", [[NSUUID UUID] UUIDString]];
    UIImage* originalImage = info[UIImagePickerControllerOriginalImage];
    [UIImageJPEGRepresentation(originalImage, 1.0) writeToFile:path atomically:YES];
    
    [self uploadFileAtPath:path withName:[path lastPathComponent]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Dropbox upload handling

- (DBRestClient *)dropboxClient {
    if (!_dropboxClient) {
        _dropboxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _dropboxClient.delegate = self;
    }
    
    return _dropboxClient;
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath
          metadata:(DBMetadata *)metadata {
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    
    [[NSFileManager defaultManager] removeItemAtPath:srcPath error:nil];
    [UIAlertView bbu_showInfoWithMessage:NSLocalizedString(@"Upload finished successfully.", nil)];
    
    self.addButton.enabled = YES;
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    
    [UIAlertView bbu_showAlertWithError:error];
    
    self.addButton.enabled = YES;
}

- (void)uploadFileAtPath:(NSString*)filePath withName:(NSString*)name {
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    [self.dropboxClient uploadFile:name toPath:@"/Apps/Desktoppr" withParentRev:nil fromPath:filePath];
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
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.title = self.desktopprPhotoSource.username;
    
    [super showThumbnailViewWithAnimation:animation];
}

- (void)hideThumbnailViewWithAnimation:(BOOL)animation {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.title = self.thumbnailNavigationTitle;
    
    [super hideThumbnailViewWithAnimation:animation];
}

@end
