//
//  PDDateDisplayCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/31/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDDateDisplayCell.h>

#define kEdgeInset 2
static NSString *shorter_time = @"HH:mm";

@implementation PDDateDisplayCell

//
// cells are copied, which means a formatter can be shared across the cells
// as the cells are resized, the smallest cell can determine the formatter's behavior across the board

- (BOOL) isSelected
{
	return selected;
}

- (void) setSelected:(BOOL)isSelected
{
	selected = isSelected;
}

- (BOOL) boldsWhenSelected
{
	return boldsWhenSelected;
}

- (void) setBoldsWhenSelected:(BOOL)doesBold
{
	boldsWhenSelected = doesBold;
}

#pragma mark -

- copyWithZone:(NSZone *)zone {
    PDDateDisplayCell *cell = (PDDateDisplayCell *)[super copyWithZone:zone];
    //cell->_formatter = [_formatter retain];
	cell->_dayFormatter = [_dayFormatter retain];
	cell->_timeFormatter = [_timeFormatter retain];
	
	cell->widthWas = widthWas;
	cell->alreadyJumpedOnNoTime = alreadyJumpedOnNoTime;
	
	cell->selected = selected;
	cell->boldsWhenSelected = boldsWhenSelected;
	
    return cell;
}

- (void ) dealoc {
	if ( _dayFormatter ) [_dayFormatter release];
	if ( _timeFormatter ) [_timeFormatter release];
}

- (NSColor*) textColor {
	
	//if ( [self isHighlighted] && ([[[self controlView] window] firstResponder] == [self controlView]) && 
	//		[[[self controlView] window] isMainWindow] && [[[self controlView] window] isKeyWindow] )
	//	return [NSColor whiteColor];
	if ( [self isHighlighted] && [[[self controlView] window] firstResponder] == [self controlView] )
	{
		if ( [[[self controlView] window] isKindOfClass:[NSPanel class]] && [[[self controlView] window] isKeyWindow] )
			return [NSColor whiteColor];
		
		else if ( [[[self controlView] window] isMainWindow] && [[[self controlView] window] isKeyWindow] )
			return [NSColor whiteColor];
		
		else
			return [super textColor];
	}
		
	else if ( [self isHighlighted] && [(NSTableView*)[self controlView] editedRow] != -1 && [(NSTableView*)[self controlView] editedColumn] != -1 )
		return [NSColor whiteColor];
	else
		return [super textColor];
	
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	
	NSString *time_string = nil, *day_string = nil;
	NSSize time_size, day_size;
	NSPoint time_origin, day_origin;
	
	NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
	[self font], NSFontAttributeName, [self textColor], NSForegroundColorAttributeName, nil];
	
	if ([self isSelected]) 
	{
		// prepare the text in white.
		[attrs setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
		
		// bold the text if that option has been requested
		if ( [self boldsWhenSelected] )
		{
			NSFont *originalFont = [attrs objectForKey:NSFontAttributeName];
			if ( originalFont ) {
				NSFont *boldedFont = [[NSFontManager sharedFontManager] convertFont:originalFont toHaveTrait:NSBoldFontMask];
				if ( boldedFont )
					[attrs setObject:boldedFont forKey:NSFontAttributeName];
			}
		}
	}
	
	NSDate *date = [self objectValue];
	if ( _dayFormatter == nil ) { 
				
		//_formatter = [[NSDateFormatter alloc] init];
		_dayFormatter = [[NSDateFormatter alloc] init];
		_timeFormatter = [[NSDateFormatter alloc] init];
		
		[_dayFormatter setDateStyle:NSDateFormatterLongStyle];
		[_dayFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		[_timeFormatter setDateStyle:NSDateFormatterNoStyle];
		[_timeFormatter setTimeStyle:NSDateFormatterShortStyle];
	}
	
	if ( cellFrame.size.width > widthWas && [_dayFormatter dateStyle] != NSDateFormatterLongStyle ) {
		#ifdef __DEBUG__
		NSLog(@"%@ %s - growing", [self className], _cmd);
		#endif
		
		// we're growing, give the original date and time format another chance
		//[_timeFormatter setDateFormat:nil];
		[_dayFormatter setDateStyle:NSDateFormatterLongStyle];
		[_timeFormatter setTimeStyle:NSDateFormatterShortStyle];
	}
	
	widthWas = cellFrame.size.width;
	
	//
	// draw the day on the far left in medium style
	//[_formatter setDateStyle:NSDateFormatterMediumStyle];
	//[_formatter setTimeStyle:NSDateFormatterNoStyle];

CalculateDateSize:


	//day_string = [_formatter stringFromDate:date];
	day_string = [_dayFormatter stringFromDate:date];
	day_size = [day_string sizeWithAttributes:attrs];
	
	day_origin.x = cellFrame.origin.x + kEdgeInset;
	day_origin.y = cellFrame.origin.y + cellFrame.size.height/2 - day_size.height/2;
	
	
	
CalculateTimeSize:	

	//
	// draw the time on the far right in short style
	//[_formatter setDateStyle:NSDateFormatterNoStyle];
	//[_formatter setTimeStyle:NSDateFormatterShortStyle];
	
	//time_string = [_formatter stringFromDate:date];
	time_string = [_timeFormatter stringFromDate:date];
	time_size = [time_string sizeWithAttributes:attrs];
		
	time_origin.x = cellFrame.origin.x + cellFrame.size.width - time_size.width - kEdgeInset;
	time_origin.y = cellFrame.origin.y + cellFrame.size.height/2 - time_size.height/2;
	
	
	if ( time_origin.x < day_origin.x + day_size.width + kEdgeInset*3 ) {
		
		//
		// the time doesn't fit - first try making the date smaller
		if ( /* alreadyJumpedOnNoTime == NO  &&  */ [_dayFormatter dateStyle] == NSDateFormatterLongStyle ) {
			#ifdef __DEBUG__
			NSLog(@"%@ %s - recalculating date style to NSDateFormatterMediumStyle", [self className], _cmd);
			#endif
			
			[_dayFormatter setDateStyle:NSDateFormatterMediumStyle];
			goto CalculateDateSize;
		}
		else if ( alreadyJumpedOnNoTime == NO && [_dayFormatter dateStyle] == NSDateFormatterMediumStyle ) {
			#ifdef __DEBUG__
			NSLog(@"%@ %s - recalculating date style to NSDateFormatterShortStyle", [self className], _cmd);
			#endif
			
			[_dayFormatter setDateStyle:NSDateFormatterShortStyle];
			goto CalculateDateSize;
		}
		
		//
		// the time doesn't fit, make it even shorter
		//[_formatter setDateFormat:@"h:mm"];
		if ( ![shorter_time isEqualToString:[_timeFormatter dateFormat]] )
			[_timeFormatter setDateFormat:shorter_time];
		
		//time_string = [_formatter stringFromDate:date];
		time_string = [_timeFormatter stringFromDate:date];
		time_size = [time_string sizeWithAttributes:attrs];
		
		time_origin.x = cellFrame.origin.x + cellFrame.size.width - time_size.width - kEdgeInset;
		time_origin.y = cellFrame.origin.y + cellFrame.size.height/2 - time_size.height/2;
		
		//
		// if it still doesn't fit!
		if ( time_origin.x < day_origin.x + day_size.width + kEdgeInset*3 ) {
			
			//
			// time won't fit, reset date back to medium and recalculate the size
			if ( alreadyJumpedOnNoTime == NO && [_dayFormatter dateStyle] == NSDateFormatterShortStyle )
			{
				[_dayFormatter setDateStyle:NSDateFormatterMediumStyle];
				alreadyJumpedOnNoTime = YES;
				goto CalculateDateSize;
			}
			else if ( alreadyJumpedOnNoTime == NO && [_dayFormatter dateStyle] == NSDateFormatterMediumStyle )
			{
				[_dayFormatter setDateStyle:NSDateFormatterLongStyle];
				alreadyJumpedOnNoTime = YES;
				goto CalculateDateSize;
			}
			else
			{
				day_string = [_dayFormatter stringFromDate:date];
				day_size = [day_string sizeWithAttributes:attrs];
		
				day_origin.x = cellFrame.origin.x + kEdgeInset;
				day_origin.y = cellFrame.origin.y + cellFrame.size.height/2 - day_size.height/2;
				
				//
				// zero time string
				[_timeFormatter setDateFormat:[NSString string]];
				time_string = [_timeFormatter stringFromDate:date];
				
				alreadyJumpedOnNoTime = NO;
			}
			
		}
		
		//[_formatter setDateFormat:nil];
	
	}
	
	//
	// only draw the time string if it fits at all, even after being shortened
	if ( time_string != nil && [time_string length] != 0 )
	//if ( time_origin.x >= day_origin.x + day_size.width + kEdgeInset*3 )
		[time_string drawAtPoint:time_origin withAttributes:attrs];
		
	//
	// actually draw the day
	if ( day_string != nil )
		[day_string drawAtPoint:day_origin withAttributes:attrs];
	
	alreadyJumpedOnNoTime = NO;
}

- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	return nil;
}

@end
