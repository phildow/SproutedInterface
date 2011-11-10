//
//  RoundedViewWhiteText.m
//  SproutedInterface
//
//  Created by Philip Dow on 6/12/06.
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

#import <SproutedInterface/RoundedViewWhiteText.h>

#define kInset 10

@implementation RoundedViewWhiteText

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		_title = [[NSString alloc] init];
		_color = [[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] retain];
    }
    return self;
}

- (void) dealloc {
	[_title release];
	[_color release];
	[super dealloc];
}

#pragma mark -

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
	
	float font_size = 160.0;
	NSString *string = [self title];
	NSFont *font = [NSFont labelFontOfSize:font_size];
	
	NSMutableDictionary *attrs = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
			font, NSFontAttributeName, [self color], NSForegroundColorAttributeName, nil];
	
	NSSize bds_size = [self bounds].size;
	
	NSSize string_size = [string sizeWithAttributes:attrs];
	NSPoint origin = NSMakePoint(bds_size.width/2 - string_size.width/2, bds_size.height/2 - string_size.height/2);
	
	while ( origin.x < kInset ) {
		
		font_size-=4;
		font = [NSFont labelFontOfSize:font_size];
		[attrs setObject:font forKey:NSFontAttributeName];
		
		string_size = [string sizeWithAttributes:attrs];
		origin = NSMakePoint(bds_size.width/2 - string_size.width/2, bds_size.height/2 - string_size.height/2);
		
	}
	
	[string drawAtPoint:origin withAttributes:attrs];
	
}

#pragma mark -

- (NSColor*) color { return _color; }

- (void) setColor:(NSColor*)aColor {
	if ( _color != aColor ) {
		[_color release];
		_color = [aColor copyWithZone:[self zone]];
	}
}

- (NSString*) title { return _title; }

- (void) setTitle:(NSString*)text {
	if ( _title != text ) {
		[_title release];
		_title = [text copyWithZone:[self zone]];
	}
}

@end
