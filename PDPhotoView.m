
// I believe I override a number of methods in MUPhotoView
// so as to use a cell with the class, MUPhotoCell.

//
//  MUPhotoView
//
// Copyright (c) 2006 Blake Seely
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
//    OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//  * You include a link to http://www.blakeseely.com in your final product.
//
// Version History:
//
// Version 1.0 - April 17, 2006 - Initial Release
// Version 1.1 - April 29, 2006 - Photo removal support, Added support for reduced-size drawing during live resize
// Version 1.2 - September 24, 2006 - Updated selection behavior, Changed to MIT license, Fixed issue where no images would show, fixed autoscroll

#import <SproutedInterface/PDPhotoView.h>
#import <SproutedInterface/MUPhotoCell.h>

@implementation PDPhotoView

#pragma mark -
// Initializers and Dealloc
#pragma mark Initializers and Dealloc

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		
		drawsBackground = YES;
		hoverCursor = nil;
		amPrinting = NO;
		
		MUPhotoCell *defaultCell = [[[MUPhotoCell alloc] initImageCell:nil] autorelease];
		[self setCell:defaultCell];
			
	}
	
	return self;
}

#pragma mark -

- (void) dealloc
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	[cell release], cell = nil;
	[hoverCursor release], hoverCursor = nil;
	
	[super dealloc];
}

- (void) ownerWillClose:(NSNotification*)aNotification
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	if ( autoscrollTimer != nil )
	{
		[autoscrollTimer invalidate];
		autoscrollTimer = nil;
	}
	
	if ( photoResizeTimer != nil )
	{
		[photoResizeTimer invalidate];
		photoResizeTimer = nil;
	}

}

#pragma mark -

- (NSCell*) cell
{
	return cell;
}

- (void) setCell:(NSCell*)aCell
{
	if ( cell != aCell )
	{
		[cell release];
		cell = [aCell copyWithZone:[self zone]];
	}
}

- (NSCursor*) hoverCursor
{
	return hoverCursor;
}

- (void) setHoverCursor:(NSCursor*)aCursor
{
	if ( hoverCursor != aCursor )
	{
		[hoverCursor release];
		hoverCursor = [aCursor retain];
	}
}

- (unsigned) indexForMenuEvent
{
	return indexForMenuEvent;
}

- (void) setIndexForMenuEvent:(unsigned)anIndex
{
	indexForMenuEvent = anIndex;
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	[self setIndexForMenuEvent:[self photoIndexForPoint:[self convertPoint:[theEvent locationInWindow] fromView:nil]]];
	return [super menuForEvent:theEvent];
}

- (BOOL) drawsBackground
{
	return drawsBackground;
}

- (void) setDrawsBackground:(BOOL)draws
{
	drawsBackground = draws;
}

#pragma mark -

- (void)setSelectionIndexes:(NSIndexSet *)indexes
{
	// CHANGE: allow the delegate to modify the selection even if the selected photo index is available
	
	NSMutableIndexSet *oldSelection = nil;
	
	// Set the new selection, but save the old selection so we know exactly what to redraw
    if (nil != [self selectedPhotoIndexes])
    {
    	oldSelection = [[self selectedPhotoIndexes] retain];
		if ( [delegate respondsToSelector:@selector(photoView:willSetSelectionIndexes:)] )
			indexes = [delegate photoView:self willSetSelectionIndexes:indexes];
		[self setSelectedPhotoIndexes:indexes];
    } 
	else if (nil != delegate)
	{
		// We have to iterate through the photos to figure out which ones the delegate thinks are selected - that's the only way to know the old selection when in delegate mode
		oldSelection = [[NSMutableIndexSet alloc] init];
		int i, count = [self photoCount];
		for( i = 0; i < count; i += 1 )
		{
			if ([self isPhotoSelectedAtIndex:i])
			{
				[oldSelection addIndex:i];
			}
		}
		
		// Now update the selection
		indexes = [delegate photoView:self willSetSelectionIndexes:indexes];
		[delegate photoView:self didSetSelectionIndexes:indexes];
	}
	
	[self dirtyDisplayRectsForNewSelection:indexes oldSelection:oldSelection];
	[oldSelection release];
}

- (void)setPhotosArray:(NSArray *)aPhotosArray
{
	[super setPhotosArray:aPhotosArray];
	[[self window] invalidateCursorRectsForView:self];
	// call super's implementation and invalidate our cursor rects
}

- (void)setPhotoSize:(float)aPhotoSize
{
	[super setPhotoSize:aPhotoSize];
	[[self window] invalidateCursorRectsForView:self];
	// call super's implementation and invalidate our cursor rects
}

- (void)setPhotoVerticalSpacing:(float)aPhotoVerticalSpacing
{
	[super setPhotoVerticalSpacing:aPhotoVerticalSpacing];
	[[self window] invalidateCursorRectsForView:self];
	// call super's implementation and invalidate our cursor rects
}

- (void)setPhotoHorizontalSpacing:(float)aPhotoHorizontalSpacing
{
	[super setPhotoHorizontalSpacing:aPhotoHorizontalSpacing];
	[[self window] invalidateCursorRectsForView:self];
	// call super's implementation and invalidate our cursor rects
}

#pragma mark -

- (void)drawRect:(NSRect)rect
{
	if ( [NSGraphicsContext currentContextDrawingToScreen] )
		[self removeAllToolTips];		// djw: are these really working?
	
	if ( [self drawsBackground] )
	{
		// draw the background color
		[[self backgroundColor] set];
		[NSBezierPath fillRect:rect];
	}
	
	// update internal grid size, adjust height based on the new grid size
    // because I may not find out that the photos array has changed until I draw and read the photos from the delegate, this call has to stay here
    [self updateGridAndFrame];
	
    // get the number of photos
    unsigned photoCount = [self photoCount];
    if (0 == photoCount)
        return;

    // any other setup
    if (useHighQualityResize) {
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    }
	
	NSCell *drawingCell = [self cell];
	
    /**** BEGIN Drawing Photos ****/
	NSRange rangeToDraw = [self photoIndexRangeForRect:rect]; // adjusts for photoCount if the rect goes outside my range
    unsigned index;
    unsigned lastIndex = rangeToDraw.location + rangeToDraw.length;
    // Our version of photoIndexRangeForRect: returns one item more in the range than the MUPhotoView 1.2 version. Hence we also
    // must do one less iteration so here we do < instead of <= 
    for (index = rangeToDraw.location; index < lastIndex; index++) {
        
        // Get the image at the current index - a gray bezier anywhere in the view means it asked for an image, but got nil for that index
        NSImage *photo = nil;
        if ([self inLiveResize]) {
            photo = [self fastPhotoAtIndex:index];
        }
        
        if (nil == photo) {
           photo = [self photoAtIndex:index]; 
        }

        // scale it to the appropriate size, this method should automatically set high quality if necessary
        photo = [self scalePhoto:photo];
        
        // get all the appropriate positioning information
        NSRect gridRect = [self centerScanRect:[self gridRectForIndex:index]];
        NSSize scaledSize = [self scaledPhotoSizeForSize:[photo size]];
        NSRect photoRect = [self rectCenteredInRect:gridRect withSize:scaledSize];
        photoRect = [self centerScanRect:photoRect];
        
        //**** BEGIN Background Drawing - any drawing that technically goes under the image ****/
		// kSelectionStyleShadowBox draws a semi-transparent rounded rect behind/around the image
        if ([self isPhotoSelectedAtIndex:index] && [self useShadowSelection]) {
            
			NSBezierPath *shadowBoxPath = [self shadowBoxPathForRect:gridRect];
            [shadowBoxColor set];
            [shadowBoxPath fill];
        }
		
		//**** END Background Drawing ****/
 
        // draw the current photo
		
		NSString *photoTitle = nil;
		if ( [[self delegate] respondsToSelector:@selector(photoView:titleForObjectAtIndex:)] )
			photoTitle = [[self delegate] photoView:self titleForObjectAtIndex:index];
		
		[drawingCell setTitle:photoTitle];
		[drawingCell setObjectValue:photo];
		
		 // kBorderStyleShadow - set the appropriate shadow
		if ([self useShadowBorder]) {
            [borderShadow set];
        }
		
		[drawingCell drawWithFrame:photoRect inView:self];
	
        [noShadow set];
		
		// register the tooltip area - photoRect
		if ( [NSGraphicsContext currentContextDrawingToScreen] )
			[self addToolTipRect:photoRect owner:self userData:nil];
		
        // restore the photo's flipped status
		
		// BEGIN Foreground Drawing - includes outline borders, selection rectangles
        if ([self isPhotoSelectedAtIndex:index] && [self useBorderSelection]) {
            NSBezierPath *selectionBorder = [NSBezierPath bezierPathWithRect:NSInsetRect(photoRect,-3.0,-3.0)];
            [selectionBorder setLineWidth:[self selectionBorderWidth]];
            [[self selectionBorderColor] set];
            [selectionBorder stroke];
        } else if ([self useOutlineBorder]) {
            photoRect = NSInsetRect(photoRect,0.5,0.5); // line up the 1px border so it completely fills a single row of pixels
            NSBezierPath *outline = [NSBezierPath bezierPathWithRect:photoRect];
            [outline setLineWidth:1.0];
            [borderOutlineColor set];
            [outline stroke];
        }
		
        
        //**** END Foreground Drawing ****//
        
        
    }

    //**** END Drawing Photos ****//
}

- (NSString *)view:(NSView *)view stringForToolTip:(NSToolTipTag)tag point:(NSPoint)point userData:(void *)userData
{
	unsigned idx = [self photoIndexForPoint:point];
	if (idx < [self photoCount] && [[self delegate] respondsToSelector:@selector(photoView:tooltipForObjectAtIndex:)] )
	{
		return [delegate photoView:self tooltipForObjectAtIndex:[self photoIndexForPoint:point]];
	}
	return nil;
}

- (void)resetCursorRects
{	
	if ( [self hoverCursor] == nil )
		return;
	
	int i;
	for ( i = 0; i < [[self photosArray] count]; i++ )
		[self addCursorRect:[self photoRectForIndex:i] cursor:[self hoverCursor]];
}

#pragma mark -

- (void) mouseDown:(NSEvent *) event
{
	if ( [event clickCount] == 2) 
	{
		// There could be more than one selected photo.  In that case, call the delegates doubleClickOnPhotoAtIndex routine for
		// each selected photo.
		unsigned int selectedIndex = [[self selectionIndexes] firstIndex];
		while (selectedIndex != NSNotFound) {
			[delegate photoView:self doubleClickOnPhotoAtIndex:selectedIndex withFrame:[self photoRectForIndex:selectedIndex]];
			selectedIndex = [[self selectionIndexes] indexGreaterThanIndex:selectedIndex];
		}
	}
	else
	{
		mouseDown = YES;
		mouseDownPoint = [self convertPoint:[event locationInWindow] fromView:nil];
		mouseCurrentPoint = mouseDownPoint;

		unsigned				clickedIndex = [self photoIndexForPoint:mouseDownPoint];
		NSRect					photoRect = [self photoRectForIndex:clickedIndex];
		unsigned int			flags = [event modifierFlags];
		NSMutableIndexSet*		indexes = [[self selectionIndexes] mutableCopy];
		BOOL					imageHit = NSPointInRect(mouseDownPoint, photoRect);

		if (imageHit) {
			if (flags & NSCommandKeyMask) {
				// Flip current image selection state.
				if ([indexes containsIndex:clickedIndex]) {
					[indexes removeIndex:clickedIndex];
				} else {
					[indexes addIndex:clickedIndex];
				}
			} else {
				if (flags & NSShiftKeyMask) {
					// Add range to selection.
					if ([indexes count] == 0) {
						[indexes addIndex:clickedIndex];
					} else {
						unsigned int origin = (clickedIndex < [indexes lastIndex]) ? clickedIndex :[indexes lastIndex];
						unsigned int length = (clickedIndex < [indexes lastIndex]) ? [indexes lastIndex] - clickedIndex : clickedIndex - [indexes lastIndex];

						length++;
						[indexes addIndexesInRange:NSMakeRange(origin, length)];
					}
				} else {
					if (![self isPhotoSelectedAtIndex:clickedIndex]) {
						// Photo selection without modifiers.
						[indexes removeAllIndexes];
						[indexes addIndex:clickedIndex];
					}
				}
			}

			potentialDragDrop = YES;
		} else {
			if ((flags & NSShiftKeyMask) == 0) {
				[indexes removeAllIndexes];
			}
			potentialDragDrop = NO;
		}

		[self setSelectionIndexes:indexes];
		[indexes release];
	}
}

- (void)mouseUp:(NSEvent *)event
{
	return;
	// don't do a damn thing
	// bug: calling set needs display results in background drawing over image parts without the images being asked to draw again 
}

- (void)mouseDragged:(NSEvent *)event
{

	
	if (0 == columns) return;
    mouseCurrentPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    
    // if the mouse has moved less than 5px in either direction, don't register the drag yet
    float xFromStart = fabs((mouseDownPoint.x - mouseCurrentPoint.x));
	float yFromStart = fabs((mouseDownPoint.y - mouseCurrentPoint.y));
	if ((xFromStart < 5) && (yFromStart < 5)) {
		return;
        
	} else if (potentialDragDrop && (nil != delegate)) {
        // create a drag image
		unsigned clickedIndex = [self photoIndexForPoint:mouseDownPoint];
        NSImage *clickedImage = [self photoAtIndex:clickedIndex];
        //BOOL flipped = [clickedImage isFlipped];
        //[clickedImage setFlipped:NO];
        NSSize scaledSize = [self scaledPhotoSizeForSize:[clickedImage size]];
		if (nil == clickedImage) { // creates a red image, which should let the user/developer know something is wrong
            clickedImage = [[[NSImage alloc] initWithSize:NSMakeSize(photoSize,photoSize)] autorelease];
            [clickedImage lockFocus];
            [[NSColor redColor] set];
            [NSBezierPath fillRect:NSMakeRect(0,0,photoSize,photoSize)];
            [clickedImage unlockFocus];
        }
		NSImage *dragImage = [[NSImage alloc] initWithSize:scaledSize];

		// draw the drag image as a semi-transparent copy of the image the user dragged, and optionally a red badge indicating the number of photos
        [dragImage lockFocus];
		[clickedImage drawInRect:NSMakeRect(0,0,scaledSize.width,scaledSize.height) fromRect:NSMakeRect(0,0,[clickedImage size].width,[clickedImage size].height)  operation:NSCompositeCopy fraction:0.5];
		[dragImage unlockFocus];
        
        //[clickedImage setFlipped:flipped];

		// if there's more than one image, put a badge on the photo
		if ([[self selectionIndexes] count] > 1) {
			NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
			[attributes setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
			[attributes setObject:[NSFont fontWithName:@"Helvetica" size:14] forKey:NSFontAttributeName];
			NSAttributedString *badgeString = [[NSAttributedString alloc] initWithString:[[NSNumber numberWithInt:[[self selectionIndexes] count]] stringValue] attributes:attributes];
			NSSize stringSize = [badgeString size];
			int diameter = stringSize.width;
			if (stringSize.height > diameter) diameter = stringSize.height;
			diameter += 5;
			
			// calculate the badge circle
			int minY = 5;
			int maxX = [dragImage size].width - 5;
			int maxY = minY + diameter;
			int minX = maxX - diameter;
			NSBezierPath *circle = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(minX,minY,maxX-minX,maxY-minY)];
			// draw the circle
			[dragImage lockFocus];
			[[NSColor colorWithDeviceRed:1 green:0.1 blue:0.1 alpha:0.7] set];
			[circle fill];
			[dragImage unlockFocus];
			
			// draw the string
			NSPoint point;
			point.x = maxX - ((maxX - minX) / 2) - 1;
			point.y = (maxY - minY) / 2;
			point.x = point.x - (stringSize.width / 2);
			point.y = point.y - (stringSize.height / 2) + 7;
			
			[dragImage lockFocus];
			[badgeString drawAtPoint:point];
			[dragImage unlockFocus];
			
			[badgeString release];
			[attributes release];
		}
		
        // get the pasteboard and register the returned types with delegate as the owner
		NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSDragPboard];
		[pb declareTypes:[NSArray array] owner:nil]; // clear the pasteboard 
		[delegate photoView:self fillPasteboardForDrag:pb];
		
		// place the cursor in the center of the drag image
		NSPoint p = [self convertPoint:[event locationInWindow] fromView:nil];
		NSSize imageSize = [dragImage size];
		p.x = p.x - imageSize.width / 2;
		p.y = p.y + imageSize.height / 2;
		
		[self dragImage:dragImage at:p offset:NSZeroSize event:event pasteboard:pb source:self slideBack:YES];

        [dragImage release];

    } else {
        // adjust the mouse current point so that it's not outside the frame
        NSRect frameRect = [self frame];
        if (mouseCurrentPoint.x < NSMinX(frameRect))
            mouseCurrentPoint.x = NSMinX(frameRect);
        if (mouseCurrentPoint.x > NSMaxX(frameRect))
            mouseCurrentPoint.x = NSMaxX(frameRect);
        if (mouseCurrentPoint.y < NSMinY(frameRect))
            mouseCurrentPoint.y = NSMinY(frameRect);
        if (mouseCurrentPoint.y > NSMaxY(frameRect))
            mouseCurrentPoint.y = NSMaxY(frameRect);
        
        // determine the rect for the current drag area
        float minX, maxX, minY, maxY;
        minX = (mouseCurrentPoint.x < mouseDownPoint.x) ? mouseCurrentPoint.x : mouseDownPoint.x;
		minY = (mouseCurrentPoint.y < mouseDownPoint.y) ? mouseCurrentPoint.y : mouseDownPoint.y;
		maxX = (mouseCurrentPoint.x > mouseDownPoint.x) ? mouseCurrentPoint.x : mouseDownPoint.x;
		maxY = (mouseCurrentPoint.y > mouseDownPoint.y) ? mouseCurrentPoint.y : mouseDownPoint.y;
        if (maxY > NSMaxY(frameRect))
            maxY = NSMaxY(frameRect);
        if (maxX > NSMaxX(frameRect))
            maxX = NSMaxX(frameRect);
            
        NSRect selectionRect = NSMakeRect(minX,minY,maxX-minX,maxY-minY);
		
		unsigned minIndex = [self photoIndexForPoint:NSMakePoint(minX, minY)];
		unsigned xRun = [self photoIndexForPoint:NSMakePoint(maxX, minY)] - minIndex + 1;
		unsigned yRun = [self photoIndexForPoint:NSMakePoint(minX, maxY)] - minIndex + 1;
		unsigned selectedRows = (yRun / columns);
        
        // Save the current selection (if any), then populate the drag indexes
		// this allows us to shift band select to add to the current selection.
		[dragSelectedPhotoIndexes removeAllIndexes];
		[dragSelectedPhotoIndexes addIndexes:[self selectionIndexes]];
        
        // add indexes in the drag rectangle
        int i;
		for (i = 0; i <= selectedRows; i++) {
			unsigned rowStartIndex = (i * columns) + minIndex;
            int j;
            for (j = rowStartIndex; j < (rowStartIndex + xRun); j++) {
                if (NSIntersectsRect([self photoRectForIndex:j],selectionRect))
                    [dragSelectedPhotoIndexes addIndex:j];
            }
		}
        
        // if requested, set the selection. this could cause a rapid series of KVO notifications, so if this is false, the view tracks
        // the selection internally, but doesn't pass it to the bindings or the delegates until the drag is over.
		// This will cause an appropriate redraw.
        if (sendsLiveSelectionUpdates)
		{
            [self setSelectionIndexes:dragSelectedPhotoIndexes];
        }
		
        [[self superview] autoscroll:event];
		[self setNeedsDisplayInRect:[self visibleRect]];
    }
}


- (NSImage *)fastPhotoAtIndex:(unsigned)index
{
    NSImage *fastPhoto = nil;
    if ((nil != [self photosArray]) && (index < [[self photosArray] count]))
    {
        fastPhoto = [photosFastArray objectAtIndex:index];
        if ((NSNull *)fastPhoto == [NSNull null])
        {
			// Change this if you want higher/lower quality fast photos
			float fastPhotoSize = 100.0;
			
			NSImageRep *fullSizePhotoRep = [[self scalePhoto:[self photoAtIndex:index]] bestRepresentationForDevice:nil];
	        
			// Figure out what the scaled size is
			float longSide = [fullSizePhotoRep pixelsWide];
	        if (longSide < [fullSizePhotoRep pixelsHigh])
	            longSide = [fullSizePhotoRep pixelsHigh];

	        float scale = fastPhotoSize / longSide;

	        NSSize scaledSize;
	        scaledSize.width = [fullSizePhotoRep pixelsWide] * scale;
	        scaledSize.height = [fullSizePhotoRep pixelsHigh] * scale;

			// Draw the full-size image into our fast, small image.
	        fastPhoto = [[NSImage alloc] initWithSize:scaledSize];
	        //[fastPhoto setFlipped:YES];
	        [fastPhoto lockFocus];
	        [fullSizePhotoRep drawInRect:NSMakeRect(0.0, 0.0, scaledSize.width, scaledSize.height)];
	        [fastPhoto unlockFocus];

			// Save it off
            [photosFastArray replaceObjectAtIndex:index withObject:fastPhoto];
			
			[fastPhoto autorelease];
        }
    } else if ((nil != delegate) && ([delegate respondsToSelector:@selector(photoView:fastPhotoAtIndex:)])) {
        fastPhoto = [delegate photoView:self fastPhotoAtIndex:index];
    }
    
    // if the above calls failed, try to just fetch the full size image
    if (![fastPhoto isValid]) {
        fastPhoto = [self photoAtIndex:index];
    }
    
    return fastPhoto;
}

- (NSImage *)scaleImage:(NSImage *)image toSize:(float)size
{
    NSImageRep *fullSizePhotoRep = [[self scalePhoto:image] bestRepresentationForDevice:nil];

    float longSide = [fullSizePhotoRep pixelsWide];
    if (longSide < [fullSizePhotoRep pixelsHigh])
        longSide = [fullSizePhotoRep pixelsHigh];
        
    float scale = size / longSide;
        
    NSSize scaledSize;
    scaledSize.width = [fullSizePhotoRep pixelsWide] * scale;
    scaledSize.height = [fullSizePhotoRep pixelsHigh] * scale;
        
    NSImage *fastPhoto = [[NSImage alloc] initWithSize:scaledSize];
    //[fastPhoto setFlipped:YES];
    [fastPhoto lockFocus];
    [fullSizePhotoRep drawInRect:NSMakeRect(0.0, 0.0, scaledSize.width, scaledSize.height)];
    [fastPhoto unlockFocus];
        
    return [fastPhoto autorelease];
}

#pragma mark -

- (void)updateGridAndFrame
{
    /**** BEGIN Dimension calculations and adjustments ****/

	
	// get the number of photos
	unsigned photoCount = [self photoCount];
	
	// calculate the base grid size
	gridSize.height = [self photoSize] + [self photoVerticalSpacing];
	gridSize.width = [self photoSize] + [self photoHorizontalSpacing];
	
	// if there are no photos, return
	if (0 == photoCount) {
		columns = 0;
		rows = 0;
		float width = [self frame].size.width;
		float height = [[[self enclosingScrollView] contentView] frame].size.height;
		[self setFrameSize:NSMakeSize(width, height)];
		return;
	}
	
	// calculate the number of columns (ivar)
	float width = [self frame].size.width;
	columns = width / gridSize.width;
	
	// minimum 1 column
	if (1 > columns)
		columns = 1;
	
	// if we have fewer photos than columns, adjust downward
	if (photoCount < columns)
		columns = photoCount;
	
	// adjust the grid size width for extra space
	gridSize.width += (width - (columns * gridSize.width)) / columns;
	
	// calculate the number of rows of photos based on the total count and the number of columns (ivar)
	rows = photoCount / columns;
	if (0 < (photoCount % columns))
		rows++;
	// adjust my frame height to contain all the photos
	float height = rows * gridSize.height;
	NSScrollView *scroll = [self enclosingScrollView];
	if ((nil != scroll) && (height < [[scroll contentView] frame].size.height))
		height = [[scroll contentView] frame].size.height;
	
	// set my new frame size
	[self setFrameSize:NSMakeSize(width, height)];
	
	
	    
    /**** END Dimension calculations and adjustments ****/
    return;
}


- (void)updatePhotoResizing
{
    NSTimeInterval timeSinceResize = [[NSDate date] timeIntervalSinceReferenceDate] - [photoResizeTime timeIntervalSinceReferenceDate];
    if (timeSinceResize > 1) {
        isDonePhotoResizing = YES;
        //[photoResizeTimer invalidate];
		
		// **** PhilDow change - release timer ****
		//[photoResizeTimer release];
        //photoResizeTimer = nil;
    }
	
	if ( [self inLiveResize] )
		[self viewDidEndLiveResize];
}

#pragma mark -

- (NSAttributedString *)pageHeader
{
	return nil;
}

- (NSAttributedString *)pageFooter
{
	return nil;
}

/*
// Return the number of pages available for printing
- (BOOL)knowsPageRange:(NSRangePointer)range {
   
   [self updateGridAndFrame];
   
	NSRect bounds = NSMakeRect(0, 0, gridSize.width, gridSize.height);
    float printHeight = [self calculatePrintHeight];
 
    range->location = 1;
    range->length = NSHeight(bounds) / printHeight + 1;
    return YES;
}
 
// Return the drawing rectangle for a particular page number
- (NSRect)rectForPage:(int)page {
    NSRect bounds = NSMakeRect(0, 0, gridSize.width, gridSize.height);
    float pageHeight = [self calculatePrintHeight];
    return NSMakeRect( NSMinX(bounds), NSMaxY(bounds) - page * pageHeight,
                        NSWidth(bounds), pageHeight );
}
 
// Calculate the vertical size of the view that fits on a single page
- (float)calculatePrintHeight {
    // Obtain the print info object for the current operation
    NSPrintInfo *pi = [[NSPrintOperation currentOperation] printInfo];
 
    // Calculate the page height in points
    NSSize paperSize = [pi paperSize];
    float pageHeight = paperSize.height - [pi topMargin] - [pi bottomMargin];
 
    // Convert height to the scaled view 
    float scale = [[[pi dictionary] objectForKey:NSPrintScalingFactor]
                    floatValue];
    return pageHeight / scale;
}
*/

/*
- (void)beginDocument
{
	amPrinting = YES;
	[super beginDocument];
}

- (void)endDocument
{
	[super endDocument];
	amPrinting = NO;
}
*/

/*
- (void)print:(id)sender
{
	amPrinting = YES;
	[super print:sender];
	amPrinting = NO;
}
*/

@end

