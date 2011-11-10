//
//  JRLRFooter.m
//  SproutedInterface
//
//  Created by Philip Dow on 7/30/05.
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
