&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{esp/es0018.i}
{esp/utp/acesso-rpc.i}

DEF  VAR hproc AS HANDLE NO-UNDO.
DEF VAR hprog AS HANDLE NO-UNDO.
DEF VAR c-lista AS CHAR.

DEF VAR l-ok AS LOG.


DEF TEMP-TABLE tt-item
    FIELD cod-ean13 AS CHAR
    FIELD it-codigo AS CHAR
    FIELD desc-item AS CHAR FORMAT "x(60)"
    FIELD cod-unid-negoc AS CHAR
    FIELD des-unid-negoc AS CHAR.

DEF TEMP-TABLE tt-ean
    FIELD cod-ean13 AS CHAR
    FIELD it-codigo AS CHAR
    FIELD desc-item AS CHAR FORMAT "x(60)"
    FIELD cont      AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME brItem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-item

/* Definitions for BROWSE brItem                                        */
&Scoped-define FIELDS-IN-QUERY-brItem tt-item.cod-ean13 tt-item.it-codigo tt-item.desc-item tt-item.cod-unid-negoc tt-item.des-unid-negoc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItem   
&Scoped-define SELF-NAME brItem
&Scoped-define QUERY-STRING-brItem FOR EACH tt-item
&Scoped-define OPEN-QUERY-brItem OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
&Scoped-define TABLES-IN-QUERY-brItem tt-item
&Scoped-define FIRST-TABLE-IN-QUERY-brItem tt-item


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brItem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON btImprime 
     IMAGE-UP FILE "image\im-pri":U NO-FOCUS FLAT-BUTTON
     LABEL "Imprimir" 
     SIZE 7 BY 1.88 TOOLTIP "Gera Relat¢rio"
     FONT 4.

DEFINE BUTTON btLimpa 
     IMAGE-UP FILE "image/im-era.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Limpa" 
     SIZE 7 BY 1.88 TOOLTIP "Limpa registros do browse"
     FONT 4.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon/exit-au.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 2" 
     SIZE 7 BY 1.88 TOOLTIP "Clique aqui para sair do programa".

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "adeicon/asparm-u.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 8" 
     SIZE 7 BY 1.88 TOOLTIP "Gerar Excel".

DEFINE VARIABLE c-codigo-ean AS CHARACTER FORMAT "X(30)":U 
     LABEL "C¢digo EAN/Nr.Ser." 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 21.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brItem FOR 
      tt-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItem Dialog-Frame _FREEFORM
  QUERY brItem DISPLAY
      tt-item.cod-ean13  COLUMN-LABEL "EAN-13"    FORMAT "x(30)"
      tt-item.it-codigo  COLUMN-LABEL "Item"      FORMAT "x(16)"
      tt-item.desc-item  COLUMN-LABEL "Descricao"
      tt-item.cod-unid-negoc COLUMN-LABEL "Unid Negoc"  FORMAT "X(03)"
      tt-item.des-unid-negoc COLUMN-LABEL "Desc Unid Negoc" FORMAT "X(30)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 20.58
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.75 COL 51
     SPACE(48.85) SKIP(22.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "ES0939 - Consulta C¢digo EAN"
         DEFAULT-BUTTON Btn_OK.

DEFINE FRAME fMain
     BUTTON-2 AT ROW 1.5 COL 106
     btImprime AT ROW 1.5 COL 99 HELP
          "Gera Relat¢rio" WIDGET-ID 2
     c-codigo-ean AT ROW 2 COL 21 COLON-ALIGNED HELP
          "Informe o c¢digo EAN"
     brItem AT ROW 4 COL 5
     BUTTON-8 AT ROW 1.5 COL 92 WIDGET-ID 6
     btLimpa AT ROW 1.5 COL 80 HELP
          "Limpa registros do browse" WIDGET-ID 4
     RECT-15 AT ROW 3.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113 BY 24.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME fMain:FRAME = FRAME Dialog-Frame:HANDLE.

/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fMain:MOVE-BEFORE-TAB-ITEM (Btn_OK:HANDLE IN FRAME Dialog-Frame)
/* END-ASSIGN-TABS */.

ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME fMain
                                                                        */
/* BROWSE-TAB brItem c-codigo-ean fMain */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItem
/* Query rebuild information for BROWSE brItem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-item.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brItem */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* ES0939 - Consulta C¢digo EAN */
DO:
      RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
    hproc = ?.

   

    IF SESSION:PARAMETER = "NOC" THEN
    QUIT.
    APPLY "END-ERROR":U TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fMain Dialog-Frame
ON END-ERROR OF FRAME fMain
DO:
   
    RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
    hproc = ?.

    APPLY "CLOSE":U TO THIS-PROCEDURE.

    IF SESSION:PARAMETER = "NOC" THEN
    QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fMain
&Scoped-define SELF-NAME btImprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprime Dialog-Frame
ON CHOOSE OF btImprime IN FRAME fMain /* Imprimir */
DO:
    DEF VAR c-arquivo AS CHAR NO-UNDO.
    DEFINE VARIABLE i-total  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-quant  AS INTEGER     NO-UNDO.

    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY.
    IF LENGTH(c-arquivo) > 0 AND LOOKUP(SUBSTRING(c-arquivo, LENGTH(c-arquivo)), "/,\") = 0 THEN
        ASSIGN c-arquivo = c-arquivo + "\".
        
    ASSIGN c-arquivo = c-arquivo + STRING(TODAY,"999999") + STRING(TIME) + ".tmp".

    OUTPUT TO VALUE(c-arquivo) page-size 62 CONVERT TARGET SESSION:CHARSET.

    PUT UNFORMATTED 
        "Relacionamento EAN-13/Item" SKIP(2)
        "EAN-13        Item             Descricao                                          Quantidade" AT 01 SKIP
        "------------- ---------------- -------------------------------------------------- ----------" AT 01 SKIP.
         
    ASSIGN i-total = 0.
    
    FOR EACH tt-item NO-LOCK BREAK BY tt-item.cod-ean13:

        IF FIRST-OF(tt-item.cod-ean13) THEN
            ASSIGN i-quant = 0.

        ASSIGN i-quant = i-quant + 1
               i-total = i-total + 1.

        IF LAST-OF(tt-item.cod-ean13) THEN DO:
            PUT UNFORMATTED 
                 tt-item.cod-ean13 FORMAT "x(13)"      AT 01
                 tt-item.it-codigo FORMAT "x(16)"      AT 15
                 tt-item.desc-item FORMAT "x(50)"      AT 32
                 i-quant           FORMAT ">>,>>>,>>9" TO 92 SKIP.
            ASSIGN i-quant = 0.
        END.
    END.
    IF i-total <> 0 THEN
        PUT UNFORMATTED
            "----------"                 TO 92 SKIP
            "TOTAL"                      TO 81 
            i-total  FORMAT ">>,>>>,>>9" TO 92 SKIP.
    OUTPUT CLOSE.
    OS-COMMAND NO-WAIT notepad VALUE(c-arquivo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLimpa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimpa Dialog-Frame
ON CHOOSE OF btLimpa IN FRAME fMain /* Limpa */
DO:
    EMPTY TEMP-TABLE tt-item.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
    hproc = ?.

    APPLY "CLOSE":U TO THIS-PROCEDURE.

    IF SESSION:PARAMETER = "NOC" THEN
    QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fMain
&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 Dialog-Frame
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Button 2 */
DO:
   APPLY "choose" TO btn_ok IN FRAME dialog-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 Dialog-Frame
ON CHOOSE OF BUTTON-8 IN FRAME fMain /* Button 8 */
DO:
    DEF VAR c-arquivo AS CHAR NO-UNDO.
    DEFINE VARIABLE i-total  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-quant  AS INTEGER     NO-UNDO.

    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY.
    IF LENGTH(c-arquivo) > 0 AND LOOKUP(SUBSTRING(c-arquivo, LENGTH(c-arquivo)), "/,\") = 0 THEN
        ASSIGN c-arquivo = c-arquivo + "\".
        
    ASSIGN c-arquivo = c-arquivo + STRING(TODAY,"999999") + STRING(TIME) + ".csv".

    OUTPUT TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1".

    PUT UNFORMATTED 
        "Relacionamento EAN-13/Item"       SKIP
        "EAN-13;Item;Descriá∆o;Quantidade;Unid.Negocio" SKIP.
         
    ASSIGN i-total = 0.
    
    FOR EACH tt-item NO-LOCK BREAK BY tt-item.cod-ean13:

        IF FIRST-OF(tt-item.cod-ean13) THEN
            ASSIGN i-quant = 0.

        ASSIGN i-quant = i-quant + 1
               i-total = i-total + 1.

        IF LAST-OF(tt-item.cod-ean13) THEN DO:
            PUT UNFORMATTED 
                 tt-item.cod-ean13 FORMAT "x(13)"      ";"
                 tt-item.it-codigo FORMAT "x(16)"      ";"
                 tt-item.desc-item FORMAT "x(50)"      ";"
                 i-quant           FORMAT ">>,>>>,>>9" ";" 
                 tt-item.des-unid-negoc FORMAT "X(30)" SKIP.
            ASSIGN i-quant = 0.
        END.
    END.
    IF i-total <> 0 THEN
        PUT UNFORMATTED
            ";;;;"                       SKIP
            ";;TOTAL;"                    
            i-total  FORMAT ">>,>>>,>>9" SKIP.
    OUTPUT CLOSE.
    DOS SILENT START excel value(c-arquivo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-codigo-ean
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-codigo-ean Dialog-Frame
ON RETURN OF c-codigo-ean IN FRAME fMain /* C¢digo EAN/Nr.Ser. */
DO:
  RUN pi-monta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME brItem
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.


  RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
  IF RETURN-VALUE = "NOK" THEN DO:
    MESSAGE "Erro na conex∆o com o servidor RPC" SKIP
            "N∆o foi poss°vel conectar o servidor RPC. Entre em contato com o respons†vel em TI"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    QUIT.
  END.




  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
  HIDE FRAME fMain.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE Btn_OK 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
  DISPLAY c-codigo-ean 
      WITH FRAME fMain.
  ENABLE BUTTON-2 btImprime RECT-15 c-codigo-ean brItem BUTTON-8 btLimpa 
      WITH FRAME fMain.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta Dialog-Frame 
PROCEDURE pi-monta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR c-ean AS CHAR FORMAT "x(16)".
    DEF VAR pcod-ean13 AS CHAR FORMAT "x(13)".
    DEF VAR pit-codigo AS CHAR FORMAT "x(7)".
    DEF VAR pdesc-item AS CHAR FORMAT "x(60)".
    
    FOR EACH tt-ean:
        DELETE tt-ean.
    END.

    ASSIGN c-ean = c-codigo-ean:SCREEN-VALUE IN FRAME fmain.
              
    IF LENGTH(c-ean) = 16 THEN 
       ASSIGN c-ean = SUBSTRING(c-ean,4,13).

    RUN rpc/centraldeservicos.p PERSISTENT SET hprog ON SERVER hproc .   

    RUN checa-ean IN hprog  (INPUT c-ean, INPUT-OUTPUT TABLE tt-ean).
    
    DELETE OBJECT hprog.

    FIND LAST tt-ean NO-LOCK NO-ERROR.
    IF tt-ean.cont > 1 THEN DO:
        RUN menu-es/es0939a.w (INPUT TABLE tt-ean,
                               OUTPUT pcod-ean13,
                               OUTPUT pit-codigo,
                               OUTPUT pdesc-item).
        CREATE tt-item.
        ASSIGN tt-item.cod-ean13 = pcod-ean13
               tt-item.it-codigo = pit-codigo
               tt-item.desc-item = pdesc-item.

    END.
    ELSE DO:
        CREATE tt-item.
        ASSIGN tt-item.cod-ean13 = tt-ean.cod-ean13
               tt-item.it-codigo = tt-ean.it-codigo
               tt-item.desc-item = tt-ean.desc-item.
    END.

    RUN pi-unid-negoc (INPUT tt-item.it-codigo,
                       OUTPUT tt-item.cod-unid-negoc,
                       OUTPUT tt-item.des-unid-negoc).


    ASSIGN c-codigo-ean:SCREEN-VALUE IN FRAME fmain = "".

    {&OPEN-QUERY-{&BROWSE-NAME}}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-unid-negoc Dialog-Frame 
PROCEDURE pi-unid-negoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-it-codigo AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-unid-negoc AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-des-unid-negoc AS CHAR NO-UNDO.


    ASSIGN p-cod-unid-negoc = ""
           p-des-unid-negoc = "".

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:

        FOR FIRST unid-negoc NO-LOCK
            WHERE unid-negoc.cod-unid-negoc = ITEM.cod-unid-negoc:

            ASSIGN p-cod-unid-negoc = unid-negoc.cod-unid-negoc
                   p-des-unid-negoc = unid-negoc.des-unid-negoc.

        END.


    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

