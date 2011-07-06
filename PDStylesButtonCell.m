//
//  PDStylesButtonCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/1/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

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
