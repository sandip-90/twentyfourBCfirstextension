// codeunit 50109 "Report Runners"
// {
//     procedure RunSelectedReport(SelectedReport: Enum "Report Selection")
//     var
//         Reportparameters: Text;
//     begin
//         Reportparameters := '';
//         case SelectedReport of
//             SelectedReport::"Trial Balance Report":
//                 Report.Run(Report::"Trial Balance");
//             SelectedReport::"Detail Trial Balance Report":
//                 Report.Run(Report::"Detail Trial Balance");
//             SelectedReport::"Vendor Detail Trial Balance Report":
//                 Report.Run(Report::"Vendor - Detail Trial Balance");
//             SelectedReport::"Vendor Trial Balance Report":
//                 Report.Run(Report::"Vendor - Trial Balance");
//             SelectedReport::"Customer Detail Trial Balance Report":
//                 Report.Run(Report::"Customer - Detail Trial Bal.");
//             SelectedReport::"Customer Trial Balance Report":
//                 Report.Run(Report::"Customer - Trial Balance");
//             else
//                 Message('No report selected.');
//         end;
//     end;
// }
