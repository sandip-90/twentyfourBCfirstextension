page 50370 "Report Request Page"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    Caption = 'Select Report to Run';

    layout
    {
        area(content)
        {
            field(SelectedReport; SelectedReport)
            {
                Caption = 'Select a Report';
                ApplicationArea = All;

                // trigger OnValidate()
                // var
                //     ReportRunner: Codeunit "Report Runners";
                // begins
                //     ReportRunner.RunSelectedReport(SelectedReport);
                // end;
            }
            field(EmailAddressField; Emailaddress)
            {
                ApplicationArea = all;
                Caption = 'Email Address';
                ShowMandatory = true;
                NotBlank = true;
                ExtendedDatatype = EMail;

                trigger OnValidate()
                var
                    EmailAccount: Codeunit "Email Account";
                begin
                    EmailAccount.ValidateEmailAddresses(Emailaddress);
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action("Run Report")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Run Selected Report';

            //     trigger OnAction()
            //     var
            //         ReportRunner: Codeunit "Report Runners";
            //     begin
            //         ReportRunner.RunSelectedReport(SelectedReport);
            //     end;
            // }
        }
    }

    var
        SelectedReport: Enum "Report Selection"; // Stores the selected report
        Emailaddress: Text[80]; // Stores the email address to send the report to

    procedure GetEmailAddress(): Text
    begin
        exit(Emailaddress);
    end;

    procedure SetEmailAddress(Address: Text)
    begin
        Emailaddress := Address;
    end;
}
