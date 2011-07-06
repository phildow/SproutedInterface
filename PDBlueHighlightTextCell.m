//
//  PDBlueHighlightTextCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/10/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDBlueHighlightTextCell.h>


@implementation PDBlueHighlightTextCell


- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	[self setFocusRingType:NSFocusRingTypeNone];
	[self setShowsFirstResponder:NO];
	return self;
}


- (NSColor*) textColor {
	
	if ( [self isHighlighted] && ([[[self controlView] window] firstResponder] == [self controlView]) && 
			[[[self controlView] window] isMainWindow] && [[[self controlView] window] isKeyWindow] )
		return [NSColor whiteColor];
	else if ( [self isHighlighted] && 
			[(NSTableView*)[self controlView] editedRow] != -1 && [(NSTableView*)[self controlView] editedColumn] != -1 )
		return [NSColor whiteColor];
	else
		return [super textColor];
	
}

/*
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	//[super drawWithFrame:cellFrame inView:<#(NSView *)controlView#>
	
}
*/

@end
