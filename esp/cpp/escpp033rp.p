&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/******************************************************************************
**  Programa: ESCPP033
**  Data....: 17/05/2024
**  Objetivo: IMPORTA€ÇO PID / DSK 
******************************************************************************/
{include/i-prgvrs.i ESCPP033RP 1.00.00.001}
{utp/ut-glob.i}

define temp-table tt-param
    field destino          as integer
    field arq-destino      as char
    field arq-entrada      as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-serie
       FIELD it-codigo AS CHAR LABEL 'Cod.Produto'
       FIELD n-serie   AS CHAR LABEL 'SN'
       FIELD dsk       AS CHAR LABEL 'DSK'
       FIELD cod-sit   AS INT   
       FIELD situacao  AS CHAR LABEL 'Resultado'
       INDEX idx cod-sit n-serie.

/* Transfer Definitions */
def temp-table tt-raw-digita
    field raw-digita as raw.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.


create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita.
    create tt-digita.
    raw-transfer raw-digita to tt-digita.
end.                   

{include/i-rpvar.i}

{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}
/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i &STREAM="str-rp"}

DEFINE VARIABLE h-acomp   AS HANDLE   NO-UNDO.

DEFINE VARIABLE sheet AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE wbook AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE excel AS COM-HANDLE   NO-UNDO.

DEFINE VARIABLE linha AS INTEGER      NO-UNDO.

FIND mgcad.empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Importa‡Æo PID/DSK * }
assign c-sistema = return-value.
{utp/ut-liter.i Importa‡Æo PID/DSK * }
assign c-titulo-relat = return-value.

ASSIGN c-programa     = "ESCPP033RP"
       c-versao       = "1.00"
       c-revisao      = ".00.001"
       c-titulo-relat = "Importa‡Æo PID/DSK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
view stream str-rp frame f-cabec.
view stream str-rp frame f-rodape.

                                                
RUN utp\ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Processando").

/* Leitura Planilha */
RUN pi-importa.

FOR EACH tt-serie:
    RUN pi-acompanhar IN h-acomp (INPUT "Carregando: " + tt-serie.n-serie).

    FIND FIRST num-serie 
         WHERE num-serie.n-serie = tt-serie.n-serie
    EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL num-serie THEN 
       ASSIGN tt-serie.cod-sit  = 0
              tt-serie.situacao = 'ERRO - SN nao encontrado'.
    ELSE DO:

       ASSIGN tt-serie.it-codigo = num-serie.it-codigo.

       FIND FIRST item-ean WHERE item-ean.it-codigo = num-serie.it-codigo NO-LOCK NO-ERROR.

       IF AVAIL item-ean THEN DO:
          IF LENGTH(item-ean.nc) <= 3 THEN 
             ASSIGN tt-serie.cod-sit  = 1
                 tt-serie.situacao = item-ean.it-codigo + ' - Formato PID invalido ( ESCPP020 )'.
       END.

       IF tt-serie.dsk = '' THEN
          ASSIGN tt-serie.cod-sit  = 2
                 tt-serie.situacao = 'ERRO - DSK nao preenchido'.
       ELSE DO:
          ASSIGN tt-serie.cod-sit  = 3
                 tt-serie.situacao = 'DSK importado com sucesso'.

          ASSIGN OVERLAY(num-serie.char-1,50,40) = tt-serie.dsk.

       END.
    END.
END.                 

FOR EACH tt-serie:   
    RUN pi-acompanhar IN h-acomp (INPUT "Relatorio: " + tt-serie.n-serie).

    DISP stream str-rp
         tt-serie.it-codigo FORMAT 'x(16)'
         tt-serie.n-serie   FORMAT 'x(20)'
         tt-serie.dsk       FORMAT 'x(40)'      
         tt-serie.situacao  FORMAT 'x(30)'      
         WITH WIDTH 132 STREAM-IO.  
END.

/* fechamento do output do log */
{include/i-rpclo.i &STREAM="stream str-rp"}

RUN pi-finalizar IN h-acomp.
return "Ok":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-importa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa Procedure 
PROCEDURE pi-importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE c-empresa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-ano         AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-mes         AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-zona        AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-familia AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-meta       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-meta-vl    AS DECIMAL     NO-UNDO.

CREATE "Excel.Application" excel.

ASSIGN wbook = excel:WorkBooks:ADD(tt-param.arq-entrada)
       sheet = excel:sheets:ITEM(1)
       linha = 2.

ASSIGN excel:DisplayAlerts = FALSE.

DO WHILE sheet:range("A" + STRING(linha)):VALUE <> ?:

    CREATE tt-serie. 
    ASSIGN tt-serie.n-serie = sheet:range("C" + STRING(linha)):VALUE 
           tt-serie.dsk     = sheet:range("D" + STRING(linha)):VALUE.

    IF tt-serie.dsk = ? THEN
       ASSIGN tt-serie.dsk = ''.

    RUN pi-acompanhar IN h-acomp (INPUT "Leitura Planilha: " + tt-serie.n-serie).

    ASSIGN linha = linha + 1.
END.

ASSIGN excel:VISIBLE = FALSE.

RELEASE OBJECT sheet.
RELEASE OBJECT wbook.
RELEASE OBJECT excel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

