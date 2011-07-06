//
//  NSApplication+PDAdditions.h
//  SproutedUtilities
//
//  Created by Philip Dow on 9/10/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface NSApplication (PDAdditions)

- (NSWindowController*) singletonControllerWithClass:(Class)aClass;

@end
