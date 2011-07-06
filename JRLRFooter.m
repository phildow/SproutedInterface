//
//  JRLRFooter.m
//  SproutedInterface
//
//  Created by Philip Dow on 7/30/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/JRLRFooter.h>

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMShading.h>

@implementation JRLRFooter

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		
    }
    return self;
}

- (void) dealloc {
	
	[super dealloc];
}

#pragma mark -

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	
	NSRect bds = [self bounds];
	NSColor *gradientEnd = [NSColor colorWithCalibratedRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0];
	NSColor *gradientStart = [NSColor colorWithCalibratedRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
	
	[[NSBezierPath bezierPathWithRect:bds] 
			linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
	
	[[NSColor lightGrayColor] set];
	NSFrameRect([self bounds]);
}

@end
