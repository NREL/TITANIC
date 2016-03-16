%                   TDMS_VERSION_INFO
%
%   Current Version: 2.4
%   Date    : 10/12/2011
%   Authors : James Hokanson
%   
%       Fixed some bugs and tried to improve documentation. I had been
%       holding off on this as I was hoping to release a few more features
%       but I decided I need to get these fixes out.
%
%   NON-SILENT ERRORS RELATED TO INTERLEAVED DATA
%   ----------------------------------------------
%   BUG FIX: Fix variable naming for reading interleaved data. This one was
%   an error in copy/paste on my part but caused an error if used.
%
%   BUG FIX: Fixed reading of interleaved booleans and timestamps. I wasn't
%   reading the correct number of samples, this also caused an error when
%   run.
%
%   BUG FIX: I didn't update a variable that indicated the numeber of
%   samples read so an error was being needlessly thrown for interleaved
%   data
%
%   SILENT ERRORS: 
%   -------------------------
%   BUG FIX: Fixed reading of timestamps for dates prior to 1904 when written
%   as a channel (not a problem for properties). My guess is almost no one
%   would ever use this but it came up in testing.
%   
%   Current Version: 2.3
%   Date    : 7/14/2011
%   Authors : James Hokanson
%
%       Fixed a few small bugs and tried to further improve documentation.
%       Also allows now for only passing in .tdms_index, for debugging purposes
%
%       BUG FIX: Fixed problem with a check on whether or not all data
%       requested was actually returned to the user. Thanks goes to 
%       Juha Suomalainen for pointing out the problem.
%
%       BUG FIX: Parsing of objects with / characters in their names was 
%       incorrect.  I have generalized the parsing of the objects to allow
%       for ' and / characters in the name.  Thanks goes to 
%       Craig R. Smith for pointing out the problem.
%
%   Current Version: 2.2
%   Date    : 5/17/2011
%   Authors : James Hokanson
%
%       - Added GET_INDICES input with enhanced flexibility for only 
%        retrieving subsets of the data
%
%       - Changed code to allow faster retrieval of subsets. This is
%       accomplished by documenting that start position of each bit of data
%       that belongs to a channel. I had originally been hesitant to do
%       this as this requires more memory, but using this information
%       allows for a significant reduction in the # of required freads and
%       fseeks when multiple channels are available
%
%       - Moved all functions that should not be directly called into a 
%       subfolder, "tdmsSubfunctions" which needs to be added to the path 
%       as well
%
%   Current Version: 2.1
%   Date    : 4/29/2011
%   Authors : James Hokanson
%             assistance by Preston K. Manwaring
%
%       - BUG FIX: The subset parsing was not being handled correctly in
%         Version 2.0, should be fixed in this version
%
%   Version: 2.0
%   Date    : 4/28/2011
%   Authors : James Hokanson
%             assistance by Preston K. Manwaring
%   Updates :
%       - MAJOR UPDATE: Added on the ability to only get a subset of the
%       data from channels specified as a start and a length, i.e. if a
%       channel has 1 million values you could choose to read the data 10x,
%       each time grabbing a new set of 100,000 values for doing whatever
%       processing before moving onto the next chunk
%       
%       This feature is implemented as a option called GET_SUBSET, and
%       applies to all objects that are being retrieved.
%
%       This only works for decimated data currently.
%
%       NOTE: To facilitate quick multiple reads, either make a habit of
%       defragmenting your TDMS files using Labview, or capture the
%       metaStruct output when first processing a file, and pass it back in
%       on subsequent runs -> pass in via optional parameter, META_STRUCT
%
%       - NEW FILE: TDMS_readChannelOrGroup
%       - NEW FILE: TDMS_dataToGroupChanStruct_v4
%       - NEW FILE: TDMS_getStruct
%       
%
%   Version: 1.2
%   Date    : 3/19/2011
%   Author  : James Hokanson
%   Updates :
%       - BUG FIX: conversion of a timestamp property to value was incorrect 
%       I needed a '+' sign instead of a '-' sign
%       Thanks goes to Ed Zechmann for pointing out this bug
%       
%       - Added on function TDMS_dataToGroupChanStruct_v3 which now casts
%       objects AND properties to field names in a struct
%
%   -----------------------------------------------------------------------
%   Version 1.1
%   Author  : James Hokanson
%   Updates : 
%       - MAJOR BUG FIX: fixed the way unicode strings are handled
%
%       Matlab specifies the # of characters to read for unicode strings
%       Labview specifies the # of bytes to read for unicode strings
%
%       Thus one needs to read in the desired # of bytes, and then convert
%       those bytes to characters
%
%       http://www.mathworks.com/matlabcentral/newsreader/view_thread/302145
%
%       --------------------
%       - BUG FIX: fixed case sensitivity on {'GET_DATA_OPTION','getnone'}
%       - BUG FIX: fixed bug with ignoring data retrieval on certain
%           objects
%       - BUG FIX: fixed skipping bug on timestamp data
%       - all structure fields no longer necessary for 
%          ignoreSubset or getSubset GET_DATA_OPTIONs
%       - added function dataToGroupChanStruct_v2
%       - added function TDMS_exampleFunctionCalls
%
%   -----------------------------------------------------------------------
%   Version 1.0
%   Author: 
%       James Hokanson
%       University of Pittsburgh
%       Graduate Student Researcher
%   Date : January 13, 2011