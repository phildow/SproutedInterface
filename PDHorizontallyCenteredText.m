//
//  PDHorizontallyCenteredText.m
//  SproutedInterface
//
//  Created by Philip Dow on 6/19/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDHorizontallyCenteredText.h>
#import <SproutedUtilities/NSParagraphStyle_PDAdditions.h>

@implementation PDHorizontallyCenteredText

- (BOOL) isSelected
{
	return selected;
}

- (void) setSelected:(BOOL)isSelected
{
	selected = isSelected;
}

- (BOOL) boldsWhenSelected
{
	return boldsWhenSelected;
}

- (void) setBoldsWhenSelected:(BOOL)doesBold
{
	boldsWhenSelected = doesBold;
}

#pragma mark -

- (NSColor*) textColor {
	
	//if ( [self isHighlighted] && ([[[self controlView] window] firstResponder] == [self controlView]) && 
	//		[[[self controlView] window] isMainWindow] && [[[self controlView] window] isKeyWindow] )
	//	return [NSColor whiteColor];
	if ( [self isHighlighted] && [[[self controlView] window] firstResponder] == [self controlView] )
	{
		if ( [[[self controlView] window] isKindOfClass:[NSPanel class]] && [[[self controlView] window] isKeyWindow] )
			return [NSColor whiteColor];
		
		else if ( [[[self controlView] window] isMainWindow] && [[[self controlView] window] isKeyWindow] )
			return [NSColor whiteColor];
		
		else
			return [super textColor];
	}
		
	else if ( [self isHighlighted] && [(NSTableView*)[self controlView] editedRow] != -1 && [(NSTableView*)[self controlView] editedColumn] != -1 )
		return [NSColor whiteColor];
	else
		return [super textColor];
	
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSMutableAttributedString *attrString = [[[self attributedStringValue] mutableCopyWithZone:[self zone]] autorelease];
	[attrString addAttribute:NSParagraphStyleAttributeName value:
	[NSParagraphStyle defaultParagraphStyleWithLineBreakMode:NSLineBreakByTruncatingTail] 
	range:NSMakeRange(0,[attrString length])];
	
	NSSize stringSize = [attrString size];
	cellFrame.origin.y += ( cellFrame.size.height/2 - stringSize.height/2 );
	
	if ([self isSelected]) 
	{
		// prepare the text in white.
		[attrString addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0,[attrString length])];
		
		// bold the text if that option has been requested
		if ( [attrString length] > 0 && [self boldsWhenSelected] )
		{
			NSFont *originalFont = [attrString attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
			if ( originalFont ) {
				NSFont *boldedFont = [[NSFontManager sharedFontManager] convertFont:originalFont toHaveTrait:NSBoldFontMask];
				if ( boldedFont )
					[attrString addAttribute:NSFontAttributeName value:boldedFont range:NSMakeRange(0,[attrString length])];
			}
		}
	}
	
	[attrString drawInRect:cellFrame];
	//[super drawInteriorWithFrame:cellFrame inView:controlView];
}

- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	return nil;
}

@end
