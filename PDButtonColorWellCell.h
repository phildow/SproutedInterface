//
//  PDButtonColorWellCell.h
//  SproutedInterface
//
//  Created by Philip Dow on 1/7/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface PDButtonColorWellCell : NSButtonCell {
	
	NSColor *_color;
	
}

- (NSColor*) color;
- (void) setColor:(NSColor*)color;

@end
