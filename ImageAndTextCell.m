/*
	ImageAndTextCell.m
	Copyright (c) 2001-2004, Apple Computer, Inc., all rights reserved.
	Author: Chuck Pisula

	Milestones:
	Initially created 3/1/01

        Subclass of NSTextFieldCell which can display text and an image simultaneously.
*/

/*
 IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc. ("Apple") in
 consideration of your agreement to the following terms, and your use, installation, 
 modification or redistribution of this Apple software constitutes acceptance of these 
 terms.  If you do not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject to these 
 terms, Apple grants you a personal, non-exclusive license, under Apple’s copyrights in 
 this original Apple software (the "Apple Software"), to use, reproduce, modify and 
 redistribute the Apple Software, with or without modifications, in source and/or binary 
 forms; provided that if you redistribute the Apple Software in its entirety and without 
 modifications, you must retain this notice and the following text and disclaimers in all 
 such redistributions of the Apple Software.  Neither the name, trademarks, service marks 
 or logos of Apple Computer, Inc. may be used to endorse or promote products derived from 
 the Apple Software without specific prior written permission from Apple. Except as expressly
 stated in this notice, no other rights or licenses, express or implied, are granted by Apple
 herein, including but not limited to any patent rights that may be infringed by your 
 derivative works or by other works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO WARRANTIES, 
 EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, 
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS 
 USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL 
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, 
 REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND 
 WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR 
 OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <SproutedInterface/ImageAndTextCell.h>

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

@implementation ImageAndTextCell

static int kMinBackgroundWidth = 20;

- (id)initWithCoder:(NSCoder *)decoder {
	
	if ( self = [super initWithCoder:decoder] ) 
	{
		imageSize = NSMakeSize(32,32);
		contentCount = -1;
		boldsWhenSelected = YES;
	}
	
	return self;
}

- (id)initTextCell:(NSString *)aString {
	
	if ( self = [super initTextCell:aString] ) 
	{
		imageSize = NSMakeSize(32,32);
		contentCount = -1;
		boldsWhenSelected = YES;
	}
	
	return self;
}

- (void)dealloc {
   
	 [image release];
    image = nil;
	
	if ( _paragraph ) [_paragraph release];
	_paragraph = nil;
	
    [super dealloc];
}

- copyWithZone:(NSZone *)zone {
    ImageAndTextCell *cell = (ImageAndTextCell *)[super copyWithZone:zone];
	
    cell->image = [image retain];
	cell->_paragraph = [_paragraph retain];
	
	cell->imageSize = imageSize;
	cell->separatorCell = separatorCell;
	cell->updating = updating;
	cell->contentCount = contentCount;
	cell->selected = selected;
	cell->dim = dim;
	cell->boldsWhenSelected = boldsWhenSelected;
	
    return cell;
}

#pragma mark -

- (BOOL) dim
{
	return dim;
}

- (void) setDim:(BOOL)isDim
{
	dim = isDim;
}

- (BOOL) boldsWhenSelected
{
	return boldsWhenSelected;
}

- (void) setBoldsWhenSelected:(BOOL)doesBold
{
	boldsWhenSelected = doesBold;
}

- (int) contentCount
{
	return contentCount;
}

- (void) setContentCount:(int)count
{
	contentCount = count;
}

- (BOOL) updating
{
	return updating;
}

- (void) setUpdating:(BOOL)isUpdating
{
	updating = isUpdating;
}

- (BOOL) isSeparatorCell
{
	return separatorCell;
}

- (void) setIsSeparatorCell:(BOOL)separator
{
	separatorCell = separator;
}

- (NSSize) imageSize {
	return imageSize;
}

- (void) setImageSize:(NSSize)aSize {
	imageSize = aSize;
}

- (void)setImage:(NSImage *)anImage {
    if (anImage != image) {
        [image release];
        image = [anImage retain];
    }
}

- (NSImage *)image {
    return image;
}

- (BOOL) isSelected
{
	return selected;
}

- (void) setSelected:(BOOL)isSelected
{
	selected = isSelected;
}

#pragma mark -

- (NSRect)imageFrameForCellFrame:(NSRect)cellFrame {
    if (image != nil) {
        NSRect imageFrame;
		imageFrame.size = [self imageSize];
        imageFrame.origin = cellFrame.origin;
        imageFrame.origin.x += 3;
        imageFrame.origin.y += ceil((cellFrame.size.height - imageFrame.size.height) / 2);
        return imageFrame;
    }
    else
        return NSZeroRect;
}

- (NSSize)cellSize {
    NSSize cellSize = [super cellSize];
	cellSize.width += (image ? [self imageSize].width : 0) + 3;
    return cellSize;
}

#pragma mark -

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent {
    
	NSRect textFrame, imageFrame;
    NSDivideRect (aRect, &imageFrame, &textFrame, 3 + [self imageSize].width, NSMinXEdge);
    
	NSMutableDictionary *attrs;
	NSAttributedString *attrStringValue = [self attributedStringValue];
	
	if ( attrStringValue != nil && [attrStringValue length] != 0)
		attrs = [[[attrStringValue attributesAtIndex:0 effectiveRange:NULL] mutableCopyWithZone:[self zone]] autorelease];
	else
		attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				[NSFont systemFontOfSize:11], NSFontAttributeName,
				[NSColor blackColor], NSForegroundColorAttributeName, nil];
	
	if ([self isSelected]) {
		// prepare the text in white.
		//[attrs setValue:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
		[attrs setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
		
		NSFont *originalFont = [attrs objectForKey:NSFontAttributeName];
		if ( originalFont ) {
			NSFont *boldedFont = [[NSFontManager sharedFontManager] convertFont:originalFont toHaveTrait:NSBoldFontMask];
			if ( boldedFont )
				[attrs setValue:boldedFont forKey:NSFontAttributeName];
		}
		
	} 
	else {
		// prepare the text in black.
		[attrs setValue:[self textColor] forKey:NSForegroundColorAttributeName];
	}

	
	//[textObj setTextColor:[NSColor blackColor]];
	//[textObj setTextColor:[NSColor blackColor] range:NSMakeRange(0,[[textObj string] length])];	
	
	// center the text and take into account the required inset
	NSSize textSize = [[self stringValue] sizeWithAttributes:attrs];
	
	int textHeight = textSize.height;
	//int textWidth = textSize.width;
	
	textFrame.origin.y = textFrame.origin.y + (textFrame.size.height/2 - textHeight/2);
	textFrame.size.height = textHeight;
	//textFrame.size.width = textWidth;
	
	[super editWithFrame: textFrame inView: controlView editor:textObj delegate:anObject event: theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(int)selStart length:(int)selLength {
   
	NSRect textFrame, imageFrame;
   	NSDivideRect (aRect, &imageFrame, &textFrame, 3 + [self imageSize].width, NSMinXEdge);
   
	NSMutableDictionary *attrs;
	NSAttributedString *attrStringValue = [self attributedStringValue];
	
	if ( attrStringValue != nil && [attrStringValue length] != 0)
		attrs = [[[attrStringValue attributesAtIndex:0 effectiveRange:NULL] mutableCopyWithZone:[self zone]] autorelease];
	else
		attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				[NSFont systemFontOfSize:11], NSFontAttributeName,
				[NSColor blackColor], NSForegroundColorAttributeName, nil];
	
	if ([self isSelected]) {
		// prepare the text in white.
		//[attrs setValue:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
		[attrs setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
		
		NSFont *originalFont = [attrs objectForKey:NSFontAttributeName];
		if ( originalFont ) {
			NSFont *boldedFont = [[NSFontManager sharedFontManager] convertFont:originalFont toHaveTrait:NSBoldFontMask];
			if ( boldedFont )
				[attrs setValue:boldedFont forKey:NSFontAttributeName];
		}
		
	} 
	else {
		// prepare the text in black.
		[attrs setValue:[self textColor] forKey:NSForegroundColorAttributeName];
	}

	
	//[textObj setTextColor:[NSColor blackColor]];
	//[textObj setTextColor:[NSColor blackColor] range:NSMakeRange(0,[[textObj string] length])];	
	
	// center the text and take into account the required inset
	NSSize textSize = [[self stringValue] sizeWithAttributes:attrs];
	
	int textHeight = textSize.height;
	//int textWidth = textSize.width;
	
	textFrame.origin.y = textFrame.origin.y + (textFrame.size.height/2 - textHeight/2);
	textFrame.size.height = textHeight;
	//textFrame.size.width = textWidth;

	[super selectWithFrame: textFrame inView: controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

#pragma mark -

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	if ( ![self isSeparatorCell] )
	{
		 /*
		 if ([self isHighlighted]) {
			
			NSColor *gradientStart, *gradientEnd;
			
			NSRect controlBds = [controlView bounds];
			//NSRect gradientBounds = NSMakeRect(controlBds.origin.x, cellFrame.origin.y+1, 
			//		controlBds.size.width, cellFrame.size.height-1);
			
			NSRect gradientBounds = NSMakeRect(controlBds.origin.x, cellFrame.origin.y, 
					controlBds.size.width, cellFrame.size.height-1);
			
			if (([[controlView window] firstResponder] == controlView) && [[controlView window] isMainWindow] &&
					[[controlView window] isKeyWindow]) {
				
				//bottomColor = [NSColor colorWithCalibratedRed:91.0/255.0 green:129.0/255.0 blue:204.0/255.0 alpha:1.0];
				gradientStart = [NSColor colorWithCalibratedRed:136.0/255.0 green:165.0/255.0 blue:212.0/255.0 alpha:1.0];
				gradientEnd = [NSColor colorWithCalibratedRed:102.0/255.0 green:133.0/255.0 blue:183.0/255.0 alpha:1.0];
				
			} else {
				
				//bottomColor = [NSColor colorWithCalibratedRed:140.0/255.0 green:152.0/255.0 blue:176.0/255.0 alpha:0.9];
				gradientStart = [NSColor colorWithCalibratedRed:172.0/255.0 green:186.0/255.0 blue:207.0/255.0 alpha:0.9];
				gradientEnd = [NSColor colorWithCalibratedRed:152.0/255.0 green:170.0/255.0 blue:196.0/255.0 alpha:0.9];
			}
			
			[[NSBezierPath bezierPathWithRect:gradientBounds] linearGradientFillWithStartColor:
					gradientStart endColor:gradientEnd];
		}
		*/
		
		if (image != nil) {
			
			NSSize	myImageSize;
			NSRect	imageFrame;

			myImageSize = [self imageSize];
			NSDivideRect(cellFrame, &imageFrame, &cellFrame, 3 + myImageSize.width, NSMinXEdge);
				
			imageFrame.origin.x += 3;
			imageFrame.size = myImageSize;

			if ([controlView isFlipped])
				imageFrame.origin.y += ceil((cellFrame.size.height + imageFrame.size.height) / 2);
			else
				imageFrame.origin.y += ceil((cellFrame.size.height - imageFrame.size.height) / 2);
			
			//[image compositeToPoint:imageFrame.origin operation:NSCompositeSourceOver];
			
			//#warning this seems like a lot of extra work just because a newly created item draws flipped
			
			NSImage *imageCopy = [[[NSImage alloc] initWithSize:[self imageSize]] autorelease];
			//[imageCopy setFlipped:[controlView isFlipped]];
			
			[imageCopy lockFocus];
			
			[[NSGraphicsContext currentContext] saveGraphicsState];
			[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
			
			[image drawInRect:NSMakeRect(0,0,[self imageSize].width,[self imageSize].height) fromRect:NSMakeRect(0,0,[image size].width,[image size].height) 
					operation:NSCompositeSourceOver fraction:( [self dim] ? 0.5 : 1.0 )];

			[[NSGraphicsContext currentContext] restoreGraphicsState];
			
			[imageCopy unlockFocus];
			
			//[imageCopy drawInRect:imageFrame fromRect:NSMakeRect(0,0,[imageCopy size].width,[imageCopy size].height) operation:NSCompositeSourceOver fraction:1.0];
			[imageCopy compositeToPoint:imageFrame.origin operation:NSCompositeSourceOver];
		}

	}
	
    [super drawWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	if ( [self isSeparatorCell] )
	{
		NSRect controlBds = [controlView bounds];
		NSRect sepBounds = NSMakeRect(controlBds.origin.x + 4, cellFrame.origin.y + cellFrame.size.height/2 - 1, 
					controlBds.size.width - 8, 1);
		
		//[controlView lockFocus];
		
		[[NSColor colorWithCalibratedWhite:0.94 alpha:0.7] set];
		NSRectFillUsingOperation(sepBounds, NSCompositeSourceOver);
		
		//[controlView unlockFocus];
	}
	else
	{
		int textHeight;
		int countWidth;
		
		NSRect inset = cellFrame;
		NSMutableDictionary *attrs;
		NSAttributedString *attrStringValue = [self attributedStringValue];
		
		if ( attrStringValue != nil && [attrStringValue length] != 0)
			attrs = [[[attrStringValue attributesAtIndex:0 effectiveRange:NULL] mutableCopyWithZone:[self zone]] autorelease];
		else
			attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					[NSFont systemFontOfSize:11], NSFontAttributeName,
					[NSColor blackColor], NSForegroundColorAttributeName, nil];
		
		// paragraph attribute
		
		if ( _paragraph == nil ) {
			_paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopyWithZone:[self zone]];
			[_paragraph setLineBreakMode:NSLineBreakByTruncatingTail];
		}
		
		[attrs setValue:_paragraph forKey:NSParagraphStyleAttributeName];
		
		// shadow attribute
		
		//NSShadow *textShadow = [[[NSShadow alloc] init] autorelease];
		//[textShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.4 alpha:0.6]];
		//[textShadow setShadowOffset:NSMakeSize(0,-1)];
		
		//[attrs setValue:textShadow forKey:NSShadowAttributeName];
		//[attrs setValue:( [self dim] ? [[self textColor] colorWithAlphaComponent:0.5] : [self textColor] ) forKey:NSForegroundColorAttributeName];
		
		
		if ([self isSelected]) 
		{
			// prepare the text in white.
			[attrs setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
			
			// bold the text if that option has been requested
			if ( [self boldsWhenSelected] )
			{
				NSFont *originalFont = [attrs objectForKey:NSFontAttributeName];
				if ( originalFont ) {
					NSFont *boldedFont = [[NSFontManager sharedFontManager] convertFont:originalFont toHaveTrait:NSBoldFontMask];
					if ( boldedFont )
						[attrs setValue:boldedFont forKey:NSFontAttributeName];
				}
			}
		} 
		else {
			// prepare the text in black.
			[attrs setValue:( [self dim] ? [[self textColor] colorWithAlphaComponent:0.5] : [self textColor] ) forKey:NSForegroundColorAttributeName];
		}
		
		
		// modify the inset same
		inset.origin.x += 2;
		inset.size.width -= 4;
		
		// draw some status info
		
		if ( [self updating] )
		{
			float height = cellFrame.size.height - cellFrame.size.height/5;
			NSRect badgeFrame = NSMakeRect( cellFrame.origin.x + cellFrame.size.width - height - 4, 
											cellFrame.origin.y + cellFrame.size.height/2 - height/2, 
											height, height );
			
			
			NSBezierPath *updatingBadge = [NSBezierPath bezierPathWithOvalInRect:badgeFrame];
			[[NSColor colorWithCalibratedWhite:0.8 alpha:0.6] set];
			[updatingBadge fill];
			
			NSBezierPath *arc = [NSBezierPath bezierPath];
			
			[arc moveToPoint:NSMakePoint(badgeFrame.origin.x + badgeFrame.size.width/2, badgeFrame.origin.y + badgeFrame.size.height/2)];
			[arc appendBezierPathWithArcWithCenter:[arc currentPoint] radius:badgeFrame.size.height/2
					startAngle:-45 endAngle:-90 clockwise:NO];
			[arc closePath];
			
			[[NSColor colorWithCalibratedWhite:1.0 alpha:0.8] set];
			[arc fill];
			
			// modify the inset
			inset.size.width -= ( cellFrame.size.height - cellFrame.size.height/5 + 8 );
		}
		
		else if ( [self contentCount] > 0 )
		{
			NSMutableDictionary *countAttrs;
			NSColor *countBackground;
			
			NSFont *countFont = [NSFont fontWithName:@"LucidaGrande" size:10.0];
			if ( countFont == nil ) countFont = [NSFont boldSystemFontOfSize:10];
			
			NSFont *boldedFont = [[NSFontManager sharedFontManager] convertFont:countFont toHaveTrait:NSBoldFontMask];
			
			countAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
						boldedFont, NSFontAttributeName,
						[NSColor blackColor], NSForegroundColorAttributeName, nil];
					
			if ( [self isSelected] )
			{
				countBackground = [NSColor whiteColor];
				[countAttrs setObject:[NSColor colorWithCalibratedRed:105/255.0 green:122/255.0 blue:145/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName];
			}
			else
			{
				[countAttrs setObject:( [self dim] ? [[NSColor whiteColor] colorWithAlphaComponent:0.8] : [NSColor whiteColor] ) forKey:NSForegroundColorAttributeName];
				countBackground = [NSColor colorWithCalibratedRed:141/255.0 green:160/255.0 blue:186/255.0 alpha:1.0];
				if ( [self dim] ) countBackground = [countBackground colorWithAlphaComponent:0.5];
			}
			
			NSString *countString = [NSString stringWithFormat:@"%i", [self contentCount]];
			NSSize countSize = [countString sizeWithAttributes:countAttrs];
			
			countWidth = ( countSize.width + 10 );
			NSRect countRect = NSMakeRect(	cellFrame.origin.x + cellFrame.size.width - countWidth,
											cellFrame.origin.y + cellFrame.size.height/2 - countSize.height/2,
											countSize.width, countSize.height );
			
			if ( [controlView isFlipped] )
				countRect.origin.y++;
			else
				countRect.origin.y--;
			
			NSRect backgroundRect = countRect;
			backgroundRect.origin.x -= 5; backgroundRect.size.width += 10;
			backgroundRect.origin.y -= 1.5; backgroundRect.size.height += 1;
			
			if ( backgroundRect.size.width < kMinBackgroundWidth )
			{
				// re-align the background
				backgroundRect.origin.x = cellFrame.origin.x + cellFrame.size.width - kMinBackgroundWidth - 5;
				backgroundRect.size.width = kMinBackgroundWidth;
				
				// recenter the text horizontally on the background
				countRect.origin.x = cellFrame.origin.x + cellFrame.size.width - backgroundRect.size.width - 5 + ( backgroundRect.size.width/2 - countRect.size.width/2 );
			}
			
			// recenter the text vertically on the background
			//countRect.origin.y = backgroundRect.origin.y + ( backgroundRect.size.height/2 - countSize.height/2 );
			
			[countBackground set];
			[[NSBezierPath bezierPathWithRoundedRect:backgroundRect cornerRadius:7.4] fill];
			
			[countString drawInRect:countRect withAttributes:countAttrs];
			
			// modify the inset
			inset.size.width -= (backgroundRect.size.width + 10);
		}
		
		
		// center the text and take into account the required inset
		textHeight = [[self stringValue] sizeWithAttributes:attrs].height;
		inset.origin.y = inset.origin.y + (inset.size.height/2 - textHeight/2);
		inset.size.height = textHeight;
		
		// actually draw the title
		[[self stringValue] drawInRect:inset withAttributes:attrs];
	}
}

- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	return nil;
}

/*
- (NSColor*) textColor {
	
	if ( [self isHighlighted] )
		return [NSColor whiteColor];
	else
		return [super textColor];
}
*/

@end

