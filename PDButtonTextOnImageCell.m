//
//  PDButtonTextOnImageCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 1/3/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDButtonTextOnImageCell.h>


@implementation PDButtonTextOnImageCell

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
	
	
	float height = cellFrame.size.height;
	float width = cellFrame.size.width;
	
	float alpha = 1.0;
	
	NSSize centerSize;
	NSSize textSize;
	NSRect targetRect;
	NSRect textRect;
	
	NSImage *cellImage = [self image];
	
	NSMutableAttributedString *attrValue = [[[NSMutableAttributedString alloc] initWithString:[self title]attributes:
				[NSDictionary dictionaryWithObjectsAndKeys:[self font], NSFontAttributeName, nil]] autorelease];
	
	centerSize = [cellImage size];
	targetRect = NSMakeRect(width/2-centerSize.width/2, height/2-centerSize.height/2, centerSize.width, centerSize.height);
	
	if ( [self isHighlighted] ) {
		[[NSColor blackColor] set];
		NSRectFillUsingOperation(cellFrame, NSCompositeSourceOver);
		alpha = 0.6;
	}
	
	[cellImage setFlipped:YES];
	[cellImage drawInRect:targetRect
			fromRect:NSMakeRect(0,0,centerSize.width,centerSize.height)
			operation:NSCompositeSourceOver fraction:alpha];
	
	textSize = [attrValue size];
	
	// a maximum rectangle for the text
	NSRect maxTextRect = NSMakeRect(4,height/2-textSize.height/2 + 1, width-8, textSize.height);
	
	// the required size
	textRect = NSMakeRect(width/2-textSize.width/2, height/2-textSize.height/2 + 1, textSize.width, textSize.height);
	
	if ( textRect.size.width > maxTextRect.size.width ) {
		
		NSMutableParagraphStyle *parStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopyWithZone:[self zone]];
		[parStyle setLineBreakMode:NSLineBreakByTruncatingTail];
		
		[attrValue addAttribute:NSParagraphStyleAttributeName value:parStyle range:NSMakeRange(0,[attrValue length])];
		[attrValue drawInRect:maxTextRect];
		
		[parStyle release];
		
	}
	else {
		
		[attrValue drawInRect:textRect];
		
	}
	
}


@end
