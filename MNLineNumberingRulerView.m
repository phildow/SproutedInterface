

#import <SproutedInterface/MNLineNumberingRulerView.h>
#import <SproutedInterface/MNLineNumberingTextStorage.h>

// Ruler thickness value
#define RULER_THICKNESS					25

#define MarkerAttributeName NSToolTipAttributeName

// Margin of displaying bookmarked line in a context menu.
#define STRIP_PREVIEW_MARGIN			15

// Default
#define DEFAULT_OPTION					MNParagraphNumber | MNDrawBookmarks


const int MNNoLineNumbering = 0x00;
const int MNParagraphNumber = 0x03;
const int MNCharacterNumber = 0x02;
const int MNLineNumber		= 0x01;
const int MNDrawBookmarks	= 0x10;




@implementation MNLineNumberingRulerView

/*
- (id)initWithScrollView:(NSScrollView *)aScrollView orientation:(NSRulerOrientation)orientation
{
	
	if ( self = [super initWithScrollView:(NSScrollView *)aScrollView
							  orientation:(NSRulerOrientation)orientation])
	{

		//load nib
		[NSBundle loadNibNamed:@"MNLineNumbering"  owner:self];
		
		
		
		// Set default width
		[self setRuleThickness:RULER_THICKNESS];
		
		// Marker config
		[self setReservedThicknessForMarkers:0];
		[self setClientView:self]; // Markers ask me if I can add a marker.
		
		// Add a dummy marker to draw properly
		
		markerImage = [[NSImage alloc] initByReferencingFile:
			[[NSBundle bundleForClass:[self class]] pathForResource:@"marker" ofType:@"tiff"]];
		
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
		
		
		
		
	}
	
    return self;
}
*/

- (void)windowDidUpdate:(NSNotification *)notification
{
	[self display];
}

-(void)startSheet
{
	[[NSApplication sharedApplication] beginSheet:dialogueView
								   modalForWindow:[self window]
									modalDelegate:self
								   didEndSelector:NULL
									  contextInfo:NULL];
}

- (IBAction)jumpButtonClicked:(id)sender
{
	if( [sender tag] != 1 ) // jump & close or cancel
	{
		[dialogueView orderOut:self];
		[[NSApplication sharedApplication]  endSheet:dialogueView];
	}
	
	if( [sender tag] == -1 ) //cancel
		return;
	
	//check radio buttons
	int tag = [radioButtons selectedRow];
	
	int number = [textField intValue];
	
	if( tag == 0 ) //paragraph
		[self showParagraph:number];
	
	else if( tag == 1 )//line
		[self showLine:number];
	
	else if( tag == 2 )
		[self showCharacter:number -1 granularity:NSSelectByCharacter];
	
	[self display];
}

-(BOOL)showParagraph:(unsigned)paragraphNum
{
	//search paragraph number .... can be faster
	
	
	unsigned charIndex = 0;
	unsigned paragraph = 0;
	
	for( charIndex = 0; charIndex < [ [textView textStorage] length]; charIndex++ )
	{
		unichar	characterToCheck = [[[textView textStorage] string] characterAtIndex:charIndex];
		
		
		if (characterToCheck == '\n' || characterToCheck == '\r' ||
			characterToCheck == 0x2028 || characterToCheck == 0x2029)
			paragraph++;
		
		if( paragraph == paragraphNum )
			break;
	}
	
	
	
	return [self showCharacter:charIndex granularity:NSSelectByParagraph];
}



-(BOOL)showLine:(unsigned)lineNum
{
	
	unsigned targetCharIndex =  [self charIndexOfLineNumber:lineNum  ];
	
	return [self showCharacter:targetCharIndex granularity:-1];
}

-(unsigned)lineNumberAtIndex:(unsigned)charIndex
{
	unsigned index = 0;
	unsigned lineNumber = 1;
	NSRange lineRange;
	
	//convert charindex to glyphIndex
	
	unsigned glyphIndex = [layoutManager glyphRangeForCharacterRange:NSMakeRange(charIndex,1)
												actualCharacterRange:NULL].location;
	
	// Skip all lines that are visible at the top of the text view (if any)
	while ( index < glyphIndex )
	{
		++lineNumber;
		
		[layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
		index = NSMaxRange( lineRange );
	}
	
	return lineNumber;
}


-(unsigned)charIndexOfLineNumber:(unsigned)lineNumber
{
	unsigned indexLine = 0;
	unsigned charIndex = 0;
	NSRange lineRange;
	
	// Skip all lines that are visible at the top of the text view (if any)
	while ( indexLine < lineNumber )
	{
		++indexLine;
		
		[layoutManager lineFragmentRectForGlyphAtIndex:charIndex effectiveRange:&lineRange];
		charIndex = NSMaxRange( lineRange );
	}
	
	return charIndex -1;
}

-(BOOL)showCharacter:(unsigned)charIndex granularity:(NSSelectionGranularity)granularity
	// show line in document text view
	// Granularity is one of NSSelectByCharacter, NSSelectByWord, NSSelectByParagraph, or -1(select by line)
{
	NSRange		lineRange;
	
	
	// Return if text view is empty
	if([[textView textStorage] length]  < charIndex +1 ) return NO;
	
	
	// Show in textView
	if( granularity == -1 )
	{
		
		[layoutManager lineFragmentRectForGlyphAtIndex:
			[layoutManager glyphRangeForCharacterRange:NSMakeRange(charIndex,1)
								  actualCharacterRange:NULL].location effectiveRange:&lineRange];
		
		
		// Now lineRange is glyph range of the line
		// Convert lineRange(glyph range) --> lineRange(char range)	
		lineRange = [layoutManager characterRangeForGlyphRange: lineRange
											  actualGlyphRange:NULL];
		[textView setSelectedRange:lineRange];
	}
	else
	{
		[textView setSelectedRange:
			[textView selectionRangeForProposedRange:NSMakeRange(charIndex,1) granularity:granularity]];
		
	}
	
	[textView scrollRangeToVisible: [textView selectedRange]];
	return YES;
}


-(void)setVisible:(BOOL)flag
{
	if( flag == YES )
		[self setRuleThickness:RULER_THICKNESS];
	else
		[self setRuleThickness:0];
	
}
-(BOOL)isVisible
{
	if( [self ruleThickness] == 0 )
		return NO;
	else
		return YES;
	
}
-(void)setOption:(unsigned)option
{
	rulerOption = option;
	[self display];
}

- (void) dealloc
{
	//NSLog(@"view dealloc");
	[layoutManager setDelegate:NULL];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self ];
	
	
	textView = NULL;
	layoutManager = NULL;
	[markerImage release];
	
    [marginAttributes release];
	
    [super dealloc];
}

#pragma mark Drawing

-(void)drawRect:(NSRect)rect
{
	if( ! [[self window] isKeyWindow] ) return;
	
	[super drawRect:rect];
	
	
}

- (void)drawHashMarksAndLabelsInRect:(NSRect)aRect 
	//Draw numbers
{
	
	
	
	
	
	if( [self isVisible] )
	{
		
		// *** (1) draw background ***
		[self drawEmptyMargin  ];
		
		// *** (2) draw numbers ***
		[self drawNumbersInMargin ];
		
		
	}		
	
}





-(void)drawEmptyMargin
{
	
	
	NSRect aRect = NSMakeRect(0,0,[self ruleThickness],[self frame].size.height);
	/*
     These values control the color of our margin. Giving the rect the 'clear' 
     background color is accomplished using the windowBackgroundColor.  Change 
     the color here to anything you like to alter margin contents.
	 */
	
	aRect.origin.x += 1;
    [[NSColor controlHighlightColor] set];
    [NSBezierPath fillRect: aRect]; 
    
	
	// These points should be set to the left margin width.
    NSPoint top = NSMakePoint([self frame].size.width, aRect.origin.y + aRect.size.height);
    NSPoint bottom = NSMakePoint([self frame].size.width, aRect.origin.y);
	
	
	// This draws the dark line separating the margin from the text area.
    [[NSColor darkGrayColor] set];
    [NSBezierPath setDefaultLineWidth:1.0];
    [NSBezierPath strokeLineFromPoint:top toPoint:bottom];
	
	
}



-(void) drawParagraphNumbersInMargin:(unsigned)startParagraph start:(unsigned)start_index end:(unsigned)end_index
{
	
	
	unsigned index;
	for ( index = start_index; index < end_index;  )
	{
		NSRange paragraphRange = 
		[textView selectionRangeForProposedRange:NSMakeRange(index, 1) granularity:NSSelectByParagraph];
		
		
		
		unsigned glyphIndex = [layoutManager glyphRangeForCharacterRange:NSMakeRange(paragraphRange.location,1)
													actualCharacterRange:NULL].location;
		
		NSRect drawingRect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange: NULL];
		
		
		
		[self drawOneNumberInMargin:startParagraph inRect:drawingRect];
		
		index  = NSMaxRange( [layoutManager glyphRangeForCharacterRange:paragraphRange
												   actualCharacterRange:NULL] );
		
		startParagraph++;
		
	}
	
	
	
}


-(void) drawNumbersInMargin
{
	//NSLog(@"drawNumbersInMargin");
	
	UInt32		index, lineNumber;
	NSRange		lineRange;
	NSRect		lineRect;
	
	NSTextContainer* textContainer = [[layoutManager firstTextView] textContainer];
	
	// Only get the visible part of the scroller view
	NSRect documentVisibleRect = [[[layoutManager firstTextView] enclosingScrollView] documentVisibleRect];
	
	// Find the glyph range for the visible glyphs
	NSRange glyphRange = [layoutManager glyphRangeForBoundingRect: documentVisibleRect inTextContainer: textContainer];
	
	
	// Calculate the start and end indexes for the glyphs	
	unsigned start_index = glyphRange.location;
	unsigned end_index = glyphRange.location + glyphRange.length;
	
	//
	NSRange charRange = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
	// Calculate the start and end char indexes	
	unsigned start_charIndex =	charRange.location;
	unsigned end_charIndex =	charRange.location + charRange.length;
	
	
	index = 0;
	lineNumber = 1;
	
	unsigned start_paragraphNumber;
	start_paragraphNumber = [(MNLineNumberingTextStorage*)[textView textStorage] paragraphNumberAtIndex:start_charIndex];
	
	// Skip all lines that are visible at the top of the text view (if any)
	while (index < start_index)
	{
		lineRect = [layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
		index = NSMaxRange( lineRange );
		++lineNumber;
	}
	
	for ( index = start_index; index < end_index; lineNumber++ )
	{
		lineRect = [layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
		
		
		if ( ( rulerOption & 0x0F ) == MNParagraphNumber )
        {
			
			
			
        }
		else if(  ( rulerOption & 0x0F ) ==  MNLineNumber )
		{
			[self drawOneNumberInMargin:lineNumber inRect:lineRect];
			
			
		}
        else if (  ( rulerOption & 0x0F ) ==  MNCharacterNumber )   // draw character numbers
        {
            [self drawOneNumberInMargin:index +1 inRect:lineRect];
        }
		
		
		index = NSMaxRange( lineRange );
		
		
		
    }
	
	///paragraph
	
	if (  ( rulerOption & 0x0F ) ==  MNParagraphNumber )
	{
		[self drawParagraphNumbersInMargin:start_paragraphNumber start:(unsigned)start_charIndex end:(unsigned)end_charIndex ];
	}
}


-(void)drawOneNumberInMargin:(unsigned) aNumber inRect:(NSRect)r 
{
	
	
	//draw a number
	r = [textView convertRect:r toView:self]; //Convert coordinates
	
    NSString    *s;
    NSSize      stringSize;
    
    s = [NSString stringWithFormat:@"%d", aNumber, nil];
	if( aNumber == 0 )
		s = @"-";
    stringSize = [s sizeWithAttributes:marginAttributes];
	
	// Simple algorithm to center the line number next to the glyph.
    [s drawAtPoint: NSMakePoint( [self ruleThickness] - stringSize.width, 
								 r.origin.y + ((r.size.height / 2) - (stringSize.height / 2))) 
	withAttributes:marginAttributes];
	
	
}


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
	
	
	
	
	for( hoge  = charRange.location; hoge < NSMaxRange(charRange) ; hoge ++ )
	{
		
		if ( [(MNLineNumberingTextStorage*)[textView textStorage] hasBookmarkAtIndex:hoge inTextView:textView]  )
		{
			
			NSRange paragraphRange = 
			[textView selectionRangeForProposedRange:NSMakeRange(hoge, 1) granularity:NSSelectByParagraph];
			
			
			
			unsigned glyphIndex = [layoutManager glyphRangeForCharacterRange:NSMakeRange(paragraphRange.location,1)
														actualCharacterRange:NULL].location;
			
			NSRect drawingRect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange: NULL];
			drawingRect.size.height = [markerImage size].height;
			
			[self drawMarkerInRect:drawingRect ];
			
			
			
		}
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
			[marker drawRect:lineRect];
			
			exist = YES;
		}
		
		
	}
	
	if( exist == NO )
	{
		
		NSRulerMarker* aMarker = [self newMarker];
		[aMarker setMarkerLocation: lineRect.origin.y + (lineRect.size.height / 2)  ];
		[aMarker drawRect:lineRect];
		[aMarker setMovable:YES];
		[aMarker setRemovable:YES];
		[aMarker setRepresentedObject: NSStringFromRect(lineRect) ];
		[self addMarker:aMarker];
		
	}
}



///////////

-(unsigned)characterIndexAtLocation:(float)pos
{
	
	//convert
	float viewPos = [textView convertPoint:NSMakePoint(0,pos) fromView:[[self window] contentView]].y;
	
	NSRect sweepRect = NSMakeRect( 0,viewPos,100,viewPos+1);
	
	NSRange glyphRange = [layoutManager glyphRangeForBoundingRect:sweepRect inTextContainer:[textView textContainer] ];
	NSRange charRange = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
	
	//NSLog(@"characterIndexAtLocation = %d",charRange.location);
	return charRange.location;
}



#pragma mark Adding, moving, and removing markers


-(NSRulerMarker*)newMarker
{
	
	NSRulerMarker* aMarker = [[NSRulerMarker alloc] initWithRulerView:self 
													   markerLocation:-10 //invisible at first
																image:markerImage
														  imageOrigin:NSMakePoint(0,8)];
	[aMarker autorelease];
	return aMarker;	
}


- (void)mouseDown:(NSEvent *)theEvent
{
	//NSLog(@"mouseDown");
	
	// add a new marker
	if( (rulerOption & 0x10) != MNDrawBookmarks )	return;
	
	//retrieve mouse location
	markerDeleteReservationFlag = NO;
	NSPoint mousePosition = [theEvent locationInWindow];
	
	//adding or removing a marker
	unsigned clickedIndex;
	clickedIndex = [self characterIndexAtLocation:mousePosition.y];
	
	
	if( [(MNLineNumberingTextStorage*)[textView textStorage] hasBookmarkAtIndex:clickedIndex inTextView:textView]== NO) // adding a new marker
	{
		[(MNLineNumberingTextStorage*)[textView textStorage] setBookmarkAtIndex:clickedIndex flag:YES inTextView:textView];
		
		
	}else
		markerDeleteReservationFlag = YES;
	// if clicked on an existing marker, turn flag on
	// This flag is used in mouseUp to delete existing marker
	
}





-(void)mouseUp:(NSEvent *)theEvent
	// deleting a marker
{
	
	//NSLog(@"mouseUp");
	
	if(markerDeleteReservationFlag == YES)
	{
		//delete
		NSPoint mousePosition = [theEvent locationInWindow];
		
		unsigned clickedIndex;
		clickedIndex = [self characterIndexAtLocation:mousePosition.y];
		
		[(MNLineNumberingTextStorage*)[textView textStorage] setBookmarkAtIndex:clickedIndex flag:NO inTextView:textView];
	}
	
	//[self display];
	markerDeleteReservationFlag = NO;
	
}


- (void)mouseDragged:(NSEvent *)theEvent
	// dragging marker
{
	//NSLog(@"mouseDragged");
	
	
	
	if( (rulerOption & 0x10) != MNDrawBookmarks )	return;
	
	NSPoint mousePosition = [theEvent locationInWindow];
	
	unsigned clickedIndex;
	clickedIndex = [self characterIndexAtLocation:mousePosition.y];
	
	if( [(MNLineNumberingTextStorage*)[textView textStorage] hasBookmarkAtIndex:clickedIndex inTextView:textView]== YES)  //start moving
	{
		
		NSArray* markerObjects = [self markers];
		unsigned hoge;
		for(hoge = 0; hoge < [markerObjects count]; hoge++)
		{
			//get represented object
			id ii = [[markerObjects objectAtIndex:hoge] representedObject];
			NSRect identifyingRect = NSRectFromString( ii );
			
			float yy = [self convertPoint:mousePosition fromView:[[self window] contentView]].y;
			
			if( identifyingRect.origin.y <= yy && yy <= NSMaxY(identifyingRect) ) break;
			
			
		}
		//NSLog(@"%d, %d", [markerObjects count], hoge);
		[ [markerObjects objectAtIndex:hoge] trackMouse:theEvent adding:NO];	
		
	}
	markerDeleteReservationFlag = NO;	// turn delete flag off
}

#pragma mark Defining marker behaviour

// These are answers to the ruler marker which is asking the client (this ruler view) 
// for approvals.

// ADD
- (BOOL)rulerView:(NSRulerView *)aRulerView shouldAddMarker:(NSRulerMarker *)aMarker
{
	//display update
	
	return YES;
}

/*
 - (float)rulerView:(NSRulerView *)aRulerView willAddMarker:(NSRulerMarker *)aMarker atLocation:(float)location
 {
	 
	 
 }*/

- (void)rulerView:(NSRulerView *)aRulerView didAddMarker:(NSRulerMarker *)aMarker
{
	
	// add dictionary
	NSPoint mousePosition = [[self window] mouseLocationOutsideOfEventStream];
	
	
	unsigned clickedIndex;
	clickedIndex = [self characterIndexAtLocation:mousePosition.y];
	
	[(MNLineNumberingTextStorage*)[textView textStorage] setBookmarkAtIndex:clickedIndex flag:YES inTextView:textView];
	
	
	
	//[self display];
	//NSLog(@"** ADD **");
}

//MOVE
- (BOOL)rulerView:(NSRulerView *)aRulerView shouldMoveMarker:(NSRulerMarker *)aMarker
{
	//display update
	
	NSPoint mousePosition = [[self window] mouseLocationOutsideOfEventStream];
	
	
	unsigned clickedIndex;
	clickedIndex = [self characterIndexAtLocation:mousePosition.y];
	
	[(MNLineNumberingTextStorage*)[textView textStorage] setBookmarkAtIndex:clickedIndex flag:NO inTextView:textView];
	
	
	
	return YES;
}

/*
 - (float)rulerView:(NSRulerView *)aRulerView willMoveMarker:(NSRulerMarker *)aMarker toLocation:(float)location
 {	
	 
	 
 }*/

- (void)rulerView:(NSRulerView *)aRulerView didMoveMarker:(NSRulerMarker *)aMarker
{		
	// add dictionary
	NSPoint mousePosition = [[self window] mouseLocationOutsideOfEventStream];
	
	
	unsigned clickedIndex;
	clickedIndex = [self characterIndexAtLocation:mousePosition.y];
	
	[(MNLineNumberingTextStorage*)[textView textStorage] setBookmarkAtIndex:clickedIndex flag:YES inTextView:textView];
	
	
	
	
	//[self display];	//NSLog(@"** BOOKMARK MOVED **");
	
	
}

//REMOVE
- (BOOL)rulerView:(NSRulerView *)aRulerView shouldRemoveMarker:(NSRulerMarker *)aMarker
{
	return YES;
}

- (void)rulerView:(NSRulerView *)aRulerView didRemoveMarker:(NSRulerMarker *)aMarker
{
	//Do nothing here because the marker was already removed when the moving started.
	
	//NSLog(@"** BOOKMARK REMOVED 2**");
	
	
}


#pragma mark Context Menu

-(void)menu_selected	{}	// dummy method.
-(void)menu_selected_main:(NSNotification *)notification
	// this is called when contextual menu is selected
{
	
	NSMenuItem* aMenuItem = [[notification userInfo] objectForKey:@"MenuItem"];
	int tag = [aMenuItem tag];
	if( tag == -2 ) // clear bookmarks
	{
		
		[[textView textStorage] removeAttribute:MarkerAttributeName range:NSMakeRange(0,[[textView textStorage] length]) ];
		
		[self display]; 
		
		
	}else if( tag >= 0 )
	{
		
		
		[self showCharacter:tag granularity:-1];
		
		
	}else if( tag == -10 )
	{
		[self setOption:(rulerOption & 0x10) | MNNoLineNumbering];
	}
	else if( tag == -11 )
	{
		[self setOption:(rulerOption & 0x10) | MNLineNumber];
	}
	else if( tag == -12 )
	{
		[self setOption:(rulerOption & 0x10) | MNCharacterNumber];
	}
	else if( tag == -13 )
	{
		[self setOption:(rulerOption & 0x10) | MNParagraphNumber];
	}	
	else if( tag == -14 )
	{
		if( (rulerOption & 0x10) == MNDrawBookmarks )
			[self setOption:(rulerOption & 0x0F) ];
		else 
			[self setOption:(rulerOption & 0x0F) | MNDrawBookmarks ];
	}
	else if( tag == -15 )
	{
		[self setVisible:![self isVisible]];
	}
	else if( tag == -7 )
	{
		[self startSheet];
	}
	
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	NSMenuItem* aMenuItem;
	NSMenu* menu = [[NSMenu alloc] init];
	
	
	//create bookmark array
	NSMutableArray* bookmarks = [[[NSMutableArray alloc] init] autorelease];
	
	unsigned hoge;
	//NSRange __range;
	for( hoge = 0; hoge < [[textView textStorage] length] ;hoge++  )
	{
		
		unichar	characterToCheck = [[[textView textStorage] string] characterAtIndex:hoge];
		
		
		if (characterToCheck == '\n' || characterToCheck == '\r' ||
			characterToCheck == 0x2028 || characterToCheck == 0x2029)
		{
			id marker = [[textView textStorage] attribute:MarkerAttributeName atIndex:hoge 
									longestEffectiveRange:NULL inRange:NSMakeRange(0,[[textView textStorage] length])];
			
			if( marker != NULL )
			{
				if( [marker boolValue] )
				{
					NSRange paragraphRange = 
					[textView selectionRangeForProposedRange:NSMakeRange(hoge, 1) granularity:NSSelectByParagraph];
					
					[bookmarks addObject:NSStringFromRange(paragraphRange)];
				}
				
			}
			
		}
	}
	
	
	
	
	//set up menu
	
	if( (rulerOption & 0x10) == MNDrawBookmarks )
	{
		if([bookmarks count] == 0)
		{
			aMenuItem = [[NSMenuItem alloc] initWithTitle:@"No Bookmarks"																   action:@selector(dummy)
											keyEquivalent:@""];
			[aMenuItem setEnabled:NO];
			[menu addItem:[aMenuItem autorelease]];
		}else
		{
			// Add each bookmark
			unsigned hoge;
			for(hoge = 0; hoge < [bookmarks count]; hoge++)
			{
				unsigned charIndex = NSRangeFromString( [bookmarks objectAtIndex:hoge] ).location;
				NSMenuItem* aMenuItem = [[NSMenuItem alloc] initWithTitle:@""
																   action:@selector(menu_selected)
															keyEquivalent:@""];
				
				unsigned glyphIndex = [[textView layoutManager] glyphRangeForCharacterRange:NSMakeRange(charIndex,1) actualCharacterRange:NULL].location;
				//prepare bookmark preview stip
				
				//set target rect
				NSRect aRect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange:NULL];
				
				aRect.origin.y -= STRIP_PREVIEW_MARGIN;
				aRect.size.height += STRIP_PREVIEW_MARGIN * 2;
				if( aRect.size.width > 500 ) aRect.size.width = 500;
				
				// strip preview
				NSImage* stripImage = [[NSImage alloc] initWithSize:aRect.size];
				[stripImage  setFlipped:YES];
				[stripImage lockFocus];
				
				NSRect clipViewRect = [[[textView enclosingScrollView] contentView] bounds];
				
				
				NSPoint originalOrigin = [textView bounds].origin;
				NSRect originalFrame = [textView frame];
				
				
				[textView setBoundsOrigin:NSMakePoint(0,  -aRect.origin.y )];
				[textView setFrame:NSMakeRect(0,  -aRect.origin.y  ,originalFrame.size.width, originalFrame.size.height)];
				[textView drawRect:NSMakeRect(0,0,aRect.size.width,aRect.size.height)];
				
				
				[textView setBoundsOrigin:originalOrigin];
				[textView setFrame:originalFrame];
				[[[textView enclosingScrollView] contentView] setBounds:clipViewRect];
				
				
				[[NSColor darkGrayColor] set];
				[NSBezierPath setDefaultLineWidth:2.0];
				[NSBezierPath strokeRect: NSMakeRect(0,0,aRect.size.width, aRect.size.height)]; 
				
				[stripImage unlockFocus];
				
				
				
				[aMenuItem setImage:[stripImage autorelease]];
				
				[aMenuItem setTag:charIndex]; // Tag as character index
				[aMenuItem setTarget:self];
				[aMenuItem setToolTip:[NSString stringWithFormat:@"Char:%d Line:%d Paragraph:%d",
					charIndex +1, [self lineNumberAtIndex:charIndex],[(MNLineNumberingTextStorage*)[textView textStorage] paragraphNumberAtIndex:charIndex]]];
				[menu addItem:[aMenuItem autorelease]];
			}
		}
		
		////////
		[menu addItem:[NSMenuItem separatorItem]];
		
		
		////////
		aMenuItem = [[NSMenuItem alloc] initWithTitle:@"Clear Bookmarks"																   action:@selector(menu_selected)
										keyEquivalent:@""];
		[aMenuItem setTag:-2];
		[aMenuItem setTarget:self];
		[menu addItem:[aMenuItem autorelease]];
	}
	
	//Add other items
	
	
	////////
	NSMenu* submenu = [[NSMenu alloc] init];
	aMenuItem = [[NSMenuItem alloc] initWithTitle:@"No Line Numbering"																   action:@selector(menu_selected)
									keyEquivalent:@""];
	[aMenuItem setTag:-10];
	[aMenuItem setTarget:self];
	[aMenuItem setState:( (rulerOption & 0x0F) == MNNoLineNumbering ? NSOnState : NSOffState)];
	[submenu addItem:[aMenuItem autorelease]];
	
	
	////////
	aMenuItem = [[NSMenuItem alloc] initWithTitle:@"Line Number"																   action:@selector(menu_selected)
									keyEquivalent:@""];
	[aMenuItem setTag:-11];
	[aMenuItem setTarget:self];
	[aMenuItem setState:( (rulerOption & 0x0F) == MNLineNumber ? NSOnState : NSOffState)];
	[submenu addItem:[aMenuItem autorelease]];
	
	
	////////
	aMenuItem = [[NSMenuItem alloc] initWithTitle:@"Character Number"																   action:@selector(menu_selected)
									keyEquivalent:@""];
	[aMenuItem setTag:-12];
	[aMenuItem setTarget:self];
	[aMenuItem setState:( (rulerOption & 0x0F) == MNCharacterNumber ? NSOnState : NSOffState)];
	[submenu addItem:[aMenuItem autorelease]];
	
	
	////////
	aMenuItem = [[NSMenuItem alloc] initWithTitle:@"Paragraph Number"																   action:@selector(menu_selected)
									keyEquivalent:@""];
	[aMenuItem setTag:-13];
	[aMenuItem setTarget:self];
	[aMenuItem setState:( (rulerOption & 0x0F) == MNParagraphNumber ? NSOnState : NSOffState)];
	[submenu addItem:[aMenuItem autorelease]];
	
	////////
	aMenuItem = [[NSMenuItem alloc] initWithTitle:@"Show Bookmarks"																   action:@selector(menu_selected)
									keyEquivalent:@""];
	[aMenuItem setTag:-14];
	[aMenuItem setTarget:self];
	[aMenuItem setState:( (rulerOption & 0x10) == MNDrawBookmarks ? NSOnState : NSOffState)];
	[submenu addItem:[aMenuItem autorelease]];
	
	
	////////
	aMenuItem = [[NSMenuItem alloc] initWithTitle:@"Hide Ruler"																   action:@selector(menu_selected)
									keyEquivalent:@""];
	[aMenuItem setTag:-15];
	[aMenuItem setTarget:self];
	[aMenuItem setState:( ![self isVisible] ? NSOnState : NSOffState)];
	[submenu addItem:[aMenuItem autorelease]];
	
	
	////////
	aMenuItem = [[NSMenuItem alloc] initWithTitle:@"View as"																   action:@selector(menu_selected)
									keyEquivalent:@""];
	[aMenuItem setTag:-6];
	[aMenuItem setTarget:self];
	[menu addItem:[aMenuItem autorelease]];
	[menu setSubmenu:[submenu autorelease] forItem:aMenuItem];
	
	
	////////
	aMenuItem = [[NSMenuItem alloc] initWithTitle:@"Jump to..."																   action:@selector(menu_selected)
									keyEquivalent:@""];
	[aMenuItem setTag:-7];
	[aMenuItem setTarget:self];
	[menu addItem:[aMenuItem autorelease]];
	
	
	////////
	//OBSERVE CONTEXT MENU
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menu_selected_main:)
												 name:NSMenuDidSendActionNotification object:menu];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menu_selected_main:)
												 name:NSMenuDidSendActionNotification object:submenu];
	
	return [menu autorelease];
	
}


@end
