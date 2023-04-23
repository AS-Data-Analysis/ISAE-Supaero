function varargout = imu411(varargin)
%IMU411 - STM32F411 attitude sensor interface over serial communication.
%
% See also: imu411>open , imu411>read , imu411>close
%
% Measurements Units :
% measure(1)    = Time                (s)
% measure(2:4)  = Gyroscope     X,Y,Z (°/s)
% measure(5:7)  = Accelerometer X,Y,Z (g)
% measure(8:10) = Magnetometer  X,Y,Z (Gauss)
% measure(11)   = Barometer           (Millibar)
% measure(12)   = Ultrasonic sensor   (cm)
%
%-------------------------------------------------------------------------------
% (c)Institut Superieur de l'Aeronautique et de l'Espace
%    Laurent Alloza (laurent.alloza(a)isae.fr)
%    12-Nov-2015
%-------------------------------------------------------------------------------
if nargin && ischar(varargin{1}), %#ok<*DEFNU>
    cmd=str2func(varargin{1});
else
    disp('Not enough input arguments.');
    return;
end
if nargout
    [varargout{1:nargout}] = cmd(varargin{:});
else
    cmd(varargin{:});
end

function varargout = open(varargin)
%Syntax :
% result = imu411('open')
% result = imu411('open','port')
%
%Description :
% open dialog with imu411 on serialport 'port' (default = 'COM1').
% returns true if successfull.
global packet_len s;
global k_sample_sim;
global simdata;
global imu411dosimulate;
if	nargin<2
    portname='COM1';
else
    portname = upper(varargin{2});
end
imu411dosimulate = false;
if nargin > 2
    imu411dosimulate = true;
end

if ~imu411dosimulate
    disp([mfilename '>> Opening COM port ' portname '...']);
    % start serial communication
    s = winserial(portname);
    s.BaudRate = 921600;
    
    packet_len = 12*4;
    
    try	fopen(s);
    catch ME
        disp(getReport(ME));
        if nargout,	varargout(1)={false};	end;
        return;
    end
    
    if nargout
        if	strcmpi(s.CurrentState,'opened'),
            varargout(1)={true};
        else
            varargout(1)={false};
        end
    end
else
    simdata = load(varargin{3});
    simdata = simdata.simu;
    k_sample_sim = 1;
end


function close(varargin)
%Syntax :
% imu411('close')
%
%Description :
% close and delete serial communication.
global s
if isempty(s),return,end
% while not(strcmpi(s.TransferStatus,'idle')),end
fclose(s);
clear global packet_len s;


function varargout = read(varargin)
%Syntax :
% measure = imu411('read')
% measure = imu411('read', 'simdatafilenameasstring')
%
%Description :
% returns the last measurement available in a column vector.
%
%Units  :
% measure(1)    = Time                (s)
% measure(2:4)  = Gyroscope     X,Y,Z (°/s)
% measure(5:7)  = Accelerometer X,Y,Z (g)
% measure(8:10) = Magnetometer  X,Y,Z (Gauss)
% measure(11)   = Barometer           (Millibar)
% measure(12)   = Ultrasonic sensor   (cm)
global packet_len s;
global imu411dosimulate;
global k_sample_sim;
global simdata;

if nargout==0
    return;
end
% Go into sim mode?
if imu411dosimulate
    tic;
    var_gyro =  [0.0397; 0.0667; 0.2918];
    var_acc =  1e-04*[0.3093; 0.2783; 0.5351];
    var_mag =  1e-5*[0.2765; 0.2054; 0.4404];
    framestddevs = sqrt([0; var_gyro; var_acc; var_mag; 0; 0]);
    noise = framestddevs .* randn(12, 1);
    signal = simdata.obs.Data(k_sample_sim, :)';
    varargout(1) = {signal + noise};
    % Reading one frame should take the same time as actually reading the IMU:
    %while(toc < 1e-2)
    
    %end
    % Output true state as well?
    if nargout > 1
        varargout{2} = simdata.xtrue.Data(k_sample_sim, :)';
    end
    k_sample_sim = k_sample_sim + 1;
    if k_sample_sim>length(simdata.obs.Data)
        k_sample_sim = 1;
    end
else
    % Output true state as well?
    if nargout > 1
        % zero euler angles are [1 0 0 0] quaternion:
        varargout{2} = [1; zeros(12,1)];
    end
    if isempty(s),
        varargout(1)={NaN(12,1)};
        return;
    end
    
    fwrite(s,'R'); % send (R)ead command
    buffer = uint8(fread(s,packet_len+4));
    
    [dataready,data] = parsePacket(buffer);
    if dataready,
        lastdata = double(typecast(data,'single'));
        varargout(1)={lastdata'};
    else
        varargout(1)={NaN(12,1)};
    end
end

function [found,packet_data] = parsePacket(buffer)
% --- Searches for packet in buffer.
global packet_len
found = false;
if length(buffer) < packet_len+4,return,end
if buffer(1)~='S',return,end
if buffer(2)~='T',return,end
if buffer(2+packet_len+1)~=13,return,end % CR
if buffer(2+packet_len+2)~=10,return,end % LF
packet_data = buffer(3:2+packet_len);
found = true;
