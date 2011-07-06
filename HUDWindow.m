//
//  HUDWindow.m
//  HUDWindow
//
//  Created by Matt Gemmell on 12/02/2006.
//  Copyright 2006 Magic Aubergine. All rights reserved.
//

#import <SproutedInterface/HUDWindow.h>

@implementation HUDWindow


- (id)initWithContentRect:(NSRect)contentRect 
                styleMask:(unsigned int)styleMask 
                  backing:(NSBackingStoreType)bufferingType 
                    defer:(BOOL)flag 
{
	unsigned int replacementMask = NSBorderlessWindowMask;
	if ( styleMask & NSClosableWindowMask ) replacementMask |= NSClosableWindowMask;
	
	if (self = [super initWithContentRect:contentRect 
                                styleMask:replacementMask 
                                  backing:bufferingType 
                                    defer:flag]) {
		
        [self setBackgroundColor: [NSColor clearColor]];
        [self setAlphaValue:1.0];
        [self setOpaque:NO];
        [self setHasShadow:YES];
        [self setMovableByWindowBackground:YES];
        forceDisplay = NO;
        [self setBackgroundColor:[self sizedHUDBackground]];
        
		if ( styleMask & NSClosableWindowMask )
			[self addCloseWidget];
		
		[self setReleasedWhenClosed:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(windowDidResize:) 
                                                     name:NSWindowDidResizeNotification 
                                                   object:self];
        
		closesOnEvent = NO;
		closesOnEscape = NO;
		
        return self;
    }
    return nil;
}

- (void)awakeFromNib
{
    if ( [self styleMask] & NSClosableWindowMask )
		[self addCloseWidget];
}

- (void)addCloseWidget
{
    NSButton *closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(3.0, [self frame].size.height - 16.0, 13.0, 13.0)];
    
    [[self contentView] addSubview:closeButton];
    [closeButton setBezelStyle:NSRoundedBezelStyle];
    [closeButton setButtonType:NSMomentaryChangeButton];
    [closeButton setBordered:NO];
    [closeButton setImage:BundledImageWithName(@"hud_titlebar-close",@"com.sprouted.interface")];
    [closeButton setTitle:@""];
    [closeButton setImagePosition:NSImageBelow];
    [closeButton setTarget:self];
    [closeButton setFocusRingType:NSFocusRingTypeNone];
	
	if ( [[self delegate] respondsToSelector:@selector(runClose:)] )
	{
		[closeButton setTarget:[self delegate]];
		[closeButton setAction:@selector(runClose:)];
	}
	else
	{
		[closeButton setTarget:self];
		[closeButton setAction:@selector(close)];
	}
    [closeButton release];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:self];    
    [super dealloc];
}

- (void)windowDidResize:(NSNotification *)aNotification
{
    [self setBackgroundColor:[self sizedHUDBackground]];
    if (forceDisplay) {
        [self display];
    }
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag animate:(BOOL)animationFlag
{
    forceDisplay = YES;
    [super setFrame:frameRect display:displayFlag animate:animationFlag];
    forceDisplay = NO;
}

- (NSColor *)sizedHUDBackground
{
    float alpha = 0.85;
    float titlebarHeight = 19.0;
    NSImage *bg = [[NSImage alloc] initWithSize:[self frame].size];
    [bg lockFocus];
    
    // Make background path
    NSRect bgRect = NSMakeRect(0, 0, [bg size].width, [bg size].height - titlebarHeight);
    int minX = NSMinX(bgRect);
    int midX = NSMidX(bgRect);
    int maxX = NSMaxX(bgRect);
    int minY = NSMinY(bgRect);
    int midY = NSMidY(bgRect);
    int maxY = NSMaxY(bgRect);
    float radius = 6.0;
    NSBezierPath *bgPath = [NSBezierPath bezierPath];
    
    // Bottom edge and bottom-right curve
    [bgPath moveToPoint:NSMakePoint(midX, minY)];
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY) 
                                     toPoint:NSMakePoint(maxX, midY) 
                                      radius:radius];
    
    [bgPath lineToPoint:NSMakePoint(maxX, maxY)];
    [bgPath lineToPoint:NSMakePoint(minX, maxY)];
    
    // Top edge and top-left curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
                                     toPoint:NSMakePoint(minX, midY) 
                                      radius:radius];
    
    // Left edge and bottom-left curve
    [bgPath appendBezierPathWithArcFromPoint:bgRect.origin 
                                     toPoint:NSMakePoint(midX, minY) 
                                      radius:radius];
    [bgPath closePath];
    
    // Composite background color into bg
    [[NSColor colorWithCalibratedWhite:0.1 alpha:alpha] set];
    [bgPath fill];
    
    // Make titlebar path
    NSRect titlebarRect = NSMakeRect(0, [bg size].height - titlebarHeight, [bg size].width, titlebarHeight);
    minX = NSMinX(titlebarRect);
    midX = NSMidX(titlebarRect);
    maxX = NSMaxX(titlebarRect);
    minY = NSMinY(titlebarRect);
    midY = NSMidY(titlebarRect);
    maxY = NSMaxY(titlebarRect);
    NSBezierPath *titlePath = [NSBezierPath bezierPath];
    
    // Bottom edge and bottom-right curve
    [titlePath moveToPoint:NSMakePoint(minX, minY)];
    [titlePath lineToPoint:NSMakePoint(maxX, minY)];
    
    // Right edge and top-right curve
    [titlePath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY) 
                                     toPoint:NSMakePoint(midX, maxY) 
                                      radius:radius];
    
    // Top edge and top-left curve
    [titlePath appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
                                     toPoint:NSMakePoint(minX, minY) 
                                      radius:radius];
    
    [titlePath closePath];
    
    // Titlebar
    NSColor *titlebarColor = [NSColor colorWithCalibratedWhite:0.25 alpha:1.0];
    [titlebarColor set];
    [titlePath fill];
    
    // Title
    NSFont *titleFont = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [paraStyle setAlignment:NSCenterTextAlignment];
    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        titleFont, NSFontAttributeName,
        [NSColor whiteColor], NSForegroundColorAttributeName,
        [[paraStyle copy] autorelease], NSParagraphStyleAttributeName,
        nil];
    
    NSSize titleSize = [[self title] sizeWithAttributes:titleAttrs];
    // We vertically centre the title in the titlbar area, and we also horizontally 
    // inset the title by 19px, to allow for the 3px space from window's edge to close-widget, 
    // plus 13px for the close widget itself, plus another 3px space on the other side of 
    // the widget.
    NSRect titleRect = NSInsetRect(titlebarRect, 19.0, (titlebarRect.size.height - titleSize.height) / 2.0);
    [[self title] drawInRect:titleRect withAttributes:titleAttrs];
    [bg unlockFocus];
    
    return [NSColor colorWithPatternImage:[bg autorelease]];
}

- (void)setTitle:(NSString *)value {
    [super setTitle:value];
    [self windowDidResize:nil];
}

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

#pragma mark -

- (BOOL) closesOnEvent 
{ 
	return closesOnEvent; 
}

- (void) setClosesOnEvent:(BOOL)closes 
{
	closesOnEvent = closes;
}

- (BOOL) closesOnEscape
{
	return closesOnEscape;
}

- (void) setClosesOnEscape:(BOOL)closes
{
	closesOnEscape = closes;
}

#pragma mark -

- (void)keyDown:(NSEvent *)theEvent 
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif

	if ( closesOnEvent || ( closesOnEscape && [theEvent keyCode] == 53 ) )
		if ( [[self delegate] respondsToSelector:@selector(runClose:)] )
			[[self delegate] runClose:self];
		else
			[self close];
	else
		[super keyDown:theEvent];
}

- (void) mouseDown:(NSEvent*)theEvent
{	
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif

	if ( closesOnEvent ) 
		if ( [[self delegate] respondsToSelector:@selector(runClose:)] )
			[[self delegate] runClose:self];
		else
			[self close];
	else
		[super mouseDown:theEvent];
}

#pragma mark -

- (void)resignKeyWindow 
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	if ( closesOnEvent ) 
		[[self delegate] runClose:self];
	else
		[super resignKeyWindow];
		//[self close];
}

- (void)resignMainWindow 
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif

	if ( closesOnEvent ) 
		[[self delegate] runClose:self];
	else
		[super resignMainWindow];
		//[self close];
}

@end
