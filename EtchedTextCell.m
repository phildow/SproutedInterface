
/* EtchedTextCell */
// NOTE TO SELF: where did this come from?

#import <SproutedInterface/EtchedTextCell.h>

@implementation EtchedTextCell

- (void) dealloc
{
	[mShadowColor release];
	[super dealloc];
}

-(void)setShadowColor:(NSColor *)aColor
{
	if ( mShadowColor != aColor )
	{
		[mShadowColor release];
		mShadowColor = [aColor retain];
	}
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(id)controlView
{
	[NSGraphicsContext saveGraphicsState]; 
	NSShadow* theShadow = [[NSShadow alloc] init]; 
	[theShadow setShadowOffset:NSMakeSize(0, -1)]; 
	[theShadow setShadowBlurRadius:0.3]; 

	[theShadow setShadowColor:mShadowColor]; 
	
	[theShadow set];

	[super drawInteriorWithFrame:cellFrame inView:controlView];
	
	[NSGraphicsContext restoreGraphicsState];
	[theShadow release]; 
}

@end
