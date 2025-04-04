pageextension 50102 ItemCardExt extends "Item Card"
{

    layout
    {

        modify("ItemPicture")
        {
            Visible = false;
        }
        addbefore(ItemPicture)
        {
            part(ZYItemPicture; "Item Pictures")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = FIELD("No.");
            }
        }
    }
}