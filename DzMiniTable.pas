{------------------------------------------------------------------------------
TDzMiniTable component
Developed by Rodrigo Depine Dalpiaz (digao dalpiaz)
To use as a small dynamic table stored as text file

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
  TRecordStore = class
  private
    S: TStringList;

    procedure LoadRecordFromString(const Data: string);
    function GetRecordAsString: string;

    function ReadField(const FieldName: string): string;
    procedure WriteField(const FieldName, Value: string);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TDzMiniTable = class(TComponent)
  private
    FAbout: string;

    FFileName: string;
    FJumpOpen: Boolean; //JumpOpen - if file not exists, bypass open method (load blank table)
    FAutoSave: Boolean;

    FSelIndex: Integer;

    Tb: TStringList;
    CurRecord: TRecordStore;

    function GetField(const FieldName: string): Variant;
    procedure SetField(const FieldName: string; const Value: Variant);

    function GetCount: Integer;

    procedure Reset;

    procedure CheckAutoSave;
    function GetMemString: string;
    procedure SetMemString(const Value: string);
    procedure CheckInRecord;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Lines: TStringList read Tb;

    property MemString: string read GetMemString write SetMemString;
    property SelIndex: Integer read FSelIndex;
    property Count: Integer read GetCount;
    property F[const FieldName: string]: Variant read GetField write SetField;

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

    function FieldExists(const FieldName: string): Boolean;
    function ReadDef(const FieldName: string; const Default: Variant): Variant;

    function FindIndex(const FieldName: string; const Value: Variant): Integer;
    function Locate(const FieldName: string; const Value: Variant): Boolean;
    function ContainsValue(const FieldName: string; const Value: Variant): Boolean;
  published
    property About: string read FAbout;

    property FileName: string read FFileName write FFileName;
    property AutoSave: Boolean read FAutoSave write FAutoSave default False;
    property JumpOpen: Boolean read FJumpOpen write FJumpOpen default True;
  end;

procedure Register;

implementation

uses System.SysUtils;

const STR_VERSION = '1.5';

procedure Register;
begin
  RegisterComponents('Digao', [TDzMiniTable]);
end;

//

constructor TRecordStore.Create;
begin
  inherited;
  S := TStringList.Create;
end;

destructor TRecordStore.Destroy;
begin
  S.Free;
  inherited;
end;

procedure TRecordStore.LoadRecordFromString(const Data: string);
begin
  S.CommaText := Data;
end;

function TRecordStore.GetRecordAsString: string;
begin
  Result := S.CommaText;
end;

function TRecordStore.ReadField(const FieldName: string): string;
begin
  Result := S.Values[FieldName];
end;

procedure TRecordStore.WriteField(const FieldName, Value: string);
begin
  S.Values[FieldName] := Value;
end;

//

constructor TDzMiniTable.Create(AOwner: TComponent);
begin
  inherited;

  FAbout := 'Digao Dalpiaz / Version '+STR_VERSION;

  FJumpOpen := True; //default

  Tb := TStringList.Create; //full table
  CurRecord := TRecordStore.Create; //selected record

  FSelIndex := -1;
end;

destructor TDzMiniTable.Destroy;
begin
  Tb.Free;
  CurRecord.Free;

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

  CurRecord.S.Clear; //clear selected record
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

function TDzMiniTable.GetMemString: string;
begin
  Result := Tb.Text;
end;

procedure TDzMiniTable.SetMemString(const Value: string);
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

function TDzMiniTable.GetField(const FieldName: string): Variant;
begin
  CheckInRecord;

  Result := CurRecord.ReadField(FieldName);
end;

procedure TDzMiniTable.SetField(const FieldName: string; const Value: Variant);
begin
  CheckInRecord;

  CurRecord.WriteField(FieldName, Value);
end;

procedure TDzMiniTable.Select(Index: Integer);
begin
  if Index>Count-1 then raise Exception.CreateFmt('Record of index %d does not exist', [Index]);

  CurRecord.LoadRecordFromString(Tb[Index]);
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
  Tb.Add(string.Empty);
  Last;
end;

procedure TDzMiniTable.Insert(Index: Integer);
begin
  Tb.Insert(Index, string.Empty);
  Select(Index);
end;

procedure TDzMiniTable.EmptyRecord;
begin
  CheckInRecord;

  CurRecord.S.Clear;
end;

procedure TDzMiniTable.Post;
begin
  CheckInRecord;

  Tb[FSelIndex] := CurRecord.GetRecordAsString;

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

function TDzMiniTable.FieldExists(const FieldName: string): Boolean;
begin
  CheckInRecord;

  Result := ( CurRecord.S.IndexOfName(FieldName) <> -1 );
end;

function TDzMiniTable.ReadDef(const FieldName: string; const Default: Variant): Variant;
begin
  if FieldExists(FieldName) then
    Result := F[FieldName]
  else
    Result := Default;
end;

function TDzMiniTable.FindIndex(const FieldName: string; const Value: Variant): Integer;
var
  I: Integer;
  R: TRecordStore;
begin
  Result := -1;

  R := TRecordStore.Create;
  try
    for I := 0 to Tb.Count-1 do
    begin
      R.LoadRecordFromString(Tb[I]);
      if R.ReadField(FieldName) = Value then
      begin
        Result := I;
        Break;
      end;
    end;
  finally
    R.Free;
  end;
end;

function TDzMiniTable.Locate(const FieldName: string; const Value: Variant): Boolean;
var
  Idx: Integer;
begin
  Result := False;

  Idx := FindIndex(FieldName, Value);
  if Idx <> -1 then
  begin
    Select(Idx);
    Result := True;
  end;
end;

function TDzMiniTable.ContainsValue(const FieldName: string; const Value: Variant): Boolean;
begin
  Result := FindIndex(FieldName, Value) <> -1;
end;

end.
