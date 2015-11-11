unit dep_diplome2repform2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, QuickRpt, QRCtrls, DB, ADODB;

type
  TDiplome2RepForm2 = class(TForm)
    DiplomeRep2: TQuickRep;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    SummaryBand1: TQRBand;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    Query: TADOQuery;
    PageFooterBand1: TQRBand;
    PageNumLabel: TQRLabel;
    QRLabel1: TQRLabel;
    QRMemo: TQRMemo;
    QRLabel9: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel10: TQRLabel;
    DirectorLabel: TQRLabel;
    SecretarLabel: TQRLabel;
    GetDateDayLabel: TQRLabel;
    GetDateMonthLabel: TQRLabel;
    QRLabel12: TQRLabel;
    GetDateYearLabel: TQRLabel;
    procedure EmptyPrint(sender: TObject; var Value: String);
    procedure Page2Copy(sender: TObject; var Value: String);
    procedure QRDBText3Print(sender: TObject; var Value: String);
    procedure FrameCopyPrint(sender: TObject; var Value: String);
    procedure PageNumLabelPrint(sender: TObject; var Value: String);
    procedure PrintCopy2(sender: TObject; var Value: String);
    procedure PrintValue2(sender: TObject; var Value: String);
    procedure FormCreate(Sender: TObject);
    procedure SummaryBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure QRDBText1Print(sender: TObject; var Value: String);
    procedure PrintCopyTitle(sender: TObject; var Value: String);
  private
  AisCopy : boolean;
  AisSlim : boolean;
  AStrHeight: integer;
  AStrLen   : integer;
  ARiskLen  : integer;
  AFontSize : integer;
  AInYear   : integer;
  AOutYear  : integer;
  Aforeign  : boolean;
    { Private declarations }
  public
  property isCopy: boolean read AisCopy write AisCopy;
  property isSlim: boolean read AisSlim write AisSlim;
  property size: integer read AFontSize write AFontSize;
  property len: integer read AStrLen write AStrLen;
  property riskLen: integer read ARiskLen write ARiskLen;
  property h: integer read AStrHeight write AStrHeight;
  property inYear: integer read AInYear write AInYear;
  property outYear: integer read AOutYear write AOutYear;
  property Foreign: boolean read AForeign write AForeign;
    { Public declarations }
  end;

var
  Diplome2RepForm2: TDiplome2RepForm2;
  finished : boolean;



//{---------------- compact version
//const
//  len  = 95; // max length
//  h    = 12;  // string height
//  size = 7;
// h = 15; // old value
//----------------- end compact}


implementation

uses dep_main, dep_dep, kern, dep_studentform;

{$R *.dfm}

procedure TDiplome2RepForm2.EmptyPrint(sender: TObject;
  var Value: String);
begin
Value := '';
if (not isCopy) then
  with sender as TQRLabel do
  begin
  Frame.DrawTop := false;
  Frame.DrawBottom := false;
  Frame.DrawLeft := false;
  Frame.DrawRight := false;
  end;
end;

procedure TDiplome2RepForm2.Page2Copy(sender: TObject;
  var Value: String);
begin
if (not isCopy) then
  Value := '';

end;

procedure TDiplome2RepForm2.QRDBText3Print(sender: TObject;
  var Value: String);
var
mark : integer;
begin
mark := StrToIntDef(Value,0);
case mark of
 0..2 : Value := '';
 3    : Value := '�����������������';
 4    : Value := '������';
 5    : Value := '�������';
 NN   : Value := '����������(�)';
 NS   : Value := '�� ������(�)';
 ZC   : Value := '�����';
end; // case;
end;

procedure TDiplome2RepForm2.FrameCopyPrint(sender: TObject;
  var Value: String);
begin
if not isCopy then
  with sender as TQRDBText do
  begin
  Frame.DrawTop := false;
  Frame.DrawBottom := false;
  Frame.DrawLeft := false;
  Frame.DrawRight := false;
  end;
  if Value = '0' then Value := ' ';
end;

procedure TDiplome2RepForm2.PageNumLabelPrint(sender: TObject;
  var Value: String);
begin
if DiplomeRep2.PageNumber > 1 then
  Value := Value+IntToStr(DiplomeRep2.PageNumber) else
  Value := ' ';
end;

procedure TDiplome2RepForm2.PrintCopy2(sender: TObject;
  var Value: String);
begin
if not ((DiplomeRep2.PageNumber > 1) and (isCopy)) then
  Value := ' ';
end;

procedure TDiplome2RepForm2.PrintValue2(sender: TObject; var Value: String);
begin
if (DiplomeRep2.PageNumber <= 1) then
  Value := ' ';
end;

procedure TDiplome2RepForm2.FormCreate(Sender: TObject);
begin
  len  := 90; // max length
  riskLen := 20; // risk zone
  h    := 12;  // string height
  size := 7;
  finished := false;
end;

procedure TDiplome2RepForm2.SummaryBand1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
var
  year : cardinal;

begin
if not finished then
  begin

  QRMemo.Height := 10;

  year := CurrentYear;
  if ((inYear < 1992) and (Year > 1992) and (not foreign)) then
//  if ((inYear < 1992) and (outYear > 1992) and (not foreign)) then
    begin
    QRMemo.Lines.Add('������������� ������ �������� � 13.08.1992 �. ������������ � '+
      '��������������� ��������������� ���������� �������� ����������������� ����������� ������������� '+
      '���������������� �������, ������ ������������ �� �116/� �� 13.08.1992 �.');
    QRMemo.Height := QRMemo.Height + 22;
    end; //if
  if ((inYear < 2003) and (Year > 2003) and (not foreign)) then
//  if ((inYear < 2003) and (outYear > 2003) and (not foreign)) then
    begin
    QRMemo.Lines.Add('��������������� ��������������� ���������� '+
      '�������� ����������������� ����������� ������������� ���������������� ������� '+
      '� 29.07.2003 ������������ � ��������������� '+
      '��������������� ���������� �������� ����������������� ����������� ������������� '+
      '���������������� ������� ��. �.�. ��������, ������ '+
      '�� 18.08.2003 �. �173/��.');
    QRMemo.Height := QRMemo.Height + 37;
    end; // if
  if ((inYear < 2009) and (Year >= 2009) and (not foreign)) then
//  if ((inYear < 2009) and (outYear >= 2009) and (not foreign)) then
    begin
    QRMemo.Lines.Add('��������������� ��������������� ���������� '+
      '�������� ����������������� ����������� ������������� ���������������� ������� '+
      '��. �.�. �������� � 28.01.2009 ������������ � ����������� ��������������� '+
      '��������������� ���������� �������� ����������������� ����������� ������������� '+
      '���������������� ������� ��. �.�. ��������, ������ ������������ �������� �� '+
      '����������� �� 22.12.2006 �. �1598.');
    QRMemo.Height := QRMemo.Height + 37;
    end; // if
  if ((inYear < 2012) and (Year >= 2012) and (not foreign)) then
//  if ((inYear < 2009) and (outYear >= 2009) and (not foreign)) then
    begin
    QRMemo.Lines.Add('����������� ��������������� ��������������� ���������� '+
      '�������� ����������������� ����������� ������������� ���������������� ������� '+
      '��. �.�. �������� � 24.02.2012 ������������ � ��������������� '+
      '��������������� ���������� �������� ����������������� ����������� ������������� '+
      '���������������� ������� ��. �.�. ��������, ������ ������������ ����������� � ����� '+
      '����������� ������� �� 09.02.2012 �. �324.');
    QRMemo.Height := QRMemo.Height + 37;
    end; // if
  if ((inYear < 2013) and (Year >= 2013) and (not foreign)) then
    begin
    QRMemo.Lines.Add('��������������� ��������������� ���������� '+
      '�������� ����������������� ����������� ������������� ���������������� ������� '+
      '��. �.�. �������� � 26.07.2013 ������������ � ��������������� '+
      '��������������� ���������� �������� ����������������� ����������� ������������� '+
      '���������������� �������� ��. �.�. ��������, ������������ �������� ������������� '+
      '����������� ������� �� 07.06.2013 �. �438-�.');
    QRMemo.Height := QRMemo.Height + 37;
    end; // if

  QRMemo.Lines.Add(
  '--------------------------------------------------------'+
  ' ����� ��������� '+
  '--------------------------------------------------------');
  SummaryBand1.Height := QRMemo.Height+1;
  finished := true;
  end;
 //SummaryBand1.Frame.DrawBottom := true;
end;


procedure TDiplome2RepForm2.QRDBText1Print(sender: TObject;
  var Value: String);
var
//bstr, estr : string;
x, pos     : integer;
//i          : integer;
force      : boolean;
strlen     : integer;

begin
Value := ' '+Value;
//{ ---------- compact version
if isSlim then
  begin
//  force := (abs ((length(Value) mod len) - len) <= 10) and (length(Value) > 10);
  force := (length(Value) > len);
  QRDBText1.Height := h*Roof(Length(Value), len);
//  if (force and (QRDBText1.Height = h)) then
  if (force) then
  begin
//    QRDBText1.Height := QRDBText1.Height + h;
//  i := 0;
  pos := 0;
//  strlen := 0;
  for x := length(Value) downto 1 do
    if Value[x] = ' ' then
      begin
      strlen := (length(Value) - x) - pos;
//      inc(i);
      if (len - strlen) <= riskLen then
        begin
        Value[x] := #$D;
        pos := x;
        end;
      if (len > x) then break;
      end;
//    bstr := copy(Value, 1, pos);
//    estr := copy(Value, pos, length(Value)-pos+1);
//    Value := bstr+#$D+estr;
    Value[x] := #$D;
  end;
  QRDBText1.Font.Size := size;
  if QRDBText1.Height < h then QRDBText1.Height := h;
  QRDBText2.Height := QRDBText1.Height;
  QRDBText3.Height := QRDBText1.Height;
  QRDBText2.Font.Size := size;
  QRDBText3.Font.Size := size;
//  DetailBand1.Height := QRDBText1.Height+2;
  DetailBand1.Height := QRDBText1.Height;
  end;
//------------ end compact}
end;

procedure TDiplome2RepForm2.PrintCopyTitle(sender: TObject;
  var Value: String);
begin
if (not isCopy) then
 Value := '';
end;

end.
