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
{include/i-prgvrs.i ESCPP105C 2.00.00.000}
{esp/es0018.i}
{esapi/esapi023.i}      /* ttitem / ttarq / tt-mac-address */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP105C
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-pedido ~
                              fi-it-codigo ~
                              fi-desc-item ~
                              fi-seq-ini ~
                              btConfigImpr ~
                              btOK ~
                              btCancel ~
                              btHelp2 
                              

/* Local Temp-Table Definitions ---                                     */

/* Local Variable Definitions ---                                       */
DEFINE INPUT PARAMETER p-num-pedido AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttitem.

DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp  AS HANDLE      NO-UNDO.

DEFINE VARIABLE i-pesq   AS INTEGER     NO-UNDO.

/* Global Shared Variable Definitions ---                               */

DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER   NO-UNDO.
DEFINE TEMP-TABLE tt-lista-ns
    FIELD num-serie     AS CHAR FORMAT "X(13)".

DEFINE BUFFER bf-mac-address  FOR mac-address.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-15 fi-seq-ini btConfigImpr ~
fiPrinter btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-pedido fi-it-codigo fi-desc-item ~
fi-seq-ini fiPrinter 

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

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .79 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(12)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-pedido AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fi-seq-ini AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Qtd Etq" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 3.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 75 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-pedido AT ROW 2.17 COL 18 COLON-ALIGNED WIDGET-ID 16
     fi-it-codigo AT ROW 3.21 COL 18 COLON-ALIGNED WIDGET-ID 18
     fi-desc-item AT ROW 3.21 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     fi-seq-ini AT ROW 4.21 COL 18 COLON-ALIGNED WIDGET-ID 12
     btConfigImpr AT ROW 5.75 COL 65 HELP
          "Configuraá∆o da impressora"
     fiPrinter AT ROW 5.83 COL 13 NO-LABEL NO-TAB-STOP 
     btOK AT ROW 7.29 COL 2 HELP
          "Reimprimir"
     btCancel AT ROW 7.29 COL 13.14 HELP
          "Sair do Programa"
     btHelp2 AT ROW 7.29 COL 64.14 HELP
          "Ajuda"
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 5.92 COL 4.57
     rtToolBar AT ROW 7.04 COL 1
     RECT-15 AT ROW 1.75 COL 13 WIDGET-ID 6
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
         HEIGHT             = 8.17
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
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pedido IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

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

FIND FIRST ttitem WHERE
           ttitem.marcado = YES
           NO-LOCK NO-ERROR.

IF AVAIL ttitem 
THEN FIND FIRST ITEM WHERE
                ITEM.it-codigo = ttitem.it-codigo
                NO-LOCK NO-ERROR.

ASSIGN fi-pedido:SENSITIVE       IN FRAME fPage0 = NO
       fi-pedido:SCREEN-VALUE    IN FRAME fPage0 = string(p-num-pedido)
       fi-it-codigo:SENSITIVE    IN FRAME fPage0 = NO
       fi-it-codigo:SCREEN-VALUE IN FRAME fPage0 = ttitem.it-codigo WHEN AVAIL ttitem
       fi-desc-item:SENSITIVE    IN FRAME fPage0 = NO
       fi-desc-item:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item WHEN AVAIL ITEM
       fi-seq-ini:SENSITIVE      IN FRAME fPage0 = YES
       fi-seq-ini:SCREEN-VALUE   IN FRAME fPage0 = "0".

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

/*
    IF  NOT AVAIL mac-address THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "N∆o existe MAC cadastrado para o PO ou ID informado.").
    
        RETURN "NOK":U.
    END.  */

/*
    IF INPUT rs-pesquisa = 1 
    THEN RUN piImprimirEtiqueta IN THIS-PROCEDURE (INPUT mac-address.num-pedido,
                                                   INPUT 0).
    ELSE RUN piImprimirEtiqueta IN THIS-PROCEDURE (INPUT 0,
                                                   INPUT mac-address.id). */
    RUN piImprimirEtiqueta IN THIS-PROCEDURE (INPUT p-num-pedido,
                                              INPUT 0).

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
    DEFINE INPUT  PARAMETER p-num-pedido AS INTE        NO-UNDO.
    DEFINE INPUT  PARAMETER p-id-mac     AS CHAR        NO-UNDO.

    DEFINE VAR c-ID          AS CHAR  NO-UNDO.
    DEFINE VAR c-ch-acesso   AS CHAR  NO-UNDO.
    DEFINE VAR c-macs        AS CHAR  NO-UNDO.
    DEFINE VAR i-mac-cont    AS INTE  NO-UNDO.
    DEFINE VAR i-cont        AS INTE  NO-UNDO.
    DEFINE VAR l-iniarq      AS LOG   NO-UNDO.
    DEFINE VAR c-qrcode      AS CHAR  NO-UNDO FORMAT "x(60)".
    DEFINE VAR i-vert        AS INTE  NO-UNDO EXTENT 8.
    DEFINE VAR i-hori        AS INTE  NO-UNDO EXTENT 8.
    DEFINE VAR i-seq         AS INTE  NO-UNDO.
    DEFINE VAR c-camp1       AS CHAR  NO-UNDO FORMAT "x(60)".
    DEFINE VAR c-camp2       AS CHAR  NO-UNDO FORMAT "x(60)".
  
    ASSIGN c-camp1 = "(DH) WIFI-2-"
           c-camp2 = "R88FUSA1".

    IF p-num-pedido <> 0 
    THEN DO:

        ASSIGN l-iniarq = NO.

        DO i-cont = 1 TO int(fi-seq-ini:SCREEN-VALUE IN FRAME fPage0): 
            ASSIGN i-seq = i-seq + 1.

            IF i-seq = 1 
            THEN DO: 
               ASSIGN l-iniarq = YES.

               //OUTPUT TO VALUE("C:\temp\teste-etq" + STRING(TIME) + "-" + string(i-cont) + ".txt").
               OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".
            
              PUT "^XA"         SKIP.   /* Inicio Label */
              /*PUT "^XA" SKIP.
              PUT "^PW2500" SKIP.
              PUT "^MNY" SKIP.
              PUT "^MTT" SKIP.
              PUT "^BY2" SKIP.
              PUT "^PRA" SKIP. */
            
            END.

            {esp\cpp\escpp105c.i}

            IF i-seq = 8 
            THEN DO:
            
                /* zera no fim */
                ASSIGN i-seq   = 0
                       l-iniarq = NO.
            
                /* FINALIZANDO PARAMETROS DA IMPRESSORA */
                PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                PUT "^XZ" SKIP.
            
                OUTPUT CLOSE.
            
            END.
            
            run pi-acompanhar in h-acomp (input 'Seq: ' + STRING(i-cont)).

        END.

            IF l-iniarq = YES 
            THEN DO:
                /* FINALIZANDO PARAMETROS DA IMPRESSORA */
                PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                PUT "^XZ" SKIP.
                OUTPUT CLOSE.
            END.

/*
        IF fi-seq-ini:SCREEN-VALUE IN FRAME fPage0 = "0" AND 
           fi-seq-fim:SCREEN-VALUE IN FRAME fPage0 = "0" 
        THEN DO:

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-seta-titulo IN h-acomp (INPUT "Imprimindo etiqueta...":U).

            ASSIGN l-iniarq = NO.

            FOR EACH mac-address WHERE
                     mac-address.num-pedido = p-num-pedido AND
                     mac-address.it-codigo  = INPUT FRAME fPage0 fi-it-codigo
                     EXCLUSIVE-LOCK
                BREAK BY mac-address.n-serie:

                IF FIRST-OF(mac-address.n-serie) 
                THEN DO:

                    FIND FIRST item-ean WHERE
                               item-ean.it-codigo = mac-address.it-codigo
                               NO-LOCK NO-ERROR.

                    ASSIGN i-seq = i-seq + 1.
                    
                    IF i-cont = 0 
                    THEN DO: 
                       ASSIGN l-iniarq = YES.
                       //OUTPUT TO VALUE("C:\temp\teste-etq" + STRING(TIME) + ".txt").
                       OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".
                    
                       PUT "^XA"         SKIP.   /* Inicio Label */
                    
                    END.

                    ASSIGN c-macs     = ""
                           i-mac-cont = 0.

                    FOR EACH bf-mac-address WHERE
                             bf-mac-address.n-serie = mac-address.n-serie
                             NO-LOCK.
                        
                        ASSIGN i-mac-cont = i-mac-cont + 1.

                        ASSIGN c-macs = c-macs 
                                      + "MAC"
                                      + STRING(i-mac-cont)
                                      + ":"
                                      + bf-mac-address.mac 
                                      + ",".
                    END.

                    ASSIGN c-ID        = mac-address.id
                           c-ch-acesso = mac-address.ch-acesso
                           c-qrcode    = "SN:" 
                                       + STRING(mac-address.n-serie) + ","
                                       + "DT:"
                                       + string(item-ean.nome-abrev) + ","
                                       + "SC:"
                                       + string(mac-address.ch-acesso) + ","
                                       + "NC:"
                                       + string(item-ean.nc) + ","
                                       + c-macs
                                       + "\0D\0A"
                           i-cont      = i-cont + 1.

                    IF mac-address.seq-imp = 0 
                    THEN ASSIGN mac-address.seq-imp = i-seq.

                    {esp\cpp\escpp105c.i}
                    
                    IF i-cont = 4 
                    THEN DO:
                    
                        /* zera no fim */
                        ASSIGN i-cont   = 0
                               l-iniarq = NO.
                    
                        /* FINALIZANDO PARAMETROS DA IMPRESSORA */
                        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                        PUT "^XZ" SKIP.
                    
                        OUTPUT CLOSE.
                    
                    END.
                    
                    run pi-acompanhar in h-acomp (input 'Seq: ' + STRING(i-seq)).
                    
                END.
                ELSE DO:
                    ASSIGN mac-address.seq-imp = i-seq.
                END.
                    
            END.
            IF l-iniarq = YES 
            THEN DO:
                /* FINALIZANDO PARAMETROS DA IMPRESSORA */
                PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                PUT "^XZ" SKIP.
                OUTPUT CLOSE.
            END.
        END.
        ELSE DO:

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-seta-titulo IN h-acomp (INPUT "Reimprimindo etiqueta...":U).

            ASSIGN l-iniarq = NO.
            
            FOR EACH mac-address USE-INDEX ped WHERE
                     mac-address.num-pedido = p-num-pedido
                 AND mac-address.it-codigo  = INPUT FRAME fPage0 fi-it-codigo
                 AND mac-address.seq-imp   >= INT(fi-seq-ini:SCREEN-VALUE IN FRAME fPage0)
                 AND mac-address.seq-imp   <= INT(fi-seq-fim:SCREEN-VALUE IN FRAME fPage0)
                     NO-LOCK
                BREAK BY mac-address.n-serie:
            
                IF FIRST-OF(mac-address.n-serie) 
                THEN DO:
                    FIND FIRST item-ean WHERE
                               item-ean.it-codigo = mac-address.it-codigo
                               NO-LOCK NO-ERROR.

                    ASSIGN i-seq = i-seq + 1.
                    
                    IF i-cont = 0 
                    THEN DO: 
                       ASSIGN l-iniarq = YES.
                      // OUTPUT TO VALUE("C:\temp\teste-etq" + STRING(TIME) + ".txt").
                       OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".
                    
                       PUT "^XA"         SKIP.   /* Inicio Label */
                    
                    END.

                    ASSIGN c-macs     = ""
                           i-mac-cont = 0.

                    FOR EACH bf-mac-address WHERE
                             bf-mac-address.n-serie = mac-address.n-serie
                             NO-LOCK.
                        
                        ASSIGN i-mac-cont = i-mac-cont + 1.

                        ASSIGN c-macs = c-macs 
                                      + "MAC"
                                      + STRING(i-mac-cont)
                                      + ":"
                                      + bf-mac-address.mac 
                                      + ",".
                    END.

                    ASSIGN c-ID        = mac-address.id
                           c-ch-acesso = mac-address.ch-acesso
                           c-qrcode    = "SN:" 
                                       + STRING(mac-address.n-serie) + ","
                                       + "DT:"
                                       + string(item-ean.nome-abrev) + ","
                                       + "SC:"
                                       + string(mac-address.ch-acesso) + ","
                                       + "NC:"
                                       + string(item-ean.nc) + ","
                                       + c-macs
                                       + "\0D\0A"
                           i-cont      = i-cont + 1.

                    {esp\cpp\escpp105c.i}
                    
                    IF i-cont = 4 
                    THEN DO:
                    
                        /* zera no fim */
                        ASSIGN i-cont   = 0
                               l-iniarq = NO.
                    
                        /* FINALIZANDO PARAMETROS DA IMPRESSORA */
                        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                        PUT "^XZ" SKIP.
                    
                        OUTPUT CLOSE.
                    
                    END.
                    
                    run pi-acompanhar in h-acomp (input 'Seq: ' + STRING(i-seq)).    
                END.
            END.
            IF l-iniarq = YES 
            THEN DO:
                /* FINALIZANDO PARAMETROS DA IMPRESSORA */
                PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                PUT "^XZ" SKIP.
                OUTPUT CLOSE.
            END.
        END.
        */
        
    END.
/*
    ASSIGN fi-seq-ini:SENSITIVE    IN FRAME fPage0 = NO
           fi-seq-ini:SCREEN-VALUE IN FRAME fPage0 = "0"
           fi-seq-fim:SENSITIVE    IN FRAME fPage0 = NO
           fi-seq-fim:SCREEN-VALUE IN FRAME fPage0 = "0". */

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

    IF int(fi-seq-ini:SCREEN-VALUE IN FRAME fPage0) = 0
    THEN DO:
       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT 17006,
                          INPUT "Informe a quantidade de etiquetas").
       
       RETURN "NOK":U.
    END.
    
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

