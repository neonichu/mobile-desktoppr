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

@interface DesktopprPhotoSource ()

@property (weak) FGalleryViewController* gallery;
@property (strong) NSArray* pictures;
@property (strong) DesktopprWebService* webService;

@end

#pragma mark -

@implementation DesktopprPhotoSource

- (id)init {
    self = [super init];
    if (self) {
        self.username = @"keithpitt";
        
        self.webService = [DesktopprWebService new];
        [self.webService wallpapersForUser:self.username
                                     count:40
                     withCompletionHandler:^(NSArray *pictures, NSError *error) {
                         if (pictures) {
                             NSAssert(pictures.count == 40, @"Didn't get enough pictures.");
                             self.pictures = pictures;
                             [self.gallery reloadGallery];
                         } else {
                            NSLog(@"Error: %@", error.localizedDescription);
                         }
                     }];

        // For testing
        [self.webService infoForUser:self.username withCompletionHandler:^(DesktopprUser *user, NSError *error) {
            if (user) {
                NSLog(@"User: %@", user.username);
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];

        [self.webService randomWallpaperForUser:self.username
                          withCompletionHandler:^(DesktopprPicture *picture, NSError *error) {
                              if (picture) {
                                  NSLog(@"Picture: %@", picture.fullsizeURL);
                              } else {
                                  NSLog(@"Error: %@", error.localizedDescription);
                              }
                          }];
    }
    return self;
}

- (void)showRandomPicture {
    [self.webService randomWallpaperWithCompletionHandler:^(DesktopprPicture *picture, NSError *error) {
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

- (void)userListWithCompletionHandler:(DesktopprArrayBlock)block {
    [self.webService listOfUsersWithCompletionHandler:block];
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
            return [self.pictures[index] fullsizeURL];
        case FGalleryPhotoSizeThumbnail:
            return [self.pictures[index] thumbnailURL];
        default:
            break;
    }

    return nil;
}

@end
