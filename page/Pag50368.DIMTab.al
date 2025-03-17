page 50368 "DIM Tab"
{
    ApplicationArea = All;
    Caption = 'DIM Tab';
    PageType = List;
    SourceTable = "DIM table";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                }
                field("Dimension Code"; Rec."Dimension Code")
                {
                }
                field("Dimension Value"; Rec."Dimension Value")
                {
                }
            }
        }
    }
}
