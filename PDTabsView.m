
//
//  PDTabsView.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDTabsView.h>
#import <SproutedInterface/PDToolbar.h>

#import <SproutedUtilities/PDUtilityDefinitions.h>

#import <SproutedUtilities/NSBezierPath_AMAdditons.h>
#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSColor_JournlerAdditions.h>

#define kMaxTabWidth	180
#define kMinTabWidth	84
#define kTabOffset		12
#define kTabHeight		21
#define kLabelOffset	3
#define kCloseOffset	4

//static NSString *kABPeopleUIDsPboardType = @"ABPeopleUIDsPboardType";
//static NSString *kMailMessagePboardType = @"MV Super-secret message transfer pasteboard type";

static NSDictionary* TitleAttributes()
{
	static NSDictionary *textAttributes = nil;
	if ( textAttributes == nil )
	{
		NSMutableParagraphStyle *paragraphStyle;
		
		paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
		[paragraphStyle setAlignment:NSLeftTextAlignment];
		[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
		
		textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
				[NSFont boldSystemFontOfSize:11], NSFontAttributeName,
				[NSColor colorWithCalibratedWhite:0.55 alpha:1.0], NSForegroundColorAttributeName,
				paragraphStyle, NSParagraphStyleAttributeName, nil];
	}
	return textAttributes;
}

@implementation PDTabsView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		// Add initialization code here
		
		NSMutableParagraphStyle *tempStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopyWithZone:[self zone]];
		[tempStyle setLineBreakMode:NSLineBreakByTruncatingTail];
		
		tabCloseFront = [BundledImageWithName(@"tabclosefront.tif", @"com.sprouted.interface") retain];
		tabCloseBack = [BundledImageWithName(@"tabcloseback.tif", @"com.sprouted.interface") retain];
		
		tabCloseFrontDown = [BundledImageWithName(@"tabclosefrontdown.tif", @"com.sprouted.interface") retain];
		tabCloseBackDown = [BundledImageWithName(@"tabclosebackdown.tif", @"com.sprouted.interface") retain];
		
		backRollover = [BundledImageWithName(@"tabclosebackroll.tif", @"com.sprouted.interface") retain];
		frontRollover = [BundledImageWithName(@"tabclosefrontroll.tif", @"com.sprouted.interface") retain];
		
		// build a popup button that indicates more
		NSImage *moreImage = BundledImageWithName(@"more.tif", @"com.sprouted.interface");
		popTitle = [[NSMenuItem alloc] initWithTitle:@"" 
				action:nil 
				keyEquivalent:@""];
		
		[popTitle setImage:moreImage];
		
		morePop = [[NSPopUpButton alloc] initWithFrame:NSMakeRect( frameRect.size.width - 28, 6, 28, 10 ) pullsDown:YES];
		
		[morePop setBordered:NO];
		[morePop setTarget:self];
		[morePop setAction:@selector(selectTabByPop:)];
		[morePop setAutoresizingMask:NSViewMinXMargin];
		[morePop setHidden:YES];
		[[morePop menu] addItem:popTitle];
		[[morePop cell] setArrowPosition:NSPopUpNoArrow];
		
		[self addSubview:morePop];
		
		_flashingTab = -1;
		closeDown = -1;
		_targetTabForContext = -1;
		_tabToSelect = -1;
		
		hoverIndex = -1;
		selectingIndex = -1;
		closeHoverIndex = -1;
		
		borders[0] = 0; borders[1] = 0; borders[2] = 0; borders[3] = 0;
		
		drawsShadow = YES;
		_amSwitching = NO;
		_lastViewLoc = NSZeroPoint;
		_lastStillMoment = [[NSDate date] retain];
		
		titleTrackingRects = [[NSMutableArray alloc] init];
		closeButtonTrackingRects = [[NSMutableArray alloc] init];

		[self setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin];
		
		//totalImage = [[NSImage alloc] initWithSize:frameRect.size];
		
		//backgroundColor = [[NSColor windowBackgroundColor] retain];
		backgroundColor = [[NSColor colorWithCalibratedWhite:230.0/255.0 alpha:1.0] retain];
		
		// build the contextual menu
		contextMenu = [[NSMenu alloc] initWithTitle:@"Context"];
	
		NSMenuItem *newTabItem = [[[NSMenuItem alloc] 
			initWithTitle:NSLocalizedStringFromTableInBundle(
					@"new tab", 
					@"PDTabsView", 
					[NSBundle bundleWithIdentifier:@"com.sprouted.interface"], 
					@"")
			action:@selector(newTab:) 
			keyEquivalent:@""] autorelease];
				
		NSMenuItem *closeTabItem = [[[NSMenuItem alloc] 
				initWithTitle:NSLocalizedStringFromTableInBundle(
						@"close tab", 
						@"PDTabsView", 
						[NSBundle bundleWithIdentifier:@"com.sprouted.interface"], 
						@"") 
				action:@selector(closeTargetedTab:) 
				keyEquivalent:@""] autorelease];
				
		NSMenuItem *closeOtherTabsItem = [[[NSMenuItem alloc] 
				initWithTitle:NSLocalizedStringFromTableInBundle(
						@"close other tabs", 
						@"PDTabsView", 
						[NSBundle bundleWithIdentifier:@"com.sprouted.interface"], 
						@"")
				action:@selector(closeOtherTabs:) 
				keyEquivalent:@""] autorelease];
		
		[newTabItem setTarget:self];
		[closeTabItem setTarget:self];
		[closeOtherTabsItem setTarget:self];
		
		[contextMenu addItem:newTabItem];
		[contextMenu addItem:closeTabItem];
		[contextMenu addItem:[NSMenuItem separatorItem]];
		[contextMenu addItem:closeOtherTabsItem];
		
		[self setMenu:contextMenu];

		// a default _tabFromTop of no means the tabs will draw from the bottom without programmatic change
		_tabFromTop = YES;
		
		[self handleRegisterDragTypes];
		
		[self setPostsBoundsChangedNotifications:YES];
		[self setPostsFrameChangedNotifications:YES];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
				selector:@selector(_updateTrackingRects:) 
				name:NSViewBoundsDidChangeNotification 
				object:self];
				
		[[NSNotificationCenter defaultCenter] addObserver:self 
				selector:@selector(_updateTrackingRects:) 
				name:NSViewFrameDidChangeNotification 
				object:self];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(_toolbarDidChangeVisible:) 
				name:PDToolbarDidHideNotification 
				object:nil];
				
		[[NSNotificationCenter defaultCenter] addObserver:self 
				selector:@selector(_toolbarDidChangeVisible:) 
				name:PDToolbarDidShowNotification 
				object:nil];
		
		// clean up
		[tempStyle release];
	}
	return self;
}

- (void) dealloc 
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s", [self className], _cmd);
	#endif

	[backgroundColor release];
	[_lastStillMoment release];
	
	[morePop release];
	[popTitle release];
	
	[tabCloseFront release];
	[tabCloseBack release];
		
	[tabCloseFrontDown release];
	[tabCloseBackDown release];
	
	[backRollover release];
	[frontRollover release];
	
	//[totalImage release];
	
	[contextMenu release];
	[titleTrackingRects release];
	[closeButtonTrackingRects release];
	
	[self handleDeregisterDragTypes];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

#pragma mark -

- (id) delegate 
{ 
	return delegate; 
}

- (void) setDelegate:(id)anObject 
{
	delegate = anObject;
}

- (id) dataSource 
{
	return dataSource;
}

- (void) setDataSource:(id)anObject 
{
	dataSource = anObject;
}

- (int) selectedTab 
{ 
	return [[self dataSource] selectedTabIndexInTabView:self];
}

#pragma mark -

- (int*) borders
{
	return borders;
}

- (void) setBorders:(int*)theBorders
{
	borders[0] = theBorders[0];
	borders[1] = theBorders[1];
	borders[2] = theBorders[2];
	borders[3] = theBorders[3];
}

- (BOOL) tabFromTop 
{ 
	return _tabFromTop; 
}

- (void) setTabFromTop:(BOOL)direction 
{
	_tabFromTop = direction;
}

- (BOOL) drawsShadow
{
	return drawsShadow;
}

- (void) setDrawsShadow:(BOOL)shadow
{
	drawsShadow = shadow;
}

- (int) availableWidth 
{ 
	return availableWidth; 
}

- (void) setAvailableWidth:(int)tabWidth 
{
	availableWidth = tabWidth;
}

- (NSColor*) backgroundColor 
{ 
	return backgroundColor; 
}

- (void) setBackgroundColor:(NSColor*)color 
{
	if ( backgroundColor != color ) 
	{
		[backgroundColor release];
		backgroundColor = [color copyWithZone:[self zone]];
	}
}

#pragma mark -
#pragma mark Dragging & Autotabselecting

- (void) handleRegisterDragTypes 
{
	// how can I just register for everything under the sun?
	[self registerForDraggedTypes:[NSArray arrayWithObjects:
			kABPeopleUIDsPboardType, kMailMessagePboardType, NSFilenamesPboardType, kWebURLsWithTitlesPboardType, NSURLPboardType,
			NSRTFDPboardType, NSRTFPboardType, NSStringPboardType, NSTIFFPboardType, NSPICTPboardType, nil]];
			/* PDFolderIDPboardType, PDEntryIDPboardType, PDResourceIDPboardType, nil]]; */
}

- (void) handleDeregisterDragTypes 
{
	[self unregisterDraggedTypes];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	return NO;
}

- (unsigned int)dragOperationForDraggingInfo:(id <NSDraggingInfo>)dragInfo type:(NSString *)type {
	return NSDragOperationGeneric;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	if ( [self isHidden] )
		return NSDragOperationNone;
		
	return NSDragOperationGeneric;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    //we aren't particularily interested in this so we will do nothing
    //this is one of the methods that we do not have to implement
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
	
	//
	// - record the last point, set a time, invalidate the timer if it's already going
	//
	
	NSPoint mouseLoc = [sender draggingLocation];
	NSPoint viewLoc = [self convertPoint:mouseLoc fromView:nil];
	
	int i;
	int overTab = 0;
	
	// calculate positional variables
	int myX = viewLoc.x - kTabOffset;	// 12 (kTabOffset) takes into account our self imposed left offset
	//int myY = viewLoc.y;
	
	// calculate the tab visisble count
	int tabsAvailable = ([self bounds].size.width - kTabOffset*2) / [self availableWidth];
	//int actualTabs = [[self displayText] count];
	int actualTabs = [dataSource numberOfTabsInTabView:self];
	int limit = ( tabsAvailable <= actualTabs ? tabsAvailable : actualTabs );
	
	// do nothing if there is nothing to display
	//if ( [self availableWidth] == 0 || [displayText count] == 1 )
	if ( [self availableWidth] == 0 || actualTabs == 1 )
		return NSDragOperationNone;
	
	// otherwise find out which tab the mouse is over
	for ( i = 0; i < limit; i++ ) {
		if ( myX > i * [self availableWidth] && myX < (i+1) * [self availableWidth] ) {
			overTab = i;
			break;
		}
	}

	// if the viewLoc is within the selected tab, do nothing
	if ( overTab == [self selectedTab] || _amSwitching)
		return NSDragOperationNone;
	
	// check the current viewLoc against the last viewLoc
	if ( viewLoc.x == _lastViewLoc.x && viewLoc.y == _lastViewLoc.y ) {
		
		// how long has it been?
		if ( [[NSDate date] timeIntervalSinceDate:_lastStillMoment] >= 0.5 ) {
			
			// if over 1 second, flash and select this tab
			_amSwitching = YES;
			_tabToSelect = overTab;
			[self flashTab:overTab];
			
			return NSDragOperationNone;
			
		}
		else {
			
			return NSDragOperationGeneric;
			
		}
		
	}
	else {
		
		// reset the last view loc
		_lastViewLoc.x = viewLoc.x;
		_lastViewLoc.y = viewLoc.y;
		
		[_lastStillMoment release];
			_lastStillMoment = [[NSDate date] retain];
		
		return NSDragOperationGeneric;
		
	}
	
	return NSDragOperationGeneric;
	
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
	return ( ![self isHidden] );
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
   
}

- (BOOL)ignoreModifierKeysWhileDragging 
{
	return YES;
}

#pragma mark -

- (IBAction) newTab:(id)sender
{
	if ( [[self delegate] respondsToSelector:@selector(newTab:)] )
		[[self delegate] performSelector:@selector(newTab:) withObject:self];
	else
		NSBeep();
}

- (void) closeTab:(int)tab 
{
	NSRect invalidatedRect = [self frameOfTabAtIndex:tab];
	invalidatedRect.size.width = [self bounds].size.width - invalidatedRect.origin.x;
	
	// let the interested folks know what's up
	if ( delegate != nil && [delegate respondsToSelector:@selector(tabsView:removedTabAtIndex:)] )
		[delegate tabsView:self removedTabAtIndex:tab];

	hoverIndex = -1;
	closeHoverIndex = -1;
	
	[self setNeedsDisplayInRect:invalidatedRect];
}

- (void) selectTab:(int)newSelection 
{
	if ( [delegate respondsToSelector:@selector(selectedTabIndexInTabView:)] )
	{
		NSRect previousRect = [self frameOfTabAtIndex:[[self delegate] selectedTabIndexInTabView:self]];
		[self setNeedsDisplayInRect:previousRect];
	}
	
	NSRect invalidatedRect = [self frameOfTabAtIndex:newSelection];
	
	// let the interested folks know what's up
	if ( delegate != nil && [delegate respondsToSelector:@selector(tabsView:selectedTabAtIndex:)] )
		[delegate tabsView:self selectedTabAtIndex:newSelection];
	
	// invalidate these guys just for good measure
	closeHoverIndex = -1;
	[self setNeedsDisplayInRect:invalidatedRect];
}

#pragma mark -

- (void) flashTab:(int)tab 
{
	//
	// uses a timer to flash a tab, thus drawing attention to it
	// make sure there is any point to doing this
	
	// if the tab being flashed is the tab currently selected, beep
	if ( tab == [self selectedTab] ) 
	{
		NSBeep();
		return;
	}
	
	_flashing = NO;
	_malFlash = 0;
	_flashingTab = tab;
	
	// fire off the timer
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(flash:) userInfo:nil repeats:YES];
}

- (void) flash:(NSTimer*)timer 
{
	
	// invert the flash
	_flashing = !_flashing;
	
	// invalidate the timer if this is the last time through
	if ( _malFlash == 4 ) 
	{
		_flashing = NO;
		_flashingTab = -1;
		
		if ( _tabToSelect != -1 )
			[self selectTab:_tabToSelect];
		
		_amSwitching = NO;
		
		[timer invalidate];
		return;
	}
	else 
	{
		_malFlash++;
	}
	
	[self setNeedsDisplayInRect:[self frameOfTabAtIndex:_tabToSelect]];
}


#pragma mark -
#pragma mark Perform the drawing

- (void)drawRect:(NSRect)rect
{
	
	//
	// responsible for producing the the appearance of a tabbed display
	// - check the available width
	// - correctly position the text and close buttons
	// - properly render the selected tab
	//
	
	int i;
	int tabsAvailable;
	int availableCellWidth;
	
	NSRect bds = [self bounds];
	
	int tabCount = [dataSource numberOfTabsInTabView:self];
	if ( tabCount != 0 ) 
	{
		availableCellWidth = ( bds.size.width - kTabOffset*2 ) / tabCount;
		
		if ( availableCellWidth > kMaxTabWidth ) availableCellWidth = kMaxTabWidth;
		if ( availableCellWidth < kMinTabWidth ) availableCellWidth = kMinTabWidth;
		
		tabsAvailable = (bds.size.width - kTabOffset*2) / availableCellWidth;
	
		if ( tabsAvailable < tabCount )
			availableCellWidth = ( bds.size.width - 10 - kTabOffset*2 ) / tabsAvailable;
			// an additional 10 pixels for the more indicator
		
		[self setAvailableWidth:availableCellWidth];
	}
	else 
	{
		[self setAvailableWidth:0];
		availableCellWidth = 0;
		tabsAvailable = 0;
	}
	
	//[totalImage setSize:bds.size];
	//[totalImage lockFocus];
	
	//[[NSColor clearColor] set];
	//NSRectFillUsingOperation(bds, NSCompositeSourceOver);
	
	// fill with the label bar color
	//[[NSColor windowBackgroundColor] set];
	[[NSColor colorWithCalibratedWhite:230.0/255.0 alpha:1.0] set];
	NSRectFillUsingOperation(bds, NSCompositeSourceOver);
	
	// draw a gradient over that
	NSColor *gradientEnd = [NSColor colorWithCalibratedWhite:0.86 alpha:0.8]; //0.6 0.82
	NSColor *gradientStart = [NSColor colorWithCalibratedWhite:0.88 alpha:0.8]; // 0.92
	[[NSBezierPath bezierPathWithRect:bds] linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
	
	NSColor *darkBorder = ( borders[0] == YES ? [NSColor darkGrayColor] : [[NSColor darkGrayColor] colorWithAlphaComponent:0.5] );
	NSColor *lightBorder = ( borders[0] == YES ? [NSColor colorWithCalibratedWhite:1.0 alpha:0.82] : [NSColor colorWithCalibratedWhite:1.0 alpha:0.4] );
	
	if ( YES )
	{
		NSGraphicsContext *context = [NSGraphicsContext currentContext];
		[context saveGraphicsState];
		[context setShouldAntialias:NO];
		
		//[[NSColor darkGrayColor] set];
		[darkBorder set];
		[[NSBezierPath bezierPathWithLineFrom:NSMakePoint(0,bds.size.height-1) to:NSMakePoint(bds.size.width,bds.size.height-1) lineWidth:1] stroke];
		
		//[[NSColor colorWithCalibratedWhite:1.0 alpha:0.9] set];
		[lightBorder set];
		[[NSBezierPath bezierPathWithLineFrom:NSMakePoint(0,bds.size.height-2) to:NSMakePoint(bds.size.width,bds.size.height-2) lineWidth:1] stroke];
		
		[context restoreGraphicsState];
	}
	
	// forget what this is for
	/*
	NSImage *shadowBackground = [[[NSImage alloc] initWithSize:NSMakeSize(bds.size.width,bds.size.height)] autorelease];
	[shadowBackground lockFocus];
	
	//[[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0] set];
	[[NSColor colorWithCalibratedWhite:230.0/255.0 alpha:1.0] set];
	NSRectFillUsingOperation(bds, NSCompositeSourceOver);
	
	[shadowBackground unlockFocus];
	[shadowBackground drawInRect:bds fromRect:bds operation:NSCompositeSourceOver fraction:0.2];
	*/
	
	// frame ourselves with a shadow
	
	//NSShadow *shadow = nil;
	
	//[totalImage unlockFocus];
	
	//[backgroundColor set];
	//NSRectFillUsingOperation(bds, NSCompositeSourceOver);
	
	// draw a gradient over that
	//[[NSBezierPath bezierPathWithRect:bds] linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
	
	// composite the tab image on top if it all - seems wasteful
	//[totalImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
	
	// run through the available titles until we can go no further,drawing the titles and the associated close buttons
	for ( i = 0; i < tabCount; i++ ) 
	{
		if ( (i+1) * availableCellWidth <= bds.size.width - kTabOffset*2 ) 
		{
			if ( _flashing && _flashingTab == i ) 
			{
				
				// redraw the background if we're flashing
				[[NSColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:0.5] set];
				NSRectFillUsingOperation(NSMakeRect(i * availableCellWidth + kTabOffset, 1, availableCellWidth - 1, bds.size.height - 2 ), NSCompositeSourceOver);
				
				/*
				NSRect hoverRect = NSMakeRect(i * availableCellWidth + kTabOffset + 1, 2, availableCellWidth - 1 - 2, 17 );
				NSBezierPath *aPath = [NSBezierPath bezierPathWithRoundedRect:hoverRect cornerRadius:8.0];
				
				[[NSColor colorWithCalibratedRed:0.45 green:0.45 blue:0.45 alpha:1.0] set];
				[aPath fill];
				*/
			}
			
			else if ( i == hoverIndex )
			{
				// height = 22
				// stateRect.origin.x+=1; stateRect.origin.y+=2; stateRect.size.width-=1; stateRect.size.height-=5;
				
				[[NSColor colorWithCalibratedWhite:0.9 alpha:0.9] set];
				NSRectFillUsingOperation( NSMakeRect(	i * availableCellWidth + ( hoverIndex == 0 ? 0 : kTabOffset ), 
														0, 
														availableCellWidth - 1 + ( hoverIndex == 0 ? kTabOffset : 0 ), 
														bds.size.height -1 )
										, NSCompositeSourceOver);
				
				/*
				NSRect hoverRect = NSMakeRect(i * availableCellWidth + kTabOffset + 1, 2, availableCellWidth - 1 - 2, 17 );
				NSBezierPath *aPath = [NSBezierPath bezierPathWithRoundedRect:hoverRect cornerRadius:8.0];
				
				if ( i != selectingIndex )
					[[NSColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:1.0] set];
				else
					[[NSColor colorWithCalibratedRed:0.45 green:0.45 blue:0.45 alpha:1.0] set];
					
				[aPath fill];
				*/
			}
						
			// draw the title identifying this tab
			NSString *theTitle = [dataSource tabsView:self titleForTabAtIndex:i];
			theTitle = ( theTitle != nil ? theTitle : [NSString string] );
			
			NSMutableAttributedString *drawString = [[[[NSAttributedString alloc] 
					initWithString:theTitle attributes:TitleAttributes()] mutableCopyWithZone:[self zone]] autorelease];
			
			if ( /* i == hoverIndex || */ ( _flashing == YES && _flashingTab == i ) )
				[drawString addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0,[drawString length])];
			else if ( i == [self selectedTab] )
				[drawString addAttribute:NSForegroundColorAttributeName value:[NSColor blackColor] range:NSMakeRange(0,[drawString length])];
			
			int left;
			if ( tabCount == 1 )
				left = 22;
			else
				left = i * availableCellWidth + 36;
			
			float heightOffset = kLabelOffset;			
			NSRect drawRect = NSMakeRect( left - 2, heightOffset, availableCellWidth - 36, [NSFont smallSystemFontSize]+4 );
			// + 30 : space for an initial tab, space for the close button
			// initial space is 12 (kTabOffset)
			
			[drawString drawInRect:drawRect];
			
			//if ( !(i == hoverIndex || i == hoverIndex-1) )
			{
				// draw the separator
				[[NSGraphicsContext currentContext] saveGraphicsState];
				[[NSGraphicsContext currentContext] setShouldAntialias:NO];
				
				[[NSColor colorWithCalibratedWhite:0.0 alpha:0.15] set];
				[[NSBezierPath bezierPathWithLineFrom:NSMakePoint((i+1) * availableCellWidth + kTabOffset - 1, 1) /*2*/
				to:NSMakePoint((i+1) * availableCellWidth + kTabOffset - 1,[self bounds].size.height - 3) lineWidth:1.0] stroke]; /*4*/
				
				[[NSGraphicsContext currentContext] restoreGraphicsState];
			}
			
			// draw the close button for this tab, but only if there is more than one tab
			if ( tabCount != 1 ) 
			{
				NSImage *closeButton;
				
				if ( i == closeDown )
					closeButton = ( i == [self selectedTab] ? tabCloseFrontDown : tabCloseBackDown );
				else 
				{
					if ( i == /*hoverIndex*/ closeHoverIndex )
						//closeButton = ( i == [self selectedTab] ? frontRollover : backRollover );
						closeButton = backRollover;
					else
						closeButton = ( i == [self selectedTab] ? tabCloseFront : tabCloseBack );
						//closeButton = tabCloseBack;
				}
				
				float closeHeightOffset = kCloseOffset;
				NSRect closeRect = NSMakeRect( i * availableCellWidth + 17 - 1, closeHeightOffset, [closeButton size].width, [closeButton size].height );
				
				[closeButton drawInRect:closeRect fromRect:NSMakeRect(0,0,[closeButton size].width, [closeButton size].height) 
					operation:NSCompositeSourceOver fraction:1.0];
			}
			
			if ( i == tabCount - 1 && ![morePop isHidden] )
				[morePop setHidden:YES];
		}
		else 
		{
			// once we hit this point, we need to indicate that more tabs are available
			// and then break out of the loop so that we don't repeat this code
			
			if ( _flashing && _flashingTab >= i ) 
			{
				// redraw the background if we're flashing
				NSRect popFrame = [morePop frame];
				
				popFrame.origin.x+=6;
				popFrame.origin.y-=3;
				popFrame.size.width-=8;
				popFrame.size.height+=8;
				
				[[NSColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:0.5] set];
				
				NSRectFillUsingOperation(popFrame, NSCompositeSourceOver);
			}
			
			// clean our the menu and rebuild it
			[morePop removeAllItems];
			[[morePop menu] addItem:popTitle];
			
			int rt;
			for ( rt = i; rt < tabCount - 1; rt++ ) 
			{
				NSString *theTitle = [dataSource tabsView:self titleForTabAtIndex:rt];
				theTitle = ( theTitle != nil ? theTitle : [NSString string] );
				
				NSMenuItem *anItem = [[[NSMenuItem alloc] initWithTitle:theTitle 
						action:@selector(selectTabByPop:) 
						keyEquivalent:@""] autorelease];
				
				[[morePop menu] addItem:anItem];
			}
			
			[morePop setHidden:NO];
			
			break;
		}
	}
	
	// add the tracking rects if the tab count differs
	if ( lastTabCount != tabCount )
	{
		[self updateTrackingRects];
		lastTabCount = tabCount;
	}
}

- (NSRect) frameOfTabAtIndex:(int)theIndex
{
	
	if ( [[self delegate] respondsToSelector:@selector(numberOfTabsInTabView:)] && theIndex != -1 )
	{
		if ( theIndex >= [[self delegate] numberOfTabsInTabView:self] )
		{
			//NSLog(@"%@ %s - index %i is greater than avaible count %i", [self className], _cmd, theIndex, [[self delegate] numberOfTabsInTabView:self] - 1 );
			return NSZeroRect;
		}
		else
		{
			return NSMakeRect(theIndex * [self availableWidth] + (theIndex == 0 ? 0 : kTabOffset ), 0, 
			[self availableWidth] + ( theIndex == 0 ? kTabOffset : 0 ), [self bounds].size.height );
		}
	}
	else
	{
		return NSZeroRect;
	}
}

- (NSRect) frameOfCloseButtonAtIndex:(int)theIndex
{
	if ( [[self delegate] respondsToSelector:@selector(numberOfTabsInTabView:)] && theIndex != -1 )
	{
		if ( theIndex >= [[self delegate] numberOfTabsInTabView:self] )
		{
			//NSLog(@"%@ %s - index %i is greater than avaible count %i", [self className], _cmd, theIndex, [[self delegate] numberOfTabsInTabView:self] - 1 );
			return NSZeroRect;
		}
		else
		{
			return NSMakeRect(	theIndex * [self availableWidth] + 17 - 1, 
								kCloseOffset, 
								[backRollover size].width, 
								[backRollover size].height );
		}
	}
	else
	{
		return NSZeroRect;
	}
}

#pragma mark -
#pragma mark Tracking

- (void) updateTrackingRects
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	int i;
	int tabsAvailable;
	int availableCellWidth;
	
	NSRect bds = [self bounds];
	int tabCount = [dataSource numberOfTabsInTabView:self];
	
	// remove the previous tooltips
	[self removeAllToolTips];
	
	// remove the previous tracking rectangles
	for ( i = 0; i < [titleTrackingRects count]; i++ )
		[self removeTrackingRect:[[titleTrackingRects objectAtIndex:i] intValue]];
	for ( i = 0; i < [closeButtonTrackingRects count]; i++ )
		[self removeTrackingRect:[[closeButtonTrackingRects objectAtIndex:i] intValue]];
	
	[titleTrackingRects removeAllObjects];
	[closeButtonTrackingRects removeAllObjects];
	
	if ( tabCount != 0 ) 
	{
		availableCellWidth = ( bds.size.width - kTabOffset*2 ) / tabCount;
		
		if ( availableCellWidth > kMaxTabWidth ) availableCellWidth = kMaxTabWidth;
		if ( availableCellWidth < kMinTabWidth ) availableCellWidth = kMinTabWidth;
		
		tabsAvailable = (bds.size.width - kTabOffset*2) / availableCellWidth;
	
		if ( tabsAvailable < tabCount )
			availableCellWidth = ( bds.size.width - 10 - kTabOffset*2 ) / tabsAvailable;
			// an additional 10 pixels for the more indicator
	}
	else 
	{
		availableCellWidth = 0;
		tabsAvailable = 0;
	}
	
	
	// run through the available titles until we can go no further,drawing the titles and the associated close buttons
	for ( i = 0; i < tabCount; i++ ) 
	{
		if ( (i+1) * availableCellWidth <= bds.size.width - kTabOffset*2 ) 
		{

			int left;
			if ( tabCount == 1 )
				left = 18;
			else
				left = i * availableCellWidth + 36;
			
			float heightOffset = kLabelOffset;			
			
			NSRect tooltipRect = NSMakeRect( left, heightOffset, availableCellWidth - 36, 17 );
			NSRect drawRect = NSMakeRect(i * availableCellWidth + kTabOffset + 4, 2, availableCellWidth - 1 - 8, 17 );
			
			NSTrackingRectTag aTrackingRect = [self addTrackingRect:drawRect owner:self userData:nil assumeInside:NO];
			[titleTrackingRects addObject:[NSNumber numberWithInt:aTrackingRect]];
			
			if ( [[self delegate] respondsToSelector:@selector(tabsView:titleForTabAtIndex:)] )
				[self addToolTipRect:tooltipRect owner:[[[self delegate] tabsView:self titleForTabAtIndex:i] retain] userData:nil];
			
			// + 30 : space for an initial tab, space for the close button
			// initial space is 12 (kTabOffset)
			
			// draw the close button for this tab, but only if there is more than one tab
			if ( tabCount != 1 ) 
			{
				float closeHeightOffset = kCloseOffset;
				NSRect closeRect = NSMakeRect( i * availableCellWidth + 17, closeHeightOffset, [tabCloseFrontDown size].width, [tabCloseFrontDown size].height );
				
				[self addToolTipRect:closeRect owner:
				[NSLocalizedStringFromTableInBundle(@"close tab tip", @"PDTabsView", [NSBundle bundleWithIdentifier:@"com.sprouted.interface"], @"") retain] userData:nil];
				
				NSTrackingRectTag aTrackingRect = [self addTrackingRect:closeRect owner:self userData:nil assumeInside:NO];
				[closeButtonTrackingRects addObject:[NSNumber numberWithInt:aTrackingRect]];
			}
		}
		else 
		{
			// once we hit this point, we need to indicate that more tabs are available
			// and then break out of the loop so that we don't repeat this code
			
			if ( _flashing && _flashingTab >= i ) 
			{
				// redraw the background if we're flashing
				NSRect popFrame = [morePop frame];
				
				popFrame.origin.x+=6;
				popFrame.origin.y-=3;
				popFrame.size.width-=8;
				popFrame.size.height+=8;
			}
			
			break;
		}
	}

}

- (void) _updateTrackingRects:(NSNotification*)aNotification
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	[self updateTrackingRects];
}

- (void) _toolbarDidChangeVisible:(NSNotification*)aNotification
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	if ( [[self window] toolbar] == [aNotification object] )
		[self updateTrackingRects];
}

#pragma mark -

- (void)mouseEntered:(NSEvent *)theEvent
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	int i;
	BOOL forceHoverUpdate = NO;
	NSTrackingRectTag trackTag = [theEvent trackingNumber];
	
	// first check for a match with the close button
	
	for ( i = 0; i < [closeButtonTrackingRects count]; i++ )
	{
		if ( trackTag == [[closeButtonTrackingRects objectAtIndex:i] intValue] )
		{
			closeHoverIndex = i;
			if ( hoverIndex != closeHoverIndex )
			{
				forceHoverUpdate = YES;
				hoverIndex = i;
			}
		}
	}
	
	// then check for a match with the whole thing 
	if ( hoverIndex == -1 )
	{
		for ( i = 0; i < [titleTrackingRects count]; i++ )
		{
			if ( trackTag == [[titleTrackingRects objectAtIndex:i] intValue] )
			{
				hoverIndex = i;
				forceHoverUpdate = YES;
			}
		}
	}
	
	if ( closeHoverIndex != -1 )
	{
		#ifdef __DEBUG__
		NSLog(@"%@ %s - hovering at %i", [self className], _cmd, closeHoverIndex);
		#endif
		
		NSRect invalidatedRect = [self frameOfCloseButtonAtIndex:closeHoverIndex];
		invalidatedRect.origin.x-=1; invalidatedRect.size.width+=2;
		[self setNeedsDisplayInRect:invalidatedRect];
	}
	
	if ( hoverIndex != -1 && forceHoverUpdate )
	{
		#ifdef __DEBUG__
		NSLog(@"%@ %s - hovering at %i", [self className], _cmd, hoverIndex);
		#endif
		
		NSRect invalidatedRect = [self frameOfTabAtIndex:hoverIndex];
		invalidatedRect.origin.x-=1; invalidatedRect.size.width+=2;
		[self setNeedsDisplayInRect:invalidatedRect];
	}
}

- (void)mouseExited:(NSEvent *)theEvent
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	if ( [[self delegate] respondsToSelector:@selector(numberOfTabsInTabView:)] 
		&& closeHoverIndex != -1 && closeHoverIndex < [[self delegate] numberOfTabsInTabView:self] )
	{
		NSRect invalidatedRect = [self frameOfCloseButtonAtIndex:closeHoverIndex];
		invalidatedRect.origin.x-=1; invalidatedRect.size.width+=2;
		[self setNeedsDisplayInRect:invalidatedRect];
		
		closeHoverIndex = -1;
	}
	
	else if ( [[self delegate] respondsToSelector:@selector(numberOfTabsInTabView:)] 
		&& hoverIndex != -1 && hoverIndex < [[self delegate] numberOfTabsInTabView:self] )
	{
		NSRect invalidatedRect = [self frameOfTabAtIndex:hoverIndex];
		invalidatedRect.origin.x-=1; invalidatedRect.size.width+=2;
		[self setNeedsDisplayInRect:invalidatedRect];
		
		hoverIndex = -1;
	}
	
}


#pragma mark -

- (BOOL)mouseDownCanMoveWindow 
{ 
	return NO;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	// converts the event into a tab selection or close and 
	// sends ourself the message
	
	BOOL clickedInEmptySpace = YES;
	BOOL closing = NO;
	int i;
	
	// mouse location and x coordinates
	NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	int myX = mouseLoc.x - kTabOffset;	// 12 (kTabOffset) takes into account our self imposed left offset
	int myY = mouseLoc.y;
	
	int actualTabs = [dataSource numberOfTabsInTabView:self];
	
	// do nothing if there is nothing to display
	if ( [self availableWidth] == 0 ) 
	{
		return;
	}
	else if ( actualTabs == 1 )
	{
		// bail unless the user double-clicked outside of the tab's area
		if ( myX > 1 * [self availableWidth] 
				&& myX < [self bounds].size.width - 30 
				&& [theEvent clickCount] > 1 
				&& [[self delegate] respondsToSelector:@selector(newTab:)] ) 
		{
			// create and select the new tab
			[[self delegate] performSelector:@selector(newTab:) withObject:self];
			[self selectTab:[dataSource numberOfTabsInTabView:self]-1];
		}
		else
		{
			return;
		}
	}
	else
	{
		int tabsAvailable = ([self bounds].size.width - kTabOffset*2) / [self availableWidth];
		int limit = ( tabsAvailable <= actualTabs ? tabsAvailable : actualTabs );
		
		// selecting within a close box
		
		for ( i = 0; i < limit; i++ ) 
		{
			if ( myX >= i * [self availableWidth] + 5 && myX <= i * [self availableWidth] + 5 + [tabCloseFront size].width 
					&& myY >= kCloseOffset && myY <= kCloseOffset + [tabCloseFront size].height ) 
			{
				// enter my own even loop until we have some kind of result
				BOOL keepOn = YES;
				BOOL isInside = YES;
				NSPoint mouseLoc;
				
				NSRect invalidatedRect;
				NSRect innenRect = NSMakeRect(i * [self availableWidth] + 17, kCloseOffset, [tabCloseFront size].width, [tabCloseFront size].height);
				
				closeDown = i;
				clickedInEmptySpace = NO;
				
				[self displayRect:[self frameOfTabAtIndex:i]];
				
				while (keepOn) 
				{
					theEvent = [[self window] nextEventMatchingMask: NSLeftMouseUpMask | NSLeftMouseDraggedMask];
					
					mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
					isInside = [self mouse:mouseLoc inRect:innenRect];
					
					switch ([theEvent type]) 
					{
					case NSLeftMouseDragged:
							invalidatedRect = [self frameOfTabAtIndex:i];
							closeDown = ( isInside ? i : -1 );
							[self displayRect:invalidatedRect];
							break;
							
					case NSLeftMouseUp:
							invalidatedRect = [self frameOfTabAtIndex:i];
							if (isInside) [self closeTab:i];
							closeDown = -1;
							[self displayRect:invalidatedRect];
							keepOn = NO;
							
							break;
					default:
							/* Ignore any other kind of event. */
							break;
					}
				};
			
				//[self setNeedsDisplay:YES];
				closing = YES;
			}
		}
		
		// basic tab selection
		if ( !closing ) 
		{
			for ( i = 0; i < limit; i++ ) 
			{
				if ( myX > i * [self availableWidth] && myX < (i+1) * [self availableWidth] ) 
				{				
					// do not process this if this tab is already selected
					if ( i != [self selectedTab] )
					{
						selectingIndex = i;
						NSRect hoverRect = NSMakeRect(selectingIndex * [self availableWidth] + kTabOffset, 2, [self availableWidth] - 1, 17 ); 
						[self setNeedsDisplayInRect:hoverRect];
						[self selectTab:i];
					}
					
					clickedInEmptySpace = NO;
					break;
				}
			}
			
			closeDown = -1;
		}
		
		// clicked in empty space, clicked count > 1, new delegate wants new tabs
		if ( clickedInEmptySpace == YES 
				&& myX < [self bounds].size.width - 30
				&& [theEvent clickCount] > 1 
				&& [[self delegate] respondsToSelector:@selector(newTab:)] )
		{
			// create and select the new tab
			[[self delegate] performSelector:@selector(newTab:) withObject:self];
			[self selectTab:[dataSource numberOfTabsInTabView:self]-1];
		}
	}
}

#pragma mark -

- (void)mouseUp:(NSEvent *)theEvent
{
	NSRect hoverRect = NSMakeRect(selectingIndex * [self availableWidth] + kTabOffset, 2, [self availableWidth] - 1, 17 ); 
	selectingIndex = -1;
	[self setNeedsDisplayInRect:hoverRect];
}

- (IBAction) selectTabByPop:(id)sender 
{
	int tabsAvailable = ([self bounds].size.width - kTabOffset*2) / [self availableWidth];
	int selectedItem = [morePop indexOfSelectedItem];
	
	int tabToSelect = tabsAvailable + selectedItem - 1;
	
	[self selectTab:tabToSelect];
}

#pragma mark -

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	_targetTabForContext = -1;
	
	NSPoint local_point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	int i, limit, tabsAvailable, actualTabs;
	int myX = local_point.x - kTabOffset;
	
	actualTabs = [[self dataSource] numberOfTabsInTabView:self];
	
	// do nothing if there is nothing to display
	if ( [self availableWidth] == 0 || actualTabs == 1 )
		return [super menuForEvent:theEvent];
	
	tabsAvailable = ([self bounds].size.width - kTabOffset*2) / [self availableWidth];
	limit = ( tabsAvailable <= actualTabs ? tabsAvailable : actualTabs );
	
	for ( i = 0; i < limit; i++ ) 
	{
		if ( myX > i * [self availableWidth] && myX < (i+1) * [self availableWidth] ) 
		{
			_targetTabForContext = i;
			break;
		}
	}
	
	return [super menuForEvent:theEvent];
}

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem
{
	BOOL enabled = YES;
	SEL action = [menuItem action];
	
	if ( action == @selector(newTab:) )
		enabled = [[self delegate] respondsToSelector:@selector(newTab:)];
	else if ( action == @selector(closeTargetedTab:) )
		enabled = ( [[self dataSource] numberOfTabsInTabView:self] != 1 && _targetTabForContext != -1 );
	else if ( action == @selector(closeOtherTabs:) )
		enabled = ( [[self dataSource] numberOfTabsInTabView:self] != 1 && _targetTabForContext != -1 );
	
	return enabled;
}

- (IBAction) closeTargetedTab:(id)sender
{
	if ( _targetTabForContext == - 1 )
	{
		NSBeep(); return;
	}
	
	[self closeTab:_targetTabForContext];
	_targetTabForContext = -1;
}

- (IBAction) closeOtherTabs:(id)sender
{
	if ( _targetTabForContext == - 1 )
	{
		NSBeep(); return;
	}

	int i;
	int numTabs = [[self dataSource] numberOfTabsInTabView:self];
	
	// close the tabs behind
	for ( i = numTabs - 1; i > _targetTabForContext; i--  )
		[self closeTab:i];
		
	// close the tabs in front
	for ( i = 0; i < _targetTabForContext; i++ )
		[self closeTab:0];
	
	_targetTabForContext = -1;
}

- (void)viewDidMoveToWindow 
{
	if ( [self window] != nil )
		[self updateTrackingRects];
}

@end
