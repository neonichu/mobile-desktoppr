//
//  DesktopprPicture.m
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "DesktopprPicture.h"
#import "ISO8601DateFormatter.h"

@implementation DesktopprPicture

-(NSString*)description {
    return [[NSString alloc] initWithData:self.JSONData encoding:NSUTF8StringEncoding];
}

-(NSDictionary*)externalRepresentation {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	dict[@"bytes"] = self.bytes;
	dict[@"created_at"] = self.created_at;
	dict[@"height"] = self.height;
	dict[@"id"] = self.id;
	dict[@"review_state"] = self.review_state;
    dict[@"uploader"] = self.uploader;
	dict[@"url"] = self.url;
	dict[@"user_count"] = self.user_count;
	dict[@"views_count"] = self.views_count;
	dict[@"width"] = self.width;
	return dict;
}

-(id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
		_bytes = dictionary[@"bytes"];
        _created_at = [[ISO8601DateFormatter new] dateFromString:dictionary[@"created_at"]];
		_height = dictionary[@"height"];
		_id = dictionary[@"id"];
		_review_state = dictionary[@"review_state"];
        _uploader = dictionary[@"uploader"];
		NSString* url = dictionary[@"url"];
		_url = url ? [NSURL URLWithString:url] : nil;
		_user_count = dictionary[@"user_count"];
		_views_count = dictionary[@"views_count"];
		_width = dictionary[@"width"];
        
        self.caption = [dictionary[@"url"] lastPathComponent];
        NSString* urlString = dictionary[@"image"][@"url"];
        self.fullsize_url = urlString ? [NSURL URLWithString:urlString] : nil;
        urlString = dictionary[@"image"][@"thumb"][@"url"];
        self.thumbnail_url = urlString ? [NSURL URLWithString:urlString] : nil;
	}
    return self;
}

-(NSData*)JSONData {
    return [NSJSONSerialization dataWithJSONObject:self.externalRepresentation
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

@end
