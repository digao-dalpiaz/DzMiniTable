object FrmExample: TFrmExample
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MiniTable Example'
  ClientHeight = 242
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LbList: TLabel
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Customer List'
  end
  object L: TListBox
    Left = 8
    Top = 24
    Width = 273
    Height = 209
    ItemHeight = 13
    TabOrder = 0
    OnClick = LClick
  end
  object BtnAdd: TButton
    Left = 288
    Top = 24
    Width = 89
    Height = 33
    Caption = 'Add'
    TabOrder = 1
    OnClick = BtnEditClick
  end
  object BtnEdit: TButton
    Left = 288
    Top = 64
    Width = 89
    Height = 33
    Caption = 'Edit'
    TabOrder = 2
    OnClick = BtnEditClick
  end
  object BtnDel: TButton
    Left = 288
    Top = 104
    Width = 89
    Height = 33
    Caption = 'Delete'
    TabOrder = 3
    OnClick = BtnDelClick
  end
  object BtnMoveUp: TButton
    Left = 288
    Top = 152
    Width = 89
    Height = 33
    Caption = 'Move Up'
    TabOrder = 4
    OnClick = BtnMoveUpClick
  end
  object BtnMoveDown: TButton
    Left = 288
    Top = 192
    Width = 89
    Height = 33
    Caption = 'Move Down'
    TabOrder = 5
    OnClick = BtnMoveDownClick
  end
  object MT: TMiniTable
    Left = 216
    Top = 56
  end
end
