tableextension 70100 "GeneralLedgerSetupExt" extends "General Ledger Setup"
{
    fields
    {
        field(70100; "Parking Account"; Code[20])
        {
            Caption = 'Parking Account';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
            Description = 'Specify the Parking account to be checked upon posting';
        }
    }

}