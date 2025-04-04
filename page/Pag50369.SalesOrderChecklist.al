page 50369 "Sales Order Checklist"
{
    ApplicationArea = All;
    Caption = 'Sales Order Checklist';
    PageType = List;
    SourceTable = "Checklist Table";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SN; Rec.SN)
                {
                    ApplicationArea = All;
                }
                field(Question; Rec.Question)
                {
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field(Answer; Rec.Answer)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
