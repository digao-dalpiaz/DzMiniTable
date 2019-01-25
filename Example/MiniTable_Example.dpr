program MiniTable_Example;

uses
  Vcl.Forms,
  UFrmExample in 'UFrmExample.pas' {FrmExample},
  UFrmEdit in 'UFrmEdit.pas' {FrmEdit};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmExample, FrmExample);
  Application.Run;
end.
