//
//  PDBorderedFill.h
//  SproutedInterface
//
//  Created by Philip Dow on 12/15/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface PDBorderedView : NSView {
	
	int			borders[4];
	BOOL		bordered;
	
	NSColor		*fillColor;
	NSColor		*borderColor;
	
}

- (int*) borders;
- (void) setBorders:(int*)sides;

- (BOOL) bordered;
- (void) setBordered:(BOOL)flag;

- (NSColor*) fillColor;
- (void) setFillColor:(NSColor*)aColor;

- (NSColor*) borderColor;
- (void) setBorderColor:(NSColor*)aColor;

@end
