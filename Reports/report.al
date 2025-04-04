// report 50372 "DSR - Cash"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = 'Cargo/4. Report/DSR - Cash.rdl';

//     dataset
//     {
//         dataitem("G/L Entry"; "G/L Entry")
//         {
//             DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
//             PrintOnlyIfDetail = true;
//             // RequestFilterFields = "Receive Location", "User ID", "Posting Date";
//             RequestFilterFields = "User ID", "Posting Date";
//             column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
//             {
//             }
//             column(COMPANYNAME; COMPANYNAME)
//             {
//             }
//             column(CurrReport_PAGENO; CurrReport.PAGENO)
//             {
//             }
//             column(USERID; USERID)
//             {
//             }
//             column(G_L_Entry__Entry_No__; "Entry No.")
//             {
//             }
//             column(G_L_Entry__G_L_Account_No__; "G/L Account No.")
//             {
//             }
//             column(G_L_Entry__Posting_Date_; "Posting Date")
//             {
//             }
//             column(G_L_Entry_Amount; Amount)
//             {
//             }
//             column(G_L_Entry__User_ID_; "User ID")
//             {
//             }
//             column(G_L_Entry__External_Document_No__; "External Document No.")
//             {
//             }
//             column(G_L_Entry__Customer_No__; "Customer No.")
//             {
//             }
//             column(G_L_Entry__Cargo_Item_No__; "Cargo Item No.")
//             {
//             }
//             column(G_L_Entry_Airlines; CompanyInfo.Airlines)
//             {
//             }
//             column(G_L_Entry_Agency; "Source No.")
//             {
//             }
//             column(G_L_Entry__FOP_s_; "FOP's")
//             {
//             }
//             column(G_L_Entry__Receive_Location_; "Receive Location")
//             {
//             }
//             column(Filters; Filters)
//             {
//             }
//             column(G_L_EntryCaption; G_L_EntryCaptionLbl)
//             {
//             }
//             column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
//             {
//             }
//             column(G_L_Entry__G_L_Account_No__Caption; FIELDCAPTION("G/L Account No."))
//             {
//             }
//             column(G_L_Entry__Posting_Date_Caption; FIELDCAPTION("Posting Date"))
//             {
//             }
//             column(G_L_Entry_AmountCaption; FIELDCAPTION(Amount))
//             {
//             }
//             column(G_L_Entry__User_ID_Caption; FIELDCAPTION("User ID"))
//             {
//             }
//             column(G_L_Entry__External_Document_No__Caption; FIELDCAPTION("External Document No."))
//             {
//             }
//             column(G_L_Entry__Customer_No__Caption; FIELDCAPTION("Customer No."))
//             {
//             }
//             column(G_L_Entry__Cargo_Item_No__Caption; FIELDCAPTION("Cargo Item No."))
//             {
//             }
//             column(G_L_Entry_AirlinesCaption; 'Airlines')
//             {
//             }
//             column(G_L_Entry_AgencyCaption; 'Agency')
//             {
//             }
//             column(G_L_Entry__FOP_s_Caption; FIELDCAPTION("FOP's"))
//             {
//             }
//             column(G_L_Entry__Receive_Location_Caption; FIELDCAPTION("Receive Location"))
//             {
//             }
//             column(G_L_Entry__Entry_No__Caption; FIELDCAPTION("Entry No."))
//             {
//             }
//             dataitem("Cargo Item"; "Cargo Item")
//             {
//                 DataItemLink = "No." = FIELD("Cargo Item No."), "System No." = field("Cargo System No.");

//                 DataItemTableView = SORTING("System No.", "No.") ORDER(Ascending);
//                 RequestFilterFields = "Origin Airport", "Destination Airport";
//                 column(Cargo_Item__Cargo_Item___No__; "Cargo Item"."No.")
//                 {
//                 }
//                 column(Cargo_Item__Cargo_Item___Origin_Airport_; "Cargo Item"."Origin Airport")
//                 {
//                 }
//                 column(Cargo_Item__Cargo_Item___Destination_Airport_; "Cargo Item"."Destination Airport")
//                 {
//                 }
//                 column(Cargo_Item__Cargo_Item__Rate; "Cargo Item".Rate)
//                 {
//                 }
//                 column(Cargo_Item__Cargo_Item___Final_Weight_; "Cargo Item"."Final Weight")
//                 {
//                 }
//                 column(Cargo_Item__Cargo_Item___Other_Charge_; "Cargo Item"."Other Charge")
//                 {
//                 }
//                 column(Cargo_Item__Cargo_Item___Invoice_No__; "Cargo Item"."Invoice No.")
//                 {
//                 }
//                 column(Cargo_Item_System_No_; "System No.")
//                 {
//                 }
//             }

//             trigger OnAfterGetRecord();
//             begin
//                 Amount := -Amount;
//             end;

//             trigger OnPreDataItem();
//             begin
//                 LastFieldNo := FIELDNO("Entry No.");
//                 GLSetup.GET;
//                 Filters := "G/L Entry".GETFILTERS + ', ' + "Cargo Item".GETFILTERS;
//                 SETFILTER("G/L Account No.", '%1|%2', GLSetup."Cargo Unearned Revenue", GLSetup."Misc. Income");
//                 SETRANGE("FOP's", "FOP's"::Cash);
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPreReport();
//     begin
//         "G/L Entry".SETFILTER("G/L Entry"."User ID", USERID);
//         "G/L Entry".SETRANGE("G/L Entry"."Posting Date", WORKDATE);
//         CompanyInfo.get;
//     end;

//     var
//         LastFieldNo: Integer;
//         FooterPrinted: Boolean;
//         Filters: Text[250];
//         GLSetup: Record "General Ledger Setup";
//         G_L_EntryCaptionLbl: Label 'G/L Entry';
//         CurrReport_PAGENOCaptionLbl: Label 'Page';
//         CompanyInfo: Record "Company Information";
// }

