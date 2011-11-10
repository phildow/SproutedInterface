//
//  PDMatrixButtonCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/10/06.
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

#import <SproutedInterface/PDMatrixButtonCell.h>

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

@implementation PDMatrixButtonCell

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) {
		
		[self setBordered:NO];
		
	}
	
	return self;
	
}

- (id)initTextCell:(NSString *)aString {
	
	if ( self = [super initTextCell:aString] ) {
		
		[self setBordered:NO];
		
	}
	
	return self;
	
}

- (id)initImageCell:(NSImage *)anImage {
	
	if ( self = [super initImageCell:anImage] ) {
		
		[self setBordered:NO];
		
	}
	
	return self;
	
}

- (void) dealloc {
	
	[super dealloc];
	
}

#pragma mark -



- (NSRect)drawingRectForBounds:(NSRect)theRect {
	return theRect;
}

- (NSRect)titleRectForBounds:(NSRect)theRect {
	return theRect;
}



- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	//
	// bypass the frame
	//
	
	[self drawInteriorWithFrame:cellFrame inView:controlView];
	
}



- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	float alpha = ( [self isEnabled] ? 1.0 : 0.70 );
	NSColor *gradientStart, *gradientEnd, *borderColor;
	
	int x = cellFrame.origin.x;
	int y = cellFrame.origin.y;
	
	int height = cellFrame.size.height;
	
	if ( [self isHighlighted] || [self state] == NSOnState ) {
	
		if ( [self isHighlighted] ) {
				
			borderColor = [NSColor colorWithCalibratedRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:alpha];
			gradientStart = [NSColor colorWithCalibratedRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:alpha];
			gradientEnd = [NSColor colorWithCalibratedRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:alpha];
			
		}
		
		else if ( [self state] == NSOnState ) {
				
			borderColor = [NSColor colorWithCalibratedRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:alpha];
			gradientEnd = [NSColor colorWithCalibratedRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:alpha];
			gradientStart = [NSColor colorWithCalibratedRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:alpha];
			
		}
		
		NSRect targetRect = NSInsetRect(cellFrame,0.5,2.5);
		targetRect.size.width-=4.0;
		
		[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:8.5] 
				linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
		
		[borderColor set];
		[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:8.5] stroke];

	}
	
	static int kImageOffset = 2;
	
	NSImage *image;
	
	if ( [self isHighlighted] ) {
		
		NSImage *original = [self image];
		NSImage *dark = [[NSImage alloc] initWithSize:NSMakeSize([original size].width,[original size].height)];
		
		[dark lockFocus];
		[[NSColor blackColor] set];
		NSRectFillUsingOperation(NSMakeRect(0,0,[original size].width,[original size].height), NSCompositeSourceOver);
		[dark unlockFocus];
		
		//image = [[original copyWithZone:[self zone]] autorelease];
		image = [[NSImage alloc] initWithSize:NSMakeSize([original size].width,[original size].height)];
		[image setFlipped:[[self controlView] isFlipped]];
		
		[image lockFocus];
		[original drawInRect:NSMakeRect(0,0,[original size].width,[original size].height) 
				fromRect:NSMakeRect(0,0,[original size].width,[original size].height) 
				operation:NSCompositeSourceOver fraction:1.0];
		[dark drawInRect:NSMakeRect(0,0,[original size].width,[original size].height) 
				fromRect:NSMakeRect(0,0,[original size].width,[original size].height)
				operation:NSCompositePlusDarker fraction:0.20];
		[original drawInRect:NSMakeRect(0,0,[original size].width,[original size].height) 
				fromRect:NSMakeRect(0,0,[original size].width,[original size].height) 
				operation:NSCompositeDestinationIn fraction:1.0];
		[image unlockFocus];
		
		[dark release];
		
	}
	else {
		//
		// pass it along
		image = [[self image] copyWithZone:[self zone]];
		[image setFlipped:[[self controlView] isFlipped]];
	}
	
	NSSize imageSize = [image size];
	NSRect imageTarget = NSMakeRect(x + kImageOffset, y + height/2-imageSize.height/2, imageSize.width, imageSize.height);
	
	[image drawInRect:imageTarget fromRect:NSMakeRect(0,0,imageSize.width,imageSize.height) 
			operation:NSCompositeSourceOver fraction:1.0];
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont systemFontOfSize:11.0], NSFontAttributeName, 
			( [self isEnabled] ? [NSColor blackColor] : [NSColor lightGrayColor] ), NSForegroundColorAttributeName, nil];
				
	NSSize stringSize = [[self title] sizeWithAttributes:attributes];
	
	NSRect stringRect = NSMakeRect( x + kImageOffset*2 + imageSize.width, y + height/2.0-stringSize.height/2.0, 
			stringSize.width, stringSize.height);
	
	[[self title] drawInRect:stringRect withAttributes:attributes];
	
	[image release];

}


@end
