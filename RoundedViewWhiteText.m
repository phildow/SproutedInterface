//
//  RoundedViewWhiteText.m
//  SproutedInterface
//
//  Created by Philip Dow on 6/12/06.
//  Copyright 2006 Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

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
