//
//  PDURLTextFieldCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/28/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDURLTextFieldCell.h>

#import <SproutedUtilities/NSBezierPath_AMAdditons.h>
#import <SproutedUtilities/NSBezierPath_AMShading.h>

@implementation PDURLTextFieldCell


- (id)initWithCoder:(NSCoder *)decoder {
	if ( self = [super initWithCoder:decoder] ) {
		_appearanceStyle = kPDAppearanceStyleBlue;
		[self _initializeColors];
	}
	return self;
}


- (id)initImageCell:(NSImage *)anImage {
	if ( self = [super initImageCell:anImage] ) {
		_appearanceStyle = kPDAppearanceStyleBlue;
		[self _initializeColors];
	}
	return self;
}

- (id)initTextCell:(NSString *)aString {
	if ( self = [super initTextCell:aString] ) {
		_appearanceStyle = kPDAppearanceStyleBlue;
		[self _initializeColors];
	}
	return self;
}

- (void) dealloc {
	[_image release];
	[_progress_gradient_start release];
	[_progress_gradient_end release];
	[super dealloc];
}

#pragma mark -

- (void) _initializeColors {
	if ( _appearanceStyle == kPDAppearanceStyleGraphite ) {
		_progress_gradient_start = [[NSColor 
				colorWithCalibratedRed:187.0/255.0 green:196.0/255.0 blue:209.0/255.0 alpha:1.0] retain];
		_progress_gradient_end = [[NSColor 
				colorWithCalibratedRed:174.0/255.0 green:185.0/255.0 blue:201.0/255.0 alpha:1.0] retain];
	}
	else {
		_progress_gradient_start = [[NSColor 
				colorWithCalibratedRed:167.0/255.0 green:209.0/255.0 blue:255.0/255.0 alpha:1.0] retain];
		_progress_gradient_end = [[NSColor 
				colorWithCalibratedRed:126.0/255.0 green:186.0/255.0 blue:255.0/255.0 alpha:1.0] retain];
	}
}

#pragma mark -

- (NSRect)textRectForFrame:(NSRect)frame
{
	frame.origin.x += 20;
    frame.size.width -= 20;
    return frame;
}

- (NSRect) imageRectForFrame:(NSRect)frame {
	frame.origin.x+=2;
	frame.size.width = 18;
	return frame;
}

- (NSRect) progressRectForFrame:(NSRect)frame {
	if ( [self estimatedProgress] == 0 || [self estimatedProgress] > 1 ) return NSZeroRect;
	
	frame.origin.y+=2;
	frame.size.height-=3;
	frame.origin.x+=1;
	frame.size.width=( (frame.size.width-=2) * [self estimatedProgress] );
	return frame;
}

#pragma mark -

- (NSImage*) image { return _image; }

- (void) setImage:(NSImage*)anImage {
	if ( _image != anImage ) {
		[_image release];
		_image = [anImage copyWithZone:[self zone]];
	}
}

- (double) estimatedProgress { return _estimated_progress; }

- (void) setEstimatedProgress:(double)estimate {
	_estimated_progress = estimate;
}

#pragma mark -

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj 
		delegate:(id)anObject event:(NSEvent *)theEvent
{
	[super editWithFrame:[self textRectForFrame:aRect] inView:controlView editor:textObj 
			delegate:anObject event:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj 
		delegate:(id)anObject start:(int)selStart length:(int)selLength
{
    [super selectWithFrame:[self textRectForFrame:aRect] inView:controlView editor:textObj 
			delegate:anObject start:selStart length:selLength];
}


- (void)resetCursorRect:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super resetCursorRect:[self textRectForFrame:cellFrame] inView:controlView];
}

#pragma mark -


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	// disable focus ring so I can draw my own
	[self setFocusRingType:NSFocusRingTypeNone];	
		
	[super drawWithFrame:cellFrame inView:controlView];
	
	// re-enable focus ring so that mine is properly erased
	[self setFocusRingType:NSFocusRingTypeDefault];	
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	// disable focus ring so I can draw my own
	[self setFocusRingType:NSFocusRingTypeNone];		
	
	[super highlight:flag withFrame:cellFrame inView:controlView];
	
	// re-enable focus ring so that mine is properly erased
	[self setFocusRingType:NSFocusRingTypeDefault];	
}


- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	
	BOOL does_draw_background = [self drawsBackground];
	
	// Draw the focus ring
	[self drawFocusRingWithFrame:cellFrame inView:controlView];

	// Draw Progress Bar
	[self drawProgressIndicatorWithFrame:[self progressRectForFrame:cellFrame] inView:controlView];

	// Draw the FavIcon
	[self drawImageWithFrame:[self imageRectForFrame:cellFrame] inView:controlView];

	// Draw Remaining Things
	
	// Disable background drawing so that the interior draw does not erase the progress bar
	[self setDrawsBackground:NO];
	
	[super drawInteriorWithFrame:[self textRectForFrame:cellFrame] inView:controlView];
	
	// Renable background drawing so that the view otherwise properly draws itself
	[self setDrawsBackground:does_draw_background];
	
}

- (void)drawFocusRingWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	if ([super showsFirstResponder] && [[controlView window] isKeyWindow] ) {
	
		[NSGraphicsContext saveGraphicsState];
		NSSetFocusRingStyle(NSFocusRingOnly);
		NSBezierPath *bezier = [NSBezierPath bezierPathWithRect:cellFrame];
		[bezier fill];
		[NSGraphicsContext restoreGraphicsState];
		
    }
}

- (void) drawProgressIndicatorWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {
	
	NSRect top, bottom;
	NSDivideRect(cellFrame, &top, &bottom, cellFrame.size.height/2, NSMinYEdge);
	top.size.height++;
	
	[[NSBezierPath bezierPathWithRect:top] linearGradientFillWithStartColor:_progress_gradient_start endColor:_progress_gradient_end];
	[[NSBezierPath bezierPathWithRect:bottom] linearGradientFillWithStartColor:_progress_gradient_end endColor:_progress_gradient_start];
}

- (void)drawImageWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	NSImage *target_image = [self image];
	if ( target_image != nil ) {
		
		[target_image setFlipped:[controlView isFlipped]];
		
		NSSize image_size = [target_image size];
		if ( image_size.width > 20 ) [target_image setSize:NSMakeSize(20, image_size.height*20/image_size.width)];
		
		NSRect source_rect = NSMakeRect( 0, 0, image_size.width, image_size.height );
		NSRect target_rect = NSMakeRect(	cellFrame.size.width/2 - image_size.width/2, 
											cellFrame.size.height/2 - image_size.height/2,
											image_size.width, image_size.height );
											
		target_rect.origin.x+=cellFrame.origin.x;
		target_rect.origin.y+=cellFrame.origin.y;
		
		[target_image drawInRect:target_rect fromRect:source_rect 
				operation:NSCompositeSourceOver fraction:1.0];
		
	}

}

@end