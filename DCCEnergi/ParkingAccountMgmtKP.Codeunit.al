codeunit 70100 "ParkingAccountMgmtKP"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", OnBeforeOnRun, '', false, false)]
    local procedure CheckParkingAccount(var PurchaseHeader: Record "Purchase Header")
    var
        PurchLine: record "Purchase Line";
        GenLedgerSetup: Record "General Ledger Setup";
        ParkingAccountErr: Label 'A line exists with account %1 - this is a parking account and must be changed', comment = '%1 must be the Parking account';
    begin
        if PurchaseHeader.IsTemporary then
            exit;
        GenLedgerSetup.SetLoadFields("Parking Account");
        GenLedgerSetup.GET();
        if GenLedgerSetup."Parking Account" = '' then
            exit;

        PurchLine.SetRange(PurchLine."Document No.", PurchaseHeader."No.");
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Type", PurchLine.Type::"G/L Account");
        PurchLine.SetRange("No.", GenLedgerSetup."Parking Account");
        if PurchLine.IsEmpty = false then
            Error(ParkingAccountErr, GenLedgerSetup."Parking Account");
    end;

    [EventSubscriber(ObjectType::Codeunit, CODEUNIT::"Gen. Jnl.-Post Line", OnBeforeRunWithCheck, '', false, false)]
    local procedure CheckParkingAccountEM(var GenJournalLine: Record "Gen. Journal Line"; var GenJournalLine2: Record "Gen. Journal Line")
    var
        ParkingAccountErr: Label 'A line exists with account %1 - this is a parking account and must be changed', comment = '%1 must be the Parking account';
    begin
        if GenJournalLine.IsTemporary then
            exit;

        if IsParkingAccount(GenJournalLine2."Account No.") then
            Error(ParkingAccountErr, GenJournalLine2."Account No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, CODEUNIT::"Gen. Jnl.-Post Line", OnBeforeRunWithoutCheck, '', false, false)]
    local procedure CheckParkingAccountGenJnl(var GenJournalLine: Record "Gen. Journal Line"; var GenJournalLine2: Record "Gen. Journal Line")
    var
        ParkingAccountErr: Label 'A line exists with account %1 - this is a parking account and must be changed', comment = '%1 must be the Parking account';
    begin
        if GenJournalLine.IsTemporary then
            exit;

        if IsParkingAccount(GenJournalLine2."Account No.") then
            Error(ParkingAccountErr, GenJournalLine2."Account No.");
    end;


    local procedure IsParkingAccount(AccountNo: code[20]): Boolean
    var
        GenLedgerSetupKP: Record "General Ledger Setup";
    begin
        GenLedgerSetupKP.SetLoadFields("Parking Account");
        GenLedgerSetupKP.GET();
        if GenLedgerSetupKP."Parking Account" = '' then
            exit;

        if AccountNo = GenLedgerSetupKP."Parking Account" then
            exit(true);
    end;
}