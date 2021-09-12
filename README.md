# DzMiniTable

## Delphi non-visual component to handle small dynamic table stored as plain text

![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-XE3..10.4-blue.svg)
![Platforms](https://img.shields.io/badge/Platforms-Win32%20and%20Win64-red.svg)
![Auto Install](https://img.shields.io/badge/-Auto%20Install%20App-orange.svg)
![VCL and FMX](https://img.shields.io/badge/-VCL%20and%20FMX-lightgrey.svg)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/C0C53LVFN)

Please, checkout my new component [DzXMLTable](https://github.com/digao-dalpiaz/DzXMLTable), it's a new concept of this component, storing data in XML format.

- [What's New](#whats-new)
- [Component Description](#component-description)
- [Installing](#installing)
- [Published Properties](#published-properties)
- [Public Properties](#public-properties)
- [Procedures/Functions](#proceduresfunctions)

## What's New

- 09/12/2021 (Version 1.8)

   - Delphi 11 auto-install support.

<details>
  <summary>Click here to view the entire changelog</summary>

- 03/13/2021 (Version 1.7)

   - Removed CompInstall.exe from component sources due to AV false positive warning (now you can get it directly from CompInstall repository).

- 02/01/2021 (Version 1.6)

   - Removed Delphi XE2 from the list of environments as it was never possible to compile in this version.

- 12/18/2020 (Version 1.5)

   - Updated Component Installer app (Fixed call to rsvars.bat when Delphi is installed in a path containing spaces characters).

- 10/31/2020 (Version 1.4)

   - Included Delphi 10.4 auto-install support.

- 10/27/2020 (Version 1.3)

   - Fixed previous Delphi versions (at least on XE2, XE3, XE4 and XE5) package tag. It was causing package compilation error.

- 10/26/2020 (Version 1.2)

   - Updated CompInstall to version 2.0 (now supports GitHub auto-update)

- 10/09/2020 (Version 1.1)

   - New methods to search data

- 05/03/2020

   - Updated CompInstall to version 1.2

- 02/11/2019

   - Include auto install app

- 02/08/2019

   - Component renamed. Please full uninstall previous version before install this version. :warning:

- 02/07/2019

   - Add Win64 support (library folders changed!) :warning:
   
</details>

## Component Description

When you are working on your software project, you always need to store some data into a INI file or some text file, as a configuration file or other information.

So, the options you have is INI file, or plain text. And almost always you need a table with some fields.

In a plain text, you can use one record per line, and separate fields using tab character, or pipe character, or another one. But you have some problems with this method: you need to take care about the separator char, not using it at fields value; and you have a biggest problem: in a future version, if you need to add a column, you lose the compatibility at this file when there are already data stored.

If you are working with INI file, you can specify the field names, but even that, you have problems to store one record per section, and is difficult to reorder records, delete records and name the record.

But don't worry, here is the solution.

The MiniTable is a non-visual component where you can store records with fields and values, and you can name the field, so you don't need to worry at future versions. You can add new fields at any time, just reading and writing them.

## Installing

### Auto install

1. Download Component Installer from: https://github.com/digao-dalpiaz/CompInstall/releases/latest
2. Put **CompInstall.exe** into the component repository sources folder.
3. Close Delphi IDE and run **CompInstall.exe** app.

### Manual install

1. Open **DzMiniTable** package in Delphi.
2. Ensure **Win32** Platform and **Release** config are selected.
3. Then **Build** and **Install**.
4. If you want to use Win64 platform, select this platform and Build again.
5. Add sub-path Win32\Release to the Library paths at Tools\Options using 32-bit option, and if you have compiled to 64 bit platform, add sub-path Win64\Release using 64-bit option.

Supports Delphi XE3..Delphi 10.4

## Published Properties

`AutoSave: Boolean` = Enables auto save to specified FileName at any method that writes any change to the table

`FileName: String` = Specifies the full file name to Open and Save the table

`JumpOpen: Boolean` = When this property is enabled, if the file does not exist at Open method, the table will be loaded empty without raise any exception.

## Public Properties

`Lines: TStringList` = Allows you to change the stored table manually. **You should never change this TStringList.**

`MemString: String` = Allows you to load the table directly from a string, and store the table to a string. This is useful when you are storing the table in a database blob file.

`SelIndex: Integer` = Returns the current selected index (read-only property)

`Count: Integer` = Returns the record count of the table (read-only property)

`F[FieldName: String]: Variant` = Read/write a field value at current selected record. The FieldName is case-insensitive.
If you are reading field value and the field does not exist, the result is an empty string.

## Procedures/Functions

```delphi
procedure SelReset;
```
Resets the selection of record to none. You can use this method to initialize an iteration of record, ensuring the selected record is reseted.

```delphi
function InRecord: Boolean;
```
Returns true if there is a record selected

```delphi
procedure Open;
```
Load the table from file specified at FileName property

```delphi
procedure Save;
```
Save the table to file specified at FileName property

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
DzMiniTable.SelReset;
while MiniTable.Next do
begin
  ListBox.Add(DzMiniTable.F['Name']+' / '+MiniTable.F['Phone']);
end;
```

```delphi
procedure New;
```
Create a new record at the end of the table position and select it, so you can immediately start write fields.

```delphi
procedure Insert(Index: Integer);
```
Insert a new record at the index position and select it, so you can immediately start write fields.

```delphi
procedure Post;
```
Writes all change in the current record to the table. You don't need to start editing of the record. See example below:

```delphi
DzMiniTable.New;
DzMiniTable.F['Name'] := 'John';
DzMiniTable.F['Phone'] := '1111-2222';
DzMiniTable.Post;
```
or:
```delphi
DzMiniTable.Select(3);
DzMiniTable.F['Phone'] := '1111-2222';
DzMiniTable.Post;
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
function FindIndex(const FieldName: string; const Value: Variant): Integer;
```
Find any field value on all records, returning record index position.

```delphi
function Locate(const FieldName: string; const Value: Variant): Boolean;
```
Find any field value on all records, returning true if record found, and **positioning it as current record**.
If no record is found, the current position will not be changed.

```delphi
function ContainsValue(const FieldName: string; const Value: Variant): Boolean;
```
Find any field value on all records, returning true if record found.

```delphi
function FieldExists(const FieldName: String): Boolean;
```
Returns true if the FieldName exists at current selected record.

```delphi
function ReadDef(const FieldName: String; const Default: Variant): Variant;
```
This functions is the same as the F property, but here you can specify a default value when the Field does not exist in the record.

