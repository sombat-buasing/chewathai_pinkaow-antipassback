unit uFunction;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP, IdBaseComponent, IdMessage,
  IdAttachment,IdAttachmentFile, DB, DBGrids, RzDBGrid, StrUtils, iniFiles, DateUtils,
  Vcl.StdCtrls, Vcl.Mask, RzEdit, Vcl.Buttons, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL;



  procedure ShowDBGrid( var n : integer ;
                             cFieldName : string   ;
                             nWidth : integer ;
                             taAlignment : TAlignment  ;
                             cTitleCaption : string ;
                             dbg : TDBGrid ) ;

implementation


procedure ShowDBGrid( var n : integer ;
                             cFieldName : string   ;
                             nWidth : integer ;
                             taAlignment : TAlignment  ;
                             cTitleCaption : string ;
                             dbg : TDBGrid ) ;

begin
  dbg.Columns.Add ;
  dbg.Columns[n].FieldName := cFieldName ;
  dbg.Columns[n].Width := nWidth ;
  dbg.Columns[n].Alignment := taAlignment ;
  dbg.Columns[n].Title.Caption := cTitleCaption ;
  dbg.Columns[n].Title.Alignment := taCenter ;
  n := n + 1 ;
end;

end.
