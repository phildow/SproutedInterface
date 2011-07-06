//
//  TransparentWindow.m
//  RoundedFloatingPanel
//
//  Created by Matt Gemmell on Thu Jan 08 2004.
//  <http://iratescotsman.com/>
//

#define kEdgeInset 40
#define kWinHeight 186

#import <SproutedInterface/TransparentWindow.h>

@implementation TransparentWindow

- (id)init {
	return [self initWithContentRect:NSMakeRect(0,0,186,186) styleMask:NSBorderlessWindowMask 
			backing:NSBackingStoreBuffered defer:NO];
}

- (id)initWithContentRect:(NSRect)contentRect 
                styleMask:(unsigned int)aStyle 
                  backing:(NSBackingStoreType)bufferingType 
                    defer:(BOOL)flag {
    
    if (self = [super initWithContentRect:contentRect 
                                        styleMask:NSBorderlessWindowMask 
                                          backing:NSBackingStoreBuffered 
                                   defer:NO]) {
        [self setLevel: NSStatusWindowLevel];
        [self setBackgroundColor: [NSColor clearColor]];
        [self setAlphaValue:1.0];
        [self setOpaque:NO];
        [self setHasShadow:NO];
        
		[self setReleasedWhenClosed:YES];
		
        return self;
    }
    
    return nil;
}

- (BOOL) closesOnEvent 
{ 
	return _closesOnEvent; 
}

- (void) setClosesOnEvent:(BOOL)closes 
{
	_closesOnEvent = closes;
}

- (void) fillScreenHorizontallyAndCenter 
{
	
	NSScreen *screen = [NSScreen mainScreen];
	NSRect visible_frame = [screen visibleFrame];
	
	NSRect win_frame = NSMakeRect( kEdgeInset, 20, visible_frame.size.width - kEdgeInset*2, kWinHeight );
	[self setFrame:win_frame display:NO];
	[self center];
}

- (void) completelyFillScreen 
{
	[self setFrame:[[NSScreen mainScreen] frame] display:YES];
}

- (BOOL) canBecomeKeyWindow
{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{    
    if ( _closesOnEvent ) 
		[self close];
	else 
		[super mouseDown:theEvent];
}

- (void)keyDown:(NSEvent *)theEvent 
{
	if ( _closesOnEvent ) 
		[self close];
	else 
		[super keyDown:theEvent];
}

- (void)resignKeyWindow 
{
	if ( _closesOnEvent ) 
		[self close];
}

- (void)resignMainWindow 
{
	if ( _closesOnEvent ) 
		[self close];
}

@end
