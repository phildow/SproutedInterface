//
//  PDFavorite.m
//  SproutedInterface
//
//  Created by Philip Dow on 3/17/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDFavorite.h>

#import <SproutedUtilities/NSBezierPath_AMShading.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>
#import <SproutedUtilities/NSColor_JournlerAdditions.h>

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
				[NSColor colorWithCalibratedRed:0.20 green:0.20 blue:0.20 alpha:1.0], NSForegroundColorAttributeName,
				paragraphStyle, NSParagraphStyleAttributeName, nil];
	}
	return textAttributes;
}

static NSDictionary* HoverTitleAttributes()
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
				[NSColor colorWithCalibratedRed:0.98 green:0.98 blue:0.98 alpha:1.0], NSForegroundColorAttributeName,
				paragraphStyle, NSParagraphStyleAttributeName, nil];
	}
	return textAttributes;
}

@implementation PDFavorite

- (id) initWithFrame:(NSRect)frame title:(NSString*)title identifier:(id)identifier {
	
	if ( self = [self initWithFrame:frame] ) {
		
		_state = PDFavoriteNoHover;
		_idealSize.width = -1;
		
		label = 0;
		
		if ( title )
			_title = [title copyWithZone:[self zone]];
		else
			_title = [[NSString alloc] initWithString:@""];
		
		if ( identifier )
			_identifier = [identifier copyWithZone:[self zone]];
		else
			_identifier = [[NSString alloc] initWithString:@""];
			
	}
	
	return self;
	
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) dealloc {
	
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	[_title release];
	[_identifier release];
	
	[super dealloc];
}

#pragma mark -

- (void)drawRect:(NSRect)rect 
{
    // Drawing code here.
	
	NSRect bds = [self bounds];
	NSAttributedString *textStr;
	
	NSRect stateRect = bds;
	NSBezierPath *roundedRect;
	
	switch ( _state ) {
		
		case PDFavoriteHover:
			
			stateRect.origin.x+=1; stateRect.origin.y+=2; stateRect.size.width-=1; stateRect.size.height-=5;
		
			roundedRect = [NSBezierPath bezierPathWithRoundedRect:stateRect cornerRadius:8.0];
			[[NSColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:1.0] set];
			[roundedRect fill];
			
			textStr = [self generateHoverAttributedTitle:[self title]];
			break;
		
		case PDFavoriteMouseDown:
			
			stateRect.origin.x+=1; stateRect.origin.y+=2; stateRect.size.width-=1; stateRect.size.height-=5;
		
			roundedRect = [NSBezierPath bezierPathWithRoundedRect:stateRect cornerRadius:8.0];
			[[NSColor colorWithCalibratedRed:0.45 green:0.45 blue:0.45 alpha:1.0] set];
			[roundedRect fill];
			
			textStr = [self generateHoverAttributedTitle:[self title]];
			break;
		
		default:
			
			if ( [self drawsLabel] && [self label] != 0 )
			{
				stateRect.origin.x+=1; stateRect.origin.y+=2; stateRect.size.width-=1; stateRect.size.height-=5;
				[self _drawLabel:stateRect];
			}
			
			textStr = [self generateAttributedTitle:[self title]];
			break;
		
	}
	
	NSSize strSize = [textStr size];
	NSRect strBds = NSMakeRect(	bds.size.width/2-strSize.width/2,
								bds.size.height/2-strSize.height/2,
								strSize.width, strSize.height );
	
		
	[textStr drawInRect:strBds];
	
}

- (void) _drawLabel:(NSRect)rect
{
	NSRect inset = rect;
	NSColor *gradientStart = [NSColor colorForLabel:[self label] gradientEnd:YES];
	NSColor *gradientEnd = [NSColor colorForLabel:[self label] gradientEnd:NO];
	NSBezierPath *aPath = [NSBezierPath bezierPathWithRoundedRect:inset cornerRadius:8.0]; // 7.3
	
	[[NSColor colorWithCalibratedWhite:0.6 alpha:1.0] set];
	[aPath linearGradientFillWithStartColor:gradientStart endColor:gradientEnd];
}

#pragma mark -

- (NSString*) title { return _title; }

- (void) setTitle:(NSString*)title {
	if ( _title != title ) {
		[_title release];
		_title = [title copyWithZone:[self zone]];
	}
}


- (id) identifier { return _identifier; }

- (void) setIdentifier:(id)identifier {
	if ( _identifier != identifier ) {
		[_identifier release];
		_identifier = [identifier copyWithZone:[self zone]];
	}
}

- (int) state { return _state; }

- (void) setState:(int)state {
	
	_state = state;
	
}

- (int) label
{
	return label;
}

- (void) setLabel:(int)aLabel
{
	label = aLabel;
	[self setNeedsDisplay:YES];
}

- (BOOL) drawsLabel
{
	return drawsLabel;
}

- (void) setDrawsLabel:(BOOL)draws
{
	drawsLabel = draws;
	[self setNeedsDisplay:YES];
}

#pragma mark -

- (NSAttributedString*) generateAttributedTitle:(NSString*)title 
{	
	NSAttributedString *attrString = [[NSAttributedString alloc] 
			initWithString:( title != nil ? title : @"" ) attributes:TitleAttributes()];
	
	return [attrString autorelease];
}

- (NSAttributedString*) generateHoverAttributedTitle:(NSString*)title 
{
	NSAttributedString *attrString = [[NSAttributedString alloc] 
			initWithString:( title != nil ? title : @"" ) attributes:HoverTitleAttributes()];

	return [attrString autorelease];
}

- (NSSize) idealSize {
	
	if ( _idealSize.width != -1 )
		
		return _idealSize;
	
	else {
	
		NSAttributedString *theAttributedTitle = [self generateAttributedTitle:[self title]];
		
		_idealSize = [theAttributedTitle size];
		_idealSize.width+=16;
		
		// for extra label color
		_idealSize.width+=4;
		
		return _idealSize;
	
	}
}

- (NSImage*) image {
	
	NSRect bds = [self bounds];
	NSAttributedString *textStr;
	
	NSRect stateRect = bds;
	NSBezierPath *roundedRect;
	
	NSSize idealSize = [self idealSize];
	idealSize.height = 22;
	
	NSImage *returnImage = [[NSImage alloc] initWithSize:idealSize];
	
	[returnImage lockFocus];
	
	stateRect.origin.x+=1; stateRect.origin.y+=2; stateRect.size.width-=1; stateRect.size.height-=5;
		
	roundedRect = [NSBezierPath bezierPathWithRoundedRect:stateRect cornerRadius:10.0];
	[[NSColor colorWithCalibratedRed:0.45 green:0.45 blue:0.45 alpha:1.0] set];
	[roundedRect fill];

	textStr = [self generateHoverAttributedTitle:[self title]];
	
	NSSize strSize = [textStr size];
	NSRect strBds = NSMakeRect(	bds.size.width/2-strSize.width/2,
								bds.size.height/2-strSize.height/2,
								strSize.width, strSize.height );
	
	[textStr drawInRect:strBds];
	
	[returnImage unlockFocus];
	
	return [returnImage autorelease];
	
}

#pragma mark -

- (BOOL)mouseDownCanMoveWindow 
{ 
	return NO;
}

@end
