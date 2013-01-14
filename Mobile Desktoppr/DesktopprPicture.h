//
//  DesktopprPicture.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesktopprPicture : NSObject

@property (strong) NSString* caption;
@property (strong) NSString* fullsizeURL;
@property (strong) NSString* thumbnailURL;

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
