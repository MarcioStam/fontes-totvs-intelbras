
/***********************************************************************
**  Programa..: ESCDP077
**  Autor.....: Alexandre de Freitas.Campos.Gonáalves
**  Data......: Maio/2015 - Desenvolvimento
**  Descricao.: Relat¢rio Importa cadastros
**  Versao....: 004 07/05/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i escdp077rp 1.00.00.000}
  
/****************************  Definitions  ****************************/

{esp/cdp/escdp077tt.i}

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE STREAM str-excel.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{include/i-rpvar.i}
{include/i-freeac.i}

/****************************  Variables  ****************************/

DEFINE VARIABLE h-acomp           AS HANDLE    NO-UNDO.

DEFINE VARIABLE c-arquivo-entrada AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arquivo-saida   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont            AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-ok              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-linha           AS CHAR FORMAT "X(200)" NO-UNDO.
DEFINE VARIABLE c-acao            AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-erro            AS LOGICAL   NO-UNDO.  

DEFINE VARIABLE e-acao            AS CHARACTER NO-UNDO.
DEFINE VARIABLE e-cliente         AS INTEGER   NO-UNDO.
DEFINE VARIABLE e-atendente       AS INTEGER   NO-UNDO.
DEFINE VARIABLE e-motivo          AS CHARACTER FORMAT "X(40)" NO-UNDO.

/****************************  Temp-Tables  ****************************/

FOR FIRST param-global NO-LOCK.
END.

DEFINE TEMP-TABLE tt-saida-error
    FIELD acao       AS CHAR
    FIELD cliente    AS INT 
    FIELD atendente  AS INT 
    FIELD motivo     AS CHAR
    FIELD desc-error AS CHAR FORMAT "X(60)".

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

DEFINE TEMP-TABLE tt-mot-aprov-auto-ped
    FIELD cod-emitente LIKE mot-aprov-auto-ped.cod-emitente 
    FIELD atendente    LIKE mot-aprov-auto-ped.atendente
    FIELD c-motivo     LIKE mot-aprov-auto-ped.c-motivo.

/****************************** Frames ***********************************/

FOR FIRST tt-param:
END.

FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri:
 END.

ASSIGN c-programa     = "ESCDP077"
       c-sistema      = "Especificos Intelbras"
       c-titulo-relat = "Importaá∆o/exclus∆o de Registros"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''.

FORM e-acao      COLUMN-LABEL "Aá∆o"
     e-cliente   COLUMN-LABEL "Cliente"
     e-atendente COLUMN-LABEL "Atendente"
     e-motivo    COLUMN-LABEL "Observaá∆o"
    WITH FRAME f-ns STREAM-IO DOWN WIDTH 132.

FORM tt-saida-error.acao      COLUMN-LABEL "Aá∆o"       
     tt-saida-error.cliente   COLUMN-LABEL "Cliente"     
     tt-saida-error.atendente COLUMN-LABEL "Atendente"
     tt-saida-error.desc-erro COLUMN-LABEL "Descriá∆o de erro"
    WITH FRAME b-ns STREAM-IO DOWN WIDTH 132. 


ASSIGN c-arquivo-entrada = tt-param.arq-entrada
       c-arquivo-saida   = c-arquivo-entrada + "_Reporte_erros.csv".

INPUT FROM VALUE(c-arquivo-entrada)CONVERT TARGET SESSION:CHARSET.

/*****************************  Main Block  *****************************/

DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados...").

    {include/i-rpout.i}
    {include/i-rpcab.i}
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN piImporta.
    
END.

PROCEDURE piImporta:
    
    REPEAT:
        
        IMPORT UNFORMATTED c-linha.
        
        FIND FIRST mot-aprov-auto-ped EXCLUSIVE-LOCK
            WHERE mot-aprov-auto-ped.cod-emitente = INT(ENTRY(2, c-linha, ";"))
              AND mot-aprov-auto-ped.atendente    = INT(ENTRY(3, c-linha, ";")) NO-ERROR.

        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = INT(entry(2, c-linha, ";")) NO-ERROR.
        
        FIND atendente NO-LOCK
            WHERE atendente.cd-oper = INT(ENTRY(3, c-linha, ";")) NO-ERROR.

        
        ASSIGN c-acao      = ENTRY(1, c-linha, ";")
               e-acao      = c-acao
               e-cliente   = INT(ENTRY(2, c-linha, ";"))
               e-atendente = INT(ENTRY(3, c-linha, ";"))
               e-motivo    = ENTRY(4, c-linha, ";").

        IF c-acao <> "i" AND c-acao <> "e" THEN DO:
            
            CREATE tt-saida-error.
            ASSIGN tt-saida-error.acao      = ENTRY(1, c-linha, ";")
                   tt-saida-error.cliente   = INT(ENTRY(2, c-linha, ";"))
                   tt-saida-error.atendente = INT(ENTRY(3, c-linha, ";"))
                   tt-saida-error.motivo    = ENTRY(4, c-linha, ";")
                   tt-saida-error.desc-erro = "Aá∆o n∆o reconhecida,registro desconsiderado."
                   l-erro = YES. 
            NEXT.
        
        END.
        
        IF NOT AVAIL emitente THEN DO:

            CREATE tt-saida-error.
            ASSIGN tt-saida-error.acao      = ENTRY(1, c-linha, ";")
                   tt-saida-error.cliente   = INT(ENTRY(2, c-linha, ";"))
                   tt-saida-error.atendente = INT(ENTRY(3, c-linha, ";"))
                   tt-saida-error.motivo    = ENTRY(4, c-linha, ";")
                   tt-saida-error.desc-erro = "Cliente n∆o cadastrado,registro desconsiderado."
                   l-erro = YES. 
            NEXT.

        END.
        
        IF NOT AVAIL atendente THEN DO:
            CREATE tt-saida-error.
            ASSIGN tt-saida-error.acao      = ENTRY(1, c-linha, ";")
                   tt-saida-error.cliente   = INT(ENTRY(2, c-linha, ";"))
                   tt-saida-error.atendente = INT(ENTRY(3, c-linha, ";"))
                   tt-saida-error.motivo    = ENTRY(4, c-linha, ";")
                   tt-saida-error.desc-erro = "Atendente n∆o cadastrado,registro desconsiderado."
                   l-erro = YES. 
            NEXT.
        END.
        
        IF c-acao BEGINS "i" THEN DO:
            IF NOT AVAIL mot-aprov-auto-ped THEN DO:
                CREATE mot-aprov-auto-ped.
                ASSIGN mot-aprov-auto-ped.cod-emitente = INT(ENTRY(2, c-linha, ";"))
                       mot-aprov-auto-ped.atendente    = INT(ENTRY(3, c-linha, ";"))
                       mot-aprov-auto-ped.c-motivo     = ENTRY(4, c-linha, ";").
            END.
            ASSIGN mot-aprov-auto-ped.c-motivo = entry(4, c-linha, ";").
            
             DISP e-acao     
             e-cliente  
             e-atendente
             e-motivo
            WITH FRAME f-ns.
            DOWN WITH FRAME f-ns.

        END.
        
        IF c-acao BEGINS "e" THEN DO:
            IF AVAIL mot-aprov-auto-ped THEN
                DELETE mot-aprov-auto-ped.
        
        END.
    
    END.
    
    IF l-erro = YES THEN DO:

        PUT "" SKIP(3).
        PUT UNFORMATTED "------------------------------------------------------------------------------------------------------------------------------------" SKIP.
        PUT UNFORMATTED "Intelbras S/A - Ind.Tel.Eletr.Brasileira         Demonstrativo de Erros" SKIP.                                 
        PUT UNFORMATTED "------------------------------------------------------------------------------------------------------------------------------------" SKIP(1).
        
        OUTPUT STREAM str-excel TO VALUE (c-arquivo-saida)CONVERT TARGET SESSION:CHARSET.
    
        PUT STREAM str-excel "Aá∆o;Cliente;Atendente;Motivo;Descriá∆o de Erro" SKIP.
    
        FOR EACH tt-saida-error:
    
            DISP tt-saida-error.acao       
                 tt-saida-error.cliente    
                 tt-saida-error.atendente  
                 tt-saida-error.desc-erro WITH FRAME b-ns.
                DOWN WITH FRAME b-ns.
                                                          
            PUT STREAM str-excel UNFORMATTED
                tt-saida-error.acao       ";"
                tt-saida-error.cliente    ";"
                tt-saida-error.atendente  ";"
                tt-saida-error.motivo     ";"
                tt-saida-error.desc-erro SKIP.
        END.
        OUTPUT STREAM str-excel CLOSE.

        PUT "" SKIP(3).
        PUT UNFORMATTED "Relatorio de erros gerado em: " c-arquivo-saida.

    END.
    
    INPUT CLOSE.
    RUN pi-finalizar IN h-acomp.

END PROCEDURE.


