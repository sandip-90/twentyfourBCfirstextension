pageextension 50301 "Ext Company Information" extends "Company Information"
{
    actions
    {
        addafter("Reason Codes")
        {
            action("Generate Report")
            {
                ApplicationArea = All;
                Caption = 'Generate Report';
                ToolTip = 'Select a report to generate.';

                trigger OnAction()
                begin
                    Page.RunModal(Page::"Report Request Page");
                end;
            }

        }
    }
}
