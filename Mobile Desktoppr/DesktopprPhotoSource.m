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
    self = [self initWithUser:nil];
    return self;
}

- (id)initWithUser:(DesktopprUser*)user {
    self = [super init];
    if (self) {
        // FIXME: Do not hardcode startup user
        self.username = user ? user.username : @"neonacho";
        
        self.webService = [DesktopprWebService new];
        [self.webService wallpapersForUser:self.username
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
