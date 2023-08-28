pageextension 70100 "GenLedgerSetupKP" extends "General Ledger Setup"
{
    layout
    {
        addlast(General)
        {
            field("Parking Account"; Rec."Parking Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specify the Parking account to be checked upon posting';
            }

        }
    }
}