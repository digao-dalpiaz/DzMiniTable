# MiniTable

## Delphi non-visual component to handle small dynamic table stored as plain text

- [Component Description](#component-description)
- [Installing](#installing)
- [Published Properties](#published-properties)
- [Public Properties](#public-properties)
- [Procedures/Functions](#proceduresfunctions)

## Component Description

When you are working on your software project, you always need to store some data into a INI file or some text file, as a configuration file or other information.

So, the options you have is INI file, or plain text. And almost always you need a table with some fields.

In a plain text, you can use one record per line, and separate fields using tab character, or pipe character, or another one. But you have some problems with this method: you need to take care about the separator char, not using it at fields value; and you have a biggest problem: in a future version, if you need to add a column, you lose the compatibility at this file when there are already data stored.

If you are working with INI file, you can specify the field names, but even that, you have problems to store one record per section, and is difficult to reorder records, delete records and name the record.

But don't worry, here is the solution.

The MiniTable is a non-visual component where you can store records with fields and values, and you can name the field, so you don't need to worry at future versions. You can add new fields at any time, just reading and writing them.

## Installing

Just add the MiniTable.pas to a package. Then build and install.

Note: To ensure the component is displayed with its icon, add the following line to the Package Source:
```
{$R MiniTable.dcr}
```

Supports Delphi XE2..Delphi 10.3 Rio

## Published Properties

`AutoSave: Boolean` = Enables auto save to specifyed FileName at any method that writes any change to the table

`FileName: String` = Specifyes the full file name to Open and Save the table

`JumpOpen: Boolean` = When this property is enabled, if the file does not exist at Open method, the table will be loaded empty without raise any exception.

## Public Properties

`Lines: TStringList` = Allows you to change the stored table manually. **You should never change this TStringList.**

`MemString: String` = Allows you to load the table directly from a string, and store the table to a string. This is useful when you are storing the table in a database blob file.

`SelIndex: Integer` = Returns the current selected index (read-only property)

`Count: Integer` = Returns the record count of the table (read-only property)

`F[FieldName: String]: Variant` = Read/write a field value at current selected record. The FieldName is case-insensitive.

## Procedures/Functions

```delphi
procedure SelReset;
```
Resets the selection of record to none. You can use this method to inicialize an iteration of record, ensuring the selected record is reseted.

```delphi
function InRecord: Boolean;
```
Returns true if there is a record selected

```delphi
procedure Open;
```
Load the table from file specifyed at FileName property

```delphi
procedure Save;
```
Save the table to file specifyed at FileName property

```delphi
procedure EmptyTable;
```
Clear all data in the table

```delphi
procedure EmptyRecord;
```
Clear all data in the current selected record

```delphi
function IsEmpty: Boolean;
```
Returns true if the table is empty

```delphi
procedure Select(Index: Integer);
```
Select the record by index position. When you select a record, all its fields stays stored at internal memory, so you can read and write the fields value using `F` property.

```delphi
procedure First;
```
Select the first record in the table

```delphi
procedure Last;
```
Select the last record in the table

```delphi
function Next: Boolean;
```
Select the next record in the table, based in the current index position. This method is useful to iterate all record. See example below:

```delphi
MiniTable.SelReset;
while MiniTable.Next do
begin
  ListBox.Add(MiniTable.F['Name']+' / '+MiniTable.F['Phone']);
end;
```

```delphi
procedure New;
```
Create a new record at the end of the table position and select it, so you can imediatelly start write fields.

```delphi
procedure Insert(Index: Integer);
```
Insert a new record at the index position and select it, so you can imediatelly start write fields.

```delphi
procedure Post;
```
Writes all change in the current record to the table. You don't need to start editting of the record. See example below:

```delphi
MiniTable.New;
MiniTable.F['Name'] := 'Jhon';
MiniTable.F['Phone'] := '1111-2222';
MiniTable.Post;
```
or:
```delphi
MiniTable.Select(3);
MiniTable.F['Phone'] := '1111-2222';
MiniTable.Post;
```

```delphi
procedure Delete;
```
Delete the current selected record

```delphi
procedure MoveDown;
```
Move the current record to one index down

```delphi
procedure MoveUp;
```
Move the current record to one index up

```delphi
function Find(const FieldName: String; const Value: Variant; KeepIndex: Boolean = False): Boolean;
```
Use this function to locate any field value on all records. The KeepIndex parameter allows you to specify if you want keep the current position of record, just returning true or false if the field value was located.
If you want to auto-select the found record, use KeepIndex=False (the default parameter value).

```delphi
function FieldExists(const FieldName: String): Boolean;
```
Returns true if the FieldName exists at current selected record.

```delphi
function ReadDef(const FieldName: String; const Default: Variant): Variant;
```
This functions is the same as the F property, but here you can specify a default value when the Field does not exist in the record.

