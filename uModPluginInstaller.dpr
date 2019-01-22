program uModPluginInstaller;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  uCommands in 'uCommands.pas',
  uConst in 'uConst.pas',
  uPluginManager in 'uPluginManager.pas',
  uConfigManager in 'uConfigManager.pas',
  uHelpers in 'uHelpers.pas';

procedure RunApplication;
var
  aResponse: string;
begin
  ListCommands;

  while True do
  begin
    Readln(aResponse);
    aResponse := aResponse.ToLower;

    if aResponse.StartsWith(cCommandFind) then
      CommandFind(aResponse)
    else if aResponse.StartsWith(cCommandInstall) then
      CommandInstall(aResponse.Replace(cCommandInstall, '').ToInteger)
    else if SameText(aResponse, cCommandHelp) then
      ListCommands
    else if (SameText(aResponse, cCommandExit)) or (SameText(aResponse, cCommandQuit)) then
    begin
      FreeAndNil(PluginManager);
      Break
    end
    else
      WriteInvalidCommand;
  end;
end;

begin
  try
    PluginManager := TPluginManager.Create;

    Writeln('uMod Plugin Installer by Quantum.');
    RunApplication;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      Writeln('Press any key to exit.');
      Readln;
    end;
  end;

end.

