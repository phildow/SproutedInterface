//
//  PDBorderedFill.m
//  SproutedInterface
//
//  Created by Philip Dow on 12/15/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDBorderedView.h>

@implementation PDBorderedView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		fillColor = [[NSColor whiteColor] retain];
		borderColor = [[NSColor 
				colorWithCalibratedRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0] retain];
		
		bordered = YES;
		
		borders[0] = 1;	// top
		borders[1] = 1;	// right
		borders[2] = 1;	// bottom
		borders[3] = 1;	// left
		
    }
    return self;
}

- (void) dealloc {
	
	[fillColor release];
	fillColor = nil;
	
	[borderColor release];
	borderColor = nil;
	
	[super dealloc];
	
}

#pragma mark -

- (int*) borders { 
	return borders;
}

- (void) setBorders:(int*)sides {
	
	borders[0] = sides[0];
	borders[1] = sides[1];
	borders[2] = sides[2];
	borders[3] = sides[3];
}

- (BOOL) bordered { 
	return bordered; 
}

- (void) setBordered:(BOOL)flag {
	bordered = flag;
}

- (NSColor*) fillColor { 
	return fillColor; 
}

- (void) setFillColor:(NSColor*)aColor {
	
	if ( fillColor != aColor ) {
		[fillColor release];
		fillColor = [aColor copyWithZone:[self zone]];
	}
}

- (NSColor*) borderColor { 
	return borderColor; 
}

- (void) setBorderColor:(NSColor*)aColor {
	
	if ( borderColor != aColor ) {
		[borderColor release];
		borderColor = [aColor copyWithZone:[self zone]];
	}
}

- (void)drawRect:(NSRect)rect {
	
	// Draw a frame and fill in white
	NSRect bds = [self bounds];
	
	NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];
	
	//then fills it the requested color
	if ( fillColor != nil )
	{
		[[self fillColor] set];
		NSRectFillUsingOperation(bds, NSCompositeSourceOver);
	}
	
	if ( [self bordered] )
	{
	
		NSPoint topLeft, topRight, bottomRight, bottomLeft;
			
		topLeft = NSMakePoint(0.5, bds.size.height-0.5);
		topRight = NSMakePoint(bds.size.width, bds.size.height-0.5);
		
		bottomRight = NSMakePoint(bds.size.width-0.5, 0.5);
		bottomLeft = NSMakePoint(0.5, 0.5);

		
		float scaleFactor = [[NSScreen mainScreen] userSpaceScaleFactor];
		if ( scaleFactor != 1.0 ) {
			
			// apply the scale factor
			topLeft.x *= scaleFactor;
			topLeft.y *= scaleFactor;
			
			topRight.x *= scaleFactor;
			topRight.y *= scaleFactor;
			
			bottomRight.x *= scaleFactor;
			bottomRight.y *= scaleFactor;
			
			bottomLeft.x *= scaleFactor;
			bottomLeft.y *= scaleFactor;
			
			// adjust the points to integral boundaries
			topLeft.x = ceil(topLeft.x);
			topLeft.y = ceil(topLeft.y);
			
			topRight.x = ceil(topRight.x);
			topRight.y = ceil(topRight.y);
			
			bottomRight.x = ceil(bottomRight.x);
			bottomRight.y = ceil(bottomRight.y);
			
			bottomLeft.x = ceil(bottomLeft.x);
			bottomLeft.y = ceil(bottomLeft.y);
			
			// convert back to user space
			topLeft.x /= scaleFactor;
			topLeft.y /= scaleFactor;
			
			topRight.x /= scaleFactor;
			topRight.y /= scaleFactor;
			
			bottomRight.x /= scaleFactor;
			bottomRight.y /= scaleFactor;
			
			bottomLeft.x /= scaleFactor;
			bottomLeft.y /= scaleFactor;
			
			
		}
				
		//
		//draws an outline around the guy, just like with other views
		if ( [self bordered] ) {
			NSBezierPath *borderPath = [NSBezierPath bezierPath];
			if ( borders[0] ) {
				[borderPath moveToPoint:topLeft];
				[borderPath lineToPoint:topRight];
			}
			if ( borders[1] ) {
				[borderPath moveToPoint:topRight];
				[borderPath lineToPoint:bottomRight];
			}
			if ( borders[2] ) {
				[borderPath moveToPoint:bottomRight];
				[borderPath lineToPoint:bottomLeft];
			}
			if ( borders[3] ) {
				[borderPath moveToPoint:bottomLeft];
				[borderPath lineToPoint:topLeft];
			}

			[[self borderColor] set ];
			
			[currentContext saveGraphicsState];
			[currentContext setShouldAntialias:NO];
			
			[borderPath setLineWidth:1.0];
			[borderPath stroke];
			
			[currentContext restoreGraphicsState];
		}
	}
}

@end
