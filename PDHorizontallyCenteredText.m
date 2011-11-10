//
//  PDHorizontallyCenteredText.m
//  SproutedInterface
//
//  Created by Philip Dow on 6/19/07.
//  Copyright Philip Dow / Sprouted. All rights reserved.
//

/*
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the organization nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

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
