table 50155 "Checklist Table"
{
    Caption = 'Checklist Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; SN; Code[20])
        {
            Caption = 'SN';
        }
        field(2; Question; Text[100])
        {
            Caption = 'Question';
        }
        field(3; "Type"; Enum "Checklist Type Enum")
        {
            Caption = 'Type';
        }
        field(4; Answer; Text[100])
        {
            Caption = 'Answer';
        }
    }
    keys
    {
        key(PK; SN)
        {
            Clustered = true;
        }
    }
}
