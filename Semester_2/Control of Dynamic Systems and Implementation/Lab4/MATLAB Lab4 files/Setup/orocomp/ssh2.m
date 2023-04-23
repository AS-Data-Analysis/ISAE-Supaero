classdef ssh2 < handle
%Class definition for SSH2 connection object
%
%EXAMPLE:
% mytarget = ssh2('192.168.10.2');
% mytarget.username = 'mylogin';
% mytarget.password = 'mypasswd';
% mytarget.timeout = 2;
% mytarget.open();
% filelist = mytarget.execCommand('cd myproject;ls');
% mytarget.scpget('myproject',{'main.c';'main.h'},'.');
% ...
% mytarget.scpmode = 640; % '-rw- r-- ---'
% mytarget.scpput('.',{'main.c';'main.h'},'myproject');
% mytarget.close();
%
%-------------------------------------------------------------------------------
% (c)Institut Superieur de l'Aeronautique et de l'Espace
%    Laurent Alloza (laurent.alloza(a)isae.fr)
%    14-Sep-2015
%-------------------------------------------------------------------------------
  properties (Constant,Hidden)
    ganymed_library = 'ganymed-ssh2-build250.jar'; % official download from cleondris.ch
  end
  properties
    hostname = 'localhost';     % ip or address of ssh server
    hostport = 22;              % default 22
    username = 'root';
    password = '';
    timeout  = 0;               % timeout in seconds (0 = no timeout )
    proxyHost = '';             % ip or address of HTTPproxy server
    proxyPort = 3128;           % default 3128 for Squid proxy servers
    proxyUser = '';             % proxy username
    proxyPass = '';             % proxy password
    scpmode = 600;              % default 600 = '-rw- --- ---'
  end
  properties (Hidden)
    connection;
  end
  methods
    function this = ssh2(varargin)
      %Create a SSH2 connection object with the specified hostname
      %
      %Syntax:
      % ssh2obj = ssh2('192.168.10.1');
      % or
      % ssh2obj = ssh2('server.domain.com');
      %
      ssh2.loadjavalib(this.ganymed_library);
      if nargin>0, this.hostname=varargin{1}; end
      assert(ischar(this.hostname),'hostname must be a string.');
    end
    function ok = check(this)
      %Checks the connection to the target by sending 'whoami' command
      %
      %Syntax:
      % success = ssh2obj.check();
      %Returns:
      % true on success.
      import ch.ethz.ssh2.*;
      if isempty(this.connection), ok=false; return; end
      if not(this.connection.isAuthenticationComplete), ok=false; return; end
      try
        user = this.execCommand('whoami');
      catch err %#ok<NASGU>
        user = '';
      end
      if not(strcmp(user,this.username)), ok=false; return; end
      ok=true;
    end
    function open(this)
      %Opens (or reopens) the SSH2 connection to target with stored settings
      %
      %Syntax:
      % ssh2obj.open();
      import ch.ethz.ssh2.*;
      assert(ischar(this.hostname),'hostname must be a string.');
      this.close();
      this.connection = Connection(this.hostname,fix(this.hostport));
      this.setProxy();
      this.connection.connect([],0,fix(this.timeout*1000));
      assert(ischar(this.username),'username must be a string.');
      assert(ischar(this.password),'password must be a string.');
      if isempty(this.password),
        this.connection.authenticateWithNone(this.username);
      else
        this.connection.authenticateWithPassword(this.username,this.password);
      end
    end
    function result = execCommand(this,cmdstr)
      %Execute a remote command and wait for the response.
      %
      %Syntax:
      % outstr = ssh2obj.execCommand(cmdstr);
      %
      %Returns:
      % cellstr with the response from the host.
      import ch.ethz.ssh2.*;
      import java.io.BufferedReader;
      import java.io.InputStream;
      import java.io.InputStreamReader;
      assert(this.connection.isAuthenticationComplete,'You must be connected before sending a command.');
      assert(ischar(cmdstr),'Input must be a string.');
      session = this.connection.openSession();
      session.execCommand(cmdstr);
      stdout = StreamGobbler(session.getStdout());
      br = BufferedReader(InputStreamReader(stdout));
      result = {};
      while(true),
        line = char(br.readLine());
        if(isempty(line)),
          break;
        else
          result{end+1,1} = line; %#ok<AGROW>
        end
      end
      session.close();
    end
    function execCommandNoWait(this,cmdstr)
      %Execute a remote command but don't wait for the response.
      %
      %Syntax:
      % ssh2obj.execCommandNoWait(cmdstr);
      %
      import ch.ethz.ssh2.*;
      assert(this.connection.isAuthenticationComplete,'You must be connected before sending a command.');
      assert(ischar(cmdstr),'Input must be a string.');
      session = this.connection.openSession();
      session.execCommand(cmdstr);
      session.close();
    end
    function scpget(this,remoteDirectory,remoteFiles,localDirectory)
      %Copy files from target using SecureCopy (SCP)
      %
      %Syntax:
      % ssh2obj.scpget(remoteDirectory,remoteFiles,localDirectory)
      import ch.ethz.ssh2.*;
      assert(this.connection.isAuthenticationComplete,'You must be connected before sending a command.');
      assert(ischar(localDirectory),'localDirectory must be a string.');
      assert(ischar(remoteDirectory),'remoteDirectory must be a string.');
      assert(ischar(remoteFiles)|iscellstr(remoteFiles),'remoteFiles must be a string or a cellstr.');
      remoteFiles = this.remotePathString(cellstr(remoteFiles),remoteDirectory);
      scp = SCPClient(this.connection);
      scp.get(remoteFiles,localDirectory);
    end
    function scpput(this,localDirectory,localFiles,remoteDirectory)
      %Copy files to target using SecureCopy (SCP)
      %
      %Syntax:
      % ssh2obj.scpput(localDirectory,localFiles,remoteDirectory)
      import ch.ethz.ssh2.*;
      assert(this.connection.isAuthenticationComplete,'You must be connected before sending a command.');
      assert(ischar(localDirectory),'localDirectory must be a string.');
      assert(ischar(remoteDirectory),'remoteDirectory must be a string.');
      assert(ischar(localFiles)|iscellstr(localFiles),'localFiles must be a string or a cellstr.');
      localFiles=this.localPathString(cellstr(localFiles),localDirectory);
      scp = SCPClient(this.connection);
      scp.put(localFiles,remoteDirectory,sprintf('%04d',this.scpmode));
    end
    function close(this)
      %Closes the connection
      import ch.ethz.ssh2.*;
      if isempty(this.connection),return,end
      this.connection.close();
      this.connection = [];
    end
    function delete(this)
      %Closes the connection and deletes the object
      close(this);
    end
  end
  methods (Hidden,Access=private)
    function setProxy(this)
      import ch.ethz.ssh2.*;
      if isempty(this.proxyHost),return,end % No proxy
      if isempty(this.proxyUser),
        proxy = HTTPProxyData(this.proxyHost,this.proxyPort);
      else
        proxy = HTTPProxyData(this.proxyHost,this.proxyPort,this.proxyUser,this.proxyPass);
      end
      this.connection.setProxyData(proxy);
    end
  end
  methods (Static,Hidden,Access=private)
    function loadjavalib(ganymed_library)
      % check if lib is already loaded
      java_lib_loaded = not(isempty(cell2mat(strfind(javaclasspath('-all'),ganymed_library))));
      if java_lib_loaded, return; end
      % check if lib is in the MATLAB path
      pathtolib = which(ganymed_library);
      assert(not(isempty(pathtolib)),'SSH2 cannot find the %s java package in MATLAB path.',ganymed_library);
      % add lib to dynamic java path
      javaaddpath(pathtolib);
    end
    function str = remotePathString(fileStr,pathStr)
      % assume that we're uploading to a unix server, filesep = '/';
      filesepstr = '/';
      if (~isempty(pathStr) && (pathStr(end) ~= filesepstr)) %no pathsep included
        str = strcat(pathStr,filesepstr,fileStr);
      elseif (~isempty(pathStr)) %pathsep is included
        str = strcat(pathStr,fileStr);
      else
        str = fileStr;
      end
    end
    function str = localPathString(fileStr,pathStr)
      % use the encoding scheme of local host
      filesepstr = filesep();
      if (~isempty(pathStr) && (pathStr(end)~=filesepstr)) %no pathsep included
        str = strcat(pathStr,filesepstr,fileStr);
      elseif not(isempty(pathStr)) %pathsep is included
        str = strcat(pathStr,fileStr);
      else
        str = fileStr;
      end
    end
  end
end