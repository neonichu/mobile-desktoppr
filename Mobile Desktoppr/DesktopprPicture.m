//
//  DesktopprPicture.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "DesktopprPicture.h"

@implementation DesktopprPicture

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.caption = [dictionary[@"url"] lastPathComponent];
        self.fullsizeURL = dictionary[@"image"][@"url"];
        self.thumbnailURL = dictionary[@"image"][@"thumb"][@"url"];
    }
    return self;
}

@end
