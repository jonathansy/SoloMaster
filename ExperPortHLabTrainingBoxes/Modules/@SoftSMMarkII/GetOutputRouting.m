% output_routing_cell = GetOutputRouting(fsm)
%                Retreive the currently specified output routing
%                for the fsm.  Note that output routing takes
%                effect on the next call to SetStateMatrix().  For
%                more documentation on output routing see the help
%                for SetOutputRouting.m
function [routing] = GetOutputRouting(fsm)
    fsm = get(fsm.Fig, 'UserData');
    routing = fsm.OutputRouting;
    