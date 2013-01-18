//
//  DesktopprUser.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesktopprUser : NSObject

@property (readonly) NSURL* avatar_url;
@property (readonly) NSDate* created_at;
@property (readonly) NSNumber* followers_count;
@property (readonly) NSNumber* following_count;
@property (readonly) NSNumber* lifetime_member;
@property (readonly) NSString* name;
@property (readonly) NSNumber* uploaded_count;
@property (readonly) NSString* username;
@property (readonly) NSNumber* wallpapers_count;

@property (readonly) NSDictionary* externalRepresentation;

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
