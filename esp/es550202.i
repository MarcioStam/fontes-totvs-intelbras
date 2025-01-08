/*****************************************************************************

    Programa    : sdin001i01.i
    
    Objetivo    : Include para Validaá∆o da Planilha Excel
    
    Autor       : DatasulWA - Minas Gerais - Eduardo Leite
    
    Data        : 12/03/2009
    
    Revis∆o     :
    
*****************************************************************************/    

create "excel.application" ChExcel.

if ChExcel:version              <> "11.0" and 
   entry(2,cNomeArqDestino,".") = "xls"   then do:

    assign ChBook                 = ChExcel:WorkBooks:OPEN(cNomeArqDestino)
           ChSheet                = ChExcel:ActiveSheet
           ChExcel:DisplayAlerts  = no /*** N∆o mostrar mensagens de error ***/
           ChExcel:visible        = no /*** N∆o mostrar a planilha na tela ***/
           chexcel:ScreenUpdating = no /*** N∆o efetuar display na tela    ***/.
    
    ChExcel:ActiveWorkbook:SaveAs(replace(cNomeArqDestino,"xls","xlsx"),
                                  51,
                                  "",
                                  "",
                                  false,
                                  false,
                                  3,
                                  1,
                                  1,
                                  1) no-error.

    os-command silent value("del " + cNomeArqDestino).

    assign cNomeArqDestino = replace(cNomeArqDestino,"xls","xlsx"). /*** Salvar planilha gerada no 97/2003 para o 2007 ***/

    ChExcel:ActiveWorkbook:close.

    if valid-handle(ChExcel) then
        release object ChExcel      no-error.

    if valid-handle(ChSheet) then
        release object ChSheet      no-error.

    if valid-handle(ChBook) then
        release object ChBook       no-error.

end.

if valid-handle(ChExcel) then
    release object ChExcel      no-error.
