table 846 "Cash Flow Worksheet Line"
{
    Caption = 'Cash Flow Worksheet Line';

    fields
    {
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Cash Flow Forecast No."; Code[20])
        {
            Caption = 'Cash Flow Forecast No.';
            TableRelation = "Cash Flow Forecast";

            trigger OnValidate()
            var
                CashFlowForecast: Record "Cash Flow Forecast";
            begin
                if "Cash Flow Forecast No." = '' then
                    exit;

                CashFlowForecast.Get("Cash Flow Forecast No.");
                Description := CashFlowForecast.Description;
            end;
        }
        field(4; "Cash Flow Date"; Date)
        {
            Caption = 'Cash Flow Date';
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; "Cash Flow Account No."; Code[20])
        {
            Caption = 'Cash Flow Account No.';
            TableRelation = "Cash Flow Account";

            trigger OnValidate()
            var
                CFAccount: Record "Cash Flow Account";
            begin
                if "Cash Flow Account No." <> '' then begin
                    CFAccount.Get("Cash Flow Account No.");
                    CFAccount.TestField("Account Type", CFAccount."Account Type"::Entry);
                    CFAccount.TestField(Blocked, false);
                    if "Cash Flow Account No." <> xRec."Cash Flow Account No." then begin
                        Description := CFAccount.Name;
                        "Source Type" := CFAccount."Source Type";
                    end;
                end;
            end;
        }
        field(7; "Source Type"; Enum "Cash Flow Source Type")
        {
            Caption = 'Source Type';

            trigger OnValidate()
            begin
                if "Source Type" <> "Source Type"::"G/L Budget" then
                    "G/L Budget Name" := '';
            end;
        }
        field(8; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(9; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(10; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(11; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(12; "Pmt. Disc. Tolerance Date"; Date)
        {
            Caption = 'Pmt. Disc. Tolerance Date';
        }
        field(13; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(14; "Payment Discount"; Decimal)
        {
            Caption = 'Payment Discount';
        }
        field(15; "Associated Entry No."; Integer)
        {
            Caption = 'Associated Entry No.';
        }
        field(16; Overdue; Boolean)
        {
            Caption = 'Overdue';
            Editable = false;
        }
        field(17; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(18; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(30; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(34; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST("Liquid Funds")) "G/L Account"
            ELSE
            IF ("Source Type" = CONST(Receivables)) "Cust. Ledger Entry"."Document No."
            ELSE
            IF ("Source Type" = CONST(Payables)) "Vendor Ledger Entry"."Document No."
            ELSE
            IF ("Source Type" = CONST("Fixed Assets Budget")) "Fixed Asset"
            ELSE
            IF ("Source Type" = CONST("Fixed Assets Disposal")) "Fixed Asset"
            ELSE
            IF ("Source Type" = CONST("Sales Orders")) "Sales Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF ("Source Type" = CONST("Purchase Orders")) "Purchase Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF ("Source Type" = CONST("Service Orders")) "Service Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF ("Source Type" = CONST("Cash Flow Manual Expense")) "Cash Flow Manual Expense"
            ELSE
            IF ("Source Type" = CONST("Cash Flow Manual Revenue")) "Cash Flow Manual Revenue"
            ELSE
            IF ("Source Type" = CONST("G/L Budget")) "G/L Account"
            ELSE
            IF ("Source Type" = CONST(Job)) Job."No.";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgEntry: Record "Vendor Ledger Entry";
            begin
                case "Source Type" of
                    "Source Type"::"Liquid Funds":
                        MoveDefualtDimToJnlLineDim(DATABASE::"G/L Account", "Source No.", "Dimension Set ID");
                    "Source Type"::Receivables:
                        begin
                            CustLedgEntry.SetRange("Document No.", "Source No.");
                            if CustLedgEntry.FindFirst then
                                "Dimension Set ID" := CustLedgEntry."Dimension Set ID";
                        end;
                    "Source Type"::Payables:
                        begin
                            VendLedgEntry.SetRange("Document No.", "Source No.");
                            if VendLedgEntry.FindFirst then
                                "Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                        end;
                    "Source Type"::"Fixed Assets Disposal",
                  "Source Type"::"Fixed Assets Budget":
                        MoveDefualtDimToJnlLineDim(DATABASE::"Fixed Asset", "Source No.", "Dimension Set ID");
                end;
            end;
        }
        field(35; "G/L Budget Name"; Code[10])
        {
            Caption = 'G/L Budget Name';
            TableRelation = "G/L Budget Name";

            trigger OnValidate()
            begin
                TestField("Source Type", "Source Type"::"G/L Budget");
            end;
        }
        field(36; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Cash Flow Forecast No.", "Document No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        LockTable();
        ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
    end;

    var
        DimMgt: Codeunit DimensionManagement;

    procedure EmptyLine(): Boolean
    begin
        exit(("Cash Flow Forecast No." = '') and ("Cash Flow Account No." = ''));
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);

        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1', "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure MoveDefualtDimToJnlLineDim(TableID: Integer; No: Code[20]; var DimensionSetID: Integer)
    var
        TableID2: array[10] of Integer;
        No2: array[10] of Code[20];
        Dimension: Code[20];
    begin
        TableID2[1] := TableID;
        No2[1] := No;
        Dimension := '';
        DimensionSetID :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, TableID2, No2, '', Dimension, Dimension, 0, 0);
    end;

    local procedure CalculateForPostedDocuments(CashFlowForecast: Record "Cash Flow Forecast")
    var
        CFDiscountDate: Date;
        CheckCrMemo: Boolean;
    begin
        case "Document Type" of
            "Document Type"::Invoice:
                CheckCrMemo := false;
            "Document Type"::"Credit Memo":
                CheckCrMemo := true;
            else
                exit;
        end;

        if not CashFlowForecast."Consider Discount" then
            exit;

        if CashFlowForecast."Consider Pmt. Disc. Tol. Date" then
            CFDiscountDate := "Pmt. Disc. Tolerance Date"
        else
            CFDiscountDate := "Pmt. Discount Date";

        if CFDiscountDate <> 0D then begin
            if CFDiscountDate >= WorkDate then begin
                "Cash Flow Date" := CFDiscountDate;
                "Amount (LCY)" := "Amount (LCY)" - "Payment Discount";
            end else
                "Payment Discount" := 0;
            exit;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalculateCFAmountAndCFDate(var MaxPmtTolerance: Decimal)
    var
        CashFlowForecast: Record "Cash Flow Forecast";
    begin
        if "Document Date" = 0D then
            "Document Date" := WorkDate;
        if "Cash Flow Date" = 0D then
            "Cash Flow Date" := "Document Date";
        if "Amount (LCY)" = 0 then
            exit;

        if not ("Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) then
            exit;

        if not CashFlowForecast.Get("Cash Flow Forecast No.") then
            exit;

        if "Source Type" in ["Source Type"::"Sales Orders", "Source Type"::"Purchase Orders", "Source Type"::"Service Orders"] then
            InsertNewLinesForUnpostedDocuments(CashFlowForecast, MaxPmtTolerance)
        else
            CalculateForPostedDocuments(CashFlowForecast);
    end;

    [Scope('OnPrem')]
    procedure InsertNewLinesForUnpostedDocuments(CashFlowForecast: Record "Cash Flow Forecast"; var MaxPmtTolerance: Decimal)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        PaymentTermsToApply: Code[10];
        CFDiscountDate: Date;
        DiscountDateCalculation: DateFormula;
        PaymentLines: Record "Payment Lines";
        GLSetup: Record "General Ledger Setup";
        OriginalAmount: Decimal;
        InsertLine: Boolean;
        CountForPaymentLines: Integer;
        AccumulatedAmount: Decimal;
        IsHandled: Boolean;
    begin
        PaymentTermsToApply := "Payment Terms Code";
        if not CheckForCrMemoCalculation(PaymentTermsToApply) then
            exit;

        PaymentLines.SetRange(Type, PaymentLines.Type::"Payment Terms");
        PaymentLines.SetRange(Code, PaymentTermsToApply);

        if not PaymentLines.FindSet then
            exit;

        CountForPaymentLines := PaymentLines.Count();
        OriginalAmount := "Amount (LCY)";
        InsertLine := false;
        GLSetup.Get();

        repeat
            if InsertLine then begin
                "Line No." := "Line No." + 1;
            end else
                InsertLine := true;

            if CountForPaymentLines = 1 then begin
                "Amount (LCY)" := Round(OriginalAmount - AccumulatedAmount, GLSetup."Amount Rounding Precision");

                ApplyMaxPmtTolerance(MaxPmtTolerance, (OriginalAmount - AccumulatedAmount) / OriginalAmount, GLSetup."Amount Rounding Precision");
            end else begin
                CountForPaymentLines := CountForPaymentLines - 1;
                "Amount (LCY)" := Round(
                    OriginalAmount * PaymentLines."Payment %" / 100,
                    GLSetup."Amount Rounding Precision");
                AccumulatedAmount := AccumulatedAmount + "Amount (LCY)";

                ApplyMaxPmtTolerance(MaxPmtTolerance, PaymentLines."Payment %" / 100, GLSetup."Amount Rounding Precision");
            end;

            if CashFlowForecast."Consider Discount" then begin
                GeneralLedgerSetup.Get();

                DiscountDateCalculation := PaymentLines."Discount Date Calculation";
                if Format(DiscountDateCalculation) = '' then
                    DiscountDateCalculation := PaymentLines."Due Date Calculation";
                CFDiscountDate := CalcDate(DiscountDateCalculation, "Document Date");
                if CashFlowForecast."Consider Pmt. Disc. Tol. Date" then
                    CFDiscountDate := CalcDate(GeneralLedgerSetup."Payment Discount Grace Period", CFDiscountDate);

                IsHandled := false;
                OnCalculateCFAmountAndCFDateOnBeforeCalcPaymentDiscount(CFDiscountDate, PaymentLines, IsHandled);
                if not IsHandled then
                    if CFDiscountDate >= WorkDate then begin
                        "Cash Flow Date" := CFDiscountDate;

                        "Payment Discount" := Round("Amount (LCY)" * PaymentLines."Discount %" / 100);
                        "Amount (LCY)" := "Amount (LCY)" - "Payment Discount";
                    end else begin
                        "Cash Flow Date" := CalcDate(PaymentLines."Due Date Calculation", "Document Date");
                        "Payment Discount" := 0;
                    end;
            end else
                "Cash Flow Date" := CalcDate(PaymentLines."Due Date Calculation", "Document Date");

            if "Amount (LCY)" <> 0 then
                Insert(true);

        until PaymentLines.Next() = 0;

        MaxPmtTolerance := 0;
    end;

    [Scope('OnPrem')]
    procedure CheckForCrMemoCalculation(PaymentTermsToApply: Code[10]): Boolean
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if not PaymentTerms.Get(PaymentTermsToApply) then
            exit(false);

        if ("Document Type" = "Document Type"::"Credit Memo") and not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then
            exit(false);

        exit(true);
    end;

    local procedure ApplyMaxPmtTolerance(MaxPmtTolerance: Decimal; Percent: Decimal; Rounding: Decimal)
    var
        PmtToleranceToApply: Decimal;
    begin
        if MaxPmtTolerance = 0 then
            exit;

        PmtToleranceToApply := Round(MaxPmtTolerance * Percent, Rounding);
        if Abs("Amount (LCY)") < Abs(PmtToleranceToApply) then
            "Amount (LCY)" := 0
        else
            "Amount (LCY)" := "Amount (LCY)" - PmtToleranceToApply;
    end;

    [Scope('OnPrem')]
    procedure ShowSource()
    var
        CFManagement: Codeunit "Cash Flow Management";
    begin
        CFManagement.ShowSource(Rec);
    end;

    procedure GetNumberOfSourceTypes(): Integer
    begin
        exit(16);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var CashFlowWorksheetLine: Record "Cash Flow Worksheet Line"; var xCashFlowWorksheetLine: Record "Cash Flow Worksheet Line"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var CashFlowWorksheetLine: Record "Cash Flow Worksheet Line"; var xCashFlowWorksheetLine: Record "Cash Flow Worksheet Line"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnCalculateCFAmountAndCFDateOnBeforeCalcPaymentDiscount(CFDiscountDate: Date; PaymentLines: record "Payment Lines"; var IsHandled: boolean)
    begin
    end;
}

