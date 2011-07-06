//
//  PDButtonCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/4/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDButtonCell.h>

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

#define PDButtonCellFillLeft		0
#define PDButtonCellFillCenter		1
#define PDButtonCellFillRight		2

#define PDButtonCellDarkLeft		3
#define PDButtonCellDarkCenter		4
#define PDButtonCellDarkRight		5

@implementation PDButtonCell

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
	
	int height = cellFrame.size.height;
	int width = cellFrame.size.width;
	
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont systemFontOfSize:11.0], NSFontAttributeName, 
			( [self isEnabled] ? [NSColor blackColor] : [NSColor lightGrayColor] ), NSForegroundColorAttributeName, nil];
				
	NSSize stringSize = [[self title] sizeWithAttributes:attributes];
	
	NSRect stringRect = NSMakeRect(width/2.0-stringSize.width/2.0, height/2.0-stringSize.height/2.0, 
			stringSize.width, stringSize.height);
			
	NSRect targetRect = NSMakeRect( stringRect.origin.x-16.0, stringRect.origin.y-2.0, 
			stringRect.size.width+32.0, stringRect.size.height+4.0 );
	
	targetRect = NSInsetRect(targetRect,0.5,0.5);
	
	[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:8.5] 
			linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
	
	[borderColor set];
	[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:8.5] stroke];
	
	[[self title] drawInRect:stringRect withAttributes:attributes];


}

@end
