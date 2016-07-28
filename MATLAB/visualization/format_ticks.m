%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BEGIN HEADER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Name: format_tick.m
%
%Usage: [hx,hy] = ...
%          format_tick(h,tickx,ticky,tickposx,tickposy,rotx,roty,offset,...
%                      varargin);
%
%Description: Replace or appends XTickLabels and YTickLabels of axis handle
%             h with input tickx and ticky array
%
%***NOTE!***: BE SURE TO DELETE ANY PREVIOUS TEXT OBJECTS CREATED BY THIS
%             FUNCTION BEFORE RUNNING THIS ON THE SAME FIGURE TWICE
%
%Required Inputs:
%       h        : handle of axis to change tick labels (can use gca)
%Optional Inputs
%       xlabels, ylabels - cell array of tick labels or string to append to current
%                          labels (Can use [] or not specify to ignore) 
%       xticks, yticks - Vector of x positions where you want the tick labels
%                        (Can use [] or not specify to ignore)
%       rotx, toy - Number of degrees to rotate x tick labels (Can use [] or not specify to ignore) Default = 0.0
%       offset  - Label offsets from axis in fraction of total range
%                 (Can use [] or not specify to ignore) Default = 0.0
%       other - Any standard text formatting parameters such as 
%               'FontSize','FontWeight',etc.
%               Use the same way you would in a set command after putting
%               in the required input values.
%
%Outputs:
%        hx: handle of text objects created for XTickLabels
%        hy: handle of text objects created for YTickLabels
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BEGIN FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hx,hy] = ...
    format_ticks(h,varargin)

defaults = struct('xticks',[],'yticks',[],...
                  'xrot',[],'yrot',[],...
                  'offset', []);
defaults.xlabels = {};
defaults.ylabels = {};
[args, varargin] = parse_namevalue_pairs(defaults, varargin);
tickx = args.xlabels;
ticky = args.ylabels;
tickposx = args.xticks;
tickposy = args.yticks;
rotx = args.xrot;
roty = args.yrot;
offset = args.offset;


%define axis text offset (percentage of total range)
if ~exist('offset','var');
    offset = 0.02;
elseif length(offset) == 0;
    offset = 0.02;
end;

%make sure the axis handle input really exists
if ~exist('h','var');
    h = gca;
    warning(['Axis handle NOT Input, Defaulting to Current Axes, '...
        num2str(h)]);
elseif length(h) == 0;
    h = gca;
    warning(['Axis Handle NOT Input, Defaulting to Current Axes, '...
        num2str(h)]);
elseif ~ishandle(h(1))
    warning(['Input (' num2str(h(1)) ') is NOT an axis handle, ' ...
        'defaulting to current axis, ' num2str(h)]);
        h = gca;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%BEGIN: FIRST THE X-AXIS TICK LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fix the XTickLabels if they have been erased in the past
if length(get(h,'XTickLabel'))==0; 
    set(h,'XTickLabel',get(h,'XTick'));
end;
%set the xtick positions if entered
if exist('tickposx','var');
    if length(tickposx) > 0;
        set(h,'XTick',tickposx);
    end;
    tickposx = get(h,'XTick');
     set(h,'XTickLabel',tickposx);
end;
%make sure the xtick positions are in the xlimit range
if exist('tickposx','var');
    if length(tickposx) > 0;
        lim = get(h,'XLim');
        if lim(1) > min(tickposx);
            lim(1) = min(tickposx);
        end;
        if lim(2) < max(tickposx);
            lim(2) = max(tickposx);
        end;
        set(h,'XLim',lim);
    end;
end;
%get the tick labels and positions if the user did not input them
if ~iscell(tickx)
    tmp = cell(size(tickx));
    for i = 1:length(tickx)
        tmp{i} = num2str(tickx(i));
    end
    tickx = tmp;
end
if ~exist('tickx','var') || isempty(tickx)
    tickx = get(h,'XTickLabel');
    if ischar(tickx);
        temp = tickx;
        tickx = cell(1,size(temp,1));
        for j=1:size(temp,1);
            tickx{j} = strtrim( temp(j,:) );
        end;
    end;    
elseif isstr(tickx);
    append = tickx;
    tickx = get(h,'XTickLabel');
    if ischar(tickx);
        temp = tickx;
        tickx = cell(1,size(temp,1));
        for j=1:size(temp,1);
            tickx{j} = strtrim( temp(j,:) );
        end;
    end;
    if strcmp(append(1),'$');
        for j=1:length(tickx);
            tickx{j} = ['$' tickx{j} append(2:end)];
        end;
    else;            
        for j=1:length(tickx);
            tickx{j} = [tickx{j} append];
        end;
    end;
end;
%find out if we have to use the LaTex interpreter
latex_on = 0;
if ~isempty(tickx)
    temp = tickx{1};
    if strcmp(temp(1),'$');
        latex_on = 1;
    end;
end
%erase the current tick label
set(h,'XTickLabel',{});
%get the x tick positions if the user did not input them
if ~exist('tickposx','var');
    tickposx = get(h,'XTick');
elseif length(tickx) == 0;
    tickposx = get(h,'XTick');
end;
%get the y tick positions if the user did not input them
if ~exist('tickposy','var');
    tickposy = get(h,'YTick');
elseif length(tickposy) == 0;
    tickposy = get(h,'YTick');
end;
%set the new tick positions
set(h,'YTick',tickposy);
set(h,'XTick',tickposx);
%check the lengths of the xtick positions and xtick labels
l1 = length(tickx);
l2 = length(tickposx);
if l1==0; 
    set(h,'XTickLabel',tickx);
end;
if l1~=l2;
    disp(['Length of XTick = ' num2str(length(tickposx))]);
    disp(['Length of XTickLabel = ' num2str(length(tickx))]);
    if l2 < l1;
        warning(['Reducing Length of XTickLabel!']);
    else;
        warning(['Reducing Length of XTick!']);
    end;   
    l3 = min([l1,l2]);

    
    tickx = tickx(1:l3);
    tickposx = tickposx(1:l3);
end;
%set rotation to 0 if not input
if ~exist('rotx','var');
    rotx = 0;
elseif length(rotx) == 0; 
    rotx = 0;
end;
%Convert the cell labels to a character string
%tickx = char(tickx);
tickx = cellstr(tickx);
%Make the XTICKS!
lim = get(h,'YLim');
if min(tickposy) < lim(1);
    lim(1) = min(tickposy);
end;
if max(tickposy) > lim(2);
    lim(2) = max(tickposy);
end;
if rotx == 0;
    if latex_on;
        hx = text(tickposx,...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposx),1),...
            tickx,'HorizontalAlignment','center',...
            'VerticalAlignment','top','rotation',rotx,'interpreter','LaTex');
    else;
        hx = text(tickposx,...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposx),1),...
            tickx,'HorizontalAlignment','center',...
            'VerticalAlignment','top','rotation',rotx);
    end;
elseif rotx < 0;
    if latex_on;
        hx = text(tickposx,...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposx),1),...
            tickx,'HorizontalAlignment','left','interpreter','LaTex',...
            'VerticalAlignment','middlefi','rotation',rotx);
    else;
        hx = text(tickposx,...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposx),1),...
            tickx,'HorizontalAlignment','left',...
             'VerticalAlignment','middle','rotation',rotx);
    end;
else;
    if latex_on;
        hx = text(tickposx,...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposx),1),...
            tickx,'HorizontalAlignment','right','interpreter','LaTex',...
            'VerticalAlignment','middle','rotation',rotx);
    else;
        hx = text(tickposx,...
            repmat(lim(1)-offset*(lim(2)-lim(2)),length(tickposx),1),...
            tickx,'HorizontalAlignment','right',...
            'VerticalAlignment','middle','rotation',rotx);
    end;
end;
%Get and set the text size and weight
set(hx,'FontSize',get(h,'FontSize'));
set(hx,'FontWeight',get(h,'FontWeight'));

%Set the additional parameters if they were input
if length(varargin) >= 2;
    command_string = ['set(hx'];
    for j=1:2:length(varargin);
        command_string = [command_string ',' ...
            '''' varargin{j} ''',varargin{' num2str(j+1) '}'];
    end;
    command_string = [command_string ');'];
    eval(command_string);
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%END: FIRST THE X-AXIS TICK LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%BEGIN: NOW THE Y-AXIS TICK LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%only move forward if we are doing anything to the yticks
%fix the YTickLabels if they have been erased in the past
if length(get(h,'YTickLabel'))==0;
    set(h,'YTickLabel',get(h,'YTick'));
end;
%set the ytick positions if entered
if exist('tickposy','var');
    if length(tickposy) > 0;
        set(h,'YTick',tickposy);
        set(h,'YTickLabel',tickposy);
    end;
end;
%make sure the xtick positions are in the xlimit range
if exist('tickposy','var');
    if length(tickposy) > 0;
        lim = get(h,'YLim');
        if lim(1) > min(tickposy);
            lim(1) = min(tickposy);
        end;
        if lim(2) < max(tickposy);
            lim(2) = max(tickposy);
        end;
        set(h,'YLim',lim);
    end;
end;
if ~iscell(ticky)
    tmp = cell(size(ticky));
    for i = 1:length(ticky)
        tmp{i} = num2str(ticky(i));
    end
    tick = tmp;
end
%get the tick labels and positions if the user did not input them
if ~exist('ticky','var') || isempty(ticky)
    ticky = get(h,'YTickLabel');
    if ischar(ticky);
        temp = ticky;
        ticky = cell(1,size(temp,1));
        for j=1:size(temp,1);
            ticky{j} = strtrim( temp(j,:) );
        end;
    end;
elseif isstr(ticky);
    append = ticky;
    ticky = get(h,'YTickLabel');
    if ischar(ticky);
        temp = ticky;
        ticky = cell(1,size(temp,1));
        for j=1:size(temp,1);
            ticky{j} = strtrim( temp(j,:) );
        end;
    end;
    if strcmp(append(1),'$');
        for j=1:length(ticky);
            ticky{j} = ['$' ticky{j} append(2:end)];
        end;
    else;
        for j=1:length(ticky);
            ticky{j} = [ticky{j} append];
        end;
    end;
end;
%find out if we have to use the LaTex interpreter
temp = ticky{1};
if strcmp(temp(1),'$');
    latex_on = 1;
else;
    latex_on = 0;
end;
%erase the current tick label
set(h,'YTickLabel',{});
%get the x tick positions if the user did not input them
if ~exist('tickposy','var');
    tickposy = get(h,'YTick');
elseif length(ticky) == 0;
    tickposy = get(h,'YTick');
end;
%get the x tick positions if the user did not input them
if ~exist('tickposx','var');
    tickposx = get(h,'YTick');
elseif length(tickposx) == 0;
    tickposx = get(h,'XTick');
end;
%set the new tick positions
set(h,'YTick',tickposy);
%    set(h,'XTick',tickposx);
%check the lengths of the xtick positions and xtick labels
l1 = length(ticky);
l2 = length(tickposy);
if l1==0;
    set(h,'YTickLabel',ticky);
end;
if l1~=l2;
    disp(['Length of YTick = ' num2str(length(tickposy))]);
    disp(['Length of YTickLabel = ' num2str(length(ticky))]);
    if l2 < l1;
        warning(['Reducing Length of YTickLabel!']);
    else;
        warning(['Reducing Length of YTick!']);
    end;
    l3 = min([l1,l2]);
    ticky = ticky(1:l3);
    tickposy = tickposy(1:l3);
end;
%set rotation to 0 if not input
if ~exist('roty','var');
    roty = 0;
elseif length(roty) == 0;
    roty = 0;
end;
%Convert the cell labels to a character string
%ticky = char(ticky);
ticky = cellstr(ticky);
%Make the YTICKS!
lim = get(h,'XLim');
if min(tickposx) < lim(1);
    lim(1) = min(tickposx);
end;
if max(tickposx) > lim(2);
    lim(2) = max(tickposx);
end;
if roty == 0;
    if latex_on;
        hy = text(...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposy),1),...
            tickposy,...
            ticky,'VerticalAlignment','middle',...
            'HorizontalAlignment','right','rotation',roty,'interpreter','LaTex');
    else;
        hy = text(...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposy),1),...
            tickposy,...
            ticky,'VerticalAlignment','middle',...
            'HorizontalAlignment','right','rotation',roty);
    end;
elseif roty < 180;
     if latex_on;
        hy = text(...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposy),1),...
            tickposy,...
            ticky,'VerticalAlignment','middle',...
            'HorizontalAlignment','right','rotation',roty,'interpreter','LaTex');
    else;
        hy = text(...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposy),1),...
            tickposy,...
            ticky,'VerticalAlignment','middle',...
            'HorizontalAlignment','right','rotation',roty);
    end;
else;
      if latex_on;
        hy = text(...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposy),1),...
            tickposy,...
            ticky,'VerticalAlignment','middle',...
            'HorizontalAlignment','right','rotation',roty,'interpreter','LaTex');
    else;
        hy = text(...
            repmat(lim(1)-offset*(lim(2)-lim(1)),length(tickposy),1),...
            tickposy,...
            ticky,'VerticalAlignment','middle',...
            'HorizontalAlignment','right','rotation',roty);
    end;
end;
%Get and set the text size and weight
set(hy,'FontSize',get(h,'FontSize'));
set(hy,'FontWeight',get(h,'FontWeight'));

%Set the additional parameters if they were input
if length(varargin) >= 2;
    command_string = ['set(hy'];
    for j=1:2:length(varargin);
        command_string = [command_string ',' ...
            '''' varargin{j} ''',varargin{' num2str(j+1) '}'];
    end;
    command_string = [command_string ');'];
    eval(command_string);
end;
