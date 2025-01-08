&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP105A 2.00.00.000}
{esp/es0018.i}
{esapi/esapi023.i}      /* ttitem / ttarq / tt-mac-address */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP105A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-pedido ~
                              btConfigImpr ~
                              btOK ~
                              btCancel ~
                              btHelp2 ~
                              i-qtd-pedido ~
                              i-qtd-imprimir
                              

/* Local Temp-Table Definitions ---                                     */

/* Local Variable Definitions ---                                       */
DEFINE INPUT PARAMETER p-num-pedido AS INTEGER NO-UNDO.

DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp  AS HANDLE      NO-UNDO.

DEFINE VARIABLE i-pesq   AS INTEGER     NO-UNDO.

DEFINE VARIABLE l-imp-uuid AS LOGICAL   NO-UNDO INIT NO.

/* Global Shared Variable Definitions ---                               */

DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-num-serie FOR num-serie.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-15 i-qtd-pedido ~
i-qtd-imprimir btConfigImpr fiPrinter btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-pedido i-qtd-pedido i-qtd-imprimir ~
fiPrinter 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Sair" 
     SIZE 10 BY 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Imprimir" 
     SIZE 10 BY 1.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 52 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fi-pedido AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-qtd-imprimir AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Quantidade que deseja imprimir" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-qtd-pedido AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Qtd. Pedido" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 1.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 75 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-pedido AT ROW 1.17 COL 8 COLON-ALIGNED WIDGET-ID 16
     i-qtd-pedido AT ROW 1.17 COL 47 COLON-ALIGNED WIDGET-ID 18 NO-TAB-STOP 
     i-qtd-imprimir AT ROW 2.5 COL 47 COLON-ALIGNED WIDGET-ID 20
     btConfigImpr AT ROW 3.75 COL 65 HELP
          "Configuraá∆o da impressora"
     fiPrinter AT ROW 3.83 COL 13 NO-LABEL NO-TAB-STOP 
     btOK AT ROW 5.5 COL 2 HELP
          "Reimprimir"
     btCancel AT ROW 5.5 COL 13.14 HELP
          "Sair do Programa"
     btHelp2 AT ROW 5.5 COL 64.14 HELP
          "Ajuda"
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 4.13 COL 4.57
     rtToolBar AT ROW 5.25 COL 1
     RECT-15 AT ROW 1 COL 1.43 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 75.14 BY 11.96
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 5.88
         WIDTH              = 75.43
         MAX-HEIGHT         = 42.38
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 42.38
         VIRTUAL-WIDTH      = 274.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-pedido IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       i-qtd-pedido:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Sair */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fpage0 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Imprimir */
DO:

    RUN piExecute IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Etiqueta n∆o foi impressa!":U).
    ELSE DO:


        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Etiqueta impressa com sucesso!":U).

        RUN pi-calcular-qtd-pedido.

        ASSIGN i-qtd-imprimir:SCREEN-VALUE IN FRAME fpage0 = "0".

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-calcular-qtd-pedido.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcular-qtd-pedido wWindow 
PROCEDURE pi-calcular-qtd-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

ASSIGN fi-pedido:SENSITIVE       IN FRAME fPage0 = NO
       fi-pedido:SCREEN-VALUE    IN FRAME fPage0 = string(p-num-pedido).

FOR EACH num-serie NO-LOCK
    WHERE num-serie.num-pedido = p-num-pedido
      AND NOT num-serie.log-1:

    ASSIGN i-cont = i-cont + 1.
END.

ASSIGN i-qtd-pedido:SCREEN-VALUE IN FRAME fpage0 = string(i-cont).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wWindow 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Impress∆o de etiquetas...":U).

    ASSIGN INPUT FRAME fPage0 fiPrinter.


    RUN piValidateParam IN THIS-PROCEDURE (INPUT fiPrinter). 

    IF RETURN-VALUE = "NOK":U THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        IF VALID-HANDLE(h-acomp) THEN
            DELETE PROCEDURE h-acomp.

        ASSIGN h-acomp = ?.

        RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Preparando para impress∆o...":U).

    RUN piImprimirEtiqueta IN THIS-PROCEDURE (INPUT p-num-pedido).

    IF RETURN-VALUE = "NOK":U THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        IF VALID-HANDLE(h-acomp) THEN
            DELETE PROCEDURE h-acomp.

        ASSIGN h-acomp = ?.

        RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

  //  RUN esp\cpp\escpp105.p.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimirEtiqueta wWindow 
PROCEDURE piImprimirEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-pedido AS INTEGER NO-UNDO.

    DEFINE VARIABLE iColuna AS INTEGER NO-UNDO.

    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    ASSIGN INPUT FRAME fpage0 i-qtd-imprimir i-qtd-pedido.

    IF (i-qtd-imprimir = 0 OR i-qtd-pedido = 0) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17242,
                           INPUT "Quantidade inv†lida ~~ Quantidade do pedido ou quantidade a imprimir n∆o pode ser zero").
        RETURN "NOK".
    END.


    OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".

    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */
        "^PW1248"     SKIP   /* Para zebra com 300dpi */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */
        "^PON"        SKIP   /* Orientacao impressora N = Normal */
        "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
        "^MNY"        SKIP   /* Papel de etiquetas contnuo */
        "^XZ" SKIP.

    ASSIGN iColuna = 1
           i-cont  = 0.

    FOR EACH num-serie NO-LOCK
        WHERE num-serie.num-pedido = p-num-pedido
          AND NOT num-serie.log-1:

        FIND FIRST b-num-serie EXCLUSIVE-LOCK
             WHERE b-num-serie.n-serie = num-serie.n-serie NO-ERROR.
        IF AVAIL b-num-serie THEN DO:

            ASSIGN i-cont = i-cont + 1.

            IF i-cont > i-qtd-imprimir  THEN
                LEAVE.

            ASSIGN b-num-serie.log-1 = YES.
            RELEASE b-num-serie NO-ERROR.            
            
            
            IF iColuna = 1 THEN DO:
                
                PUT UNFORMATTED "^XA" SKIP
                        "^FO75,20^A0N,15,20^FD" num-serie.it-codigo "^FS" SKIP                 /* Item - Etiqueta Pequena 1 */
                        "^FO75,35^BY1,3.0^BCN,26,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP      /* Numero de serie EAN 128 - Etiqueta Pequena 1 */
                        "^FO75,65^A0N,15,20,^FB180,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de serie - Etiqueta Pequena 1 */
            
            
                ASSIGN iColuna = 2.
            END.
            ELSE DO:
                
                PUT UNFORMATTED 
                    "^FO371,20^A0N,15,20^FD" num-serie.it-codigo "^FS" SKIP            /* Item - Etiqueta Pequena 2 */
                    "^FO371,35^BY1,3.0^BCN,26,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP  /* Numero de serie EAN 128 - Etiqueta Pequena 2 */
                    "^FO371,65^A0N,15,20,^FB180,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP           /* Numero de serie - Etiqueta Pequena 2 */
                    "^XZ" SKIP.
            
               ASSIGN iColuna = 1.
            END.
            
            PUT UNFORMATTED
                 "^PQ" STRING(1, "99999") SKIP. /* Repetiá‰es */

        END.       
    END.           

    PUT UNFORMATTED 
        "^XZ" SKIP.

    OUTPUT CLOSE.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidateParam wWindow 
PROCEDURE piValidateParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pPrinter       AS CHARACTER   NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Validando parÉmetros...":U).


    IF NUM-ENTRIES(pPrinter, ":":U) = 2 THEN DO:
        ASSIGN cPrinter = SUBSTRING(pPrinter, 1, INDEX(pPrinter, ":":U) - 1)
               cLayout  = SUBSTRING(pPrinter, INDEX(pPrinter, ":":U) + 1, LENGTH(pPrinter) - INDEX(pPrinter, ":":U)).

        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
            WHERE imprsor_usuar.nom_impressora = cPrinter
              AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

        IF NOT AVAILABLE imprsor_usuar THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.

        FIND FIRST layout_impres
            WHERE layout_impres.nom_impressora    = cPrinter
              AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

        IF NOT AVAILABLE layout_impres THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        IF NUM-ENTRIES(pPrinter, ":":U) < 2 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.

        ASSIGN cPrinter = ENTRY(1, pPrinter, ":":U)
               cLayout  = ENTRY(2, pPrinter, ":":U).

        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
            WHERE imprsor_usuar.nom_impressora = cPrinter
              AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

        IF NOT AVAILABLE imprsor_usuar THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.

        FIND FIRST layout_impres
            WHERE layout_impres.nom_impressora = cPrinter
              AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

        IF NOT AVAILABLE layout_impres THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.
    END.

    ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

