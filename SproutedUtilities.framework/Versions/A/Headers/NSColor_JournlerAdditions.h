//
//  NSColor_JournlerAdditions.h
//  SproutedUtilities
//
//  Created by Philip Dow on 1/9/07.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface NSColor (JournlerAdditions)

+ (NSColor*) colorForLabel:(int)label gradientEnd:(BOOL)end;
+ (NSColor*) darkColorForLabel:(int)label gradientEnd:(BOOL)end;

@end
