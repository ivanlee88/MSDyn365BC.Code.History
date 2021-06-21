table 9 "Country/Region"
{
    Caption = 'Country/Region';
    LookupPageID = "Countries/Regions";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; "ISO Code"; Code[2])
        {
            Caption = 'ISO Code';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DotNet_Regex: Codeunit DotNet_Regex;
            begin
                if "ISO Code" = '' then
                    exit;
                if StrLen("ISO Code") < MaxStrLen("ISO Code") then
                    Error(ISOCodeLengthErr, StrLen("ISO Code"), MaxStrLen("ISO Code"), "ISO Code");
                DotNet_Regex.Regex('^[a-zA-Z]*$');
                if not DotNet_Regex.IsMatch("ISO Code") then
                    FieldError("ISO Code", ASCIILetterErr);
            end;
        }
        field(5; "ISO Numeric Code"; Code[3])
        {
            Caption = 'ISO Numeric Code';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "ISO Numeric Code" = '' then
                    exit;
                if StrLen("ISO Numeric Code") < MaxStrLen("ISO Numeric Code") then
                    Error(ISOCodeLengthErr, StrLen("ISO Numeric Code"), MaxStrLen("ISO Numeric Code"), "ISO Numeric Code");
                if not TypeHelper.IsNumeric("ISO Numeric Code") then
                    FieldError("ISO Numeric Code", NumericErr);
            end;
        }
        field(6; "EU Country/Region Code"; Code[10])
        {
            Caption = 'EU Country/Region Code';
        }
        field(7; "Intrastat Code"; Code[10])
        {
            Caption = 'Intrastat Code';
        }
        field(8; "Address Format"; Option)
        {
            Caption = 'Address Format';
            InitValue = "City+Post Code";
            OptionCaption = 'Post Code+City,City+Post Code,City+County+Post Code,Blank Line+Post Code+City,,,,,,,,,,Custom';
            OptionMembers = "Post Code+City","City+Post Code","City+County+Post Code","Blank Line+Post Code+City",,,,,,,,,,Custom;

            trigger OnValidate()
            begin
                if xRec."Address Format" <> "Address Format" then begin
                    if "Address Format" = "Address Format"::Custom then
                        InitAddressFormat;
                    if xRec."Address Format" = xRec."Address Format"::Custom then
                        ClearCustomAddressFormat;
                end;
            end;
        }
        field(9; "Contact Address Format"; Option)
        {
            Caption = 'Contact Address Format';
            InitValue = "After Company Name";
            OptionCaption = 'First,After Company Name,Last';
            OptionMembers = First,"After Company Name",Last;
        }
        field(10; "VAT Scheme"; Code[10])
        {
            Caption = 'VAT Scheme';
        }
        field(11; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
        field(12; "County Name"; Text[30])
        {
            Caption = 'County Name';
        }
        field(8000; Id; Guid)
        {
            Caption = 'Id';
            ObsoleteState = Pending;
            ObsoleteReason = 'This functionality will be replaced by the systemID field';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "EU Country/Region Code")
        {
        }
        key(Key3; "Intrastat Code")
        {
        }
        key(Key4; Name)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Code", Name, "VAT Scheme")
        {
        }
    }

    trigger OnDelete()
    var
        VATRegNoFormat: Record "VAT Registration No. Format";
    begin
        VATRegNoFormat.SetFilter("Country/Region Code", Code);
        VATRegNoFormat.DeleteAll;
    end;

    trigger OnInsert()
    begin
        "Last Modified Date Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified Date Time" := CurrentDateTime;
    end;

    trigger OnRename()
    begin
        "Last Modified Date Time" := CurrentDateTime;
    end;

    var
        CountryRegionNotFilledErr: Label 'You must specify a country or region.';
        ISOCodeLengthErr: Label 'The length of the string is %1, but it must be equal to %2 characters. Value: %3.', Comment = '%1, %2 - numbers, %3 - actual value';
        ASCIILetterErr: Label 'must contain ASCII letters only';
        TypeHelper: Codeunit "Type Helper";
        NumericErr: Label 'must contain numbers only';

    procedure IsEUCountry(CountryRegionCode: Code[10]): Boolean
    var
        CountryRegion: Record "Country/Region";
    begin
        if CountryRegionCode = '' then
            Error(CountryRegionNotFilledErr);

        if not CountryRegion.Get(CountryRegionCode) then
            Error(CountryRegionNotFilledErr);

        exit(CountryRegion."EU Country/Region Code" <> '');
    end;

    procedure GetNameInCurrentLanguage(): Text[50]
    var
        CountryRegionTranslation: Record "Country/Region Translation";
        Language: Codeunit Language;
    begin
        if CountryRegionTranslation.Get(Code, Language.GetUserLanguageCode) then
            exit(CountryRegionTranslation.Name);
        exit(Name);
    end;

    procedure CreateAddressFormat(CountryCode: Code[10]; LinePosition: Integer; FieldID: Integer): Integer
    var
        CustomAddressFormat: Record "Custom Address Format";
    begin
        CustomAddressFormat.Init;
        CustomAddressFormat."Country/Region Code" := Code;
        CustomAddressFormat."Field ID" := FieldID;
        CustomAddressFormat."Line Position" := LinePosition - 1;
        CustomAddressFormat.Insert;

        if FieldID <> 0 then
            CreateAddressFormatLine(CountryCode, 1, FieldID, CustomAddressFormat."Line No.");

        CustomAddressFormat.BuildAddressFormat;
        CustomAddressFormat.Modify;

        exit(CustomAddressFormat."Line No.");
    end;

    procedure CreateAddressFormatLine(CountryCode: Code[10]; FieldPosition: Integer; FieldID: Integer; LineNo: Integer)
    var
        CustomAddressFormatLine: Record "Custom Address Format Line";
    begin
        CustomAddressFormatLine.Init;
        CustomAddressFormatLine."Country/Region Code" := CountryCode;
        CustomAddressFormatLine."Line No." := LineNo;
        CustomAddressFormatLine."Field Position" := FieldPosition - 1;
        CustomAddressFormatLine.Validate("Field ID", FieldID);
        CustomAddressFormatLine.Insert;
    end;

    procedure InitAddressFormat()
    var
        CompanyInformation: Record "Company Information";
        CustomAddressFormat: Record "Custom Address Format";
        LineNo: Integer;
    begin
        CreateAddressFormat(Code, 1, CompanyInformation.FieldNo(Name));
        CreateAddressFormat(Code, 2, CompanyInformation.FieldNo("Name 2"));
        CreateAddressFormat(Code, 3, CompanyInformation.FieldNo("Contact Person"));
        CreateAddressFormat(Code, 4, CompanyInformation.FieldNo(Address));
        CreateAddressFormat(Code, 5, CompanyInformation.FieldNo("Address 2"));
        case xRec."Address Format" of
            xRec."Address Format"::"City+Post Code":
                begin
                    LineNo := CreateAddressFormat(Code, 6, 0);
                    CreateAddressFormatLine(Code, 1, CompanyInformation.FieldNo(City), LineNo);
                    CreateAddressFormatLine(Code, 2, CompanyInformation.FieldNo("Post Code"), LineNo);
                end;
            xRec."Address Format"::"Post Code+City",
            xRec."Address Format"::"Blank Line+Post Code+City":
                begin
                    LineNo := CreateAddressFormat(Code, 6, 0);
                    CreateAddressFormatLine(Code, 1, CompanyInformation.FieldNo("Post Code"), LineNo);
                    CreateAddressFormatLine(Code, 2, CompanyInformation.FieldNo(City), LineNo);
                end;
            xRec."Address Format"::"City+County+Post Code":
                begin
                    LineNo := CreateAddressFormat(Code, 6, 0);
                    CreateAddressFormatLine(Code, 1, CompanyInformation.FieldNo(City), LineNo);
                    CreateAddressFormatLine(Code, 2, CompanyInformation.FieldNo(County), LineNo);
                    CreateAddressFormatLine(Code, 3, CompanyInformation.FieldNo("Post Code"), LineNo);
                end;
        end;
        if LineNo <> 0 then begin
            CustomAddressFormat.Get(Code, LineNo);
            CustomAddressFormat.BuildAddressFormat;
            CustomAddressFormat.Modify;
        end;
    end;

    local procedure ClearCustomAddressFormat()
    var
        CustomAddressFormat: Record "Custom Address Format";
    begin
        CustomAddressFormat.SetRange("Country/Region Code", Code);
        CustomAddressFormat.DeleteAll(true);
    end;
}

