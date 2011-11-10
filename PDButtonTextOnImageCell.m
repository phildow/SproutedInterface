//
//  PDButtonTextOnImageCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 1/3/06.
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
