//
//  PDRankCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 9/13/06.
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

#import <SproutedInterface/PDRankCell.h>
#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

@implementation PDRankCell

- (id)initWithCoder:(NSCoder *)decoder {
	if ( self = [super initWithCoder:decoder] ) {
		minRank = 0.0;
		maxRank = 1.0;
	}
	return self;
}

- (id)initTextCell:(NSString *)aString {
	if ( self = [super initTextCell:aString] ) {
		minRank = 0.0;
		maxRank = 1.0;
	}
	return self;
}

#pragma mark -

- (float) minRank {
	return minRank;
}

- (void) setMinRank:(float)value {
	minRank = value;
}

- (float) maxRank {
	return maxRank;
}

- (void) setMaxRank:(float)value {
	maxRank = value;
}

- (float) rank {
	return rank;
}

- (void) setRank:(float)value {
	rank = value;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSNumber *rankObject = [self objectValue];
	float aRank = [rankObject floatValue];
	
	// draw the rank
	if ( aRank != 0 ) {
		
		NSRect inset = cellFrame;
		
		inset.origin.x += 2;
		inset.size.width -= 4;
		inset.origin.y += 1;
		inset.size.height -= 2;
		
		float delta = ( maxRank - minRank );
		if ( delta == 0 ) delta = 0.000001;
		
		float rankPercent = ( aRank - minRank ) / delta;
		float distance = ( inset.size.width * rankPercent );
		
		NSRect rankRect = NSMakeRect(	inset.origin.x, 
										inset.origin.y + ( inset.size.height / 2 ) - 5,
										distance, 10);
		
		NSColor *gradientStart, *gradientEnd;
	
		gradientStart = [NSColor colorWithCalibratedRed:195.0/255.0 green:195.0/255.0 blue:195.0/255.0 alpha:0.8];
		gradientEnd = [NSColor colorWithCalibratedRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:0.8];
			
		NSRect top, bottom;
		NSDivideRect(rankRect, &top, &bottom, rankRect.size.height/2, NSMinYEdge);
		top.size.height++;
		
		NSBezierPath *contentPath = [NSBezierPath bezierPath];
		NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:rankRect cornerRadius:5.0];
		
		int i;
		for ( i = 1; i < distance; i+=2 )
		{
			[contentPath moveToPoint:NSMakePoint(rankRect.origin.x+i, rankRect.origin.y)];
			[contentPath lineToPoint:NSMakePoint(rankRect.origin.x+i, rankRect.origin.y+rankRect.size.height)];
		}
		
		NSGraphicsContext *context = [NSGraphicsContext currentContext];
		[context saveGraphicsState];
		[clipPath setClip];
		
		[[NSBezierPath bezierPathWithRect:top] linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
		[[NSBezierPath bezierPathWithRect:bottom] linearGradientFillWithStartColor:gradientEnd endColor:gradientStart];
		
		//[context setShouldAntialias:NO];
		
		//[[NSColor colorWithCalibratedWhite:1.0 alpha:0.3] set];
		//[contentPath setLineWidth:1.0];
		//[contentPath stroke];
		
		[context restoreGraphicsState];
	}
}


@end
