report 10940 "VAT Reconciliation A"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VATReconciliationA.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'VAT Reconciliation A';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE("Account Type" = CONST(Posting));
            column(DateRangeformatted; Format(DateFrom) + '  til  ' + Format(DateTo))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(V10940_; '10940')
            {
            }
            column(TodayFormatted; LowerCase(Format(Today, 0, 4)))
            {
            }
            column(No_GLAcc; "No.")
            {
            }
            column(Name_GLAcc; Name)
            {
            }
            column(VATReconciliationACaption; VATReconciliationACaptionLbl)
            {
            }
            column(PurchVATCaption; PurchVATCaptionLbl)
            {
            }
            column(BaseCaption; BaseCaptionLbl)
            {
            }
            column(SalesVATCaption; SalesVATCaptionLbl)
            {
            }
            column(VATCaption; VATCaptionLbl)
            {
            }
            column(VATProdPostingGrpCaption; VATProdPostingGrpCaptionLbl)
            {
            }
            column(VATBusPostingGrpCaption; VATBusPostingGrpCaptionLbl)
            {
            }
            column(PurchCaption; PurchCaptionLbl)
            {
            }
            column(SalesCaption; SalesCaptionLbl)
            {
            }
            dataitem("VAT Posting Setup"; "VAT Posting Setup")
            {
                DataItemTableView = SORTING("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                column(VATPercentageFormatted; Format("VAT %") + '%')
                {
                }
                column(VATCalcType_VATPostingSetup; "VAT Calculation Type")
                {
                }
                column(VATProdPostingGrp_VATPostingSetup; "VAT Prod. Posting Group")
                {
                }
                column(VATBusPostingGrp_VATPostingSetup; "VAT Bus. Posting Group")
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "VAT Bus. Posting Group" = FIELD("VAT Bus. Posting Group"), "VAT Prod. Posting Group" = FIELD("VAT Prod. Posting Group");
                    DataItemTableView = SORTING("G/L Account No.", "Posting Date") WHERE("Gen. Posting Type" = FILTER(Purchase .. Sale));
                    column(TurnoverReceivable; TurnoverReceivable)
                    {
                    }
                    column(VatReceivableVarKr; VatReceivableVarKr)
                    {
                    }
                    column(VatPayableVarKr; VatPayableVarKr)
                    {
                    }
                    column(VatReceivable; VatReceivable)
                    {
                    }
                    column(TurnoverPayable; TurnoverPayable)
                    {
                    }
                    column(VATPayable; VATPayable)
                    {
                    }
                    column(PostingDate_GLEntry; "Posting Date")
                    {
                    }
                    column(DocNo_GLEntry; "Document No.")
                    {
                    }
                    column(Desc_GLEntry; Description)
                    {
                    }
                    column(VatReceivableVarTxt; StrSubstNo(VatReceivableVarTxt, VatReceivablePct, VatReceivableVarKr))
                    {
                    }
                    column(VatPayableVarTxt; StrSubstNo(VatPayableVarTxt, VatPayablePct, VatPayableVarKr))
                    {
                    }
                    column(Total; 'Total')
                    {
                    }
                    column(CarriedOverFromPreviousPageCaption; CarriedOverFromPreviousPageCaptionLbl)
                    {
                    }
                    column(CarriedOverToNextPageCaption; CarriedOverToNextPageCaptionLbl)
                    {
                    }
                    column(EntryNo_GLEntry; "Entry No.")
                    {
                    }
                    column(VATBusPostingGrp_GLEntry; "VAT Bus. Posting Group")
                    {
                    }
                    column(VATProdPostingGrp_GLEntry; "VAT Prod. Posting Group")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VatReceivableVarKr := 0;
                        VatPayableVarKr := 0;
                        TurnoverReceivable := 0;
                        VatReceivable := 0;
                        TurnoverPayable := 0;
                        VATPayable := 0;

                        case "Gen. Posting Type" of
                            "Gen. Posting Type"::Sale:
                                begin
                                    TurnoverReceivable := Amount;
                                    VatReceivable := "VAT Amount";
                                end;
                            "Gen. Posting Type"::Purchase:
                                begin
                                    TurnoverPayable := Amount;
                                    VATPayable := "VAT Amount";
                                end;
                        end;

                        if (TurnoverReceivable <> 0) and (TurnoverReceivable <> VatReceivable) then begin
                            VatReceivablePct := Round(VatReceivable / TurnoverReceivable * 100, 0.1);
                            if Abs(VatReceivablePct - "VAT Posting Setup"."VAT %") > 0.1 then
                                VatReceivableVarKr := Round(VatReceivable - (TurnoverReceivable * "VAT Posting Setup"."VAT %" / 100), 1);
                        end;

                        if (TurnoverPayable <> 0) and (TurnoverPayable <> VATPayable) then begin
                            VatPayablePct := Round(VATPayable / TurnoverPayable * 100, 0.1);
                            if Abs(VatPayablePct - "VAT Posting Setup"."VAT %") > 0.1 then
                                VatPayableVarKr := Round(VATPayable - (TurnoverPayable * "VAT Posting Setup"."VAT %" / 100), 1);
                        end;

                        if (TurnoverReceivable = 0) and (VatReceivable = 0) and (TurnoverPayable = 0) and (VATPayable = 0) then
                            CurrReport.Skip;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("G/L Account No.", "G/L Account"."No.");
                        SetRange("Posting Date", DateFrom, DateTo);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    GLEntry.Reset;
                    GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                    GLEntry.SetRange("G/L Account No.", "G/L Account"."No.");
                    GLEntry.SetRange("Posting Date", DateFrom, DateTo);
                    GLEntry.SetRange("VAT Bus. Posting Group", "VAT Bus. Posting Group");
                    GLEntry.SetRange("VAT Prod. Posting Group", "VAT Prod. Posting Group");
                    if GLEntry.IsEmpty then
                        CurrReport.Skip;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GLEntry.Reset;
                GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                GLEntry.SetRange("G/L Account No.", "No.");
                GLEntry.SetRange("Posting Date", DateFrom, DateTo);
                GLEntry.SetRange("Gen. Posting Type", GLEntry."Gen. Posting Type"::Purchase, GLEntry."Gen. Posting Type"::Sale);
                if GLEntry.IsEmpty then
                    CurrReport.Skip;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Period; Period)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period';
                        ToolTip = 'Specifies the VAT report period. Select a two month period, or choose Custom to specify a different period in the From and to fields.';

                        trigger OnValidate()
                        begin
                            FindDates;
                        end;
                    }
                    field(Year; YY)
                    {
                        ApplicationArea = Basic, Suite;
                        BlankZero = true;
                        Caption = 'Year';
                        ToolTip = 'Specifies the VAT reporting year.';

                        trigger OnValidate()
                        begin
                            FindDates;
                        end;
                    }
                    field(DFrom; DateFrom)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'From';
                        ToolTip = 'Specifies the start of the VAT report period.';

                        trigger OnValidate()
                        begin
                            CheckPeriodType;
                        end;
                    }
                    field(DTil; DateTo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'to';
                        ToolTip = 'Specifies the end of the VAT report period.';

                        trigger OnValidate()
                        begin
                            CheckPeriodType;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            MM := Date2DMY(CalcDate('<-2M>', Today), 2);
            YY := Date2DMY(CalcDate('<-2M>', Today), 3);
            FindPeriod;
        end;
    }

    labels
    {
    }

    var
        GLEntry: Record "G/L Entry";
        DateFrom: Date;
        DateTo: Date;
        Period: Option Custom,"January-February","March-April","May-June","July-August","September-October","November-December";
        TurnoverReceivable: Decimal;
        VatReceivable: Decimal;
        TurnoverPayable: Decimal;
        VATPayable: Decimal;
        VatReceivablePct: Decimal;
        VatPayablePct: Decimal;
        VatReceivableVarKr: Decimal;
        VatPayableVarKr: Decimal;
        YY: Integer;
        MM: Integer;
        DD: Integer;
        Text001: Label 'Period must be Custom.';
        VATReconciliationACaptionLbl: Label 'VATReconciliation A';
        PurchVATCaptionLbl: Label 'Purchase VAT';
        BaseCaptionLbl: Label 'Base';
        SalesVATCaptionLbl: Label 'Sales VAT';
        VATCaptionLbl: Label 'VAT %';
        VATProdPostingGrpCaptionLbl: Label 'VAT Prod. Posting Group';
        VATBusPostingGrpCaptionLbl: Label 'VAT Bus. Posting Group';
        PurchCaptionLbl: Label 'Purchase';
        SalesCaptionLbl: Label 'Sales';
        CarriedOverFromPreviousPageCaptionLbl: Label 'Carried over from previous page';
        CarriedOverToNextPageCaptionLbl: Label 'Carried over to next page';
        VatReceivableVarTxt: Label 'Attention! Variance in VAT receivable. Calculated VAT receivable. %1 %. Variance %2 kr.';
        VatPayableVarTxt: Label 'Attention! Variance in VAT payable. Calculated VAT payable. %1 %. Variance %2 kr.';

    [Scope('OnPrem')]
    procedure FindPeriod()
    begin
        DateFrom := DMY2Date(1, MM, YY);
        DateTo := CalcDate('<+CM>', DateFrom);

        case MM of
            1, 2:
                Period := Period::"January-February";
            3, 4:
                Period := Period::"March-April";
            5, 6:
                Period := Period::"May-June";
            7, 8:
                Period := Period::"July-August";
            9, 10:
                Period := Period::"September-October";
            11, 12:
                Period := Period::"November-December";
        end;
        FindDates;
    end;

    [Scope('OnPrem')]
    procedure FindDates()
    begin
        DateFrom := 0D;
        DateTo := 0D;

        case Period of
            Period::"January-February":
                begin
                    DateFrom := DMY2Date(1, 1, YY);
                    DD := Date2DMY(CalcDate('<+CM>', DMY2Date(1, 2, YY)), 1);
                    DateTo := DMY2Date(DD, 2, YY);
                end;
            Period::"March-April":
                begin
                    DateFrom := DMY2Date(1, 3, YY);
                    DateTo := DMY2Date(30, 4, YY);
                end;
            Period::"May-June":
                begin
                    DateFrom := DMY2Date(1, 5, YY);
                    DateTo := DMY2Date(30, 6, YY);
                end;
            Period::"July-August":
                begin
                    DateFrom := DMY2Date(1, 7, YY);
                    DateTo := DMY2Date(31, 8, YY);
                end;
            Period::"September-October":
                begin
                    DateFrom := DMY2Date(1, 9, YY);
                    DateTo := DMY2Date(31, 10, YY);
                end;
            Period::"November-December":
                begin
                    DateFrom := DMY2Date(1, 11, YY);
                    DateTo := DMY2Date(31, 12, YY);
                end;
        end;
    end;

    local procedure CheckPeriodType()
    begin
        if Period <> Period::Custom then
            Error(Text001);
    end;
}

