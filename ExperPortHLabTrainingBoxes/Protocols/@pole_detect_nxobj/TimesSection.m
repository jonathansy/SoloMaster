function [x, y] = TimesSection(obj, action, x, y)

GetSoloFunctionArgs;

switch action
    case 'init',
        % Save the figure and the position in the figure where we are
        % going to start adding GUI elements:
        SoloParamHandle(obj, 'my_gui_info', 'value', [x y gcf]);
        
        %       NumeditParam(obj, 'ExtraITIOnError', 2, x, y);
        NumeditParam(obj, 'PoleReractTime', 0.4, x, y, 'TooltipString', ...
            'Time allowed for removing the pole before start answering period');
        next_row(y);
        MenuParam(obj, 'ExtraITIOnError', {'2','3','4','5','6','7','8','9','10','11','12','13','14','15','20','25','30'},'2', x, y);
        next_row(y);
        MenuParam(obj, 'SamplingPeriodTime', {'0.2','0.5','0.75','1','1.25','1.5','1.75','2','2.5','3'},'1', x, y);
        next_row(y);
%         if value(SamplingPeriodTime)>1
%             aptm = 1;
%         else
%             aptm = 2 - value(SamplingPeriodTime);
%         end
        NumeditParam(obj, 'AnswerPeriodTime', 1.5, x,y); % Can be modified by make_and_upload_state_matrix
        next_row(y, 1);
        SoloFunctionAddVars('make_and_upload_state_matrix', 'ro_args', ...
            {'ExtraITIOnError','SamplingPeriodTime','PoleReractTime'});
        SoloFunctionAddVars('make_and_upload_state_matrix', 'rw_args', ...
            {'AnswerPeriodTime'});
            
        SubheaderParam(obj, 'title', 'Times', x, y);
        next_row(y, 1.5);
        
    case 'reinit',
        currfig = gcf;
        
        % Get the original GUI position and figure:
        x = my_gui_info(1); y = my_gui_info(2); figure(my_gui_info(3));
        
        % Delete all SoloParamHandles who belong to this object and whose
        % fullname starts with the name of this mfile:
        delete_sphandle('owner', ['^@' class(obj) '$'], ...
            'fullname', ['^' mfilename]);
        
        % Reinitialise at the original GUI position and figure:
        [x, y] = feval(mfilename, obj, 'init', x, y);
        
        % Restore the current figure:
        figure(currfig);
end;

   
      