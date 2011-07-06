//
//  PDGradientView.m
//  SproutedInterface
//
//  Created by Philip Dow on 10/20/06.
//  Copyright 2006 Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDGradientView.h>


@implementation PDGradientView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		
		if ( [self respondsToSelector:@selector(addTrackingArea:)] )
		{
			//10.5
			[self setGradientStartColor:[NSColor colorWithCalibratedWhite:0.82 alpha:0.8]]; // 1.0, 0.6
			[self setGradientEndColor:[NSColor colorWithCalibratedWhite:0.92 alpha:0.8]]; // 1.0
		}
		else
		{
			//10.4
			[self setGradientStartColor:[NSColor colorWithCalibratedWhite:0.92 alpha:0.8]]; // 1.0, 0.6
			[self setGradientEndColor:[NSColor colorWithCalibratedWhite:0.82 alpha:0.8]]; // 1.0
		}
		[self setBackgroundColor:[NSColor windowBackgroundColor]]; // 1.0
		
		fillColor = [[NSColor whiteColor] retain];
		borderColor = [[NSColor colorWithCalibratedRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0] retain];
		
		bordered = NO;
		
		borders[0] = 0;	// top
		borders[1] = 0;	// right
		borders[2] = 0;	// bottom
		borders[3] = 0;	// left
		
    }
    return self;
}

- (void) dealloc {
	[gradientStartColor release];
    [gradientEndColor release];
    [backgroundColor release];
	[fillColor release];
	[borderColor release];
	
	[super dealloc];
}

#pragma mark -

- (void) resetGradient
{
	[self setGradientStartColor:[NSColor colorWithCalibratedWhite:0.92 alpha:0.6]]; // 1.0
	[self setGradientEndColor:[NSColor colorWithCalibratedWhite:0.82 alpha:0.6]]; // 1.0
	[self setBackgroundColor:[NSColor windowBackgroundColor]]; // 1.0
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

- (NSColor *)gradientStartColor
{
    return gradientStartColor;
}


- (void)setGradientStartColor:(NSColor *)newGradientStartColor
{
    // Must ensure gradient colors are in NSCalibratedRGBColorSpace, or Core Image gets angry.
	
    NSColor *newCalibratedGradientStartColor = [newGradientStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			
    [newCalibratedGradientStartColor retain];
    [gradientStartColor release];
    gradientStartColor = newCalibratedGradientStartColor;
   
}


- (NSColor *)gradientEndColor
{
    return gradientEndColor;
}


- (void)setGradientEndColor:(NSColor *)newGradientEndColor
{
    // Must ensure gradient colors are in NSCalibratedRGBColorSpace, or Core Image gets angry.
    NSColor *newCalibratedGradientEndColor = [newGradientEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
    [newCalibratedGradientEndColor retain];
    [gradientEndColor release];
    gradientEndColor = newCalibratedGradientEndColor;
}


- (NSColor *)backgroundColor
{
    return backgroundColor;
}


- (void)setBackgroundColor:(NSColor *)newBackgroundColor
{
    [newBackgroundColor retain];
    [backgroundColor release];
    backgroundColor = newBackgroundColor;
}

#pragma mark -

- (void)drawRect:(NSRect)rect {
   
	// Construct rounded rect path
    NSRect boxRect = [self bounds];
    NSRect bgRect = boxRect;
  
	int minX = NSMinX(bgRect);
    int maxX = NSMaxX(bgRect);
    int minY = NSMinY(bgRect);
    int maxY = NSMaxY(bgRect);
	
	NSBezierPath *bgPath = [NSBezierPath bezierPathWithRect:rect];

     // Draw solid color background
	[backgroundColor set];
	[bgPath fill];
   
	// Draw gradient background using Core Image
	
	// Wonder if there's a nicer way to get a CIColor from an NSColor...
	CIColor* startColor = [CIColor colorWithRed:[gradientStartColor redComponent] 
										  green:[gradientStartColor greenComponent] 
										   blue:[gradientStartColor blueComponent] 
										  alpha:[gradientStartColor alphaComponent]];
	CIColor* endColor = [CIColor colorWithRed:[gradientEndColor redComponent] 
										green:[gradientEndColor greenComponent] 
										 blue:[gradientEndColor blueComponent] 
										alpha:[gradientEndColor alphaComponent]];
	
	CIFilter *myFilter = [CIFilter filterWithName:@"CILinearGradient"];
	[myFilter setDefaults];
	[myFilter setValue:[CIVector vectorWithX:(minX) 
										   Y:(minY)] 
				forKey:@"inputPoint0"];
	[myFilter setValue:[CIVector vectorWithX:(minX) 
										   Y:(maxY)] 
				forKey:@"inputPoint1"];
	[myFilter setValue:startColor 
				forKey:@"inputColor0"];
	[myFilter setValue:endColor 
				forKey:@"inputColor1"];
	CIImage *theImage = [myFilter valueForKey:@"outputImage"];
	
	
	// Get a CIContext from the NSGraphicsContext, and use it to draw the CIImage
	CGRect dest = CGRectMake(minX, minY, maxX - minX, maxY - minY);
	
	CGPoint pt = CGPointMake(bgRect.origin.x, bgRect.origin.y);
	
	NSGraphicsContext *nsContext = [NSGraphicsContext currentContext];
	[nsContext saveGraphicsState];
	
	[bgPath addClip];
	
	[[nsContext CIContext] drawImage:theImage 
							 atPoint:pt 
							fromRect:dest];
	
	[nsContext restoreGraphicsState];
	
	if ( [self bordered] ) {
	
		NSPoint topLeft, topRight, bottomRight, bottomLeft;
			
		topLeft = NSMakePoint(0.5, boxRect.size.height-0.5);
		topRight = NSMakePoint(boxRect.size.width, boxRect.size.height-0.5);
		
		bottomRight = NSMakePoint(boxRect.size.width-0.5, 0.5);
		bottomLeft = NSMakePoint(0.5, 0.5);

		// does this actually work?
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
		
		[nsContext saveGraphicsState];
		[nsContext setShouldAntialias:NO];
		
		[borderPath setLineWidth:1.0];
		[borderPath stroke];
		
		[nsContext restoreGraphicsState];
	}	
}

@end
