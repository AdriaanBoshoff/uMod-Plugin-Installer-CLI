unit uConfigManager;

interface

type
  TConfigManager = class
    const
      CONFIG_FILE = './config.cfg';
  public
    plugins_folder: string;
    procedure SaveString(const aSection, aKey, aValue: string);
    function ReadString(const aSection, aKey, aValue: string): string;
  end;

var
  config: TConfigManager;

implementation

uses
  IniFiles;

{ TConfigManager }

function TConfigManager.ReadString(const aSection, aKey, aValue: string): string;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(CONFIG_FILE);
  try
    Result := ini.ReadString(aSection, aKey, aValue);
  finally
    ini.Free;
  end;
end;

procedure TConfigManager.SaveString(const aSection, aKey, aValue: string);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(CONFIG_FILE);
  try
    ini.WriteString(aSection, aKey, aValue);
  finally
    ini.Free;
  end;
end;

end.

