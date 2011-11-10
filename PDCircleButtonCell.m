//
//  PDCircleButtonCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/10/05.
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

#import <SproutedInterface/PDCircleButtonCell.h>

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

#define PDButtonCellFillLeft		0
#define PDButtonCellFillCenter		1
#define PDButtonCellFillRight		2

#define PDButtonCellDarkLeft		3
#define PDButtonCellDarkCenter		4
#define PDButtonCellDarkRight		5

@implementation PDCircleButtonCell

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
	
	[super dealloc];
	
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
	
	static float fontSize = 12.0;
	int height = cellFrame.size.height;
	int width = cellFrame.size.width;
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont boldSystemFontOfSize:fontSize], NSFontAttributeName, 
			( [self isEnabled] ? [NSColor blackColor] : [NSColor lightGrayColor] ), NSForegroundColorAttributeName, nil];
				
	NSSize stringSize = [[self title] sizeWithAttributes:attributes];
	
	NSRect stringRect = NSMakeRect(width/2.0-stringSize.width/2.0, height/2.0-stringSize.height/2.0, 
			stringSize.width, stringSize.height);
	
	float offset = fontSize * 1.5;
	
	NSRect targetRect = NSMakeRect( width/2.0 - offset/2, height/2.0 - offset/2, offset, offset );	
	targetRect = NSInsetRect(targetRect,0.5,0.5);
	
	[[NSBezierPath bezierPathWithOvalInRect:targetRect]
		linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
	
	[borderColor set];
	[[NSBezierPath bezierPathWithOvalInRect:targetRect] stroke];
	
	[[self title] drawInRect:stringRect withAttributes:attributes];


}

@end