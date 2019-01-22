unit uConst;

interface

resourcestring
  sInvalidCommand = '- Error: Invalid Command';
  sCommands = 'List of commands: ' + slineBreak +
    '   - "find <plugin name>" to search for plugins.' + slineBreak +
    '   - "install <index>" to install a plugin.' + slineBreak +
    '   - "help" to list all commands' + slineBreak +
    '   - "exit/quit" to close the application' + slineBreak + '';

const
  cArrow = '->';
  cCommandFind = 'find';
  cCommandInstall = 'install';
  cCommandHelp = 'help';
  cCommandExit = 'exit';
  cCommandQuit = 'quit';
  eErrorTooManyRequests = 'Error: HTTP/1.1 429 Too Many Requests';

implementation

end.
