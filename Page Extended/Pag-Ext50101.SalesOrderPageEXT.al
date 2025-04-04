pageextension 50101 "Sales Order Page_EXT" extends "Sales Order"
{
    actions
    {
        addafter("Archive Document")
        {
            action(ValidateChecklist)
            {
                ApplicationArea = all;
                Caption = 'Validate Checklist';
                Image = CheckList;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Sales Order Checklist";
                trigger OnAction()
                var
                    myInt: Integer;
                begin

                end;
            }
        }
    }

}
