/***********************************************************************
**  Programa..: ESP/FTP/ESFTP094RP.P
**  Autor.....: SENSUS Tecnologia
**  Data......: Abril/2013 - Desenvolvimento
**  Descricao.: Relatorio de NF aguardando embarque
**  VersÆo....: 
************************************************************************/
{include/i-prgvrs.i ESFTP094 2.06.00.000}

/*---[ Definitions ]---------------------------------------------------*/
{utp/ut-glob.i}
{esp/ftp/esftp094tt.i}
{include/i-rpvar.i}

/*---[ Temp-Tables ]---------------------------------------------------*/

/*---[ Variaveis ]-----------------------------------------------------*/
DEFINE VARIABLE h-acomp       as handle  no-undo.
DEFINE VARIABLE v-num-linha   AS INTEGER NO-UNDO.
DEFINE VARIABLE v-lin-inicial AS INTEGER NO-UNDO.
DEFINE VARIABLE v-lin-final   AS INTEGER NO-UNDO.
DEFINE VARIABLE v-lin-total   AS INTEGER NO-UNDO.

DEFINE VARIABLE chExcel     AS COM-HANDLE.
DEFINE VARIABLE chWorkbook  AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

ASSIGN chExcel     = ?
       chWorkbook  = ?
       chWorksheet = ?.

/* --- XlBordersIndex --- */
def var xlEdgeLeft         as decimal init 7.
def var xlEdgeRight        as decimal init 10.
def var xlEdgeTop          as decimal init 8.
def var xlEdgeBottom       as decimal init 9.
def var xlInsideHorizontal as decimal init 12.
def var xlInsideVertical   as decimal init 11.
def var xlDiagonalDown     as decimal init 5.
def var xlDiagonalUp       as decimal init 6.

/* --- XlLineStyle --- */
def var xlContinuous       as decimal init 1.
def var xlDash             as decimal init -4115.
def var xlDashDot          as decimal init 4.
def var xlDashDotDot       as decimal init 5.
def var xlDot              as decimal init -4118.
def var xlDouble           as decimal init -4119.
def var xlSlantDashDot     as decimal init 13.
def var xlLineStyleNone    as decimal init -4142.

/* --- XlWidth --- */
def var xlThick            as decimal init 4.
def var xlThin             as decimal init 2.
def var xlNone             as decimal init -4142.
/* --- page set up variables --- */
def var xlPortrait         as decimal init 1.
def var xlLandscape        as decimal init 2.

/* --- alignment variables --- */
def var xlRight            as decimal init -4152.
def var xlLeft             as decimal init -4131.
def var xlTop              as decimal init -4160.
def var xlBottom           as decimal init -4107.
def var xlCenter           as decimal init -4108.

/* --- color index --- */
def var xlAutomatic        as decimal init -4105.

/* --- shift variables --- */
def var xlToLeft           as decimal init -4159.

/* --- SpecialCells Variables */
def var x1CellTypeLastCell as decimal init 11.

/*---[ Frames ]--------------------------------------------------------*/

/*---[ Parƒmetros ]----------------------------------------------------*/
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 
         
for first param-global no-lock. end.
for first mgcad.empresa no-lock
    where empresa.ep-codigo = param-global.empresa-pri: end.
for first estabelec no-lock
    where estabelec.ep-codigo = mgcad.empresa.ep-codigo: end.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relatorio Notas Fiscais aguardando Embarque"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP094"
       c-versao       = "2.06"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */
do  on stop undo, leave:
    {include/i-rpout.i &STREAM="stream str-rp"}
    {include/i-rpcab.i &STREAM="str-rp"}

    run utp/ut-acomp.p persistent set h-acomp.  

    run pi-inicializar in h-acomp (input "Imprimindo...").

    /* corpo do relat¢rio */
    CREATE "Excel.Application" chExcel.
    chExcel:Visible = FALSE.
    chWorkbook  = chExcel:Workbooks:Open(SEARCH("esp\layout\loesftp094001.xls")).
    chWorksheet = chWorkbook:Worksheets:Item(1).
    
    ASSIGN v-num-linha = 1.
    
    run piImprimeRelat.
    
    run pi-rodape.
    
    {include/i-rpclo.i &STREAM="stream str-rp"}
    run pi-finalizar in h-acomp.
    RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE piImprimeRelat:
    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.
    
    ASSIGN chWorkSheet:Range("E" + STRING(v-num-linha)):VALUE = trim(STRING(tt-param.cod-estabel))
           chWorkSheet:Range("E" + STRING(v-num-linha)):HorizontalAlignment = -4152
           v-num-linha = v-num-linha + 1
           chWorkSheet:Range("E" + STRING(v-num-linha)):VALUE = trim(STRING(tt-param.nr-embarque))
           chWorkSheet:Range("E" + STRING(v-num-linha)):HorizontalAlignment = -4152
           v-num-linha = v-num-linha + 2.

    for first embarque no-lock
        where embarque.cod-estabel = tt-param.cod-estabel
        and   embarque.cdd-embarq = tt-param.nr-embarque,
        each nota-fiscal no-lock where
             nota-fiscal.cod-estabel   = embarque.cod-estabel and 
             nota-fiscal.cdd-embarq   = embarque.cdd-embarq and 
             nota-fiscal.dt-emis-nota >= tt-param.dt-emis-ini and 
             nota-fiscal.dt-emis-nota <= tt-param.dt-emis-fim and 
             nota-fiscal.dt-cancela = ?,
       first emitente no-lock where
             emitente.cod-emitente = nota-fiscal.cod-emitente:
             
        RUN pi-acompanhar IN h-acomp (INPUT "NF.: " + nota-fiscal.nr-nota-fis).

        ASSIGN chWorkSheet:Range("A" + STRING(v-num-linha)):VALUE = "'" + trim(STRING(nota-fiscal.nr-nota-fis))
               chWorkSheet:Range("A" + STRING(v-num-linha)):HorizontalAlignment = -4131
               chWorkSheet:Range("B" + STRING(v-num-linha)):VALUE = trim(STRING(nota-fiscal.serie))
               chWorkSheet:Range("B" + STRING(v-num-linha)):HorizontalAlignment = -4152
               chWorkSheet:Range("C" + STRING(v-num-linha)):VALUE = "'" + trim(STRING(nota-fiscal.dt-emis-nota, "99/99/9999"))
               chWorkSheet:Range("C" + STRING(v-num-linha)):HorizontalAlignment = -4108
               chWorksheet:Range("D" + STRING(v-num-linha)):VALUE = "'" + STRING(nota-fiscal.vl-tot-nota, ">>,>>>,>>>,>>9.99")
               chWorkSheet:Range("D" + STRING(v-num-linha)):HorizontalAlignment = -4152
               chWorkSheet:Range("E" + STRING(v-num-linha)):VALUE = trim(STRING(nota-fiscal.nat-operacao))
               chWorkSheet:Range("E" + STRING(v-num-linha)):HorizontalAlignment = -4152.

        find last volume-nf no-lock
            where volume-nf.cod-estabel = nota-fiscal.cod-estabel
            and   volume-nf.serie       = nota-fiscal.serie
            and   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis no-error.
        if  avail volume-nf 
        then ASSIGN chWorkSheet:Range("F" + STRING(v-num-linha)):VALUE = trim(STRING(volume-nf.nr-volume))
                    chWorkSheet:Range("F" + STRING(v-num-linha)):HorizontalAlignment = -4152.
        else ASSIGN chWorkSheet:Range("F" + STRING(v-num-linha)):VALUE = "0"
                    chWorkSheet:Range("F" + STRING(v-num-linha)):HorizontalAlignment = -4152.
        
        ASSIGN chWorkSheet:Range("G" + STRING(v-num-linha)):VALUE = trim(STRING(emitente.nome-emit))
               chWorkSheet:Range("G" + STRING(v-num-linha)):HorizontalAlignment = -4131
               chWorkSheet:Range("H" + STRING(v-num-linha)):VALUE = trim(STRING(emitente.cod-emitente))
               chWorkSheet:Range("H" + STRING(v-num-linha)):HorizontalAlignment = -4152
               v-num-linha = v-num-linha + 1.
    end. /* for first embarque no-lock */

END PROCEDURE.

PROCEDURE pi-rodape:
/*--------------------------------------------------------------------------------------
**
----------------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-nome-arquivo AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE v-carac-proib  AS CHARACTER  NO-UNDO.
    
    FIND FIRST usuar_mestre NO-LOCK
        WHERE  usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    IF  AVAIL usuar_mestre 
    THEN ASSIGN v-nome-arquivo = usuar_mestre.nom_dir_spool + "/" + usuar_mestre.nom_subdir_spool + "/EmbQuarentena_" + string(REPLACE(STRING(TODAY, "99/99/9999"),"/","")) + "_" + STRING(TIME) + ".xls"
                v-nome-arquivo = replace(v-nome-arquivo, "/", "~\").
    ELSE ASSIGN v-nome-arquivo = "c:\tmp\EmbQuarentena_" + string(REPLACE(STRING(TODAY, "99/99/9999"),"/","")) + "_" + STRING(TIME) + ".xls".
     
    chWorkbook:SaveCopyAs(v-nome-arquivo).

    PUT STREAM str-rp UNFORMATTED
        "Planilha gerada no caminho ...: ":U AT 01 STRING(v-nome-arquivo) AT 35.

    /* --- Close the workbook --- */
    if chWorkbook <> ? then
      chWorkbook:Close(0).
    
    /* --- Close the program --- */
    if chExcel <> ? then
      chExcel:Quit.
    
    /* --- Release all the com handles --- */
    if chWorksheet <> ? then
      RELEASE OBJECT chWorksheet.

    if chWorkbook <> ? then
      RELEASE OBJECT chWorkbook.

    if chExcel <> ? then
      RELEASE OBJECT chExcel.

    chWorksheet = ?.
    chWorkbook = ?.      
    chExcel = ?.

    PUT STREAM str-rp UNFORMATTED SKIP.

END PROCEDURE. /* PROCEDURE pi-rodape: */

/* Fim */
