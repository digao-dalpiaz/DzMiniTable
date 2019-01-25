object FrmEdit: TFrmEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Add Customer'
  ClientHeight = 205
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 29
    Height = 13
    Caption = 'Group'
  end
  object Label3: TLabel
    Left = 16
    Top = 112
    Width = 37
    Height = 13
    Caption = 'Amount'
  end
  object Bevel1: TBevel
    Left = 16
    Top = 160
    Width = 409
    Height = 9
    Shape = bsTopLine
  end
  object EdName: TEdit
    Left = 16
    Top = 32
    Width = 177
    Height = 21
    TabOrder = 0
  end
  object EdGroup: TEdit
    Left = 16
    Top = 80
    Width = 177
    Height = 21
    TabOrder = 1
  end
  object EdAmount: TEdit
    Left = 16
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object BtnOK: TButton
    Left = 144
    Top = 168
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 224
    Top = 168
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
