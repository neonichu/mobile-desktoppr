//
//  DesktopprPicture.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesktopprPicture : NSObject

@property (readonly) NSNumber* bytes;
@property (readonly) NSDate* created_at;
@property (readonly) NSNumber* height;
@property (readonly) NSNumber* id;
@property (readonly) NSString* review_state;
@property (readonly) NSString* uploader;
@property (readonly) NSURL* url;
@property (readonly) NSNumber* user_count;
@property (readonly) NSNumber* views_count;
@property (readonly) NSNumber* width;

@property (strong) NSString* caption;
@property (strong) NSURL* fullsize_url;
@property (strong) NSURL* thumbnail_url;

@property (readonly) NSDictionary* externalRepresentation;

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
