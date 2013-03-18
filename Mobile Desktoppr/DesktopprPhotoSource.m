//
//  DesktopprPhotoSource.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "DesktopprPhotoSource.h"
#import "DesktopprPicture.h"
#import "DesktopprUser.h"
#import "DesktopprWebService.h"
#import "UIAlertView+BBU.h"

static NSString* const kDefaultUser = @"neonacho";

@interface DesktopprPhotoSource ()

@property (weak) FGalleryViewController* gallery;
@property (strong) NSArray* pictures;
@property (strong) DesktopprUser* user;

@end

#pragma mark -

@implementation DesktopprPhotoSource

- (void)fetchWallpapers {
    [[DesktopprWebService sharedService] wallpapersForUser:self.username
                                                     count:40
                                     withCompletionHandler:^(NSArray *pictures, NSError *error) {
                                         if (pictures) {
                                             self.pictures = pictures;
                                             [self.gallery reloadGallery];
                                         } else {
                                             [UIAlertView bbu_showAlertWithError:error];
                                         }
                                     }];
}

- (id)init {
    self = [self initWithUser:nil];
    return self;
}

- (id)initWithUser:(DesktopprUser*)user {
    self = [super init];
    if (self) {
        if (user) {
            self.user = user;
            
            [self fetchWallpapers];
        } else {
            if ([[DesktopprWebService sharedService] isLoggedIn]) {
                [[DesktopprWebService sharedService] whoamiWithCompletionHandler:^(DesktopprUser *user, NSError *error) {
                    if (!user) {
                        [UIAlertView bbu_showAlertWithError:error];
                        return;
                    }
                    
                    self.user = user;
                    
                    [self fetchWallpapers];
                }];
            } else {
                [[DesktopprWebService sharedService] infoForUser:kDefaultUser
                                           withCompletionHandler:^(DesktopprUser *user, NSError *error) {
                                               if (!user) {
                                                   [UIAlertView bbu_showAlertWithError:error];
                                                   return;
                                               }
                                               
                                               self.user = user;
                                               
                                               [self fetchWallpapers];
                                           }];
            }
        }
    }
    return self;
}

- (void)showRandomPicture {
    [[DesktopprWebService sharedService] randomWallpaperWithCompletionHandler:^(DesktopprPicture *picture, NSError *error) {
        if (picture) {
            self.pictures = @[ picture ];
            [self.gallery reloadGallery];
            // TODO: User as navigation title
            // TODO: Tap navigation title to jump to user
        } else {
            [UIAlertView bbu_showAlertWithError:error];
        }
    }];
}

- (NSString*)username {
    return self.user.username;
}

#pragma mark - FGalleryViewController delegate methods

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController*)gallery {
    self.gallery = gallery;
    return self.pictures.count;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index {
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery captionForPhotoAtIndex:(NSUInteger)index {
    return [self.pictures[index] caption];
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery urlForPhotoSize:(FGalleryPhotoSize)size
                  atIndex:(NSUInteger)index {
    switch (size) {
        case FGalleryPhotoSizeFullsize:
            return [self.pictures[index] fullsize_url].absoluteString;
        case FGalleryPhotoSizeThumbnail:
            return [self.pictures[index] thumbnail_url].absoluteString;
        default:
            break;
    }

    return nil;
}

@end
