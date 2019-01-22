unit uCommands;

interface

uses
  System.SysUtils, System.Types, System.Classes, System.IOUtils, DateUtils;

procedure CommandInstall(const aIndex: Integer);

procedure CommandFind(aPluginName: string);

procedure WriteInvalidCommand;

procedure ListCommands;

implementation

uses
  uConst, djson, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdHTTP, uPluginManager, uConfigManager;

procedure CommandInstall(const aIndex: Integer);
var
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
  stream: TMemoryStream;
begin
  Writeln('');
  Writeln('Starting download...');
  try
    http := TIdHTTP.Create(nil);
    try
      http.Request.UserAgent := 'Indy/10 uMod Plugin Installer';
      ssl := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      try
        ssl.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
        http.IOHandler := ssl;

        stream := TMemoryStream.Create;
        try
          Writeln('Downloading ' + PluginManager.plugins[aIndex].title + '...');
          http.Get(PluginManager.plugins[aIndex].download_url, stream);
          Writeln('Saving as ' + PluginManager.plugins[aIndex].name + '.cs');
          stream.SaveToFile(PluginManager.plugins[aIndex].name + '.cs');
          Writeln('Plugin Downloaded!');
        finally
          stream.Free;
        end;
      finally
        ssl.Free;
      end;
    finally
      http.Free;
    end;
    Write(cArrow);
  except
    on E: Exception do
    begin
      Writeln('ERROR: ' + E.Message);
      Write(cArrow);
    end;
  end;
end;

procedure CommandFind(aPluginName: string);
var
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
  jdata, jplugin: TdJSON;
  aPlugin: TPlugin;
  I: Integer;
  page, last_page: Integer;
begin
  Writeln('');
  aPluginName := aPluginName.Replace(cCommandFind, '').Trim;
  last_page := 1;

  if aPluginName.Trim.IsEmpty then
  begin
    Writeln('Please enter a plugin name to search. Eg: "find Death Notes"');
    Write(cArrow);
    Exit;
  end;

  try
    Writeln('Searching plugins matching "' + aPluginName + '"...');
    PluginManager.plugins.Clear;

    http := TIdHTTP.Create(nil);
    try
      http.Request.UserAgent := 'Indy/10 (Windows NT 10.0; Win64; x64; rv:64.0) Gecko/20100101 Firefox/64.0';
      ssl := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      try
        ssl.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
        http.IOHandler := ssl;

        jdata := TdJSON.Parse(http.Get('https://umod.org/plugins/search.json?query=' + StringReplace(aPluginName, ' ', '', [rfReplaceAll]) + '&page=1&sort=&sortdir=asc&filter='));
        try
          last_page := jdata['last_page'].AsInteger;
        finally
          jdata.Free;
        end;

        for page := 1 to last_page do
        begin
          jdata := TdJSON.Parse(http.Get('https://umod.org/plugins/search.json?query=' + StringReplace(aPluginName, ' ', '', [rfReplaceAll]) + '&page=' + page.ToString + '&sort=&sortdir=asc&filter='));
          try
            for jplugin in jdata['data'] do
            begin
              aPlugin.name := jplugin['name'].AsString;
              aPlugin.title := jplugin['title'].AsString;
              aPlugin.slug := jplugin['slug'].AsString;
              aPlugin.description := jplugin['description'].AsString;
              aPlugin.json_url := jplugin['json_url'].AsString;
              aPlugin.latest_release_version_formatted := jplugin['latest_release_version_formatted'].AsString;
              aPlugin.download_url := jplugin['download_url'].AsString;
              aPlugin.author := jplugin['author'].AsString;

              if aPlugin.author.Trim.IsEmpty then
                aPlugin.author := 'unclaimed';

              PluginManager.plugins.Add(aPlugin);
            end;
          finally
            jdata.Free;
          end;
        end;

        if PluginManager.plugins.Count <> 0 then
        begin
          Writeln(Format('Listing %s plugins:', [PluginManager.plugins.Count.ToString]));

          for I := 0 to PluginManager.plugins.Count - 1 do
          begin
            with PluginManager.plugins[I] do
            begin
              Writeln(Format('   [%s] %s %s - %s (by %s)', [I.ToString, title, latest_release_version_formatted, description, author]));
            end;
          end;
        end
        else
          Writeln('No plugins were found matching: "' + aPluginName + '"');
      finally
        ssl.Free;
      end;
    finally
      http.Free;
    end;
    Write(cArrow);
  except
    on E: Exception do
    begin
      if SameText(E.Message, eErrorTooManyRequests) then
      begin
        Writeln('There has been too many requests. Please wait 1 minute and try again.');
        Write(cArrow);
      end
      else
      begin
        Writeln('Error: ' + E.Message);
        Write(cArrow);
      end;
    end;
  end;
end;

procedure WriteInvalidCommand;
begin
  Writeln('');
  Writeln(sInvalidCommand);
  Write(cArrow);
end;

procedure ListCommands;
begin
  Writeln('');
  Writeln(sCommands);
  write(cArrow);
end;

end.

