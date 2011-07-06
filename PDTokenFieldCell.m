//
//  PDTokenFieldCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 7/16/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//
//	Note that PDTokenFieldCell does not require PDTokenField
//

#import <SproutedInterface/PDTokenFieldCell.h>


@implementation PDTokenFieldCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	//NSLog(@"%@ %s view is a %@",[self className],_cmd,[controlView className]);
	
	[self setControlSize:NSSmallControlSize];
	[super drawWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	//NSLog(@"%@ %s view is a %@",[self className],_cmd,[controlView className]);
	
	// a small adjustment if we're running 10.4 but not 10.5
	if ( ![self respondsToSelector:@selector(scriptingValueForSpecifier:)] )
		cellFrame.origin.y -= 1;
	
	[self setControlSize:NSSmallControlSize];
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}

#pragma mark -
#pragma mark Fixes for Bindings Problem with Dragging & Copy/Paste

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    if ([super performDragOperation:sender])
    {
        //NSLog(@"perform custom drag operation");
		
        if ( [self delegate] != nil && [[self delegate] respondsToSelector:@selector(tokenFieldCell:didReadTokens:fromPasteboard:)] )
			[[self delegate] tokenFieldCell:self didReadTokens:[self objectValue] fromPasteboard:[sender draggingPasteboard]];
			
        return YES;
    }
	else
	{
		return NO;
	}
}

- (id) _tokensFromPasteboard:(id)fp8
{
	id tokens = [super _tokensFromPasteboard:fp8];
	
	if ( [self delegate] != nil && [[self delegate] respondsToSelector:@selector(tokenFieldCell:didReadTokens:fromPasteboard:)] )
		[[self delegate] tokenFieldCell:self didReadTokens:tokens fromPasteboard:fp8];
		
	return tokens;
}

@end
