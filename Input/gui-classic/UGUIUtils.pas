unit UGUIUtils;

interface

uses
  Classes, SysUtils, Dialogs;

function InputQueryPassword(ACaption, APrompt : String; var defValue : String) : Boolean;

implementation

function InputQueryPassword(ACaption, APrompt : String; var defValue : String) : Boolean;
begin
  Result := InputQuery(ACaption,#31+APrompt,defValue);
end;

end.

