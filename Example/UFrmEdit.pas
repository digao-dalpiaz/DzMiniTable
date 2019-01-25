unit UFrmEdit;

interface

uses Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Controls, System.Classes;

type
  TFrmEdit = class(TForm)
    Label1: TLabel;
    EdName: TEdit;
    Label2: TLabel;
    EdGroup: TEdit;
    Label3: TLabel;
    EdAmount: TEdit;
    BtnOK: TButton;
    BtnCancel: TButton;
    Bevel1: TBevel;
    procedure BtnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Edit: Boolean;
  end;

var
  FrmEdit: TFrmEdit;

function DoEdit(Edit: Boolean): Boolean;

implementation

{$R *.dfm}

uses UFrmExample;

function DoEdit(Edit: Boolean): Boolean;
begin
  FrmEdit := TFrmEdit.Create(Application);
  FrmEdit.Edit := Edit;
  Result := FrmEdit.ShowModal = mrOk;
  FrmEdit.Free;
end;

procedure TFrmEdit.FormShow(Sender: TObject);
begin
  if Edit then
  begin
    Caption := 'Edit Customer';

    EdName.Text := FrmExample.MT.F['NAME'];
    EdGroup.Text := FrmExample.MT.F['GROUP'];
    EdAmount.Text := FrmExample.MT.F['AMOUNT'];
  end;
end;

procedure TFrmEdit.BtnOKClick(Sender: TObject);
begin
  if not Edit then
    FrmExample.MT.New;

  FrmExample.MT.F['NAME'] := EdName.Text;
  FrmExample.MT.F['GROUP'] := EdGroup.Text;
  FrmExample.MT.F['AMOUNT'] := EdAmount.Text;

  FrmExample.MT.Post;

  if Edit then
    FrmExample.L.Items[FrmExample.L.ItemIndex] := EdName.Text
  else
  begin
    FrmExample.L.ItemIndex := FrmExample.L.Items.Add(EdName.Text);
    FrmExample.UpdButtons;
  end;

  ModalResult := mrOk;
end;

end.
