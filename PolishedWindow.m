//
//  PolishedWindow.m
//  TunesWindow
//
//  Created by Matt Gemmell on 12/02/2006.
//  Copyright 2006 Magic Aubergine. All rights reserved.
//

#import <SproutedInterface/PolishedWindow.h>
#import <SproutedUtilities/SproutedUtilities.h>

@implementation PolishedWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)styleMask backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag 
{
    return [self initWithContentRect:contentRect styleMask:styleMask backing:bufferingType defer:flag flat:NO];
}

- (id)initWithContentRect:(NSRect)contentRect  styleMask:(unsigned int)styleMask backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag flat:(BOOL)flat 
{

	if ( ![self respondsToSelector:@selector(contentBorderThicknessForEdge:)] )
	{
		// Conditionally add textured window flag to stylemask
		unsigned int newStyle;
		if (styleMask & NSTexturedBackgroundWindowMask){
			newStyle = styleMask;
		} else {
			newStyle = (NSTexturedBackgroundWindowMask | styleMask);
		}
		
		if (self = [super initWithContentRect:contentRect styleMask:newStyle backing:bufferingType defer:flag] )
		{
			// PD Modifications
			_flat = YES;
			forceDisplay = NO;
			
			bottomLeft = [BundledImageWithName(@"flat_bottom_left.png", @"com.sprouted.interface") retain];
			bottomMiddle = [BundledImageWithName(@"flat_bottom_middle.png", @"com.sprouted.interface") retain];
			bottomMiddlePattern = [[NSColor colorWithPatternImage:bottomMiddle] retain];
			
			bottomRight = [BundledImageWithName(@"flat_bottom_right.png", @"com.sprouted.interface") retain];
			topLeft = [BundledImageWithName(@"flat_top_left.png", @"com.sprouted.interface") retain];
			topMiddle = [BundledImageWithName(@"flat_top_middle.png", @"com.sprouted.interface")retain];
			topMiddlePattern = [[NSColor colorWithPatternImage:topMiddle] retain];
			
			topRight = [BundledImageWithName(@"flat_top_right.png", @"com.sprouted.interface") retain];
			middleLeft = [BundledImageWithName(@"middle_left.png", @"com.sprouted.interface") retain];
			middleRight = [BundledImageWithName(@"middle_right.png", @"com.sprouted.interface") retain];
			
			[self setBackgroundColor:[self sizedPolishedBackground]];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) 
			name:NSWindowDidResizeNotification object:self];
        }
    }
    else
	{
		if ( self = [super initWithContentRect:contentRect styleMask:styleMask backing:bufferingType defer:flag] )
		{
			//[self setContentBorderThickness:20.0 forEdge:NSMinYEdge];
			//[self setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
		}
	}
	
    return self;
}

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4
- (void)setToolbar:(NSToolbar *)toolbar
{
    //if ( ![self respondsToSelector:@selector(contentBorderThicknessForEdge:)] )
	//{
		// Only actually call this if we respond to it on this machine
		if ([toolbar respondsToSelector:@selector(setShowsBaselineSeparator:)]) {
			[toolbar setShowsBaselineSeparator:NO];
		}
    //}
    [super setToolbar:toolbar];
}
#endif

- (void)dealloc
{
    if ( ![self respondsToSelector:@selector(contentBorderThicknessForEdge:)] )
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:self];
		
		[bottomLeft release];
		[bottomMiddle release];
		[bottomMiddlePattern release];
		[bottomRight release];
		[topLeft release];
		[topMiddle release];
		[topMiddlePattern release];
		[topRight release];
		[middleLeft release];
		[middleRight release];
	}
    
    [super dealloc];
}

- (void)windowDidResize:(NSNotification *)aNotification
{
	if ( ![self respondsToSelector:@selector(contentBorderThicknessForEdge:)] )
	{
		[self setBackgroundColor:[self sizedPolishedBackground]];
		if (forceDisplay) {
			[self display];
		}
	}
}

- (void)setMinSize:(NSSize)aSize
{
    if ( ![self respondsToSelector:@selector(contentBorderThicknessForEdge:)] )
		[super setMinSize:NSMakeSize(MAX(aSize.width, 150.0), MAX(aSize.height, 150.0))];
	else
		[super setMinSize:aSize];
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag animate:(BOOL)animationFlag
{
    if ( ![self respondsToSelector:@selector(contentBorderThicknessForEdge:)] )
	{
		forceDisplay = YES;
		[super setFrame:frameRect display:displayFlag animate:animationFlag];
		forceDisplay = NO;
	}
	else
		[super setFrame:frameRect display:displayFlag animate:animationFlag];
}

- (NSColor *)sizedPolishedBackground
{
    NSImage *bg = [[NSImage alloc] initWithSize:[self frame].size];
	    
    // Find background color to draw into window
    [topMiddle lockFocus];
    NSColor *bgColor = NSReadPixel(NSMakePoint(0, 0));
    [topMiddle unlockFocus];
	//NSColor *bgColor = [NSColor colorWithCalibratedWhite:235.0/255.0 alpha:1.0];
    
    // Set min width of temporary pattern image to prevent flickering at small widths
    float minWidth = 300.0;
    
    // Create temporary image for top-middle pattern
    NSImage *topMiddleImg = [[NSImage alloc] initWithSize:NSMakeSize(MAX(minWidth, [self frame].size.width), [topMiddle size].height)];
    [topMiddleImg lockFocus];
    [topMiddlePattern set];
    NSRectFillUsingOperation(NSMakeRect(0, 0, [topMiddleImg size].width, [topMiddleImg size].height), NSCompositeSourceOver);
    [topMiddleImg unlockFocus];
    
    // Create temporary image for bottom-middle pattern
    NSImage *bottomMiddleImg = [[NSImage alloc] initWithSize:NSMakeSize(MAX(minWidth, [self frame].size.width), [bottomMiddle size].height)];
    [bottomMiddleImg lockFocus];
    [bottomMiddlePattern set];
    NSRectFillUsingOperation(NSMakeRect(0, 0, [bottomMiddleImg size].width, [bottomMiddleImg size].height), NSCompositeSourceOver);
    [bottomMiddleImg unlockFocus];
    
    // Begin drawing into our main image
    [bg lockFocus];
    
    // Composite current background color into bg
    [bgColor set];
    NSRectFillUsingOperation(NSMakeRect(0, 0, [bg size].width, [bg size].height), NSCompositeSourceOver);
    
    if ([self flat]) {
        // Composite middle left/right images
		
		//[middleLeft setFlipped:NO];
		[middleLeft drawInRect:NSMakeRect(0, 0, 
                                          [middleLeft size].width, 
                                          [self frame].size.height) 
                      fromRect:NSMakeRect(0, 0, 
                                          [middleLeft size].width, 
                                          [middleLeft size].height) 
                     operation:NSCompositeSourceOver 
                      fraction:1.0];
		
		//[middleRight setFlipped:NO];
		[middleRight drawInRect:NSMakeRect([self frame].size.width - [middleRight size].width + 1.0, 0, 
                                          [middleRight size].width, 
                                          [self frame].size.height) 
                      fromRect:NSMakeRect(0, 0, 
                                          [middleRight size].width, 
                                          [middleRight size].height) 
                     operation:NSCompositeSourceOver 
                      fraction:1.0];
    }
    
    // Composite bottom-middle image
	//[bottomMiddleImg setFlipped:NO];
    [bottomMiddleImg drawInRect:NSMakeRect([bottomLeft size].width, 0, 
                                           [bg size].width - [bottomLeft size].width - [bottomRight size].width, 
                                           [bottomLeft size].height) 
                       fromRect:NSMakeRect(0, 0, 
                                           [bg size].width - [bottomLeft size].width - [bottomRight size].width, 
                                           [bottomLeft size].height) 
                      operation:NSCompositeSourceOver 
                       fraction:1.0];
    [bottomMiddleImg release];
    
    // Composite bottom-left and bottom-right images
	//[bottomLeft setFlipped:NO];
    [bottomLeft compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
					   
	//[bottomRight setFlipped:NO];
    [bottomRight compositeToPoint:NSMakePoint([bg size].width - [bottomRight size].width, 0) operation:NSCompositeSourceOver];
    
    // Composite top-middle image
	//[topMiddleImg setFlipped:NO];
    [topMiddleImg drawInRect:NSMakeRect([topLeft size].width, 
										[bg size].height - [topLeft size].height, 
                                        [bg size].width - [topLeft size].width - [topRight size].width, 
                                        [topLeft size].height) 
                    fromRect:NSMakeRect(0, 0, 
                                        [bg size].width - [topLeft size].width - [topRight size].width, 
                                        [topLeft size].height) 
                   operation:NSCompositeSourceOver 
                    fraction:1.0];
    [topMiddleImg release];
    
    // Composite top-left and top-right images
	//[topLeft setFlipped:NO];
    [topLeft compositeToPoint:NSMakePoint(0, [bg size].height - [topLeft size].height) operation:NSCompositeSourceOver];
	
	//[topRight setFlipped:NO];
    [topRight compositeToPoint:NSMakePoint([bg size].width - [topRight size].width, 
                                           [bg size].height - [topRight size].height) operation:NSCompositeSourceOver];
    
    [bg unlockFocus];
    
    return [NSColor colorWithPatternImage:[bg autorelease]];
}

- (BOOL)flat
{
    return _flat;
}

- (void)setFlat:(BOOL)newFlat
{
    _flat = newFlat;
    forceDisplay = YES;
    [self windowDidResize:nil];
    forceDisplay = NO;
}

@end
