//
//  PDFontDisplay.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDFontDisplay.h>
#import <SproutedInterface/PDFontPreview.h>

@implementation PDFontDisplay

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
	}
	return self;
}

- (void)drawRect:(NSRect)rect {

	/*
	This view whites out the background, draws a control rect around itself, 
	and then displays the font according to its superview's font and color preferences.
	The result is similar to that found in Safari's or Mail's preferences.
	*/

	NSRect bds = [self bounds];
	
	//fills it white
	[[NSColor whiteColor] set];
	NSRectFillUsingOperation(NSMakeRect( 1, 1, bds.size.width-2, bds.size.height-2), NSCompositeSourceOver);
	
	//get a string description of the font
	NSString *drawString = [NSString stringWithFormat:@"%@ %i", [[(PDFontPreview*)[self superview] font] displayName], 
		[[NSNumber numberWithFloat:[[(PDFontPreview*)[self superview] font] pointSize]] intValue]];
	
	//set up our attributes so we know how to draw the string
	NSMutableDictionary *tempAttributes = [NSMutableDictionary dictionary];
	[tempAttributes setObject:[(PDFontPreview*)[self superview] font] forKey:NSFontAttributeName];

	//make sure our color is correct
	[tempAttributes setObject:[(PDFontPreview*)[self superview] color] forKey:NSForegroundColorAttributeName];
	
	//grab the fonts size
	NSSize stringSize = [drawString sizeWithAttributes:tempAttributes];
	//center a rect
	NSRect stringRect = NSMakeRect( bds.size.width/2 - stringSize.width/2, bds.size.height/2 - stringSize.height/2, 
		stringSize.width, stringSize.height );
	
	//and draw the string in the rect
	[drawString drawInRect:stringRect withAttributes:tempAttributes];
	
	//draws an outline around the guy, just like with other views
	//last to cover up any text that might overflow into this single pixel line
	[[NSColor controlShadowColor] set ];
	NSFrameRect(bds);
}

@end
