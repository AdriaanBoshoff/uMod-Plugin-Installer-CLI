unit uPluginManager;

interface

uses
  System.Generics.Collections, System.SysUtils;

type
  TPlugin = record
    name: string;
    title: string;
    slug: string;
    description: string;
    json_url: string;
    latest_release_version_formatted: string;
    download_url: string;
    author: string;
  end;

type
  TPluginManager = class
  public
    plugins: TList<TPlugin>;
    constructor Create;
  end;

var
  PluginManager: TPluginManager;

implementation

{ TPluginManager }

constructor TPluginManager.Create;
begin
  plugins := TList<TPlugin>.Create;
end;

end.

