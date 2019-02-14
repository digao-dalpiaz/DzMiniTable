{------------------------------------------------------------------------------
TDzMiniTable component
Developed by Rodrigo Depiné Dalpiaz (digão dalpiaz)
To use as a small dinamic table stored as text file

https://github.com/digao-dalpiaz/DzMiniTable

Please, read the documentation at GitHub link.

File structure example:
  ID=1,Nome=Jhon
  ID=2,Nome=Mary
------------------------------------------------------------------------------}

unit DzMiniTable;

interface

uses System.Classes;

type
  TDzMiniTable = class(TComponent)
  private
    FAbout: String;

    FFileName: String;
    FJumpOpen: Boolean; //JumpOpen - if file not exists, bypass open method (load blank table)
    FAutoSave: Boolean;

    FSelIndex: Integer;

    Tb, S: TStringList;

    function GetField(const FieldName: String): Variant;
    procedure SetField(const FieldName: String; const Value: Variant);

    function GetCount: Integer;

    procedure Reset;

    procedure CheckAutoSave;
    function GetMemString: String;
    procedure SetMemString(const Value: String);
    procedure CheckInRecord;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Lines: TStringList read Tb;

    property MemString: String read GetMemString write SetMemString;
    property SelIndex: Integer read FSelIndex;
    property Count: Integer read GetCount;
    property F[const FieldName: String]: Variant read GetField write SetField;

    procedure SelReset;
    function InRecord: Boolean;

    procedure Open;
    procedure Save;
    procedure EmptyTable;
    procedure EmptyRecord;
    function IsEmpty: Boolean;
    procedure Select(Index: Integer);
    procedure First;
    procedure Last;
    function Next: Boolean;
    procedure New;
    procedure Insert(Index: Integer);
    procedure Post;
    procedure Delete;
    procedure MoveDown;
    procedure MoveUp;
    function Find(const FieldName: String; const Value: Variant; KeepIndex: Boolean = False): Boolean;
    function FieldExists(const FieldName: String): Boolean;
    function ReadDef(const FieldName: String; const Default: Variant): Variant;
  published
    property About: String read FAbout;

    property FileName: String read FFileName write FFileName;
    property AutoSave: Boolean read FAutoSave write FAutoSave default False;
    property JumpOpen: Boolean read FJumpOpen write FJumpOpen default True;
  end;

procedure Register;

implementation

uses System.SysUtils;

procedure Register;
begin
  RegisterComponents('Digao', [TDzMiniTable]);
end;

//

constructor TDzMiniTable.Create(AOwner: TComponent);
begin
  inherited;

  FAbout := 'Digão Dalpiaz / Version 1.0';

  FJumpOpen := True; //default

  Tb := TStringList.Create; //full table
  S := TStringList.Create; //selected record

  FSelIndex := -1;
end;

destructor TDzMiniTable.Destroy;
begin
  Tb.Free;
  S.Free;

  inherited;
end;

function TDzMiniTable.InRecord: Boolean;
begin
  Result := FSelIndex<>-1;
end;

procedure TDzMiniTable.CheckInRecord;
begin
  if not InRecord then
    raise Exception.Create('No record selected');
end;

procedure TDzMiniTable.SelReset;
begin
  if FSelIndex=-1 then Exit;

  S.Clear; //clear selected record
  FSelIndex := -1;
end;

procedure TDzMiniTable.Reset;
begin
  Tb.Clear;
  SelReset;
end;

procedure TDzMiniTable.Open;
begin
  Reset; //clear stringlist's and selection set

  if FJumpOpen then
    if not FileExists(FFileName) then Exit;

  Tb.LoadFromFile(FFileName);
end;

procedure TDzMiniTable.Save;
begin
  Tb.SaveToFile(FFileName);
end;

function TDzMiniTable.GetMemString: String;
begin
  Result := Tb.Text;
end;

procedure TDzMiniTable.SetMemString(const Value: String);
begin
  Reset;

  Tb.Text := Value;
end;


function TDzMiniTable.GetCount: Integer;
begin
  Result := Tb.Count;
end;

function TDzMiniTable.IsEmpty: Boolean;
begin
  Result := ( Count = 0 );
end;

function TDzMiniTable.GetField(const FieldName: String): Variant;
begin
  CheckInRecord;

  Result := S.Values[FieldName];
end;

procedure TDzMiniTable.SetField(const FieldName: String; const Value: Variant);
begin
  CheckInRecord;

  S.Values[FieldName] := Value;
end;

procedure TDzMiniTable.Select(Index: Integer);
begin
  if Index>Count-1 then raise Exception.CreateFmt('Record of index %d does not exist', [Index]);

  S.CommaText := Tb[Index];
  FSelIndex := Index;
end;

function TDzMiniTable.Next: Boolean;
begin
  Result := ( FSelIndex < Count-1 );

  if Result then
    Select(FSelIndex+1)
  else
    SelReset;
end;

procedure TDzMiniTable.First;
begin
  if IsEmpty then raise Exception.Create('There is no record to select');

  Select(0);
end;

procedure TDzMiniTable.Last;
begin
  if IsEmpty then raise Exception.Create('There is no record to select');

  Select(Count-1);
end;

procedure TDzMiniTable.New;
begin
  Tb.Add('');
  Last;
end;

procedure TDzMiniTable.Insert(Index: Integer);
begin
  Tb.Insert(Index, '');
  Select(Index);
end;

procedure TDzMiniTable.EmptyRecord;
begin
  CheckInRecord;

  S.Clear;
end;

procedure TDzMiniTable.Post;
begin
  CheckInRecord;

  Tb[FSelIndex] := S.CommaText;

  CheckAutoSave;
end;

procedure TDzMiniTable.Delete;
begin
  CheckInRecord;

  Tb.Delete(FSelIndex);
  SelReset;

  CheckAutoSave;
end;

procedure TDzMiniTable.MoveUp;
begin
  CheckInRecord;

  if FSelIndex=0 then raise Exception.Create('Already at first record');

  Tb.Exchange(FSelIndex, FSelIndex-1);
  Dec(FSelIndex);

  CheckAutoSave;
end;

procedure TDzMiniTable.MoveDown;
begin
  CheckInRecord;

  if FSelIndex=Count-1 then raise Exception.Create('Already at last record');

  Tb.Exchange(FSelIndex, FSelIndex+1);
  Inc(FSelIndex);

  CheckAutoSave;
end;

procedure TDzMiniTable.EmptyTable;
begin
  Reset; //clear stringlist's and selection set

  CheckAutoSave;
end;

procedure TDzMiniTable.CheckAutoSave;
begin
  if FAutoSave then Save;
end;

function TDzMiniTable.Find(const FieldName: String; const Value: Variant; KeepIndex: Boolean = False): Boolean;
var Idx: Integer;
begin
  Result := False;

  Idx := FSelIndex;
  try
    SelReset;
    while Next do
      if F[FieldName] = Value then Exit(True);
  finally
    if KeepIndex then
      if Idx<>-1 then
        Select(Idx)
      else
        SelReset;
  end;
end;

function TDzMiniTable.FieldExists(const FieldName: String): Boolean;
begin
  CheckInRecord;

  Result := ( S.IndexOfName(FieldName) <> -1 );
end;

function TDzMiniTable.ReadDef(const FieldName: String; const Default: Variant): Variant;
begin
  if FieldExists(FieldName) then
    Result := F[FieldName]
  else
    Result := Default;
end;

end.
