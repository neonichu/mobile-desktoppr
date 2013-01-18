//
//  DesktopprUser.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "DesktopprUser.h"

@implementation DesktopprUser

-(NSString*)description {
    return [[NSString alloc] initWithData:self.JSONData encoding:NSUTF8StringEncoding];
}

-(NSDictionary*)externalRepresentation {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	dict[@"avatar_url"] = self.avatar_url;
	dict[@"created_at"] = self.created_at;
	dict[@"followers_count"] = self.followers_count;
	dict[@"following_count"] = self.following_count;
	dict[@"lifetime_member"] = self.lifetime_member;
	dict[@"name"] = self.name;
	dict[@"uploaded_count"] = self.uploaded_count;
	dict[@"username"] = self.username;
	dict[@"wallpapers_count"] = self.wallpapers_count;
	return dict;
}

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
		NSString* avatar_url = dictionary[@"avatar_url"];
		_avatar_url = avatar_url ? [NSURL URLWithString:avatar_url] : nil;
		_created_at = dictionary[@"created_at"];
		_followers_count = dictionary[@"followers_count"];
		_following_count = dictionary[@"following_count"];
		_lifetime_member = dictionary[@"lifetime_member"];
		_name = dictionary[@"name"];
		_uploaded_count = dictionary[@"uploaded_count"];
		_username = dictionary[@"username"];
		_wallpapers_count = dictionary[@"wallpapers_count"];
	}
    return self;
}

-(NSData*)JSONData {
    return [NSJSONSerialization dataWithJSONObject:self.externalRepresentation
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

@end
