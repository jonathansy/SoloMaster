% sm = RegisterEventsCallback(sm, callback) 
% sm = RegisterEventsCallback(sm, callback, callback_on_connection_failure) 
%                Enable asynchronous notification as the FSM gets new
%                events (state transitions).  Your callback code is
%                executed as new events are generated by the FSM.
%                Your code is evaluated (using the equivalent of an
%                eval).  When your code runs, the event(s) that just
%                occurred are in an Mx4 matrix (as would be returned
%                from GetEvents()) as the special variable 'ans'.
%                Thus, your callback code should save this variable
%                right away lest it be destroyed by subsequent matlab
%                statements.  Pass an empty callback to disable the
%                EventsCallback mechanism (or call
%                StopEventsCallback).
%
%                Optionally you can pass a third parameter, an
%                additional callback to use so that your code can be
%                notified if there is an unexpected TCP connection
%                loss to the FSM server.  This is so that your code
%                can be notified that no more events will come in due
%                to a connection loss.  Otherwise, it would be
%                impossible to know that no more events are possible
%                -- your code might wait forever for events that will
%                never arrive.  Possible actions to take in this
%                callback include displaying error messages in matlab
%                and/or trying to restart the connection by calling
%                RegisterEventsCallback again.
%
%                Note: This entire callback mechanism only works under
%                Windows currently and requires that the executable
%                FSM_Event_Notification_Helper_Process.exe be in your
%                Windows PATH or in the current working directory!
%
%                Note 2: The events callback mechanism is highly
%                experimental and as such, only a maximum of 1
%                callbacks may be registered and enabled at a time
%                globally for all instances of RTLSM objects in the
%                matlab session.  What does this mean?  That
%                subsequent calls to this function for *any* insance
%                of an @RTLSM will actually kill/disable the existing
%                callback that was previously registered/active for
%                any other instance of an @RTLSM.  
function [sm] = RegisterEventsCallback(varargin)
    if (nargin < 2), 
      error(['Please pass at least 2 arguments to this function']); 
    end;
    sm = varargin{1};
    callback = varargin{2};
    callback_connfail = '';
    if (~isa(sm, 'RTLSM')), 
      error (['First argument must be an RTLSM object!']);
    end;
    if (nargin > 2),
      callback_connfail = varargin{3};
    end;
    if (~isa(callback_connfail, 'char') | ~isa(callback, 'char')), 
      error (['Callbacks argument(s) must be strings!']);
    end;
    
    if (strcmp(computer,'PCWIN')),
      % force the automation server to be enabled, so that COM will work
      enableservice('AutomationServer', true);
    end;

    if (isempty(callback)), 
      sm = StopEventsCallback(sm);
    else
      
      ret = FSMClient('notifyEvents', sm.handle, callback, callback_connfail);
      if (~ret),
        error(['Unspecified internal error from FSMClient.  Could not' ...
               ' start notify events!']);
      end;
    
    end;
    
    return;
