//
//  JournlerGradientView.m
//  SproutedInterface
//
//  Created by Philip Dow on 10/20/06.
//  Copyright 2006 Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import "JournlerGradientView.h"

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

@implementation JournlerGradientView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		
		[self setControlTint:[NSColor currentControlTint]];
		[self resetGradient];
		
		fillColor = [[NSColor whiteColor] retain];
		borderColor = [[NSColor colorWithCalibratedRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0] retain];
		
		bordered = NO;
		
		borders[0] = 0;	// top
		borders[1] = 0;	// right
		borders[2] = 0;	// bottom
		borders[3] = 0;	// left
		
		drawsGradient = YES;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_controlTintChanged:)
		name:NSControlTintDidChangeNotification object:NSApp];
    }
    return self;
}

- (void) dealloc {
	[gradientStartColor release];
    [gradientEndColor release];
    [backgroundColor release];
	[fillColor release];
	[borderColor release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

#pragma mark -

+ (void) drawGradientInView:(NSView*)aView rect:(NSRect)aRect highlight:(BOOL)highlight shadow:(float)shadowLevel
{
	// Construct rounded rect path
    NSRect boxRect = aRect;
    NSRect bgRect = boxRect;
	NSRect rect = aRect;
  
	int minX = NSMinX(bgRect);
    int maxX = NSMaxX(bgRect);
    int minY = NSMinY(bgRect);
    int maxY = NSMaxY(bgRect);
	
	float fraction = ( highlight ? 0.5 : 0.5 );
	
	NSBezierPath *bgPath = [NSBezierPath bezierPathWithRect:rect];
	NSGraphicsContext *nsContext = [NSGraphicsContext currentContext];
	
	NSColor *backgroundColor = [NSColor windowBackgroundColor];
	NSColor *gradientStartColor, *gradientEndColor;
	
	if ( [aView isFlipped] )
	{
		gradientEndColor = [[[[NSColor colorWithCalibratedWhite:0.92 alpha:0.6] 
				colorUsingColorSpaceName:NSCalibratedRGBColorSpace] 
				blendedColorWithFraction:fraction ofColor:[NSColor colorForControlTint:[NSColor currentControlTint]]]
				shadowWithLevel:shadowLevel];
		
		gradientStartColor = [[[[NSColor colorWithCalibratedWhite:0.82 alpha:0.6] 
				colorUsingColorSpaceName:NSCalibratedRGBColorSpace] 
				blendedColorWithFraction:fraction ofColor:[NSColor colorForControlTint:[NSColor currentControlTint]]]
				shadowWithLevel:shadowLevel];
	}
	else
	{
		gradientStartColor = [[[[NSColor colorWithCalibratedWhite:0.92 alpha:0.6] 
				colorUsingColorSpaceName:NSCalibratedRGBColorSpace] 
				blendedColorWithFraction:fraction ofColor:[NSColor colorForControlTint:[NSColor currentControlTint]]]
				shadowWithLevel:shadowLevel];
		
		gradientEndColor = [[[[NSColor colorWithCalibratedWhite:0.82 alpha:0.6] 
				colorUsingColorSpaceName:NSCalibratedRGBColorSpace] 
				blendedColorWithFraction:fraction ofColor:[NSColor colorForControlTint:[NSColor currentControlTint]]]
				shadowWithLevel:shadowLevel];
	}
	
     // Draw solid color background
	[backgroundColor set];
	[bgPath fill];
   
	// Draw gradient background using Core Image
	CIColor *startColor = [[[CIColor alloc] initWithColor:gradientStartColor] autorelease];
	CIColor *endColor = [[[CIColor alloc] initWithColor:gradientEndColor] autorelease];
	
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
	
	[nsContext saveGraphicsState];
	
	[bgPath addClip];
	
	[[nsContext CIContext] drawImage:theImage 
							 atPoint:pt 
							fromRect:dest];
	
	[nsContext restoreGraphicsState];
}

- (void)drawRect:(NSRect)rect {
   
	// Construct rounded rect path
    NSRect boxRect = [self bounds];
    NSRect bgRect = boxRect;
  
	int minX = NSMinX(bgRect);
    int maxX = NSMaxX(bgRect);
    int minY = NSMinY(bgRect);
    int maxY = NSMaxY(bgRect);
	
	NSBezierPath *bgPath = [NSBezierPath bezierPathWithRect:rect];
	NSGraphicsContext *nsContext = [NSGraphicsContext currentContext];

     // Draw solid color background
	[backgroundColor set];
	[bgPath fill];
   
	// Draw gradient background using Core Image
	
	if ( [self drawsGradient] )
	{
		
		if ( [self usesBezierPath] )
		{
			bgPath = [NSBezierPath bezierPathWithRect:boxRect];
			[bgPath linearGradientFillWithStartColor:gradientStartColor endColor:gradientEndColor];
		}
		else
		{
			
			CIColor *startColor = [[[CIColor alloc] initWithColor:gradientStartColor] autorelease];
			CIColor *endColor = [[[CIColor alloc] initWithColor:gradientEndColor] autorelease];
			
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
			
			[nsContext saveGraphicsState];
			
			[bgPath addClip];
			
			[[nsContext CIContext] drawImage:theImage 
									 atPoint:pt 
									fromRect:dest];
			
			[nsContext restoreGraphicsState];
		}
	}
	
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


#pragma mark -

- (void) resetGradient
{
	if ( [self respondsToSelector:@selector(addTrackingArea:)] )
	{
		//10.5 - ends up no different that the pdgradientview
		[self setGradientStartColor:[NSColor colorWithCalibratedWhite:0.82 alpha:0.8]]; // 1.0
		[self setGradientEndColor:[NSColor colorWithCalibratedWhite:0.92 alpha:0.8]]; // 1.0
	}
	else
	{
		//10.4
		[self setGradientStartColor:[NSColor colorWithCalibratedWhite:0.92 alpha:0.6]]; // 1.0
		[self setGradientEndColor:[NSColor colorWithCalibratedWhite:0.82 alpha:0.6]]; // 1.0
	}
	
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

#pragma mark -

- (BOOL) drawsGradient
{
	return drawsGradient;
}

- (void) setDrawsGradient:(BOOL)draws
{
	drawsGradient = draws;
}

- (BOOL) usesBezierPath
{
	return usesBezierPath;
}

- (void) setUsesBezierPath:(BOOL)bezier
{
	usesBezierPath = bezier;
}

#pragma mark -

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

- (NSControlTint) controlTint
{
	return controlTint;
}

- (void) setControlTint:(NSControlTint)aTint
{
	controlTint = aTint;
	[self resetGradient];
}

#pragma mark -

- (NSColor *)gradientStartColor
{
    return gradientStartColor;
}

- (void)setGradientStartColor:(NSColor *)newGradientStartColor
{
    // Must ensure gradient colors are in NSCalibratedRGBColorSpace, or Core Image gets angry.
    NSColor *newCalibratedGradientStartColor;
	if ( [self respondsToSelector:@selector(addTrackingArea:)] )
	{
		newCalibratedGradientStartColor = [newGradientStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}
	else
	{
		newCalibratedGradientStartColor = [[newGradientStartColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace] 
		blendedColorWithFraction:0.5 ofColor:[NSColor colorForControlTint:[self controlTint]]];
	}
		
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
	NSColor *newCalibratedGradientEndColor;
	
    if ( [self respondsToSelector:@selector(addTrackingArea:)] )
	{
		newCalibratedGradientEndColor = [newGradientEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}
	else
	{
		newCalibratedGradientEndColor = [[newGradientEndColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace]
		blendedColorWithFraction:0.5 ofColor:[NSColor colorForControlTint:[self controlTint]]];
	}
	
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
	[self setNeedsDisplay:YES];
}

#pragma mark -

- (void) _controlTintChanged:(NSNotification*)aNotification
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	[self resetGradient];
	[self setNeedsDisplay:YES];
}

@end
