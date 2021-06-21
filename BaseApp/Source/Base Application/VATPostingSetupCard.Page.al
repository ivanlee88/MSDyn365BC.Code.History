page 473 "VAT Posting Setup Card"
{
    Caption = 'VAT Posting Setup Card';
    DataCaptionFields = "VAT Bus. Posting Group", "VAT Prod. Posting Group";
    PageType = Card;
    SourceTable = "VAT Posting Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("VAT Calculation Type"; "VAT Calculation Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how VAT will be calculated for purchases or sales of items with this particular combination of VAT business posting group and VAT product posting group.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies description for this particular combination of VAT business posting group and VAT product posting group.';
                }
                field("VAT %"; "VAT %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the relevant VAT rate for the particular combination of VAT business posting group and VAT product posting group. Do not enter the percent sign, only the number. For example, if the VAT rate is 25 %, enter 25 in this field.';
                }
                field("Deductible %"; "Deductible %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the percentage of the transaction amount to which VAT is applied.';
                }
                field("Unrealized VAT Type"; "Unrealized VAT Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how to handle unrealized VAT, which is VAT that is calculated but not due until the invoice is paid.';
                    Visible = UnrealizedVATVisible;
                }
                field("VAT Identifier"; "VAT Identifier")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code to group various VAT posting setups with similar attributes, for example VAT percentage.';
                }
                field("VAT Clause Code"; "VAT Clause Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT Clause Code that is associated with the VAT Posting Setup.';
                }
                field("EU Service"; "EU Service")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if this combination of VAT business posting group and VAT product posting group are to be reported as services in the periodic VAT reports.';
                }
                field("Service Tariff No. Mandatory"; "Service Tariff No. Mandatory")
                {
                    ApplicationArea = VAT;
                    ToolTip = 'Specifies if the service tariff number is required for tax reporting.';
                }
                field("Adjust for Payment Discount"; "Adjust for Payment Discount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to recalculate VAT amounts when you post payments that trigger payment discounts.';
                    Visible = AdjustForPmtDiscVisible;
                }
                field("Include in VAT Transac. Rep."; "Include in VAT Transac. Rep.")
                {
                    ApplicationArea = VAT;
                    ToolTip = 'Specifies if you want to include the entry in the VAT transaction report.';
                }
                field("Certificate of Supply Required"; "Certificate of Supply Required")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if documents that use this combination of VAT business posting group and VAT product posting group require a certificate of supply.';
                }
                field("Tax Category"; "Tax Category")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT category in connection with electronic document sending. For example, when you send sales documents through the PEPPOL service, the value in this field is used to populate the TaxApplied element in the Supplier group. The number is based on the UNCL5305 standard.';
                }
                field("Reversed VAT Bus. Post. Group"; "Reversed VAT Bus. Post. Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT";
                    ToolTip = 'Specifies the business posting group for reversed VAT.';
                }
                field("Reversed VAT Prod. Post. Group"; "Reversed VAT Prod. Post. Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT";
                    ToolTip = 'Specifies the product posting group for reversed VAT.';
                }
                field("Include in VAT Comm. Rep."; "Include in VAT Comm. Rep.")
                {
                    ApplicationArea = VAT;
                    ToolTip = 'Specifies if you want to include the entry in the VAT Payment Communication report.';
                }
                field("Fattura Document Type"; "Fattura Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value to export into the TipoDocument XML node of the Fattura document.';
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                field("Sales VAT Account"; "Sales VAT Account")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post sales VAT for the particular combination of VAT business posting group and VAT product posting group.';
                }
                field("Sales VAT Unreal. Account"; "Sales VAT Unreal. Account")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post unrealized sales VAT (as calculated when you post sales invoices) using this particular combination of VAT business posting group and VAT product posting group.';
                    Visible = UnrealizedVATVisible;
                }
                field("Sales Prepayments Account"; "Sales Prepayments Account")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the account to which you want to post the VAT sales prepayment amount.';
                }
            }
            group(Purchases)
            {
                Caption = 'Purchases';
                field("Purchase VAT Account"; "Purchase VAT Account")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post purchase VAT for the particular combination of business group and product group.';
                }
                field("Purch. VAT Unreal. Account"; "Purch. VAT Unreal. Account")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post unrealized purchase VAT (as calculated when you post purchase invoices) using this particular combination of VAT business posting group and VAT product posting group.';
                    Visible = UnrealizedVATVisible;
                }
                field("Reverse Chrg. VAT Acc."; "Reverse Chrg. VAT Acc.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general ledger account number to which you want to post reverse charge VAT (purchase VAT) for this combination of VAT business posting group and VAT product posting group, if you have selected the Reverse Charge VAT option in the VAT Calculation Type field.';
                }
                field("Reverse Chrg. VAT Unreal. Acc."; "Reverse Chrg. VAT Unreal. Acc.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general ledger account number to which you want to post amounts for unrealized reverse charge VAT (purchase VAT) for this combination of VAT business posting group and VAT product posting group, if you have selected the Reverse Charge VAT option in the VAT Calculation Type field.';
                    Visible = UnrealizedVATVisible;
                }
                field("Nondeductible VAT Account"; "Nondeductible VAT Account")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the account associated with the VAT amount that is not deducted due to the type of goods or services purchased.';
                }
                field("Purch. Prepayments Account"; "Purch. Prepayments Account")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the account to which you want to post the VAT purchases prepayment amount.';
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Allow Posting From"; "Allow Posting From")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the start date from which VAT posting is allowed.';
                }
                field("Allow Posting To"; "Allow Posting To")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the end date to which VAT posting is allowed.';
                }
            }
            group(Usage)
            {
                Caption = 'Usage';
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Setup")
            {
                Caption = '&Setup';
                Image = Setup;
                action("VAT &Transaction Report Amount")
                {
                    ApplicationArea = VAT;
                    Caption = 'VAT &Transaction Report Amount';
                    Image = VATPostingSetup;
                    RunObject = Page "VAT Transaction Report Amounts";
                    ToolTip = 'View or edit the threshold amounts for the VAT transactions report.';
                }
            }
        }
        area(processing)
        {
            action(SuggestAccounts)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Suggest Accounts';
                Image = Default;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Suggest G/L Accounts for selected setup.';

                trigger OnAction()
                begin
                    SuggestSetupAccounts;
                end;
            }
            action(Copy)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Copy';
                Ellipsis = true;
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Copy selected fields or all fields in the VAT Posting Setup window to a new record. Before you start to copy, you must create the new record.';

                trigger OnAction()
                begin
                    CurrPage.SaveRecord;
                    CopyVATPostingSetup.SetVATSetup(Rec);
                    CopyVATPostingSetup.RunModal;
                    Clear(CopyVATPostingSetup);
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetAccountsVisibility(UnrealizedVATVisible, AdjustForPmtDiscVisible);
    end;

    var
        CopyVATPostingSetup: Report "Copy - VAT Posting Setup";
        UnrealizedVATVisible: Boolean;
        AdjustForPmtDiscVisible: Boolean;
}

