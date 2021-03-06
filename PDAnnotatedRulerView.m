//
//  PDAnnotatedRulerView.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/23/07.
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

#import <SproutedInterface/PDAnnotatedRulerView.h>

// Ruler thickness value
#define RULER_THICKNESS					25

// Margin of displaying bookmarked line in a context menu.
#define STRIP_PREVIEW_MARGIN			15

// Default
#define DEFAULT_OPTION					MNParagraphNumber | MNDrawBookmarks

@implementation PDAnnotatedRulerView

- (id)initWithScrollView:(NSScrollView *)aScrollView orientation:(NSRulerOrientation)orientation
{
	
	if ( self = [super initWithScrollView:(NSScrollView *)aScrollView orientation:(NSRulerOrientation)orientation])
	{		
		[self setScrollView:aScrollView];
		[self setOrientation:orientation];
		
		//load nib
		//[NSBundle loadNibNamed:@"PDAnnotatedRuler"  owner:self];
		
		
		
		// Set default width
		[self setRuleThickness:RULER_THICKNESS];
		
		// Marker config
		[self setReservedThicknessForMarkers:0];
		[self setClientView:self]; // Markers ask me if I can add a marker.
		
		// Add a dummy marker to draw properly
		
		markerImage = [[NSImage alloc] initByReferencingFile:
			[[NSBundle bundleForClass:[self class]] pathForResource:@"prioritymedium" ofType:@"tiff"]];
		
		NSRulerMarker* aMarker = [self newMarker];
		[self addMarker:aMarker];
		[self removeMarker:aMarker];
		
		
		// Set letter attributes
		marginAttributes = [[NSMutableDictionary alloc] init];
		[marginAttributes setObject:[NSFont labelFontOfSize:9] forKey: NSFontAttributeName];
		[marginAttributes setObject:[NSColor darkGrayColor] forKey: NSForegroundColorAttributeName];
		
		rulerOption = DEFAULT_OPTION;
		
		markerDeleteReservationFlag = NO;
		
		//
		textView = [aScrollView documentView];
		layoutManager = [textView layoutManager];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(windowDidUpdate:)
													 name:NSWindowDidUpdateNotification
												   object:[aScrollView window]];
	
	[self setOption:MNDrawBookmarks];
	
	}
	
    return self;
}

#pragma mark -

- (void)drawMarkersInRect:(NSRect)aRect
{	
	//NSLog(@"drawMarkersInRect %@",NSStringFromRect(aRect));
	
	if( (rulerOption & 0x10) == 0 )
		return;
	
	
	
	
	// *** (0) remove existing markers ***
	// Delete markers unless while dragging.
	
	NSArray* existingMarkers = [self markers];
	
	unsigned hoge = 0;
	for( hoge = 0; hoge < [existingMarkers count]; hoge++)
	{
		if( ! [[existingMarkers objectAtIndex:hoge] isDragging] )
			[self removeMarker:[existingMarkers objectAtIndex:hoge]];
		
	}
	
	
	
	
	// Only get the visible part of the scroller view
	NSRect documentVisibleRect = [[[layoutManager firstTextView] enclosingScrollView] documentVisibleRect];
	
	// Find the glyph range for the visible glyphs
	NSRange glyphRange = [layoutManager glyphRangeForBoundingRect: documentVisibleRect inTextContainer: [textView textContainer]];
	
	NSRange charRange = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
	
	NSRange limitRange;
	NSRange effectiveRange;
	
	limitRange = charRange;
	
	while (limitRange.length > 0) {
	
	//for( hoge= charRange.location; hoge < NSMaxRange(charRange) ; hoge ++ )
	//{
	
		hoge = limitRange.location;
		
		id attribute = [[textView textStorage] attribute:NSToolTipAttributeName
				atIndex:limitRange.location longestEffectiveRange:&effectiveRange
				inRange:limitRange];
		
		if ( attribute != nil )
		{
		//if ( [[textView textStorage] hasBookmarkAtIndex:hoge inTextView:textView effectiveRange:effectiveRange]  )
		//{
			
			//NSRange paragraphRange = 
			//[textView selectionRangeForProposedRange:NSMakeRange(hoge, 1) granularity:NSSelectByParagraph];
			
			
			
			//unsigned glyphIndex = [layoutManager glyphRangeForCharacterRange:NSMakeRange(paragraphRange.location,1)
			//											actualCharacterRange:NULL].location;
			
						
			unsigned glyphIndex = [layoutManager glyphRangeForCharacterRange:NSMakeRange(hoge,1)
														actualCharacterRange:NULL].location;
			
			NSRect drawingRect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange: NULL];
			drawingRect.size.height = [markerImage size].height;
			
			[self drawMarkerInRect:drawingRect ];
			
			
			
		}
		
		limitRange = NSMakeRange(NSMaxRange(effectiveRange), NSMaxRange(limitRange) - NSMaxRange(effectiveRange));
	}
	
	
	
}

-(void)drawMarkerInRect:(NSRect)lineRect 
	// check if a marker should be drawn and draw it if necessary
{
	
	lineRect =  [textView convertRect:lineRect toView:self];
	
	
	NSArray* markerObjects = [self markers];
	unsigned hoge;
	BOOL exist = NO;
	for(hoge = 0; hoge < [markerObjects count]; hoge++)
	{
		//get represented object
		NSRulerMarker* marker = [markerObjects objectAtIndex:hoge];
		
		
		if( [[marker representedObject] isEqualToString:NSStringFromRect(lineRect) ] )
		{
			//if( ! [marker isDragging] )
			//	[marker setMarkerLocation: lineRect.origin.y + (lineRect.size.height / 2)  ];		
			[[[self scrollView] backgroundColor] set];
			NSRectFillUsingOperation(lineRect, NSCompositeSourceOver);
			
			[marker drawRect:lineRect];
			
			exist = YES;
		}
		
		
	}
	
	if( exist == NO )
	{
		
		NSRulerMarker* aMarker = [self newMarker];
		[aMarker setMarkerLocation: lineRect.origin.y + (lineRect.size.height / 2)  ];
		
		[[[self scrollView] backgroundColor] set];
		NSRectFillUsingOperation(lineRect, NSCompositeSourceOver);
		[aMarker drawRect:lineRect];
		
		[aMarker setMovable:YES];
		[aMarker setRemovable:YES];
		[aMarker setRepresentedObject: NSStringFromRect(lineRect) ];
		[self addMarker:aMarker];
		
	}
}


#pragma mark -

- (void)mouseDown:(NSEvent *)theEvent
{
	return;
}

- (void)mouseUp:(NSEvent *)theEvent
{
	return;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	return;
}

@end
