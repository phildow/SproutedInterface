//
//  NSText+PDAdditions.h
//  SproutedUtilities
//
//  Created by Philip Dow on 6/26/06.
//  Copyright Sprouted. All rights reserved.
//	All inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface NSText (PDAdditions)

- (void)setFont:(NSFont *)aFont ranges:(NSArray*)theRanges;
- (void)setTextColor:(NSColor *)aColor ranges:(NSArray*)theRanges;

@end
