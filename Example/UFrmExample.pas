unit UFrmExample;

interface

uses Vcl.Forms, DzMiniTable, Vcl.StdCtrls, Vcl.Controls, System.Classes;

type
  TFrmExample = class(TForm)
    MT: TDzMiniTable;
    L: TListBox;
    LbList: TLabel;
    BtnAdd: TButton;
    BtnEdit: TButton;
    BtnDel: TButton;
    BtnMoveUp: TButton;
    BtnMoveDown: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure LClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnMoveUpClick(Sender: TObject);
    procedure BtnMoveDownClick(Sender: TObject);
  private
    procedure LoadList;
  public
    procedure UpdButtons;
  end;

var
  FrmExample: TFrmExample;

implementation

{$R *.dfm}

uses UFrmEdit, System.SysUtils;

procedure TFrmExample.FormCreate(Sender: TObject);
begin
  MT.FileName := ExtractFilePath(Application.ExeName)+'DATA.TXT';

  LoadList;
  UpdButtons;
end;

procedure TFrmExample.FormDestroy(Sender: TObject);
begin
  MT.Save;
end;

procedure TFrmExample.LoadList;
begin
  MT.Open;

  MT.SelReset;
  while MT.Next do
  begin
    L.Items.Add( MT.F['NAME'] );
  end;
end;

procedure TFrmExample.LClick(Sender: TObject);
begin
  MT.Select(L.ItemIndex);
  UpdButtons;
end;

procedure TFrmExample.UpdButtons;
var Sel: Boolean;
begin
  Sel := L.ItemIndex<>-1;

  BtnEdit.Enabled := Sel;
  BtnDel.Enabled := Sel;

  BtnMoveUp.Enabled := Sel and (L.ItemIndex>0);
  BtnMoveDown.Enabled := Sel and (L.ItemIndex<L.Count-1);
end;

procedure TFrmExample.BtnEditClick(Sender: TObject);
begin
  DoEdit(Sender = BtnEdit);
end;

procedure TFrmExample.BtnDelClick(Sender: TObject);
begin
  MT.Delete;
  L.DeleteSelected;
  UpdButtons;
end;

procedure TFrmExample.BtnMoveUpClick(Sender: TObject);
begin
  MT.MoveUp;
  L.Items.Exchange(L.ItemIndex, L.ItemIndex-1);
  UpdButtons;
end;

procedure TFrmExample.BtnMoveDownClick(Sender: TObject);
begin
  MT.MoveDown;
  L.Items.Exchange(L.ItemIndex, L.ItemIndex+1);
  UpdButtons;
end;

end.
