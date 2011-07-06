//
//  PDFavoritesBar.m
//  SproutedInterface
//
//  Created by Philip Dow on 3/17/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDFavoritesBar.h>
#import <SproutedInterface/PDFavorite.h>

#import <SproutedInterface/PDToolbar.h>

#import <SproutedUtilities/NSBezierPath_AMAdditons.h>
#import <SproutedUtilities/NSBezierPath_AMShading.h>

@implementation PDFavoritesBar

- (id)initWithFrame:(NSRect)frame {
	if ( self = [super initWithFrame:frame] )
	{
        // Initialization code here.
		
		_titleSheet = YES;
		
		_backgroundColor = [[NSColor windowBackgroundColor] retain];
		_favorites = [[NSMutableArray alloc] init];
		_trackingRects = [[NSMutableArray alloc] init];
		
		// CHANGES
		_vFavorites = [[NSMutableArray alloc] init];
		
		NSImage *moreImage = [NSImage imageNamed:@"more.tif"];
		_popTitle = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
		
		[_popTitle setImage:moreImage];
		
		_morePop = [[NSPopUpButton alloc] initWithFrame:NSMakeRect( frame.size.width - 28, 6, 28, 10 ) pullsDown:YES];
		
		[_morePop setBordered:NO];
		[_morePop setTarget:self];
		[_morePop setAction:@selector(_favoriteFromPop:)];
		[_morePop setAutoresizingMask:NSViewMinXMargin];
		[_morePop setHidden:YES];
		[[_morePop menu] addItem:_popTitle];
		[[_morePop cell] setArrowPosition:NSPopUpNoArrow];
		
		[self addSubview:_morePop];
		
		[self setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin];
		[self registerForDraggedTypes:[NSArray arrayWithObjects:PDFavoritePboardType, nil]];
		
		[self setPostsBoundsChangedNotifications:YES];
		[self setPostsFrameChangedNotifications:YES];
		
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_generateFavoriteViews:) 
		//name:NSViewBoundsDidChangeNotification object:self];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_generateFavoriteViews:) 
		//name:NSViewFrameDidChangeNotification object:self];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_positionFavoriteViews:) 
		name:NSViewBoundsDidChangeNotification object:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_positionFavoriteViews:) 
		name:NSViewFrameDidChangeNotification object:self];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoritesDidChange:) 
		name:PDFavoritesDidChangeNotification object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_toolbarDidChangeVisible:) 
		name:PDToolbarDidHideNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_toolbarDidChangeVisible:) 
		name:PDToolbarDidShowNotification object:nil];
		
		// label bindings
		[self bind:@"drawsLabels" toObject:[NSUserDefaultsController sharedUserDefaultsController] 
		withKeyPath:@"values.FavoritesBarDrawsLabels" options:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:YES], NSNullPlaceholderBindingOption, nil]];
		
		// set the initial favorites
		//NSArray *theFavorites = [[NSUserDefaults standardUserDefaults] arrayForKey:@"PDFavoritesBar"];
		//if ( theFavorites == nil ) theFavorites = [NSArray array];
		//[self setFavorites:theFavorites];
		
		// build the contextual menu
		contextMenu = [[NSMenu alloc] initWithTitle:@"Context"];
		
		NSString *aTitle = NSLocalizedStringFromTableInBundle(@"draw labels", @"PDFavoritesBar", [NSBundle bundleWithIdentifier:@"com.sprouted.interface"], @"");
		NSMenuItem *labelsToggle = [[[NSMenuItem alloc] initWithTitle:aTitle action:@selector(toggleDrawsLabels:) keyEquivalent:@""] autorelease];
		
		[labelsToggle setTarget:self];		
		[contextMenu addItem:labelsToggle];
		[self setMenu:contextMenu];

    }
    return self;
}

- (void) dealloc {
	
	#ifdef __DEBUG__
	NSLog(@"%@ %s - beginning",[self className],_cmd);
	#endif
	
	int i;
	for ( i = 0; i < [_trackingRects count]; i++ )
		[self removeTrackingRect:[[_trackingRects objectAtIndex:i] intValue]];
		
	[_trackingRects release];
	[_vFavorites release];
	
	[_backgroundColor release];
	[_favorites release];
	[_morePop release];
	[_popTitle release];
	
	[contextMenu release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	//[self unbind:@"favorites"];
	[self unregisterDraggedTypes];
	
	#ifdef __DEBUG__
	NSLog(@"%@ %s - ending",[self className],_cmd);
	#endif
	
	[super dealloc];
}

#pragma mark -

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	
	NSRect bds = [self bounds];
	
	// fill with the label bar color
	[_backgroundColor set];
	NSRectFillUsingOperation(bds, NSCompositeSourceOver);
	
	// draw a gradient over that
	NSColor *gradientStart = [NSColor colorWithCalibratedWhite:0.86 alpha:0.8]; // 0.6 // 0.82
	NSColor *gradientEnd = [NSColor colorWithCalibratedWhite:0.88 alpha:0.8]; // 0.92
	[[NSBezierPath bezierPathWithRect:bds] linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];

	NSGraphicsContext *context = [NSGraphicsContext currentContext];
	[context saveGraphicsState];
	[context setShouldAntialias:NO];
	
	[[NSColor darkGrayColor] set];
	[[NSBezierPath bezierPathWithLineFrom:NSMakePoint(0,bds.size.height-1) to:NSMakePoint(bds.size.width,bds.size.height-1) lineWidth:1] stroke];
	
	[[NSColor colorWithCalibratedWhite:1.0 alpha:0.82] set];
	[[NSBezierPath bezierPathWithLineFrom:NSMakePoint(0,bds.size.height-2) to:NSMakePoint(bds.size.width,bds.size.height-2) lineWidth:1] stroke];
	
	[context restoreGraphicsState];
}

#pragma mark -

- (NSColor*) backgroundColor 
{ 
	return _backgroundColor; 
	}

- (void) setBackgroundColor:(NSColor*)color 
{
	if ( _backgroundColor != color ) 
	{
		[_backgroundColor release];
		_backgroundColor = [color copyWithZone:[self zone]];
	}
}

- (NSMutableArray*) favorites 
{ 
	return _favorites; 
}

- (void) setFavorites:(NSArray*)favorites 
{
	if ( _favorites != favorites ) 
	{
		[_favorites release];
		_favorites = [favorites retain];
		
		// regenerate the favorites view
		[self _generateFavoriteViews:nil];
		
		// and re-position
		//[self _positionFavoriteViews:nil];
	}
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

- (id) target 
{ 
	return _target; 
}

- (void) setTarget:(id)target 
{
	_target = target;
}

- (SEL) action 
{
	return _action; 
}

- (void) setAction:(SEL)action 
{
	_action = action;
}

- (BOOL) drawsLabels
{
	return drawsLabels;
}

- (void) setDrawsLabels:(BOOL)draws
{
	drawsLabels = draws;
	[_vFavorites setValue:[NSNumber numberWithBool:drawsLabels] forKey:@"drawsLabel"];
}

- (IBAction) toggleDrawsLabels:(id)sender
{
	[[NSUserDefaults standardUserDefaults] 
	setBool:![[NSUserDefaults standardUserDefaults] boolForKey:@"FavoritesBarDrawsLabels"] 
	forKey:@"FavoritesBarDrawsLabels"];
	
	//[self setDrawsLabels:![self drawsLabels]];
	//[_vFavorites setValue:[NSNumber numberWithBool:[self drawsLabels]] forKey:@"drawsLabel"];
	//[_vFavorites setValue:[NSNumber numberWithBool:YES] forKey:@"needsDisplay"];
}

#pragma mark -

- (void) sendEvent:(unsigned)sender {
	
	_eventFavorite = sender;
	if ( [[self target] respondsToSelector:[self action]] )
		[[self target] performSelector:[self action] withObject:self];
		
}

- (NSDictionary*) eventFavorite {
	
	return [[self favorites] objectAtIndex:_eventFavorite];
	
}

#pragma mark -

- (BOOL) addFavorite:(NSDictionary*)aFavorite atIndex:(unsigned)loc requestTitle:(BOOL)showSheet {
	
	NSMutableArray *tempFavs = [[[self favorites] mutableCopyWithZone:[self zone]] autorelease];
	if ( tempFavs == nil ) tempFavs = [NSMutableArray array];
	
	if ( loc > [tempFavs count] )
		loc = [tempFavs count];
	else if ( loc < 0 )
		loc = 0;
	
	//
	// show a sheet if requested
	if ( showSheet ) {
		
		NSString *newTitle = [self _titleFromTitleSheet:[aFavorite objectForKey:PDFavoriteName]];
		if ( !newTitle ) return NO;
		
		NSMutableDictionary *modAddition = [aFavorite mutableCopyWithZone:[self zone]];
		[modAddition setObject:newTitle forKey:PDFavoriteName];
		
		[tempFavs insertObject:modAddition atIndex:loc];
		
		[modAddition release];
		
	}
	else {
	
		[tempFavs insertObject:aFavorite atIndex:loc];
	
	}
	
	[self setFavorites:tempFavs];
	[[NSUserDefaults standardUserDefaults] setObject:tempFavs forKey:@"PDFavoritesBar"];
	[[NSNotificationCenter defaultCenter] postNotificationName:PDFavoritesDidChangeNotification 
			object:self userInfo:[NSDictionary dictionaryWithObject:tempFavs forKey:@"favorites"]];
	
	return YES;
	
}

- (void) removeFavoriteAtIndex:(unsigned)loc
{	
	NSMutableArray *tempFavs = [[[self favorites] mutableCopyWithZone:[self zone]] autorelease];
	if ( tempFavs == nil ) tempFavs = [NSMutableArray array];
	
	if ( loc > [tempFavs count] )
		loc = [tempFavs count];
	else if ( loc < 0 )
		loc = 0;
	
	[tempFavs removeObjectAtIndex:loc];	
	
	[self setFavorites:tempFavs];
	[self _generateFavoriteViews:self];
	[self _positionFavoriteViews:self];
	
	[[NSUserDefaults standardUserDefaults] setObject:tempFavs forKey:@"PDFavoritesBar"];
	[[NSNotificationCenter defaultCenter] postNotificationName:PDFavoritesDidChangeNotification 
			object:self userInfo:[NSDictionary dictionaryWithObject:tempFavs forKey:@"favorites"]];
}

#pragma mark -

- (void) favoritesDidChange:(NSNotification*)aNotification
{
	if ( [aNotification object] != self )
	{
		NSArray *theFavorites = [[aNotification userInfo] objectForKey:@"favorites"];
		[self setFavorites:theFavorites];
	}
}

- (PDFavorite*) favoriteWithIdentifier:(id)anIdentifier
{
	int anIndex = [[_vFavorites valueForKey:@"identifier"] indexOfObject:anIdentifier];
	if ( anIndex == NSNotFound ) return nil;
	else return [_vFavorites objectAtIndex:anIndex];
}

- (void) setLabel:(int)label forFavorite:(PDFavorite*)aFavorite
{
	[aFavorite setLabel:label];
	[aFavorite setNeedsDisplay:YES];
}

- (void) rescanLabels
{
	if ( ![[self delegate] respondsToSelector:@selector(favoritesBar:labelOfItemWithIdentifier:)] )
		return;
		
	PDFavorite *aFavorite;
	NSEnumerator *enumerator = [_vFavorites objectEnumerator];
	
	while ( aFavorite = [enumerator nextObject] )
		[aFavorite setLabel:[[self delegate] favoritesBar:self labelOfItemWithIdentifier:[aFavorite identifier]]];
}

#pragma mark -


- (void) _generateFavoriteViews:(id)object {
	
	#ifdef __DEBUG__
	NSLog(@"%@ %s - beginning",[self className],_cmd);
	#endif
	
	int i;
	
	[_vFavorites makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[_vFavorites removeAllObjects];
	
	for ( i = 0; i < [_favorites count]; i++ ) {
		
		NSDictionary *aFavDict = [_favorites objectAtIndex:i];
		PDFavorite *aFavorite = [[[PDFavorite alloc] initWithFrame:NSMakeRect(0,0,40,22) 
				title:[aFavDict objectForKey:PDFavoriteName] identifier:[aFavDict objectForKey:PDFavoriteID]] autorelease];
		
		if ( [[self delegate] respondsToSelector:@selector(favoritesBar:labelOfItemWithIdentifier:)] )
			[aFavorite setLabel:[[self delegate] favoritesBar:self labelOfItemWithIdentifier:[aFavorite identifier]]];
		
		[_vFavorites addObject:aFavorite];
	
	}
	
	[_vFavorites setValue:[NSNumber numberWithBool:[self drawsLabels]] forKey:@"drawsLabel"];
	
	#ifdef __DEBUG__
	NSLog(@"%@ %s - ending",[self className],_cmd);
	#endif
}

- (void) _positionFavoriteViews:(id)object
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s - beginning",[self className],_cmd);
	#endif
	
	int i;
	int totalWidth = 10;
	NSRect bds = [self bounds];
	
	for ( i = 0; i < [_trackingRects count]; i++ )
		[self removeTrackingRect:[[_trackingRects objectAtIndex:i] intValue]];
		
	[_trackingRects removeAllObjects];
	//[_vFavorites makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	[_morePop removeAllItems];
	[_morePop setHidden:YES];
	
	for ( i = 0; i < [_vFavorites count]; i++ ) {
		
		PDFavorite *aFavorite = [_vFavorites objectAtIndex:i];
		
		NSSize idealSize = [aFavorite idealSize];
		
		if ( totalWidth + idealSize.width < bds.size.width - 10 ) {
			
			NSRect thisRect = NSMakeRect(totalWidth, 0, idealSize.width, 22);
			NSTrackingRectTag thisTrack = [self addTrackingRect:thisRect owner:self userData:nil assumeInside:NO];
			
			[aFavorite setFrame:thisRect];
			[_trackingRects addObject:[NSNumber numberWithInt:thisTrack]];
			
			if ( [aFavorite superview] == nil )
				[self addSubview:aFavorite];
			
		}
		else {
			
			if ( [aFavorite superview] != nil )
				[aFavorite removeFromSuperview];
			
			if ( [_morePop isHidden] )
				[_morePop setHidden:NO];
			if ( [_morePop numberOfItems] == 0 )
				[[_morePop menu] addItem:_popTitle];
			
			NSMenuItem *thisItem = [[NSMenuItem alloc] initWithTitle:[aFavorite title] action:@selector(_favoriteFromPop:) keyEquivalent:@""];
			[thisItem setTag:i];
			[thisItem setTarget:self];
			[thisItem setRepresentedObject:aFavorite];
			
			[[_morePop menu] addItem:thisItem];
			[thisItem release];
		}
		
		totalWidth+=idealSize.width+=4;
	}
	
	#ifdef __DEBUG__
	NSLog(@"%@ %s - ending",[self className],_cmd);
	#endif

}

/*
- (void) _generateFavoriteViews:(id)object {
	
	#ifdef __DEBUG__
	NSLog(@"%@ %s - beginning",[self className],_cmd);
	#endif
	
	int i;
	int totalWidth = 10;
	NSRect bds = [self bounds];
	
	if ( _trackingRects != nil ) 
	{
		for ( i = 0; i < [_trackingRects count]; i++ )
			[self removeTrackingRect:[[_trackingRects objectAtIndex:i] intValue]];
			
		[_trackingRects release];
		_trackingRects = nil;
	}
	
	_trackingRects = [[NSMutableArray alloc] initWithCapacity:[_favorites count]];
	
	if ( _vFavorites != nil ) 
	{
		[_vFavorites makeObjectsPerformSelector:@selector(removeFromSuperview)];
		
		[_vFavorites release];
		_vFavorites = nil;
	}

	_vFavorites = [[NSMutableArray alloc] initWithCapacity:[_favorites count]];
	
	for ( i = 0; i < [_favorites count]; i++ ) {
		
		NSDictionary *aFavDict = [_favorites objectAtIndex:i];
		PDFavorite *aFavorite = [[PDFavorite alloc] initWithFrame:NSMakeRect(0,0,40,22) 
				title:[aFavDict objectForKey:PDFavoriteName] identifier:[aFavDict objectForKey:PDFavoriteID]];
		
		if ( [[self delegate] respondsToSelector:@selector(favoritesBar:labelOfItemWithIdentifier:)] )
			[aFavorite setLabel:[[self delegate] favoritesBar:self labelOfItemWithIdentifier:[aFavorite identifier]]];
		
		[_vFavorites setValue:[NSNumber numberWithBool:[self drawsLabels]] forKey:@"drawsLabel"];
		[_vFavorites addObject:aFavorite];
	
	}
	
	[_morePop removeAllItems];
	[_morePop setHidden:YES];
	
	for ( i = 0; i < [_vFavorites count]; i++ ) {
		
		PDFavorite *aFavorite = [_vFavorites objectAtIndex:i];
		
		NSSize idealSize = [aFavorite idealSize];
		
		if ( totalWidth + idealSize.width < bds.size.width - 10 ) {
			
			NSRect thisRect = NSMakeRect(totalWidth, 0, idealSize.width, 22);
			NSTrackingRectTag thisTrack = [self addTrackingRect:thisRect owner:self userData:nil assumeInside:NO];
			
			[aFavorite setFrame:thisRect];
			[_trackingRects addObject:[NSNumber numberWithInt:thisTrack]];
			[self addSubview:aFavorite];
			
		}
		else {
			
			if ( [_morePop isHidden] )
				[_morePop setHidden:NO];
			if ( [_morePop numberOfItems] == 0 )
				[[_morePop menu] addItem:_popTitle];
			
			NSMenuItem *thisItem = [[NSMenuItem alloc] initWithTitle:[aFavorite title] action:@selector(_favoriteFromPop:) keyEquivalent:@""];
			[thisItem setTag:i];
			[thisItem setTarget:self];
			[thisItem setRepresentedObject:aFavorite];
			
			[[_morePop menu] addItem:thisItem];
			[thisItem release];
		}
		
		totalWidth+=idealSize.width+=4;
	}
	
	#ifdef __DEBUG__
	NSLog(@"%@ %s - ending",[self className],_cmd);
	#endif
}
*/

- (void) _favoriteFromPop:(id) sender {
	
	[self sendEvent:[sender tag]];
	
}

#pragma mark -

/*
- (void)viewDidMoveToSuperview {
	
	if ( [self superview] != nil )
	//	[self _generateFavoriteViews:nil];
		[self _positionFavoriteViews:nil];
}
*/

- (void)viewDidMoveToWindow {

	if ( [self window] != nil )
	//	[self _generateFavoriteViews:nil];
		[self _positionFavoriteViews:nil];
}

#pragma mark -

- (void)mouseEntered:(NSEvent *)theEvent {
	
	int i;
	NSTrackingRectTag trackTag = [theEvent trackingNumber];
	
	for ( i = 0; i < [_trackingRects count]; i++ ) {
		if ( [[_trackingRects objectAtIndex:i] intValue] == trackTag ) {
			[[_vFavorites objectAtIndex:i] setState:PDFavoriteHover];
			[[_vFavorites objectAtIndex:i] setNeedsDisplay:YES];
			break;
		}
	}
}

- (void)mouseExited:(NSEvent *)theEvent {
	
	int i;
	NSTrackingRectTag trackTag = [theEvent trackingNumber];
	
	for ( i = 0; i < [_trackingRects count]; i++ ) {
		if ( [[_trackingRects objectAtIndex:i] intValue] == trackTag ) {
			[[_vFavorites objectAtIndex:i] setState:PDFavoriteNoHover];
			[[_vFavorites objectAtIndex:i] setNeedsDisplay:YES];
			break;
		}
	}
}

#pragma mark -


- (void)mouseDown:(NSEvent *)theEvent {
	
	//
	// converts the event into a tab selection or close and 
	// sends ourself the message
	//
	
	// enter my own even loop until we have some kind of result
	BOOL keepOn = YES;
	BOOL isInside = YES;
	NSPoint localPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSPoint originalPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	NSRect bds = [self bounds];
	NSRect innenRect;
	
	int i;
	int totalWidth = 10;
	
	for ( i = 0; i < [_vFavorites count]; i++ ) {
		
		PDFavorite *aFavorite = [_vFavorites objectAtIndex:i];
		NSSize idealSize = [aFavorite idealSize];
		
		if ( totalWidth + idealSize.width < bds.size.width - 10 ) {
			
			NSRect thisRect = NSMakeRect(totalWidth, 0, idealSize.width, 22);
			if ( NSPointInRect(localPoint,thisRect) ) {
				innenRect = thisRect;
				break;
			}
		}
		
		totalWidth+=idealSize.width+=4;
		
	}
	
	if ( i < [_vFavorites count] ) {
		
		[[_vFavorites objectAtIndex:i] setState:PDFavoriteMouseDown];
		[(PDFavorite*)[_vFavorites objectAtIndex:i] display];
		
		while (keepOn) {
		
			theEvent = [[self window] nextEventMatchingMask: NSLeftMouseUpMask |
					NSLeftMouseDraggedMask];
			
			localPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
			isInside = [self mouse:localPoint inRect:innenRect];
			
			switch ([theEvent type]) {
				case NSLeftMouseDragged:
					
					if ( originalPoint.x - localPoint.x <= -10 || originalPoint.x - localPoint.x >= 10 ||
							originalPoint.y - localPoint.y <= -6 || originalPoint.y - localPoint.y >= 6 ) {
						
						[self _initiateDragOperation:i location:localPoint event:theEvent];
						keepOn = NO;
						
					}
					
					break;
					
				case NSLeftMouseUp:
						
					if (isInside) {
						[self sendEvent:i];
						[[_vFavorites objectAtIndex:i] setState:PDFavoriteHover];
						[(PDFavorite*)[_vFavorites objectAtIndex:i] display];
					}
					else {
						[[_vFavorites objectAtIndex:i] setState:PDFavoriteNoHover];
						[(PDFavorite*)[_vFavorites objectAtIndex:i] display];
					}
					
					keepOn = NO;
					break;
					
				default:
						/* Ignore any other kind of event. */
						break;
			}
		};
	
	}
}

#pragma mark -

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
		
	NSPasteboard *pboard = [sender draggingPasteboard];
		//gets the dragging-specific pasteboard from the sender
	
    NSArray *types = [NSArray arrayWithObjects:PDFavoritePboardType, nil];
		//a list of types that we can accept
		
    NSString *desiredType = [pboard availableTypeFromArray:types];
		// one desired type
	
	if ( [desiredType isEqualToString:PDFavoritePboardType] ) {
		
		//
		// determine where the drop is to occur and make it
		
		NSPoint localPoint = [self convertPoint:[sender draggingLocation] fromView:nil];
		NSDictionary *favDict = [pboard propertyListForType:PDFavoritePboardType];
		
		int i;
		int totalWidth = 10;
		BOOL requireTitle;
		
		for ( i = 0; i < [_vFavorites count]; i++ ) {
			
			PDFavorite *aFavorite = [_vFavorites objectAtIndex:i];
			NSSize idealSize = [aFavorite idealSize];
			
			if ( localPoint.x < totalWidth + idealSize.width )
				break;
			
			totalWidth+=idealSize.width+=4;
			
		}
		
		requireTitle = ( [sender draggingSource] != self );
		
		if ( [self addFavorite:favDict atIndex:i requestTitle:requireTitle] ) 
		{
			// regenerate and reposition favorite views
			[self _generateFavoriteViews:nil];
			[self _positionFavoriteViews:nil];
			return YES;
		}
		else {
			return NO;
		}
		
	}
	else {
		
		return NO;
		
	}
	
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
	
	if ( [sender draggingSource] == self )
		return NSDragOperationMove;
	else
		return NSDragOperationCopy;
	
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
	
	if ( [sender draggingSource] == self )
		return NSDragOperationMove;
	else
		return NSDragOperationCopy;
	
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
	
	return YES;
	
}

- (void) _initiateDragOperation:(unsigned)favoriteIndex location:(NSPoint)dragStart event:(NSEvent*)theEvent  {
	
	NSSize dragOffset = NSMakeSize(0.0, 0.0);
    NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
	NSImage *dragImage = [(PDFavorite*)[_vFavorites objectAtIndex:favoriteIndex] image];
	
	//NSPoint diff;
	//dragOffset.width = [[_vFavorites objectAtIndex:favoriteIndex] idealSize].width/2;
	
	dragStart.x = dragStart.x - [dragImage size].width/2;
	dragStart.y = dragStart.y - [dragImage size].height/2;
	
    [pboard declareTypes:[NSArray arrayWithObjects:PDFavoritePboardType, nil] owner:self];
	[pboard setPropertyList:[_favorites objectAtIndex:favoriteIndex] forType:PDFavoritePboardType];
	
	[self removeFavoriteAtIndex:favoriteIndex];
 
    [self dragImage:dragImage at:dragStart offset:dragOffset event:theEvent pasteboard:pboard source:self slideBack:NO];
	
}

#pragma mark -

- (NSString*) _titleFromTitleSheet:(NSString*)defaultTitle {
	
	int result;
	NSString *returnValue;
	NSBundle *interfaceBundle = [NSBundle bundleWithIdentifier:@"com.sprouted.interface"];
	
	//
	// build the window and components
	NSRect contentRect = NSMakeRect(0,0,259,127);
	NSWindow *sheetWin = [[NSWindow alloc] initWithContentRect:contentRect styleMask:(NSTitledWindowMask|NSResizableWindowMask)
			backing:NSBackingStoreBuffered defer:YES];
	
	NSRect frameRect = [sheetWin frameRectForContentRect:contentRect];
	[sheetWin setMaxSize:NSMakeSize(600, frameRect.size.height)];
	[sheetWin setMinSize:NSMakeSize(259, frameRect.size.height)];
	
	NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(17,90,225,17)];
	[label setStringValue:NSLocalizedStringFromTableInBundle(@"Favorites Name",@"PDFavoritesBar",interfaceBundle,@"")];		// localize
	[label setSelectable:NO];
	[label setEditable:NO];
	[label setBezeled:NO];
	[label setBordered:NO];
	[label setDrawsBackground:NO];
	[[label cell] setControlSize:NSRegularControlSize];
	[label setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]]];
	
	NSTextField *title = [[NSTextField alloc] initWithFrame:NSMakeRect(20,60,219,22)];
	[title setStringValue:defaultTitle];
	[title setSelectable:YES];
	[title setEditable:YES];
	[title setBezeled:YES];
	[title setDrawsBackground:YES];
	[title setBezelStyle:NSTextFieldSquareBezel];
	[title setAutoresizingMask:NSViewWidthSizable];
	[[title cell] setScrollable:YES];
	[[title cell] setControlSize:NSRegularControlSize];
	[title setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]]];
	
	NSButton *cancel = [[NSButton alloc] initWithFrame:NSMakeRect(81,12,82,32)];
	[cancel setTarget:self];
	[cancel setAction:@selector(_cancelSheet:)];
	[cancel setTitle:NSLocalizedStringFromTableInBundle(@"Cancel",@"PDFavoritesBar",interfaceBundle,@"")];					// localize
	[cancel setBezelStyle:NSRoundedBezelStyle];
	[cancel setButtonType:NSMomentaryPushInButton];
	[cancel setKeyEquivalent:@"\E"];
	[cancel setAutoresizingMask:NSViewMinXMargin];
	[[cancel cell] setControlSize:NSRegularControlSize];
	[cancel setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]]];
	
	NSButton *okay = [[NSButton alloc] initWithFrame:NSMakeRect(163,12,82,32)];
	[okay setTarget:self];
	[okay setAction:@selector(_okaySheet:)];
	[okay setTitle:NSLocalizedStringFromTableInBundle(@"OK",@"PDFavoritesBar",interfaceBundle,@"")];							// localize
	[okay setBezelStyle:NSRoundedBezelStyle];
	[okay setButtonType:NSMomentaryPushInButton];
	[okay setAutoresizingMask:NSViewMinXMargin];
	[[okay cell] setControlSize:NSRegularControlSize];
	[okay setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]]];
	
	[[sheetWin contentView] addSubview:label];
	[[sheetWin contentView] addSubview:title];
	[[sheetWin contentView] addSubview:cancel];
	[[sheetWin contentView] addSubview:okay];
	
	[sheetWin setDefaultButtonCell:[okay cell]];
	
	//
	// set the frame
	NSString *winFrameStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"PDFavoritesBarWindowFrame"];
	if ( winFrameStr ) [sheetWin setFrameFromString:winFrameStr];
	
	//
	// run the sheet
	[NSApp beginSheet:sheetWin modalForWindow:[self window] modalDelegate: nil didEndSelector: nil contextInfo: nil];
	result = [NSApp runModalForWindow:sheetWin];
	
	[title validateEditing];
	
	[NSApp endSheet:sheetWin];
	[sheetWin close];
	
	//
	// grab the value
	if ( result != NSRunStoppedResponse )
		returnValue = nil;
	else
		returnValue = [title stringValue];
	
	//
	// save the frame
	winFrameStr = [sheetWin stringWithSavedFrame];
	[[NSUserDefaults standardUserDefaults] setObject:winFrameStr forKey:@"PDFavoritesBarWindowFrame"];
	
	//
	// clean up
	[cancel release];
	[okay release];
	[label release];
	[title release];
	//[sheetWin release];
	
	//
	// return the value
	return returnValue;
	
}

- (void) _okaySheet:(id)sender 
{	
	[NSApp stopModal];	
}

- (void) _cancelSheet:(id)sender 
{	
	[NSApp abortModal];	
}

#pragma mark -

- (BOOL)mouseDownCanMoveWindow 
{ 
	return NO;
}

- (NSRect) frameOfFavoriteAtIndex:(int)theIndex
{
	if ( theIndex >= [_vFavorites count] )
	{
		//NSLog(@"%@ %s - index %i is greater than avaible count %i", [self className], _cmd, theIndex, [_vFavorites count] - 1 );
		return NSZeroRect;
	}
	else
	{
		return [[_vFavorites objectAtIndex:theIndex] bounds];
	}
}

#pragma mark -

- (void) _toolbarDidChangeVisible:(NSNotification*)aNotification
{
	if ( [[self window] toolbar] == [aNotification object] )
		//[self _generateFavoriteViews:nil];
		[self _positionFavoriteViews:nil];
}

#pragma mark -

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem
{
	BOOL enabled = YES;
	SEL action = [menuItem action];
	
	if ( action == @selector(toggleDrawsLabels:) )
		[menuItem setState:( [self drawsLabels] ? NSOnState : NSOffState) ];
	
	return enabled;
}

@end
