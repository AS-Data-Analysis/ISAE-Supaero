function varargout = communicate(varargin)
%COMMUNICATE access to COM port
%   ID = COMMUNICATE('comopen', S) initializes the interface to the WINSERIAL routines
%   		 and returns ID, a unique integer ID corresponding to the open com port
%        configurated by S.
%        The MATLAB M-file WINSERIAL/FOPEN should be used to call this routine.
%   
%   COMMUNICATE('comclose',ID) finishes writing the COM port represented by ID.
%       This will close the stream and file handles.
%       This routine should be called by the MATLAB M-file WINSERIAL/CLOSE.
%

error('Missing MEX-file %s.',mfilename);
