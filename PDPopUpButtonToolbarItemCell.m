
//
//  PDPopUpButtonToolbarItemCell.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDPopUpButtonToolbarItemCell.h>

@implementation PDPopUpButtonToolbarItemCell


- (NSSize) iconSize
{
	return size;
}

- (void) setIconSize:(NSSize)aSize
{
	size = aSize;
}

#pragma mark Drawing

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[ self drawInteriorWithFrame:cellFrame inView:controlView ];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSImage *image = [self image];
	
	NSRect		sourceRect		= NSMakeRect( 0.0, 0.0, [ image size ].width ,[ image size ].height);
	NSRect		destRect		= sourceRect;
	NSRect		controlBounds	= [ controlView bounds ];
	
	NSGraphicsContext* context = [ NSGraphicsContext currentContext ];
	[ context saveGraphicsState ];
	[context setImageInterpolation:NSImageInterpolationHigh];
	
	if ( [ controlView isFlipped ] )
	{
		NSAffineTransform* flipTransform = [ NSAffineTransform transform ];
		[ flipTransform translateXBy:0.0 yBy:NSMaxY(controlBounds) ];
		[ flipTransform scaleXBy:1.0 yBy:-1.0 ];
		[ flipTransform concat ];
	}
	
	destRect.origin.x = ( controlBounds.size.width - [self iconSize].width ) / 2.0;
	destRect.origin.y = ( controlBounds.size.height - [self iconSize].height ) / 2.0;
	destRect.size.width = [self iconSize].width;
	destRect.size.height = [self iconSize].height;
				
	[ image drawInRect:destRect fromRect:sourceRect operation:NSCompositeSourceOver fraction:( [(NSControl*)[self controlView] isEnabled] ? 1.0 : 0.55 ) ];

	[ context restoreGraphicsState ];
}

@end
