//
//  LabelPicker.m
//  SproutedInterface
//
//  Created by Philip Dow on 11/12/05.
//  Copyright 2005 Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/LabelPicker.h>
#import <SproutedUtilities/PDUtilityDefinitions.h>
#import <SproutedUtilities/SproutedLabelConverter.h>

@implementation LabelPicker

+ (void)initialize
{
	if ( self == [LabelPicker class] ) 
	{
		[self exposeBinding:@"labelSelection"];
	}
}

- (id)initWithFrame:(NSRect)frame 
{
    if ( self = [super initWithFrame:frame] ) 
	{
        // Initialization code here.
		_labelImage = [BundledImageWithName(@"labelall.tif", @"com.sprouted.interface") retain];
		if ( _labelImage == nil ) NSLog(@"%@ %s - labelall.tif not found!",[self className],_cmd);
		
		_labelSelectedImage = [BundledImageWithName(@"labelselected.tif", @"com.sprouted.interface") retain];
		if ( _labelSelectedImage == nil ) NSLog(@"%@ %s - labelselected.tif not found!",[self className],_cmd);
		
		_labelHoverImage = [BundledImageWithName(@"labelhover.tif", @"com.sprouted.interface") retain];
		if ( _labelSelectedImage == nil ) NSLog(@"%@ %s - labelhover.tif not found!",[self className],_cmd);
		
		_clearRect = NSMakeRect(0,0,17,16);
		
		_redRect = NSMakeRect(22,0,17,16);
		_orangeRect = NSMakeRect(40,0,17,16);
		_yellowRect = NSMakeRect(58,0,17,16);
		
		_greenRect = NSMakeRect(76,0,17,16);
		_blueRect = NSMakeRect(94,0,17,16);
		_purpleRect = NSMakeRect(112,0,17,16);
		_greyRect = NSMakeRect(130,0,17,16);
		
		_target = nil;
		_tag = 0;
    }
	
    return self;
}

- (void) dealloc 
{
	[_labelImage release], _labelImage = nil;
	[_labelSelectedImage release], _labelSelectedImage = nil;
	[_labelHoverImage release], _labelHoverImage = nil;
	
	[super dealloc];
}

#pragma mark -

- (NSInteger) tag 
{ 
	return _tag; 
}

- (void) setTag:(NSInteger)aTag 
{
	_tag = aTag;
}

- (id) target 
{ 
	return _target;
}

- (void) setTarget:(id)targetObject 
{
	_target = targetObject;
}

- (SEL) action { 
	return _selector; 
}

- (void) setAction:(SEL)targetSelector 
{
	_selector = targetSelector;
}

- (NSInteger) labelSelection 
{
	return _labelSelection;
}

- (void) setLabelSelection:(NSInteger)value 
{
	[self willChangeValueForKey:@"labelSelection"];
	_labelSelection = value;
	[self didChangeValueForKey:@"labelSelection"];
	[self setNeedsDisplay:YES];
}

#pragma mark -

- (void)drawRect:(NSRect)rect 
{ 
	NSRect bds = [self bounds];
	NSRect targetSelectionRect;
	
	NSRect selectionRect = NSMakeRect(	0, 0,
										[_labelSelectedImage size].width,
										[_labelSelectedImage size].height );
	
	NSRect sourceRect = NSMakeRect(	0, 0,
									[_labelImage size].width,
									[_labelImage size].height) ;
		
	NSRect destinationRect = NSMakeRect(0, 
										bds.size.height/2 - sourceRect.size.height/2,
										sourceRect.size.width, 
										sourceRect.size.height );
			
	switch ( [self labelSelection] ) 
	{
		case 1:
			targetSelectionRect = _redRect;
			break;
		case 2:
			targetSelectionRect = _orangeRect;
			break;
		case 3:
			targetSelectionRect = _yellowRect;
			break;
		case 4:
			targetSelectionRect = _greenRect;
			break;
		case 5:
			targetSelectionRect = _blueRect;
			break;
		case 6:
			targetSelectionRect = _purpleRect;
			break;
		 case 7:
			targetSelectionRect = _greyRect;
			break;
	}
	
	if ( [self labelSelection] ) 
	{
		// target the selection image
		targetSelectionRect.size.height += ( bds.size.height/2 - targetSelectionRect.size.height/2 );
		[_labelSelectedImage drawInRect:targetSelectionRect 
				fromRect:selectionRect
				operation:NSCompositeSourceOver 
				fraction:1.0];
		
		// draw this particular color back over it
	}
	
	[_labelImage drawInRect:destinationRect 
			fromRect:sourceRect 
			operation:NSCompositeSourceOver 
			fraction:1.0];
}

#pragma mark -

- (void)mouseMoved:(NSEvent *)theEvent 
{	
	NSPoint mouseLoc;
	NSInteger myX, myY;
	
	mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	myX = mouseLoc.x;
	myY = mouseLoc.y;
}

- (BOOL)mouseDownCanMoveWindow 
{
	return NO;
}

- (void)mouseDown:(NSEvent *)theEvent 
{	
	NSPoint mouseLoc;
	NSInteger myX, myY;
	NSInteger newPoint = -1;
	
	mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	myX = mouseLoc.x;
	myY = mouseLoc.y;
	
	if ( _labelSelection != 0 && NSPointInRect(mouseLoc,_clearRect) )
		newPoint = 0;
	else if ( _labelSelection != 1 && NSPointInRect(mouseLoc,_redRect) )
		newPoint = 1;
	else if ( _labelSelection != 2 && NSPointInRect(mouseLoc,_orangeRect) )
		newPoint = 2;
	else if ( _labelSelection != 3 && NSPointInRect(mouseLoc,_yellowRect) )
		newPoint = 3;
	else if ( _labelSelection != 4 && NSPointInRect(mouseLoc,_greenRect) )
		newPoint = 4;
	else if ( _labelSelection != 5 && NSPointInRect(mouseLoc,_blueRect) )
		newPoint = 5;
	else if ( _labelSelection != 6 && NSPointInRect(mouseLoc,_purpleRect) )
		newPoint = 6;
	else if ( _labelSelection != 7 && NSPointInRect(mouseLoc,_greyRect) )
		newPoint = 7;
	
	if ( newPoint != -1 ) 
	{
		[self setLabelSelection:newPoint];
		
		if ( _target && [_target respondsToSelector:_selector] )
			[_target performSelector:_selector withObject:self];
	}
}

#pragma mark -

+ (NSInteger) finderEquivalentForPickerLabel:(NSInteger)value
{
	return [SproutedLabelConverter finderEquivalentForSproutedLabel:value];
}

+ (NSInteger) pickerEquivalentForFinderLabel:(NSInteger)value
{
	return [SproutedLabelConverter sproutedEquivalentForFinderLabel:value];
}


@end
