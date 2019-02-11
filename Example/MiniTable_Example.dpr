program MiniTable_Example;

uses
  Vcl.Forms,
  UFrmEdit in 'UFrmEdit.pas' {FrmEdit},
  UFrmExample in 'UFrmExample.pas' {FrmExample};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmExample, FrmExample);
  Application.Run;
end.
