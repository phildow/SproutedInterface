//
//  PDButtonColorWellCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 1/7/06.
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

#import <SproutedInterface/PDButtonColorWellCell.h>

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

#define kLabelOffset 20

@implementation PDButtonColorWellCell

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		[self setBordered:NO];
	}
	
	return self;	
}

- (id)initTextCell:(NSString *)aString {
	
	if ( self = [super initTextCell:aString] ) {
		[self setBordered:NO];
	}
	
	return self;
}

- (void) dealloc {
	
	[_color release];
	[super dealloc];
}

#pragma mark -


- (NSColor*) color 
{
	return _color; 
}

- (void) setColor:(NSColor*)color 
{
	if ( _color != color ) 
	{
		[self willChangeValueForKey:@"color"];
		[_color release];
		_color = [color copyWithZone:[self zone]];
		[self didChangeValueForKey:@"color"];
	}
}

#pragma mark -

- (NSRect)drawingRectForBounds:(NSRect)theRect {
	return theRect;
}

- (NSRect)titleRectForBounds:(NSRect)theRect {
	return theRect;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	//
	// bypass the frame
	//
	
	[self drawInteriorWithFrame:cellFrame inView:controlView];
	
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	float alpha = ( [self isEnabled] ? 1.0 : 0.70 );
	NSColor *gradientStart, *gradientEnd, *borderColor;
	
	if ( [self isHighlighted] /*|| [self state] == NSOnState*/ ) {
		
		borderColor = [NSColor colorWithCalibratedRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:alpha];
		gradientStart = [NSColor colorWithCalibratedRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:alpha];
		gradientEnd = [NSColor colorWithCalibratedRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:alpha];
	}
	else {
		
		borderColor = [NSColor colorWithCalibratedRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:alpha];
		gradientEnd = [NSColor colorWithCalibratedRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:alpha];
		gradientStart = [NSColor colorWithCalibratedRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:alpha];
	}
	
	NSRect targetRect = cellFrame;
	targetRect = NSInsetRect(targetRect,0.5,0.5);
	//targetRect.origin.x += 0.5; targetRect.origin.y += 0.5; targetRect.size.width = 21; targetRect.size.height -= 1;
	
	NSBezierPath *thePath = [NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:2.0];
	[thePath linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
	
	[borderColor set];
	[thePath stroke];
	
	//
	// draw the color inside the cell image
	NSColor *cellColor = [self color];
	if ( !cellColor ) cellColor = [NSColor blackColor];

	[cellColor set];
	//NSRect colorRect = NSInsetRect(targetRect, 5.0, 4.0);
	NSRect colorRect = targetRect;
	colorRect.origin.x += 5; colorRect.origin.y += 4; colorRect.size.width = 10; colorRect.size.height -= 8;
	NSBezierPath *insetPath = [NSBezierPath bezierPathWithRoundedRect:colorRect cornerRadius:2.0];
	
	[insetPath fill];
	
	[[borderColor colorWithAlphaComponent:0.7] set];
	
	//[borderColor set];
	[insetPath stroke];
	
	if ( [[self title] length] != 0 )
	{
		cellFrame.origin.x += kLabelOffset;
		cellFrame.size.width -= kLabelOffset;
		
		[super drawInteriorWithFrame:cellFrame inView:controlView];
	}
	
}

/*
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	float alpha = ( [self isEnabled] ? 1.0 : 0.70 );
	NSColor *gradientStart, *gradientEnd, *borderColor;
	
	if ( [self isHighlighted] ) {
		
		borderColor = [NSColor colorWithCalibratedRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:alpha];
		gradientStart = [NSColor colorWithCalibratedRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:alpha];
		gradientEnd = [NSColor colorWithCalibratedRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:alpha];
		
	}
	
	else {
		
		borderColor = [NSColor colorWithCalibratedRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:alpha];
		gradientEnd = [NSColor colorWithCalibratedRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:alpha];
		gradientStart = [NSColor colorWithCalibratedRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:alpha];
		
	}
	
	NSRect targetRect = cellFrame;
	
	targetRect = NSInsetRect(targetRect,0.5,0.5);
	
	[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:2.0] 
			linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
	
	[borderColor set];
	[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:2.0] stroke];
	
	// draw the color inside the cell image
	NSColor *cellColor = [self color];
	if ( !cellColor ) cellColor = [NSColor blackColor];

	[cellColor set];
	NSRect colorRect = NSInsetRect(targetRect, 6.0, 4.0);
	[[NSBezierPath bezierPathWithRoundedRect:colorRect cornerRadius:2.0] fill];

	// draw the label if there is one
	NSString *title = [self title];
	if ( title != nil && [title length] > 0 )
	{
		// really basic stuff happening here - no alignment, no elision, etc
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
				[self font], NSFontAttributeName, nil];
		
		NSSize stringSize = [title sizeWithAttributes:attributes];
		NSRect titleRect = NSMakeRect( cellFrame.origin.x + cellFrame.size.width - stringSize.width,
										cellFrame.origin.y + cellFrame.size.height - stringSize.height,
										stringSize.width, stringSize.height );
		
		[title drawInRect:titleRect withAttributes:attributes];
	}
}
*/

@end
