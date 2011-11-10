
//
//  PDPopUpButtonToolbarItemCell.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Philip Dow / Sprouted. All rights reserved.
//

/*
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the organization nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

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
