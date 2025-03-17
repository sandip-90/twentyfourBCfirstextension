table 50367 "DIM table"
{
    Caption = 'DIM table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension."Code";
        }
        field(3; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));

            trigger OnLookup()
            var
                DimensionValueRec: Record "Dimension Value";
                DimensionValuePage: Page "Dimension Values";
            begin
                if "Dimension Code" = '' then begin
                    Message('Please select a Dimension Code first.');
                    exit;
                end;

                DimensionValueRec.SetRange("Dimension Code", "Dimension Code");
                DimensionValuePage.SetTableView(DimensionValueRec);
                DimensionValuePage.LookupMode(true);

                if DimensionValuePage.RunModal() = Action::LookupOK then begin
                    DimensionValuePage.GetRecord(DimensionValueRec);
                    Validate("Dimension Value", DimensionValueRec.Code);
                end;
            end;
        }
    }
    keys
    {
        key(PK; "Item No.", "Dimension Code", "Dimension Value")
        {
            Clustered = true;
        }
    }
}
