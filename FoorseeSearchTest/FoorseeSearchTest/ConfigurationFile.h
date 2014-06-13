//
//  ConfigurationFile.h
//  FoorseeSearchTest
//
//  Created by Niklas Nilsson on 15/05/14.
//  Copyright (c) 2014 Niklas Nilsson. All rights reserved.
//

#ifndef FoorseeSearchTest_ConfigurationFile_h
#define FoorseeSearchTest_ConfigurationFile_h

//ANIMATION SETTINGS
#define DURATION_FILTER_OPEN_CLOSE 0.2f
#define DURATION_PROFILE_PAGE_OPEN_CLOSE 0.30f


//COLORS
#define COLOR_HEX_FILTER_SECTION @"1C1B29"
#define COLOR_HEX_RESULT_SECTION @"192329"
#define COLOR_HEX_PROFILE_PAGE @"1E2124"

//API
//#define FOORSEE_API_URL @"http://http://54.72.50.217/v1/"
#define FOORSEE_API_URL @"http://client_abstraction_api.moc/v1/"
#define API_KEY @"X62G2eUCuid3cF3Dxod32idudYxg"

#define RADIUS_BORDER_FILTER_CELL 5
#define WIDTH_BORDER_IMAGES 1
#define COLOR_BORDER_IMAGES @"000000"
#define HEIGHT_POSTER_THUMBNAILS 320


#define RELATION_WIDTH_TO_HEIGHT_POSTERS 0.7f


// Profile page
#define NUMBER_OF_PROFILE_PAGES_MAXIMUM 5
#define HEIGHT_HEADER_MODULE_PROFILE_PAGE 350
#define HEIGHT_PROVIDERS_MODULE_PROFILE_PAGE 150
#define HEIGHT_ACTORS_MODULE_PROFILE_PAGE 320
#define HEIGHT_SIMILAR_CONTENT_MODULE_PROFILE_PAGE 320
#define HEIGHT_IMAGES_MODULE_PROFILE_PAGE 320
#define HEIGHT_VIDEOS_MODULE_PROFILE_PAGE 320
#define SCROLLVIEW_MARGIN_BOTTOM_PROFILE_PAGE 60
#define SCROLLVIEW_MARGIN_TOP_PROFILE_PAGE 60
#define PARALLAX_SPEED_PROFILE_PAGE 0.2
#define PARALLAX_MARGIN_PROFILE_PAGE 30


//fonts
#define FONT_MAIN @"Bariol"
#define FONT_SIZE_TITLE_IN_PROFILE_PAGE 28
#define FONT_SIZE_DESCRIPTION_TEXT 17
#define FONT_SIZE_MODULE_TITLE 20
#define FONT_SIZE_FILTER_SECTION_HEADERS 30
#define FONT_SIZE_FILTER_CELLS 19

//Time logging
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

#endif
