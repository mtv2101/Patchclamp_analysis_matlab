function tabpanel(figname,tag,action)
%TABPANEL  "TabPanel Constructor" offers the easiest way for creating tabpanels in MATLAB
%  First start (NEW):
%  >> tabpanel('filename.fig','tabpaneltag',[left bottom width height])
%     'tabpaneltag' define the tag name of the tabpanel. The rectangle defined 
%     the size and location (in pixel) of the tabpanel within the parent 
%     figure window.
%
%  Alternative (OLD):
%  1. Open the figure (where the tab panel needs to be integrated) in
%     GUIDE and create a Text-Object which reserves the place of the future
%     tabpanel.
%  2. Specify and note the unique tag-name of the created text-object and the
%     figure filename.
%  3. Start "TabPanel Constructor" as follows:
%        >> tabpanel('filename.fig','tabpaneltag')
%
%  Options:
%     a. activate "TabPanel Constructor" to edit an existing tabpanel:
%        >> tabpanel('filename.fig','tabpaneltag') 
%     b. remove tabpanel from GUI
%        >> tabpanel('filename.fig','tabpaneltag','delete')
%
%  !!! IMPORTANT !!!
%  1) The current version fixes the bug (since R2009a) which force the GUI to 
%  restart when the M-File does not contain the TabSelectionFcn.
%  To fix the issue for already existing tabpanel please follow the steps:
%     1. Open the tabpanel created with TPC 2.6 with the current TPC 2.6.3
%     2. Add any new panel
%     3. Remove currently created panel
%     4. Close TPC
%
%  2) In case when the figure name has been changed you should just 
%     open the TPC and close it again.
%
%  3) While TPC is active, you can not use your figure as usual!
%     You schould close TPC and restart your GUI application!
%
%
% See also TABSELECTIONFCN.
%
%   Version: v2.7
%      Date: 2010/03/04 12:00:00
%   (c) 2005-2010 By Elmar Tarajan [MCommander@gmx.de]

%  History:
%   Version: v2.7
%   2010/03/04 added: creating tabpanel using location and size
%   2010/03/04 added: adding already existing figures as tab (beta)
%   2010/01/15 fixed: Problems using TPC after renaming the main figure
%
%   Version: v2.6.4
%  *2010/03/04 todo: creating tabpanel using location and size
%   2009/09/16 improved: code for adding the "TabSelectionChange_Callback"
%
%   Version: v2.6.3
%  *2009/09/16 todo:  Allow to edit TabPanel-Tag after creating
%   2009/09/16 improved: tab-callback code
%  *2009/09/16 todo:  Improve code for adding the "TabSelectionChange_Callback"
%   2009/09/16 fixed: Error while saving figure which name has been changed
%   2009/08/12 added: adding already available figure as new panel (beta)
%   2009/07/24 fixed: Error while closing TPC in R2009a/b
%   2009/07/24 fixed: GUI-Restart while tab switching
%   2009/07/24 some code improvements
%
%   Version: v2.6.1
%   2008/09/10 added: "tabselectionfcn" for programatically tab switching
%   2008/08/03 added: TabSelectionChange_Callback
%   2008/07/02 supporting of nested tabpanels
%   2008/06/23 works now with R14/SP1/SP2/SP3 versions
%   2008/05/08 many code improvements
%   2008/04/16 improved look - using the mouse on "settings"-button
%   2008/03/28 some code improvements
%   2008/03/17 improved look of tabs