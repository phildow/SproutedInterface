//
//  PDPopupButtonCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/10/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDPopUpButtonCell.h>

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

@implementation PDPopUpButtonCell

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		[self setBordered:NO];
	}
	
	return self;
	
}

- (id)initTextCell:(NSString *)stringValue pullsDown:(BOOL)pullDown {
	
	if ( self = [super initTextCell:stringValue pullsDown:pullDown] ) {
		
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
	NSColor *gradientStart, *gradientEnd, *borderColor, *arrowColor;
	
	if ( [self isHighlighted] ) {
		
		arrowColor = [NSColor colorWithCalibratedRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:0.9];
		borderColor = [NSColor colorWithCalibratedRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:alpha];
		gradientStart = [NSColor colorWithCalibratedRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:alpha];
		gradientEnd = [NSColor colorWithCalibratedRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:alpha];
		
	}
	
	else {
		
		arrowColor = [NSColor colorWithCalibratedRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:0.8];
		borderColor = [NSColor colorWithCalibratedRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:alpha];
		gradientEnd = [NSColor colorWithCalibratedRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:alpha];
		gradientStart = [NSColor colorWithCalibratedRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:alpha];
		
	}
	
	int height = cellFrame.size.height;
	int width = cellFrame.size.width;
	
	NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopyWithZone:[self zone]];
	[pStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont systemFontOfSize:11.0], NSFontAttributeName, 
			( [self isEnabled] ? [NSColor blackColor] : [NSColor lightGrayColor] ), NSForegroundColorAttributeName, 
			pStyle, NSParagraphStyleAttributeName, nil];
				
	NSSize stringSize = [[self title] sizeWithAttributes:attributes];
	
	NSRect stringRect = NSMakeRect(width/2.0-stringSize.width/2.0, height/2.0-stringSize.height/2.0, 
			stringSize.width, stringSize.height);

	NSRect targetRect = NSMakeRect( cellFrame.origin.x, stringRect.origin.y-2.0, 
			cellFrame.size.width, stringRect.size.height+4.0 );
	
	targetRect = NSInsetRect(targetRect,3.5,0.5);
	
	[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:8.5] 
			linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
	
	[borderColor set];
	[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:8.5] stroke];
	
	NSBezierPath *arrowsPath = [NSBezierPath bezierPath];
	[arrowsPath appendBezierPathWithTriangleInRect:NSMakeRect(0,1,5,4) orientation:AMTriangleUp];
	[arrowsPath appendBezierPathWithTriangleInRect:NSMakeRect(0,-5,5,4) orientation:AMTriangleDown];
	
	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform translateXBy:width-17.0 yBy:height/2.0];
	
	[arrowsPath transformUsingAffineTransform:transform];
	[arrowColor set];
	[arrowsPath fill];
	
	[[self titleOfSelectedItem] drawInRect:NSMakeRect(12, height/2-stringSize.height/2, width-30, stringSize.height)
			withAttributes:attributes];

}

@end
