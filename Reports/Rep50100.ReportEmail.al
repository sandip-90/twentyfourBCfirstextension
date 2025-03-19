report 50371 "Report Email"
{
    ApplicationArea = All;
    Caption = 'Send Report to Email';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                ReportID: Integer;
            begin
                // Step 1: Get Report ID
                ReportID := GetReportID(SelectedReport);
                if ReportID = 0 then
                    Error('No report selected or invalid report.');

                // Step 2: send email
                if Emailaddress <> '' then
                    SendReportByEmail(ReportID)
                else
                    RunReportDirectly(ReportID);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(SelectedReport; SelectedReport)
                    {
                        Caption = 'Select a Report';
                        ApplicationArea = All;
                    }
                    field(EmailAddressField; Emailaddress)
                    {
                        ApplicationArea = all;
                        Caption = 'Email Address';
                        //ExtendedDatatype = EMail;
                    }
                    field("Starting Date"; startDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Ending Date"; endDate)
                    {
                        ApplicationArea = All;
                    }
                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer No.';
                        TableRelation = Customer;

                    }
                    field(VendorNo; VendorNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor No.';
                        TableRelation = Vendor;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        SelectedReport: Enum "Report Selection";
        Emailaddress: Text[100];
        startDate: Date;
        endDate: Date;
        CustomerNo: Code[20];
        VendorNo: Code[20];
        showCustomerField: Boolean;
        showVendorField: Boolean;

    local procedure GetReportID(ReportSelection: Enum "Report Selection"): Integer
    begin
        case ReportSelection of
            ReportSelection::"Trial Balance Report":
                exit(Report::"Trial Balance");
            ReportSelection::"Detail Trial Balance Report":
                exit(Report::"Detail Trial Balance");
            ReportSelection::"Vendor Detail Trial Balance Report":
                exit(Report::"Vendor - Detail Trial Balance");
            ReportSelection::"Vendor Trial Balance Report":
                exit(Report::"Vendor - Trial Balance");
            ReportSelection::"Customer Detail Trial Balance Report":
                exit(Report::"Customer - Detail Trial Bal.");
            ReportSelection::"Customer Trial Balance Report":
                exit(Report::"Customer - Trial Balance");
            else
                exit(0);
        end;
    end;

    local procedure GetReportFileName(ReportSelection: Enum "Report Selection"): Text
    begin
        case ReportSelection of
            ReportSelection::"Trial Balance Report":
                exit('Trial Balance Report');
            ReportSelection::"Detail Trial Balance Report":
                exit('Detail Trial Balance Report');
            ReportSelection::"Vendor Detail Trial Balance Report":
                exit('Vendor Detail Trial Balance Report');
            ReportSelection::"Vendor Trial Balance Report":
                exit('Vendor Trial Balance Report');
            ReportSelection::"Customer Detail Trial Balance Report":
                exit('Customer Detail Trial Balance Report');
            ReportSelection::"Customer Trial Balance Report":
                exit('Customer Trial Balance Report');
            else
                exit('Report');
        end;
    end;

    local procedure RunReportDirectly(ReportID: Integer)
    var
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        DateFilterText: Text;
    begin
        DateFilterText := Format(startDate) + '..' + Format(endDate);

        case ReportID of
            Report::"Trial Balance", Report::"Detail Trial Balance":
                begin
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", DateFilterText);
                    if not GLAccount.FindSet() then
                        Error('No G/L Account records found for the selected date range (%1 to %2).', startDate, endDate);

                    //REPORT.Run(ReportID, true, false, GLAccount);
                end;
            Report::"Vendor - Detail Trial Balance", Report::"Vendor - Trial Balance":
                begin
                    Vendor.Reset();
                    Vendor.SetFilter("Date Filter", DateFilterText);
                    Vendor.SetFilter("No.", VendorNo);
                    if not Vendor.FindSet() then
                        Error('No Vendor records found for the selected date range (%1 to %2).', startDate, endDate);

                    // REPORT.Run(ReportID, true, false, Vendor);
                end;
            Report::"Customer - Detail Trial Bal.", Report::"Customer - Trial Balance":
                begin
                    Customer.Reset();
                    Customer.Get(CustomerNo);
                    Customer.SetFilter("Date Filter", DateFilterText);
                    Customer.SetFilter("No.", CustomerNo);
                    if not Customer.FindSet() then
                        Error('No Customer records found for the selected date range (%1 to %2).', startDate, endDate);

                    //REPORT.Run(ReportID, true, false, Customer);
                end;
            else
                Error('Invalid report ID: %1', ReportID);
        end;
    end;

    local procedure SendReportByEmail(ReportID: Integer)
    var
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit Email;
        Emails: Text;
        EmailMessage: Codeunit "Email Message";
        InStr: InStream;
        OutStr: OutStream;
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        RecRef: RecordRef;
        FileName: Text;
        DateFilterText: Text;
        Success: Boolean;
        CompanyInfo: Record "Company Information";
        CompanyName: Text;
        EntityName: Text;
        EmailTemplate: Record "Email Template";
        EmailList: List of [Text];
    begin
        DateFilterText := Format(startDate) + '..' + Format(endDate);

        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStr);

        // Step 1: Generate the report with filters and pass RecordRef
        Success := false;
        case ReportID of
            Report::"Trial Balance", Report::"Detail Trial Balance":
                begin
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", DateFilterText);
                    if not GLAccount.FindSet() then
                        Error('No G/L Account records found for the selected date range (%1 to %2).', startDate, endDate);
                    RecRef.GetTable(GLAccount);
                    Success := REPORT.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr, RecRef);
                end;
            Report::"Vendor - Detail Trial Balance", Report::"Vendor - Trial Balance":
                begin
                    Vendor.Reset();
                    Vendor.SetFilter("Date Filter", DateFilterText);
                    Vendor.SetFilter("No.", VendorNo);
                    if not Vendor.FindSet() then
                        Error('No Vendor records found for the selected date range (%1 to %2).', startDate, endDate);
                    RecRef.GetTable(Vendor);
                    Success := REPORT.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr, RecRef);
                end;
            Report::"Customer - Detail Trial Bal.", Report::"Customer - Trial Balance":
                begin
                    Customer.Reset();
                    Customer.SetFilter("Date Filter", DateFilterText);
                    Customer.SetFilter("No.", CustomerNo);
                    if not Customer.FindSet() then
                        Error('No Customer records found for the selected date range (%1 to %2).', startDate, endDate);
                    RecRef.GetTable(Customer);
                    Success := REPORT.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr, RecRef);
                end;
            else
                Error('Invalid report ID: %1', ReportID);
        end;

        if not Success then
            Error('Failed to generate the PDF report. Please check your data and report settings.');

        // Step 2: Create email with attachment
        // FileName := GetReportFileName(SelectedReport) + '.pdf';
        // EmailMessage.Create(Emailaddress,
        //     StrSubstNo('Report: %1', GetReportFileName(SelectedReport)),
        //     StrSubstNo('Please find attached pdf of the %1 for the period %2 to %3.',
        //         GetReportFileName(SelectedReport), startDate, endDate));

        EmailList := Emailaddress.Split(';');
        EmailMessage.Create('', StrSubstNo('Report: %1', GetReportFileName(SelectedReport)),
            StrSubstNo('Please find attached pdf of the %1 for the period %2 to %3.',
                GetReportFileName(SelectedReport), startDate, endDate));

        foreach Emails in EmailList do
            EmailMessage.AddRecipient(Enum::"Email Recipient Type"::To, Emails.Trim());

        TempBlob.CreateInStream(InStr);
        EmailMessage.AddAttachment(FileName, 'application/pdf', InStr);

        if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            Error('Failed to send email: %1', GetLastErrorText());

        Message('Report %1 sent to  %2 successfully.', GetReportFileName(SelectedReport), Emailaddress);
    end;

    local procedure GetReportFilter(ReportID: Integer; var RecordRef: RecordRef): Text
    var
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        DateFilterText: Text;
    begin
        DateFilterText := Format(startDate) + '..' + Format(endDate);

        case ReportID of
            Report::"Trial Balance", Report::"Detail Trial Balance":
                begin
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", DateFilterText);
                    if not GLAccount.FindSet() then
                        exit('could not find any records');

                    RecordRef.GetTable(GLAccount);
                end;
            Report::"Vendor - Detail Trial Balance", Report::"Vendor - Trial Balance":
                begin
                    Vendor.Reset();
                    Vendor.SetFilter("Date Filter", DateFilterText);
                    Vendor.SetFilter("No.", VendorNo);
                    if not Vendor.FindSet() then
                        exit('Could not find any records');

                    RecordRef.GetTable(Vendor);
                end;
            Report::"Customer - Detail Trial Bal.", Report::"Customer - Trial Balance":
                begin
                    Customer.Reset();
                    Customer.SetFilter("Date Filter", DateFilterText);
                    Customer.SetFilter("No.", CustomerNo);
                    if not Customer.FindSet() then
                        exit('Could not find any records');

                    RecordRef.GetTable(Customer);
                end;
            else
                exit('');
        end;

        exit('Date Filter=' + DateFilterText);
    end;
}

enum 50371 "Report Selection"
{
    Extensible = true;

    value(0; "empty")
    {
        Caption = '';
    }
    value(1; "Trial Balance Report")
    {
        Caption = 'Trial Balance Report';
    }
    value(2; "Detail Trial Balance Report")
    {
        Caption = 'Detail Trial Balance Report';
    }
    value(3; "Vendor Trial Balance Report")
    {
        Caption = 'Vendor Trial Balance Report';
    }
    value(4; "Vendor Detail Trial Balance Report")
    {
        Caption = 'Vendor Detail Trial Balance Report';
    }
    value(5; "Customer Trial Balance Report")
    {
        Caption = 'Customer Trial Balance Report';
    }
    value(6; "Customer Detail Trial Balance Report")
    {
        Caption = 'Customer Detail Trial Balance Report';
    }
}