define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer.


DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita        AS RAW.

def var raw-param        as raw no-undo.

/*{xmlinc/tterrauth.i}*/
/* TEMP-TABLE Erros de Login */
DEF TEMP-TABLE ttLoginErrors NO-UNDO  
        FIELD cod-erro  AS CHARACTER
        FIELD cod-produto AS CHARACTER
        FIELD desc-erro AS CHARACTER
        FIELD desc-arq  AS CHARACTER.

/* TEMP-TABLE Erros de Login EMS2/HR */
DEF TEMP-TABLE ttLoginErrorsEMS2HR NO-UNDO
    FIELD cod-erro  AS INTEGER
    FIELD desc-erro AS CHARACTER
    FIELD desc-arq  AS CHARACTER.

/* TEMP-TABLE Erros de Login EMS5 */
DEF TEMP-TABLE ttLoginErrorsEMS5 NO-UNDO
    FIELD ttv_num_cod_erro  AS INTEGER
    FIELD ttv_cod_desc_erro AS CHARACTER.

DEF VAR iIniTime          AS INT  NO-UNDO.
DEF VAR iFinTime          AS INT  NO-UNDO.
DEF VAR cProcessName      AS CHAR NO-UNDO.
DEF VAR lProcessoContinuo AS LOG  NO-UNDO.
DEF VAR cProdName         AS CHAR NO-UNDO.
DEF VAR iTipoFilaGravacao AS INT  NO-UNDO.
DEF VAR iTipoFilaLeitura  AS INT  NO-UNDO.
DEF VAR cUserName         AS CHAR NO-UNDO.
DEF VAR cUserPasswd       AS CHAR NO-UNDO.
DEF VAR cInstance         AS CHAR NO-UNDO.
DEF VAR cEmpresa          AS CHAR NO-UNDO.
DEF VAR time-antes        AS INT  NO-UNDO.

{esp/es0018.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

DEF VAR c-propath AS CHAR NO-UNDO. 
DEF VAR c-layout  AS CHAR NO-UNDO.
DEF VAR c-spool   AS CHAR NO-UNDO.

DEF IMAGE im-eai
    FILE 'image/totvs.jpg'. /* image/logo-peq.bmp */

DEFINE VARIABLE rotulo AS CHARACTER   
    FORMAT 'x(65)'
    VIEW-AS TEXT
    INITIAL 'INTELBRAS RPW'
    NO-UNDO.

DEF FRAME fEAI
    im-eai
    rotulo AT ROW 2.9 COL 1
WITH 
    NO-LABELS
    SIZE 70 BY 3.

ASSIGN cProdName    = ENTRY(1, SESSION:PARAMETER, ".":U) 
       cUserName    = ENTRY(2, SESSION:PARAMETER, ".":U) 
       cUserPasswd  = ENTRY(3, SESSION:PARAMETER, ".":U) 
       cEmpresa     = ENTRY(4, SESSION:PARAMETER, ".":U)
       .                                                 
                                                         
RUN xmlutp/ut-auth.p ( INPUT cProdName,                  
                       INPUT cUserName,                  
                       INPUT cUserPasswd,                
                       OUTPUT TABLE ttLoginErrors).      

IF cEmpresa <> "" THEN
    ASSIGN rotulo = rotulo + "    [ " + UPPER(cEmpresa) + " ]".
        
IF  CAN-FIND(FIRST ttLoginErrors NO-LOCK) THEN DO:
    {utp/ut-liter.i "Erro_de_login"}
    MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX.
    RETURN.
END.

IF NOT SESSION:BATCH-MODE THEN DO:
    IF OPSYS <> "UNIX" THEN DO:
        DEFAULT-WINDOW:HIDDEN             = NO.
        DEFAULT-WINDOW:HEIGHT             = 3.
        DEFAULT-WINDOW:WIDTH              = 70.
        DEFAULT-WINDOW:BGCOLOR            = 15. /* 1 - AZUL*/
        DEFAULT-WINDOW:FONT               = 1.
        DEFAULT-WINDOW:FGCOLOR            = 0. /* 8 - cinza */
        DEFAULT-WINDOW:TITLE              = "Monitor RPW 1.0 ( Usuario: " + cUserName + " )".
    END.                                             

    {utp/ut-liter.i "Lendo_Registros..."}
    MESSAGE RETURN-VALUE. /* Tem que existir, senao nao fecha a janela com control + break*/
    
END.

create tt-param.
assign tt-param.usuario         = cUserName
       tt-param.destino         = 2
       tt-param.data-exec       = today
       tt-param.hora-exec       = time
/*       tt-param.arquivo         = session:temp-directory + "es0100.txt.". */
       tt-param.arquivo         = c-dir-arquivo-session + "es0100.txt.".

RAW-TRANSFER tt-param TO raw-param NO-ERROR.
                                       
DISP rotulo WITH FRAME fEAI.

VIEW FRAME fEAI.

RUN esp/es0018p.p (INPUT "monitor-rpw", /* Nome do programa */
                   INPUT 1,         /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FOR EACH tt-prog-ponto:
    CASE tt-prog-ponto.sequencia:
        WHEN 1 THEN ASSIGN c-propath = tt-prog-ponto.conteudo.
        WHEN 2 THEN ASSIGN c-layout  = tt-prog-ponto.conteudo.
        WHEN 3 THEN ASSIGN c-spool   = tt-prog-ponto.conteudo.
    END.
END.

IF c-propath <> "" THEN
    ASSIGN PROPATH = c-propath + "," + PROPATH.

REPEAT:

    ASSIGN time-antes = TIME.

    RUN esp\es0100a.p (INPUT c-layout,
                       INPUT c-spool).

    PAUSE 60 - (TIME - time-antes).

END.

           
