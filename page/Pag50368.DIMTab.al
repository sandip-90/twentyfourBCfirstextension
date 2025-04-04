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
    actions
    {
        area(Processing)
        {
            action("Send Job Quote")
            {
                ApplicationArea = Suite;
                Caption = 'Send Project Quote';
                Image = SendTo;
                ToolTip = 'Send the project quote to the customer. You can change the way that the document is sent in the window that appears.';

                trigger OnAction()
                begin
                    CODEUNIT.Run(CODEUNIT::"Jobs-Send", Rec);
                end;
            }
        }
    }
}