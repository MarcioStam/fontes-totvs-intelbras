/***********************************************************************
**  Programa..: esp/wmp/eswmp022rp.p
**  Autor.....: Nicolas Martinez
**  Data......: Setembro/2020 - Desenvolvimento
**  Descricao.: Relatorio movimentos pendentes WM0551
**  Versao....: 001 16/09/2020
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i ESWMP022RP 2.00.00.000}

/****************************  Definitions  ****************************/

{esp/wmp/eswmp022.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE STREAM str-excel.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{include/i-rpvar.i}
{esp/es0018.i}

/****************************  Variables  ****************************/
DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.

DEFINE VARIABLE c-excel       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE chExcel       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chArquivo     AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE NO-UNDO.

/****************************  Temp-Tables  ****************************/

IF OPSYS = "UNIX":U THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "/":U THEN
    ASSIGN c-excel = c-excel + "/":U + TRIM(tt-param.usuario) + "/":U.
END.
ELSE DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
                           
    END.
    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "~\":U THEN
    ASSIGN c-excel = c-excel + "~\":U + TRIM(tt-param.usuario) + "~\":U.
END.

OS-CREATE-DIR VALUE(c-excel).
ASSIGN c-excel = c-excel + "ESWMP022.csv":U.

/* **************************** Frames ********************************* */

{include/i-rpout.i}
{include/i-rpcab.i}

FOR FIRST tt-param:
END.

ASSIGN  c-programa 	    = "ESWMP022"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbras"
	    c-sistema	    = "WMP"
	    c-titulo-relat  = "Listagem de movimentos sem integra‡Æo ERP (WM0551)".

/* para nÆo visualizar cabe‡alho/rodap‚ em sa¡da RTF */

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET SESSION:CHARSET.
/* ***************************  Main Block  *************************** */

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Listando_Movimentos *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

PUT STREAM str-excel "Estab;Local;Seq Movto;Item;Lote;Id Docto;Nro Docto;Orig Docto;Tipo Movto;Status Trsnf;Qtd Lib ERP;Qtd Item;Dep Entrada" SKIP.

FOR EACH docto-transf-depos WHERE
         docto-transf-depos.cod-estab       = tt-param.cod-estabel AND
         docto-transf-depos.cod-depos-saida = tt-param.cod-local
         NO-LOCK,
    EACH Wm-box-movto WHERE
         Wm-box-movto.id-docto = docto-transf-depos.id-docto AND
         Wm-box-movto.cod-item   >= tt-param.itCodigoIni     AND
         Wm-box-movto.cod-item   <= tt-param.itCodigoFim
         NO-LOCK:
    /*    FOR EACH Wm-box-movto WHERE
                 Wm-box-movto.cod-estabel = tt-param.cod-estabel AND
                 Wm-box-movto.cod-local   = tt-param.cod-local   AND
                 Wm-box-movto.cod-item   >= tt-param.itCodigoIni AND
                 Wm-box-movto.cod-item   <= tt-param.itCodigoFim
                 NO-LOCK,
            EACH docto-transf-depos WHERE
                 docto-transf-depos.id-docto = Wm-box-movto.id-docto
                 NO-LOCK:
    */    
    run pi-acompanhar in h-acomp (input 'Item:' + Wm-box-movto.cod-item).

    IF Wm-box-movto.qtd-liber-erp   <> 0 THEN NEXT.
    IF Wm-box-movto.ind-tipo-movto  <> 2 THEN NEXT. //S¢ saida
    IF Wm-box-movto.ind-status-movto = 1 THEN NEXT.
   // IF Wm-box-movto.ind-status-movto = 4 THEN NEXT. //Elimina concluidos

    FIND FIRST wm-docto WHERE
               wm-docto.cod-estabel = Wm-box-movto.cod-estabel AND
               wm-docto.cod-local   = Wm-box-movto.cod-local   AND
               wm-docto.id-docto    = Wm-box-movto.id-docto     
               NO-LOCK NO-ERROR.

    IF tt-param.fil-situacao = YES
    THEN DO:
        IF docto-transf-depos.idi-sit-docto <> tt-param.situacao THEN NEXT.
    END.

    /*   IF AVAIL wm-docto AND
             Wm-docto.ind-origem-docto   <> 7 THEN NEXT. //S¢ Transf Fabrica */

    PUT STREAM str-excel UNFORMATTED
         Wm-box-movto.cod-estabel   ";"
         Wm-box-movto.cod-local     ";"
         Wm-box-movto.num-seq-item  ";"
         Wm-box-movto.cod-item      ";"
         Wm-box-movto.cod-lote      ";"
         Wm-box-movto.id-docto      ";"
         IF AVAIL wm-docto THEN wm-docto.num-docto        ELSE "" ";"
         IF AVAIL wm-docto THEN {scinc/i03sc038.i 04 Wm-docto.ind-origem-docto} ELSE "" ";"
         {scinc/i01sc032.i 04 Wm-box-movto.ind-tipo-movto}    ";"
        // {scinc/i02sc032.i 04 Wm-box-movto.ind-status-movto}  ";"
        // {scinc/i02sc038.i 04 wm-docto.ind-sit-docto}
         IF AVAIL docto-transf-depos THEN {scinc/i01sc070.i 04 docto-transf-depos.idi-sit-docto} ELSE "" ";"
         Wm-box-movto.qtd-liber-erp ";"
         Wm-box-movto.qtd-item      ";" 
     //INT(Wm-box-movto.ind-status-movto) ";"
        // docto-transf-depos.cod-depos-saida ";"
         docto-transf-depos.cod-depos-entr ";"
        /* tt-param.situacao ";"
         INT(wm-docto.ind-sit-docto) ";"
         INT(Wm-box-movto.ind-status-movto) ";"
         IF AVAIL docto-transf-depos THEN INT(docto-transf-depos.idi-sit-docto) ELSE 0 ";" */
         SKIP.
END.

OUTPUT STREAM str-excel CLOSE.

IF tt-param.destino = 3 THEN
DOS SILENT START excel value(c-excel).

/*fechamento do output do relat¢rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.

