/***********************************************************************
**  Programa..: esp/ftp/esfto109rp.
**  Autor.....: Alexandre de Freitas.Campos.Gon‡alves
**  Data......: Agosto/2015 - Desenvolvimento
**  Descricao.: Busca patrimonio nota fiscal
**  Versao....: 001 08/08/2015
**                  Desenvolvimento Programa
************************************************************************/
DEF BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esftp109rp 1.00.00.00}

/****************************  Definitions  ****************************/

{esp/ftp/esftp109tt.i}

DEF TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.

DEF STREAM str-excel.

{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}

/****************************  Temp-Tables  ****************************/

DEFINE TEMP-TABLE tt-saida
    FIELD serie         LIKE nota-fiscal.serie
    FIELD cod-estabel   LIKE nota-fiscal.cod-estabel 
    FIELD nr-nota       LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis       LIKE nota-fiscal.dt-emis-nota
    FIELD cod-emitente  LIKE emitente.cod-emitente
    FIELD nome-abrev    LIKE emitente.nome-abrev
    FIELD conta         AS CHAR FORMAT "x(18)"
    FIELD bem           AS INT
    FIELD seq           AS INTEGER 
    FIELD valor-total   AS DECIMAL.

/****************************  Variables  ******************************/

DEF VAR h-acomp       AS HANDLE          NO-UNDO.
DEF VAR c-excel       AS CHAR            NO-UNDO.
DEF VAR i-nivel       AS INT FORMAT "99" NO-UNDO.
DEF VAR chExcel       AS COM-HANDLE      NO-UNDO.
DEF VAR chArquivo     AS COM-HANDLE      NO-UNDO.
DEF VAR chPlanilhaMod AS COM-HANDLE      NO-UNDO.
DEF VAR i-seq-saida   AS INT             NO-UNDO.

/****************************  Frames       ****************************/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

EMPTY TEMP-TABLE tt-prog-ponto.

IF  OPSYS = "UNIX" THEN DO:
    RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                       INPUT 1,           /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR FIRST tt-prog-ponto NO-LOCK:
        ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".
        OS-CREATE-DIR VALUE(c-excel).
        ASSIGN c-excel = c-excel + "esftp109.csv".
    END.
END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:
        ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".
        OS-CREATE-DIR VALUE(c-excel).
        ASSIGN c-excel = c-excel + "esftp109.csv".
    END.
END. 

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".
PUT STREAM str-excel "Serie;Estab.;Nr.Nota;Data EmissÆo;Cod.Cliente;Nome Cliente;Conta;Bem;Seq;Valor Nota" SKIP.

/*****************************  Main Block  *****************************/

DO ON STOP UNDO, LEAVE:
    
    {include/i-rpcab.i}
    {include/i-rpout.i} 

    EMPTY TEMP-TABLE tt-saida.
    ASSIGN i-seq-saida = 0.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Obtendo informa‡äes..."). 
    RUN piMontaRelat.

END.

PROCEDURE piMontaRelat:
    
    DEF VAR c-conta      AS CHAR NO-UNDO.
    DEF VAR i-patrimonio AS INT  NO-UNDO.
    DEF VAR i-seq        AS INT  NO-UNDO.

    FOR EACH nota-fiscal
        WHERE nota-fiscal.cod-estabel  >= tt-param.cod-estabel-ini
        AND   nota-fiscal.cod-estabel  <= tt-param.cod-estabel-fim
        AND   nota-fiscal.serie        >= tt-param.serie-ini
        AND   nota-fiscal.serie        <= tt-param.serie-fim
        AND   nota-fiscal.nr-nota-fis  >= tt-param.nr-num-nota-ini
        AND   nota-fiscal.nr-nota-fis  <= tt-param.nr-num-nota-fim
        AND   nota-fiscal.dt-emis-nota >= tt-param.data-emis-ini
        AND   nota-fiscal.dt-emis-nota <= tt-param.data-emis-fim NO-LOCK:
        
        IF  NOT AVAIL nota-fiscal THEN
            NEXT.
        
        FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

        FOR EACH it-nota-fisc
            WHERE it-nota-fisc.cod-estabel  = nota-fiscal.cod-estabel 
            AND   it-nota-fisc.serie        = nota-fiscal.serie       
            AND   it-nota-fisc.nr-nota-fis  = nota-fiscal.nr-nota-fis NO-LOCK:

            FIND FIRST int_bem_pat_nf
                WHERE int_bem_pat_nf.cod-estabel = it-nota-fisc.cod-estabel 
                AND   int_bem_pat_nf.serie       = it-nota-fisc.serie       
                AND   int_bem_pat_nf.nr-nota-fis = it-nota-fisc.nr-nota-fis 
                AND   int_bem_pat_nf.nr-seq-fat  = it-nota-fisc.nr-seq-fat  
                AND   int_bem_pat_nf.it-codigo   = it-nota-fisc.it-codigo
                AND   int_bem_pat_nf.cod_cta_pat >= tt-param.conta_pat_ini 
                AND   int_bem_pat_nf.cod_cta_pat <= tt-param.conta_pat_fim
                AND   int_bem_pat_nf.num_bem_pat >= tt-param.num_bem_pat_ini 
                AND   int_bem_pat_nf.num_bem_pat <= tt-param.num_bem_pat_fim NO-LOCK NO-ERROR.

            IF  AVAIL int_bem_pat_nf THEN DO:
                CREATE tt-saida.
                ASSIGN tt-saida.serie         = nota-fiscal.serie
                       tt-saida.cod-estabel   = nota-fiscal.cod-estabel
                       tt-saida.nr-nota       = nota-fiscal.nr-nota-fis
                       tt-saida.dt-emis       = nota-fiscal.dt-emis-nota
                       tt-saida.cod-emitente  = emitente.cod-emitente
                       tt-saida.nome-abrev    = emitente.nome-abrev
                       tt-saida.conta         = int_bem_pat_nf.cod_cta_pat        
                       tt-saida.bem           = int_bem_pat_nf.num_bem_pat    
                       tt-saida.seq           = int_bem_pat_nf.num_seq_bem_pat      
                       tt-saida.valor-total   = nota-fiscal.vl-tot-nota.
                
             END.
        END.
    END.
    RUN pi-finalizar in h-acomp.
END.

FOR EACH tt-saida NO-LOCK
    BY tt-saida.serie:

    PUT STREAM str-excel UNFORMATTED
        tt-saida.serie         ";"
        tt-saida.cod-estabel   ";"
        tt-saida.nr-nota       ";"
        tt-saida.dt-emis       ";"
        tt-saida.cod-emitente  ";"
        tt-saida.nome-abrev    ";"                  
        tt-saida.conta         ";"
        tt-saida.bem           ";"
        tt-saida.seq           ";"
        tt-saida.valor-total   SKIP.
END. 

OUTPUT STREAM str-excel CLOSE.

CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.

IF ERROR-STATUS:ERROR THEN
    CREATE "Excel.Application":U chExcel.
    
ASSIGN chArquivo     = chExcel:WorkBooks:Open(c-excel).
ASSIGN chPlanilhaMod = chArquivo:Sheets:Item(1).

chPlanilhaMod:Activate().

ASSIGN chExcel:VISIBLE     = TRUE
       chExcel:WindowState = 3.

RELEASE OBJECT chExcel       NO-ERROR.
RELEASE OBJECT chArquivo     NO-ERROR.
RELEASE OBJECT chPlanilhaMod NO-ERROR.
