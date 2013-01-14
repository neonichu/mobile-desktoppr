//
//  DesktopprUser.h
//  Mobile Desktoppr
//
//  Created by Boris Bügling on 14.01.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesktopprUser : NSObject

@property (strong) NSString* username;

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
