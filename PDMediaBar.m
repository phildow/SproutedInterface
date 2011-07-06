//
//  PDMediaBar.m
//  SproutedInterface
//
//  Created by Philip Dow on 2/21/07.
//  Copyright Sprouted. All rights reserved.
//

#import <SproutedInterface/PDMediaBar.h>
#import <SproutedInterface/PDMediabarItem.h>
#import <SproutedInterface/NewMediabarItemController.h>

@implementation PDMediaBar

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		
		[self setPostsFrameChangedNotifications:YES];
		[[NSNotificationCenter defaultCenter] addObserver:self 
		selector:@selector(_didChangeFrame:) name:NSViewFrameDidChangeNotification object:self];
    }
    return self;
}

- (void) dealloc
{
	[prefsIdentifier release];
	[barDictionary release];
	[itemIdentifiers release];
	[customItemDictionaries release];
	[itemArray release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewFrameDidChangeNotification object:self];
	
	[super dealloc];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	
	[super drawRect:rect];
}

- (BOOL)mouseDownCanMoveWindow
{
	return NO;
}

#pragma mark -

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	if ( ![[self delegate] canCustomizeMediabar:self] )
		return nil;
	
	float xMargin = [self bounds].size.width;
	float barHeight = [self bounds].size.height;
	
	NSPoint local_point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	PDMediabarItem *anItem, *representedItem = nil;
	NSEnumerator* enumerator = [itemArray objectEnumerator];
	
	while ( anItem = [enumerator nextObject] )
	{
		xMargin -= 4;
		xMargin -= [anItem frame].size.width;
		
		NSRect itemFrame = NSMakeRect(	xMargin, barHeight/2 - [anItem frame].size.height/2, 
										[anItem frame].size.width, [anItem frame].size.height);
		
		if ( [self mouse:local_point inRect:itemFrame] )
		{
			representedItem = anItem;
			break;
		}
	}

	NSBundle *myBundle = [NSBundle bundleWithIdentifier:@"com.sprouted.interface"];
	
	NSMenu *contextMenu = [[[NSMenu alloc] initWithTitle:[NSString string]] autorelease];
	
	NSMenuItem *addItem = [[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"add item title", @"Mediabar", myBundle, @"") 
	action:@selector(addCustomMediabarItem:) keyEquivalent:[NSString string]] autorelease];
	
	[addItem setTarget:self];
	[addItem setRepresentedObject:representedItem];
	
	[contextMenu addItem:addItem];
	
	NSMenuItem *editItem = [[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"edit item title", @"Mediabar", myBundle, @"") 
	action:@selector(editCustomMediabarItem:) keyEquivalent:[NSString string]] autorelease];
	
	[editItem setTarget:self];
	[editItem setRepresentedObject:representedItem];
	
	[contextMenu addItem:editItem];
	
	NSMenuItem *removeItem = [[[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"remove item title", @"Mediabar", myBundle, @"")
	action:@selector(removeCustomMediabarItem:) keyEquivalent:[NSString string]] autorelease];
	
	[removeItem setTarget:self];
	[removeItem setRepresentedObject:representedItem];
	
	[contextMenu addItem:removeItem];
	
	return contextMenu;

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

#pragma mark -

- (NSString*)prefsIdentifier
{
	return prefsIdentifier;
}

- (void) setPrefsIdentifier:(NSString*)aString
{
	if ( prefsIdentifier != aString )
	{
		[prefsIdentifier release];
		prefsIdentifier = [aString copyWithZone:[self zone]];
	}
}

- (NSDictionary*)barDictionary
{
	return barDictionary;
}

- (void) setBarDictionary:(NSDictionary*)aDictionary
{
	if ( barDictionary != aDictionary )
	{
		[barDictionary release];
		barDictionary = [aDictionary copyWithZone:[self zone]];
	}
}

- (NSArray*)itemIdentifiers
{
	return itemIdentifiers;
}

- (void) setItemIdentifiers:(NSArray*)anArray
{
	if ( itemIdentifiers != anArray )
	{
		[itemIdentifiers release];
		itemIdentifiers = [anArray copyWithZone:[self zone]];
	}
}

- (NSArray*)customItemDictionaries
{
	return customItemDictionaries;
}

- (void) setCustomItemDictionaries:(NSArray*)anArray
{
	if ( customItemDictionaries != anArray )
	{
		[customItemDictionaries release];
		customItemDictionaries = [anArray copyWithZone:[self zone]];
	}
}

- (NSArray*) itemArray
{
	return itemArray;
}

- (void) setItemArray:(NSArray*)anArray
{
	if ( itemArray != anArray )
	{
		[itemArray release];
		itemArray = [anArray copyWithZone:[self zone]];
	}
}

#pragma mark -

- (void) loadItems
{
	if ( ![[self delegate] canCustomizeMediabar:self] )
		return;
	
	// clear out the old items first
	NSView *aView;
	NSEnumerator *enumerator = [[self itemArray] objectEnumerator];
		
	while ( aView = [enumerator nextObject] )
		[aView removeFromSuperview];
	
	// load in the new ones
	NSMutableArray *myItems = [NSMutableArray array];
	
	// build the bar from our defaults and from preferences
	NSString *myPrefsIdentifier = [NSString stringWithFormat:@"PDMediaBar Configuration %@", [[self delegate] mediabarIdentifier:self]];
	NSDictionary *myBarDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:myPrefsIdentifier];
	
	NSArray *myItemIdentifiers = nil;
	NSArray *myCustomItemDictionaries = nil;
	
	if ( myBarDictionary == nil || ( myItemIdentifiers = [myBarDictionary objectForKey:@"ItemIdentifiers"] ) == nil )
	{
		myItemIdentifiers = [[self delegate] mediabarDefaultItemIdentifiers:self];
		myBarDictionary = [NSDictionary dictionaryWithObject:myItemIdentifiers forKey:@"ItemIdentifiers"];
		[[NSUserDefaults standardUserDefaults] setObject:myBarDictionary forKey:myPrefsIdentifier];
	}
	else
		myCustomItemDictionaries = [myBarDictionary objectForKey:@"CustomItemDictionaries"];
	
	[self setPrefsIdentifier:myPrefsIdentifier];
	[self setBarDictionary:myBarDictionary];
	[self setItemIdentifiers:myItemIdentifiers];
	[self setCustomItemDictionaries:myCustomItemDictionaries];
	
	NSString *anIdentifier;
	enumerator = [itemIdentifiers objectEnumerator];
	
	while ( anIdentifier = [enumerator nextObject] )
	{
		PDMediabarItem *anItem = [[self delegate] mediabar:self itemForItemIdentifier:anIdentifier willBeInsertedIntoMediabar:YES];
		if ( anItem != nil )
		{
			[anItem setMediabar:self];
			[myItems addObject:anItem];
		}
		else
		{
			// try building a custom item from it
			if ( customItemDictionaries == nil )
			{
				NSLog(@"%@ %s - no custom properties in prefs, unabe to build a custom item for media bar %@, item identifier %@", 
				[[self delegate] className], _cmd, [[self delegate] mediabarIdentifier:self], anIdentifier );
				continue;
			}
			
			// find the item in our customs list
			NSDictionary *aDictionary;
			NSEnumerator *dictionariesEnumerator = [customItemDictionaries objectEnumerator];
			
			while ( aDictionary = [dictionariesEnumerator nextObject] )
			{
				if ( [anIdentifier isEqualToString:[aDictionary objectForKey:@"identifier"]] )
				{
					anItem = [[[PDMediabarItem alloc] initWithDictionaryRepresentation:aDictionary] autorelease];
					if ( anItem == nil )
						NSLog(@"%@ %s - unable to initalize media bar item from dictionary %@", [[self delegate] className], _cmd, aDictionary);
					else
					{
						[anItem setTarget:[self delegate]];
						[anItem setAction:@selector(perfomCustomMediabarItemAction:)];
						
						[anItem setMediabar:self];
						[myItems addObject:anItem];
					}
					
					break;
				}
			}
		}
	}
	
	[self setItemArray:myItems];
}

- (void) displayItems
{
	if ( ![[self delegate] canCustomizeMediabar:self] )
		return;
	
	/*
	NSView *aView;
	NSEnumerator *enumerator = [[self itemArray] objectEnumerator];
		
	while ( aView = [enumerator nextObject] )
		[aView removeFromSuperview];
	*/
	
	float xMargin = [self bounds].size.width;
	float barHeight = [self bounds].size.height;
	float minWidth = [[self delegate] mediabarMinimumWidthForUnmanagedControls:self];
	
	PDMediabarItem *anItem;
	NSEnumerator *enumerator = [itemArray objectEnumerator];
	
	while ( anItem = [enumerator nextObject] )
	{
		xMargin -= 4;
		xMargin -= [anItem frame].size.width;
		
		NSRect itemFrame = NSMakeRect(	xMargin, barHeight/2 - [anItem frame].size.height/2, 
										[anItem frame].size.width, [anItem frame].size.height);
		[anItem setFrame:itemFrame];
		[self addSubview:anItem];
		
		if ( xMargin < minWidth )
			[anItem setHidden:YES];
		else
			[anItem setHidden:NO];
	}
}

#pragma mark -

- (IBAction) removeCustomMediabarItem:(id)sender
{
	if ( ![[self delegate] canCustomizeMediabar:self] )
		return;
	
	[self _removeCustomMediabarItem:[sender representedObject]];
}

- (IBAction) editCustomMediabarItem:(id)sender
{
	if ( ![[self delegate] canCustomizeMediabar:self] )
		return;
	
	[self _editCustomMediabarItem:[sender representedObject]];
}

#pragma mark -

- (void) _removeCustomMediabarItem:(PDMediabarItem*)anItem
{
	// reset the preferences
	NSMutableDictionary *myBarDictionary = [[[self barDictionary] mutableCopyWithZone:[self zone]] autorelease];
	if ( myBarDictionary == nil ) myBarDictionary = [NSMutableDictionary dictionary];
	
	NSMutableArray *myItemIdentifiers = nil;
	NSMutableArray *myCustomItemDictionaries = nil;

	if ( myBarDictionary == nil || ( myItemIdentifiers = [[[myBarDictionary objectForKey:@"ItemIdentifiers"] mutableCopyWithZone:[self zone]] autorelease] ) == nil )
	{
		myItemIdentifiers = [[[[self delegate] mediabarDefaultItemIdentifiers:self] mutableCopyWithZone:[self zone]] autorelease];
		myCustomItemDictionaries = [NSMutableArray array];
		
		myBarDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				myItemIdentifiers, @"ItemIdentifiers",
				myCustomItemDictionaries, @"CustomItemDictionaries", nil];
	}
	else
	{
		myCustomItemDictionaries = [[[myBarDictionary objectForKey:@"CustomItemDictionaries"] mutableCopyWithZone:[self zone]] autorelease];
		if ( myCustomItemDictionaries == nil )
			myCustomItemDictionaries = [NSMutableArray array];
	}
	
	int itemIdentifierIndex = [myItemIdentifiers indexOfObject:[anItem identifier]];
	if ( itemIdentifierIndex != NSNotFound )
		[myItemIdentifiers removeObjectAtIndex:itemIdentifierIndex];
	else
		NSLog(@"%@ %s - unable to remove item with identifier %@", [self className], _cmd, [anItem identifier]);
	
	int dictionaryIndex = [[myCustomItemDictionaries valueForKey:@"identifier"] indexOfObject:[anItem identifier]];
	if ( dictionaryIndex != NSNotFound )
		[myCustomItemDictionaries removeObjectAtIndex:dictionaryIndex];
	else
		NSLog(@"%@ %s - unable to remove item with identifier %@", [self className], _cmd, [anItem identifier]);
	
	// reset the items in the dictinoary
	[myBarDictionary setObject:myItemIdentifiers forKey:@"ItemIdentifiers"];
	[myBarDictionary setObject:myCustomItemDictionaries forKey:@"CustomItemDictionaries"];
	
	// reset the preferences
	[[NSUserDefaults standardUserDefaults] setObject:myBarDictionary forKey:prefsIdentifier];
	
	// reset our local representation
	[self setCustomItemDictionaries:myCustomItemDictionaries];
	[self setItemIdentifiers:myItemIdentifiers];
	[self setBarDictionary:myBarDictionary];
	
	// remove the item from the display
	[anItem removeFromSuperview];
	
	// rebuild the bar
	[self loadItems];
	[self displayItems];
	
	[self setNeedsDisplay:YES];
}

- (void) _editCustomMediabarItem:(PDMediabarItem*)anItem
{
	NewMediabarItemController *itemCreator = [[[NewMediabarItemController alloc] 
	initWithDictionaryRepresentation:[anItem dictionaryRepresentation]] autorelease];
		
	[itemCreator setDelegate:self];
	[itemCreator setRepresentedObject:anItem];
	[itemCreator runAsSheetForWindow:[self window] attached:NO location:NSMakeRect(0,0,0,0)];
}

#pragma mark -

- (IBAction) addCustomMediabarItem:(id)sender
{
	// subclasses may override to provide custom behavior
	if ( [[self delegate] canCustomizeMediabar:self] )
	{
		NewMediabarItemController *itemCreator = [[[NewMediabarItemController alloc] init] autorelease];
		
		[itemCreator setDelegate:self];
		[itemCreator runAsSheetForWindow:[self window] attached:NO location:NSMakeRect(0,0,0,0)];
	}	
	
	else
	{
		NSBeep();
	}
}

- (void) mediabarItemCreateDidSaveAction:(NewMediabarItemController*)mediabarItemCreator
{
	PDMediabarItem *theRepresentedObject = [mediabarItemCreator representedObject];
	
	// create a new item if no item is being edited
	if ( theRepresentedObject == nil )
	{
	
		// the delegate method from the media bar item creator - subclasses may override if they wish
		NSDictionary *dictionaryRepresentation = [mediabarItemCreator dictionaryRepresentation];
		
		// reset the preferences
		NSMutableDictionary *myBarDictionary = [[[self barDictionary] mutableCopyWithZone:[self zone]] autorelease];
		if ( myBarDictionary == nil ) myBarDictionary = [NSMutableDictionary dictionary];
		
		NSMutableArray *myItemIdentifiers = nil;
		NSMutableArray *myCustomItemDictionaries = nil;

		if ( myBarDictionary == nil || ( myItemIdentifiers = [[[myBarDictionary objectForKey:@"ItemIdentifiers"] mutableCopyWithZone:[self zone]] autorelease] ) == nil )
		{
			myItemIdentifiers = [[[[self delegate] mediabarDefaultItemIdentifiers:self] mutableCopyWithZone:[self zone]] autorelease];
			myCustomItemDictionaries = [NSMutableArray array];
			
			myBarDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					myItemIdentifiers, @"ItemIdentifiers",
					myCustomItemDictionaries, @"CustomItemDictionaries", nil];
		}
		else
		{
			myCustomItemDictionaries = [[[myBarDictionary objectForKey:@"CustomItemDictionaries"] mutableCopyWithZone:[self zone]] autorelease];
			if ( myCustomItemDictionaries == nil )
				myCustomItemDictionaries = [NSMutableArray array];
		}
		
		[myItemIdentifiers addObject:[dictionaryRepresentation objectForKey:@"identifier"]];
		[myCustomItemDictionaries addObject:dictionaryRepresentation];
		
		[myBarDictionary setObject:myItemIdentifiers forKey:@"ItemIdentifiers"];
		[myBarDictionary setObject:myCustomItemDictionaries forKey:@"CustomItemDictionaries"];
		
		[[NSUserDefaults standardUserDefaults] setObject:myBarDictionary forKey:prefsIdentifier];
		
		[self setCustomItemDictionaries:myCustomItemDictionaries];
		[self setItemIdentifiers:myItemIdentifiers];
		[self setBarDictionary:myBarDictionary];
		
		// rebuild the bar
		[self loadItems];
		[self displayItems];
	
	}
	
	// modify the represented item if one was being edited
	else
	{
		// the delegate method from the media bar item creator - subclasses may override if they wish
		
		NSDictionary *dictionaryRepresentation = [mediabarItemCreator dictionaryRepresentation];
		
		// save the preferences
		NSMutableDictionary *myBarDictionary = [[[self barDictionary] mutableCopyWithZone:[self zone]] autorelease];
		if ( myBarDictionary == nil ) myBarDictionary = [NSMutableDictionary dictionary];
		
		NSMutableArray *myItemIdentifiers = nil;
		NSMutableArray *myCustomItemDictionaries = nil;

		if ( myBarDictionary == nil || ( myItemIdentifiers = [[[myBarDictionary objectForKey:@"ItemIdentifiers"] mutableCopyWithZone:[self zone]] autorelease] ) == nil )
		{
			myItemIdentifiers = [[[[self delegate] mediabarDefaultItemIdentifiers:self] mutableCopyWithZone:[self zone]] autorelease];
			myCustomItemDictionaries = [NSMutableArray array];
			
			myBarDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					myItemIdentifiers, @"ItemIdentifiers",
					myCustomItemDictionaries, @"CustomItemDictionaries", nil];
		}
		else
		{
			myCustomItemDictionaries = [[[myBarDictionary objectForKey:@"CustomItemDictionaries"] mutableCopyWithZone:[self zone]] autorelease];
			if ( myCustomItemDictionaries == nil )
				myCustomItemDictionaries = [NSMutableArray array];
		}
		
		/*
		int itemIdentifierIndex = [myItemIdentifiers indexOfObject:[theRepresentedObject identifier]];
		if ( itemIdentifierIndex != NSNotFound )
			[myItemIdentifiers removeObjectAtIndex:itemIdentifierIndex];
		else
			NSLog(@"%@ %s - unable to remove item with identifier %@", [self className], _cmd, [theRepresentedObject identifier]);
		*/
		
		int dictionaryIndex = [[myCustomItemDictionaries valueForKey:@"identifier"] indexOfObject:[theRepresentedObject identifier]];
		if ( dictionaryIndex != NSNotFound )
			[myCustomItemDictionaries replaceObjectAtIndex:dictionaryIndex withObject:dictionaryRepresentation];
		else
			NSLog(@"%@ %s - unable to edit item with identifier %@", [self className], _cmd, [theRepresentedObject identifier]);
		
		// reset the items in the dictinoary
		[myBarDictionary setObject:myItemIdentifiers forKey:@"ItemIdentifiers"];
		[myBarDictionary setObject:myCustomItemDictionaries forKey:@"CustomItemDictionaries"];
		
		// reset the preferences
		[[NSUserDefaults standardUserDefaults] setObject:myBarDictionary forKey:prefsIdentifier];
		
		// reset our local representation
		[self setCustomItemDictionaries:myCustomItemDictionaries];
		[self setItemIdentifiers:myItemIdentifiers];
		[self setBarDictionary:myBarDictionary];
		
		// re-attribute the item
		[theRepresentedObject setAttributesFromDictionaryRepresentation:dictionaryRepresentation];

	}
	
	[self setNeedsDisplay:YES];
}

#pragma mark -

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem
{
	BOOL enabled = YES;
	SEL action = [menuItem action];
	
	if ( ![[self delegate] canCustomizeMediabar:self] )
		return NO;
	
	
	if ( action == @selector(addCustomMediabarItem:) )
		enabled = YES;
	
	else if ( action == @selector(editCustomMediabarItem:) )
		enabled = ( [[menuItem representedObject] isKindOfClass:[PDMediabarItem class]] && ( [[[menuItem representedObject] typeIdentifier] intValue] != kMenubarItemDefault ) );
	
	else if ( action == @selector(removeCustomMediabarItem:) )
		enabled = ( [[menuItem representedObject] isKindOfClass:[PDMediabarItem class]] && ( [[[menuItem representedObject] typeIdentifier] intValue] != kMenubarItemDefault ) );
	
	return enabled;
}

#pragma mark -

- (void) _didChangeFrame:(NSNotification*)aNotification
{
	float minWidth = [[self delegate] mediabarMinimumWidthForUnmanagedControls:self];
	float xMargin = [self bounds].size.width;
		
	PDMediabarItem *anItem;
	NSEnumerator *enumerator = [itemArray objectEnumerator];
	
	while ( anItem = [enumerator nextObject] )
	{
		xMargin -= 4;
		xMargin -= [anItem frame].size.width;
		
		if ( xMargin < minWidth )
			[anItem setHidden:YES];
		else
			[anItem setHidden:NO];
	}
}

@end
