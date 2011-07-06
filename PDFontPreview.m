//
//  PDFontPreview.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDFontPreview.h>
#import <SproutedInterface/PDFontDisplay.h>
#import <SproutedInterface/PDButtonColorWell.h>
#import <SproutedUtilities/NSUserDefaults+PDDefaultsAdditions.h>

@implementation PDFontPreview

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		
		NSRect	oldFrame;
		NSPoint buttonOrigin;
		
		//building the Set Font button from scratch
		changeFont = [[NSButton alloc] initWithFrame:NSMakeRect( frameRect.size.width-104, frameRect.size.height/2-16, 104, 32 )];
		[changeFont setButtonType:NSMomentaryPushInButton];
		[changeFont setBezelStyle:NSRoundedBezelStyle];
		[changeFont setBordered:YES];
		[changeFont setTarget:self];
		[changeFont setAction:@selector(selectFont:)];
		[changeFont setTitle:NSLocalizedStringFromTableInBundle(@"set font title", @"PDFontPreview", [NSBundle bundleWithIdentifier:@"com.sprouted.interface"], @"")];
		[changeFont sizeToFit];
		
		oldFrame = [changeFont frame];
		oldFrame.size.width+=10;
		[changeFont setFrame:oldFrame];
		
		buttonOrigin = NSMakePoint(frameRect.size.width - [changeFont frame].size.width, frameRect.size.height/2-16 - 1);
		
		[changeFont setFrameOrigin:buttonOrigin];
		[self addSubview:changeFont];
		
		//building the PDFontDisplay view from scratch
		fontDisplay = [[PDFontDisplay alloc] initWithFrame:
			NSMakeRect( 0, frameRect.size.height/2-13, buttonOrigin.x-25, 26 )];
		
		[self addSubview:fontDisplay];
		
		//building the Color button from scratch
		/*fontColor = [[NSColorWell alloc] initWithFrame:
			NSMakeRect( buttonOrigin.x-26, frameRect.size.height/2-13, 20, 26 )];*/
			
		fontColor = [[PDButtonColorWell alloc] initWithFrame:
				NSMakeRect( buttonOrigin.x-26, frameRect.size.height/2-13, 20, 26 )];
		[fontColor setColor:[NSColor blackColor]];
		//[fontColor setTarget:self];
		//[fontColor setAction:@selector(changeColor:)];
		
		[fontColor setTarget:self];
		[fontColor setAction:@selector(selectColor:)];

		[self addSubview:fontColor];
		
		//default font and color
		[self setFont:[NSFont systemFontOfSize:12.0]];
		[self setColor:[NSColor blackColor]];
		
		//default keys - you must change these values in your object's init or awakeFromNib code.
		
		_defaultsKey = [[NSString alloc] initWithString:@"FontDefault"];
		colorDefaultsKey = [[NSString alloc] initWithString:@"Color Preview Default"];
		
		//no target or selector
		target = nil;
		selector = nil;
		
	}
	return self;
}

- (void) dealloc {
	
	[_defaultsKey release];
		_defaultsKey = nil;
	
	[changeFont release];
		changeFont = nil;
	[fontDisplay release];
		fontDisplay = nil;

	[colorDefaultsKey release];
		colorDefaultsKey = nil;

	[fontColor release];
		fontColor = nil;
	[color release];
		color = nil;
	[font release];
		font = nil;
	
	[super dealloc];
}

#pragma mark -

- (NSString*) defaultsKey { return _defaultsKey; }

- (void) setDefaultsKey:(NSString*)aKey {
	
	if ( _defaultsKey != aKey ) {
		[_defaultsKey release];
		_defaultsKey = [aKey copyWithZone:[self zone]];
	}
	
	NSFont *aFont = [[NSUserDefaults standardUserDefaults] fontForKey:aKey];
	if ( aFont != nil ) [self setFont:aFont];
	
}

- (void) setColorDefaultsKey:(NSString*)newObject {
	
	if ( colorDefaultsKey != newObject ) {
		[colorDefaultsKey release];
		colorDefaultsKey = [newObject copyWithZone:[self zone]];
	}
	
	//and once we have our color, set the color and image well
	NSData *theData=[[NSUserDefaults standardUserDefaults] dataForKey:newObject];
	if (theData) {
		[self setColor:(NSColor *)[NSUnarchiver unarchiveObjectWithData:theData]];
		[fontColor setColor:[self color]];
	}
}

- (NSString*) colorDefaultsKey {
	return colorDefaultsKey;
}

#pragma mark -

- (void) setFont:(NSFont*)newObject {
	
	//copy our font object
	if ( font != newObject ) {
		[font release];
		font = [newObject copyWithZone:[self zone]];
	}
	
	//
	//set the defaults for size and name
	if ( [self defaultsKey] )
		[[NSUserDefaults standardUserDefaults] setFont:font forKey:[self defaultsKey]];
		
	//anytime we change our font, we must change the display font
	[fontDisplay setNeedsDisplay:YES];
	
}

- (NSFont*) font {
	return font;
}

- (void) setColor:(NSColor*)newObject {
	
	//copy the color into our object
	if ( color != newObject ) {
		[color release];
		color = [newObject copyWithZone:[self zone]];
	}
	
	//set the user default
	if ( [self colorDefaultsKey] )
		[[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:color] forKey:colorDefaultsKey];

	//anytime we change our color, we must change the display color
	[fontDisplay setNeedsDisplay:YES];
	
}

- (NSColor*) color {
	return color;
}


- (void) setColorHidden:(BOOL)hideColor {
	
	int dif = 0;
	
	//resize our font display accordingly
	if ( hideColor && ![fontColor isHidden] )
		dif += ([fontColor frame].size.width-1);
	else if ( !hideColor && [fontColor isHidden] )
		dif -= ([fontColor frame].size.width+-1);
	
	if ( dif ) {
		NSRect displayRect = [fontDisplay frame];
		displayRect.size.width += dif;
		[fontDisplay setFrame:displayRect];
	}
	
	//and pass the hiddenness on
	[fontColor setHidden:hideColor];
}

- (BOOL) colorHidden {
	return [fontColor isHidden];
}


- (void) setTarget:(id) newTarget {
	target = newTarget;
}

- (void) setAction:(SEL) newSelector {
	selector = newSelector;
}

#pragma mark -

- (void) selectFont:(id) sender {
	//set me to first responder so I catch font changes
	[[self window] makeFirstResponder:self];
	//set the font panel's current font
	[[NSFontPanel sharedFontPanel] setPanelFont:[self font] isMultiple:NO];
	//show the font panel
	[[NSFontPanel sharedFontPanel] makeKeyAndOrderFront:self];
}

- (void) selectColor:(id) sender {
	[[self window] makeFirstResponder:fontColor];
	[[NSColorPanel sharedColorPanel] setColor:[self color]];
	[NSApp orderFrontColorPanel:fontColor];
}

- (void) changeColor:(id) sender {
	//send it off to our display
	[self setColor:[sender color]];
	[fontColor setColor:[sender color]];
	//and send our action
	if ( target && selector ) [target performSelector:selector withObject:self];
}

- (void)changeFont:(id)sender {
   
	NSFont *oldFont = [self font]; 
	NSFont *newFont = [sender convertFont:oldFont]; 
   
	[self setFont:newFont]; 
	
	//and send our action
	if ( target && selector ) [target performSelector:selector withObject:self];
}

- (void)drawRect:(NSRect)rect
{
	/*
	This view does not draw anything.  It's simply a superview which abstractly manages 
	its component parts, making it simpler for the programmer and user to interact with them.
	*/
}

@end
