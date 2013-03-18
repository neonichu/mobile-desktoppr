//
//  BBUPhotoAlbumActivity.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 18.03.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "BBUPhotoAlbumActivity.h"
#import "UIAlertView+BBU.h"
#import "UIImage+Resize.h"

#define ALBUM_NAME          NSLocalizedString(@"Homescreenr", nil)

static NSString* const kUsedBefore = @"org.vu0.usedBefore";

@interface BBUPhotoAlbumActivity ()

@property (strong) ALAssetsLibrary* assetLibrary;

@end

#pragma mark -

@implementation BBUPhotoAlbumActivity

-(UIImage *)activityImage {
    return [UIImage imageNamed:@"camera"];
}

- (NSString *)activityTitle {
    return NSLocalizedString(@"Save to Photo Album", nil);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)moveAssetToGroup:(ALAsset*)asset {
    __block BOOL done = NO;
    
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:ALBUM_NAME]) {
            if (group.editable) {
                [group addAsset:asset];
            }
            
            done = YES;
            *stop = YES;
        }
    } failureBlock:^(NSError *error) {
        [UIAlertView bbu_showAlertWithError:error];
    }];
    
    if (!done) {
        [self.assetLibrary addAssetsGroupAlbumWithName:ALBUM_NAME resultBlock:^(ALAssetsGroup *group) {
            if (group.editable) {
                [group addAsset:asset];
            }
        } failureBlock:^(NSError *error) {
            [UIAlertView bbu_showAlertWithError:error];
        }];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kUsedBefore]) {
        [UIAlertView bbu_showInfoWithMessage:NSLocalizedString(@"The image was saved to your photo library, you can set it "
                                                               "as wallpaper from there.", nil)];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUsedBefore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.assetLibrary = nil;
    
    [self activityDidFinish:YES];
}

- (void)moveAssetWithURLToGroup:(NSURL*)assetURL {
    [self.assetLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        [self moveAssetToGroup:asset];
    } failureBlock:^(NSError *error) {
        [UIAlertView bbu_showAlertWithError:error];
    }];
}

- (UIViewController*)performWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[UIImage class]]) {
            [self saveImage:(UIImage*)activityItem];
        }
    }
    
    return nil;
}

- (void)saveImage:(UIImage*)image {
    CGFloat neededWidth = [[UIScreen mainScreen] bounds].size.width * [UIScreen mainScreen].scale;
    if (neededWidth < image.size.width) {
        CGFloat neededHeight = image.size.height * (neededWidth / image.size.width);
        image = [image bbu_scaledImageWithSize:CGSizeMake(neededWidth, neededHeight)];
    }
    
    self.assetLibrary = [ALAssetsLibrary new];
    [self.assetLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:nil
                                    completionBlock:^(NSURL *assetURL, NSError *error) {
                                        if (!assetURL) {
                                            [UIAlertView bbu_showAlertWithError:error];
                                            return;
                                        }
                                        
                                        [self moveAssetWithURLToGroup:assetURL];
                                    }];
}

@end
