//
//  DesktopprUser.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "DesktopprUser.h"

@implementation DesktopprUser

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        NSString* avatarUrl = dictionary[@"avatar_url"];
        if (avatarUrl) {
            self.avatarUrl = [NSURL URLWithString:avatarUrl];
        }
        
        self.username = dictionary[@"username"];
    }
    return self;
}

@end
