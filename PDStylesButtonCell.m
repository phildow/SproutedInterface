//
//  PDStylesButtonCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/1/06.
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

#import <SproutedInterface/PDStylesButtonCell.h>

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

@implementation PDStylesButtonCell

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

- (int) superscriptValue { return _superscriptValue; }

- (void) setSuperscriptValue:(int)offset {
	_superscriptValue = offset;
}

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
	
	if ( [self isHighlighted] || [self state] == NSOnState ) {
		
		borderColor = [NSColor colorWithCalibratedRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:alpha];
		gradientStart = [NSColor colorWithCalibratedRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:alpha];
		gradientEnd = [NSColor colorWithCalibratedRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:alpha];
		
	}
	
	else {
		
		borderColor = [NSColor colorWithCalibratedRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:alpha];
		gradientEnd = [NSColor colorWithCalibratedRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:alpha];
		gradientStart = [NSColor colorWithCalibratedRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:alpha];
		
	}
	
	int height = cellFrame.size.height;
	int width = cellFrame.size.width;
	
			
	//
	// draw the gradient
	
	NSRect targetRect = NSInsetRect(cellFrame,0.5,0.5);
	
	[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:2.0] 
			linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
		
	[borderColor set];
	[[NSBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:2.0] stroke];
	
	//
	// draw the string value
	
	NSAttributedString *attr_string = [self attributedTitle];
	if ( attr_string != nil ) {
		
		NSSize stringSize = [attr_string size];
		NSRect stringRect = NSMakeRect(width/2.0-stringSize.width/2.0, height/2.0-stringSize.height/2.0, 
				stringSize.width, stringSize.height);
		
		if ( _superscriptValue != 0 ) {
			
			int widthOffset = stringSize.width/3/2;
			
			NSAttributedString *partNorm = [attr_string attributedSubstringFromRange:NSMakeRange(0,1)];
			NSMutableAttributedString *partScript = 
					[[attr_string attributedSubstringFromRange:NSMakeRange(1,[attr_string length]-1)] mutableCopy];
			
			NSFont *aFont = [partScript attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
			NSFont *sizedFont = [[NSFontManager sharedFontManager] convertFont:aFont toSize:[aFont pointSize]-3];
			
			[partScript addAttribute:NSFontAttributeName value:sizedFont range:NSMakeRange(0,[partScript length])];
			
			[partNorm drawAtPoint:NSMakePoint(stringRect.origin.x+widthOffset, stringRect.origin.y)];
			[partScript drawAtPoint:
					NSMakePoint(stringRect.origin.x+widthOffset+(stringRect.size.width/[attr_string length]), 
					stringRect.origin.y - (_superscriptValue*3))];
			
		}
		else {
		
			[attr_string drawInRect:stringRect];
		
		}

	}
	else {
		
		NSString *title = [self title];
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSFont systemFontOfSize:11.0], NSFontAttributeName, 
				( [self isEnabled] ? [NSColor blackColor] : [NSColor lightGrayColor] ), NSForegroundColorAttributeName, nil];
		
		NSSize stringSize = [title sizeWithAttributes:attributes];
		NSRect stringRect = NSMakeRect(width/2.0-stringSize.width/2.0, height/2.0-stringSize.height/2.0, 
				stringSize.width, stringSize.height);
				
		[title drawInRect:stringRect withAttributes:attributes];
	
	}
	
	

}


@end
