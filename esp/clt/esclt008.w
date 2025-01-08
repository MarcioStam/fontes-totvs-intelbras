&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Global Shared Definitions ---                                        */

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO.

/* Include Definitions ---                                              */

{upc/btb910za-upc.i}
{esp/ShowMsg.i}
{esp/es0018.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE ttitem
    FIELD it-codigo LIKE item-ean.it-codigo
    FIELD desc-item AS CHARACTER FORMAT "x(60)":U
    INDEX item
        it-codigo.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lcompleto   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lvarios     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE vean        AS INTEGER     NO-UNDO.
DEFINE VARIABLE pit-codigo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caixa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-selec     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pallet    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-central   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-tipo-etiq AS CHARACTER   NO-UNDO.

/* Local Buffer Definitions ---                                         */

DEFINE BUFFER bvolume-nf        FOR volume-nf.
DEFINE BUFFER bbvolume-nf       FOR volume-nf.
DEFINE BUFFER b-volume-nf        FOR volume-nf.
DEFINE BUFFER bitem-mat         FOR item-mat.
DEFINE BUFFER bns-volume        FOR ns-volume.
DEFINE BUFFER bcaixa-ns-volume  FOR ns-volume.
DEFINE BUFFER bpallet-ns-volume FOR ns-volume.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE fi-serie AS CHARACTER   NO-UNDO.
DEFINE VARIABLE fi-embalagem AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-tipo-etiqueta AS INTEGER     NO-UNDO.   /* 1 - Volume / 2 - Item/Barra */

DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-volume

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES volume-nf ITEM

/* Definitions for BROWSE br-volume                                     */
&Scoped-define FIELDS-IN-QUERY-br-volume volume-nf.it-codigo f-desc-item(volume-nf.it-codigo) @ c-desc-item volume-nf.qtde volume-nf.qtde-col   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-volume   
&Scoped-define SELF-NAME br-volume
&Scoped-define QUERY-STRING-br-volume FOR EACH volume-nf WHERE volume-nf.cod-estabel = fi-cod-estabel AND                              volume-nf.serie       = fi-serie AND                              volume-nf.nr-nota-fis = fi-nr-nota-fis AND                              volume-nf.nr-volume = fi-nr-volume NO-LOCK, ~
               EACH ITEM WHERE ITEM.it-codigo = volume-nf.it-codigo NO-LOCK
&Scoped-define OPEN-QUERY-br-volume OPEN QUERY {&SELF-NAME}     FOR EACH volume-nf WHERE volume-nf.cod-estabel = fi-cod-estabel AND                              volume-nf.serie       = fi-serie AND                              volume-nf.nr-nota-fis = fi-nr-nota-fis AND                              volume-nf.nr-volume = fi-nr-volume NO-LOCK, ~
               EACH ITEM WHERE ITEM.it-codigo = volume-nf.it-codigo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-volume volume-nf ITEM
&Scoped-define FIRST-TABLE-IN-QUERY-br-volume volume-nf
&Scoped-define SECOND-TABLE-IN-QUERY-br-volume ITEM


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-volume}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-etiq-volume fi-ean13 br-volume btCancel ~
btExit rec-v RECT-1 
&Scoped-Define DISPLAYED-OBJECTS c-text1 fi-nr-volume fi-etiq-volume ~
fi-nr-nota-fis 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-cliente-rast wWindow 
FUNCTION f-cliente-rast RETURNS LOGICAL
  ( INPUT p-estab AS CHAR,
    INPUT p-serie  AS CHAR,
    INPUT p-nota AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-item-rastr wWindow 
FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-nota-export wWindow 
FUNCTION f-nota-export RETURNS LOGICAL
  ( INPUT p-estab AS CHAR,
    INPUT p-serie  AS CHAR,
    INPUT p-nota AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar(F5)" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE BUTTON btExit 
     LABEL "Sair(esc)" 
     SIZE-PIXELS 70 BY 24
     FONT 4.

DEFINE VARIABLE c-text1 AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE-PIXELS 91 BY 16
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-ean13 AS CHARACTER FORMAT "X(20)":U 
     LABEL "Item/Barra" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 193 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-etiq-volume AS CHARACTER FORMAT "X(44)":U 
     LABEL "Etiq.Volume" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 193 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fis AS CHARACTER FORMAT "X(16)" 
     LABEL "Nr Nota" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 88 BY 21
     FONT 4.

DEFINE VARIABLE fi-nr-volume AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Volume" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 53 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE rec-v
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE-PIXELS 42 BY 60.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 273 BY 60.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-volume FOR 
      volume-nf, 
      ITEM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-volume wWindow _FREEFORM
  QUERY br-volume DISPLAY
      volume-nf.it-codigo    COLUMN-LABEL "Item"
          f-desc-item(volume-nf.it-codigo) @ c-desc-item COLUMN-LABEL "Descriá∆o" FORMAT "X(20)"
 volume-nf.qtde         COLUMN-LABEL "Qtd."
 volume-nf.qtde-col     COLUMN-LABEL "Qtd.Col"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 46 BY 8
          &ELSE SIZE-PIXELS 320 BY 192 &ENDIF
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-text1 AT Y 269 X 4 NO-LABEL WIDGET-ID 32
     fi-nr-volume AT Y 36 X 199 COLON-ALIGNED WIDGET-ID 30
     fi-etiq-volume AT Y 12 X 59 COLON-ALIGNED WIDGET-ID 4
     fi-nr-nota-fis AT Y 36 X 59 COLON-ALIGNED WIDGET-ID 8
     fi-ean13 AT Y 12 X 59 COLON-ALIGNED WIDGET-ID 16
     br-volume AT Y 71 X 0 WIDGET-ID 200
     btCancel AT Y 264 X 180
     btExit AT Y 264 X 250 HELP
          "Sair"
     rec-v AT Y 6 X 273 WIDGET-ID 26
     RECT-1 AT Y 6 X 0 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "esclt008"
         HEIGHT-P           = 300
         WIDTH-P            = 320
         MAX-HEIGHT-P       = 702
         MAX-WIDTH-P        = 1366
         VIRTUAL-HEIGHT-P   = 702
         VIRTUAL-WIDTH-P    = 1366
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Size-to-Fit Custom                                        */
/* BROWSE-TAB br-volume fi-ean13 fpage0 */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN c-text1 IN FRAME fpage0
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       c-text1:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-ean13 IN FRAME fpage0
   NO-DISPLAY                                                           */
ASSIGN 
       fi-ean13:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN fi-nr-nota-fis IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-volume IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-volume
/* Query rebuild information for BROWSE br-volume
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH volume-nf WHERE volume-nf.cod-estabel = fi-cod-estabel AND
                             volume-nf.serie       = fi-serie AND
                             volume-nf.nr-nota-fis = fi-nr-nota-fis AND
                             volume-nf.nr-volume = fi-nr-volume NO-LOCK,
        EACH ITEM WHERE ITEM.it-codigo = volume-nf.it-codigo NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-volume */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* esclt008 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* esclt008 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-volume
&Scoped-define SELF-NAME br-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-volume wWindow
ON F5 OF br-volume IN FRAME fpage0
DO:

    APPLY "CHOOSE" TO btCancel.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-volume wWindow
ON ROW-DISPLAY OF br-volume IN FRAME fpage0
DO:
    IF volume-nf.qtde <> volume-nf.qtde-col OR
       volume-nf.qtde = 0 THEN
        ASSIGN volume-nf.it-codigo:FGCOLOR IN BROWSE br-volume = 12
               c-desc-item:FGCOLOR IN BROWSE br-volume = 12
               volume-nf.qtde:FGCOLOR IN BROWSE br-volume = 12
               volume-nf.qtde-col:FGCOLOR IN BROWSE br-volume = 12.
        
    ELSE
        ASSIGN volume-nf.it-codigo:FGCOLOR IN BROWSE br-volume = 9
               c-desc-item:FGCOLOR IN BROWSE br-volume = 9
               volume-nf.qtde:FGCOLOR IN BROWSE br-volume = 9     
               volume-nf.qtde-col:FGCOLOR IN BROWSE br-volume = 9.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar(F5) */
DO:
    assign fi-etiq-volume:VISIBLE IN FRAME {&FRAME-NAME} = YES
           fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = NO.

    RUN pi_limpa.
    
    APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON F5 OF btCancel IN FRAME fpage0 /* Cancelar(F5) */
DO:

    APPLY "CHOOSE" TO btCancel.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Sair(esc) */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON F5 OF btExit IN FRAME fpage0 /* Sair(esc) */
DO:

    APPLY "CHOOSE" TO btCancel.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ean13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ean13 wWindow
ON F4 OF fi-ean13 IN FRAME fpage0 /* Item/Barra */
DO:
    RUN piTrataItemManual.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ean13 wWindow
ON F5 OF fi-ean13 IN FRAME fpage0 /* Item/Barra */
DO:
    APPLY "CHOOSE" TO btCancel.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ean13 wWindow
ON RETURN OF fi-ean13 IN FRAME fpage0 /* Item/Barra */
DO:
    BLOCO:
    DO TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
        ASSIGN INPUT FRAME fPage0 fi-ean13.

        IF fi-ean13 = "":U THEN
            RETURN NO-APPLY.

        /**** Leitura do EAN13 ****/
        IF fi-ean13 BEGINS "789":U THEN DO:

            RUN pi-trata-ean13.

            IF RETURN-VALUE <> "OK" THEN
                UNDO BLOCO, LEAVE BLOCO.

        END.
        ELSE IF fi-ean13 BEGINS "ECO":U THEN DO:

            RUN pi-trata-caixa.

            IF RETURN-VALUE <> "OK" THEN
                UNDO BLOCO, LEAVE BLOCO.

        END.
        ELSE IF fi-ean13 BEGINS "EPA":U THEN DO:

            RUN pi-trata-pallet.

            IF RETURN-VALUE <> "OK" THEN
                UNDO BLOCO, LEAVE BLOCO.

        END.
        ELSE DO:

            RUN pi-trata-ns.

            IF RETURN-VALUE <> "OK" THEN
                UNDO BLOCO, LEAVE BLOCO.

        END.
    END.

    /* -------------------------------------------------------------- */

    {&OPEN-QUERY-br-volume}

    br-volume:DESELECT-ROWS().

    ASSIGN lcompleto = YES.

    FOR EACH bbvolume-nf NO-LOCK
        WHERE bbvolume-nf.cod-estab = bvolume-nf.cod-estabel
          AND bbvolume-nf.serie = bvolume-nf.serie
          AND bbvolume-nf.nr-nota-fis = bvolume-nf.nr-nota-fis
          AND bbvolume-nf.nr-volume = bvolume-nf.nr-volume:

        IF bbvolume-nf.qtde <> bbvolume-nf.qtde-col OR
           bbvolume-nf.qtde = 0                     THEN DO:

            ASSIGN lcompleto = NO.

            LEAVE.
        END.
    END.

    ASSIGN fi-ean13 = "":U.

    DISPLAY fi-ean13
        WITH FRAME fpage0.

    IF lcompleto THEN DO:
        BELL.

        ASSIGN fi-etiq-volume:VISIBLE IN FRAME fPage0 = YES
               fi-ean13:VISIBLE IN FRAME fpage0       = NO
               rec-v:FGCOLOR                            = 2  /* Verde */
               rec-v:BGCOLOR                            = 2.

        ASSIGN fi-etiq-volume = "":U.

        DISPLAY fi-etiq-volume
            WITH FRAME fPage0.

        APPLY "ENTRY":U TO fi-etiq-volume IN FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN rec-v:FGCOLOR = 12  /* Vermelho */
               rec-v:BGCOLOR = 12.

        APPLY "ENTRY":U TO fi-ean13 IN FRAME fPage0.
    END.

    RETURN NO-APPLY.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-etiq-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiq-volume wWindow
ON F5 OF fi-etiq-volume IN FRAME fpage0 /* Etiq.Volume */
DO:

    APPLY "CHOOSE" TO btCancel.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiq-volume wWindow
ON RETURN OF fi-etiq-volume IN FRAME fpage0 /* Etiq.Volume */
DO:
    
    IF INPUT fi-etiq-volume = "" THEN RETURN NO-APPLY.
    
    ASSIGN fi-etiq-volume = INPUT fi-etiq-volume.

    ASSIGN c-text1:SCREEN-VALUE = "".
    IF LENGTH(fi-etiq-volume) <> 21 AND LENGTH(fi-etiq-volume) <> 44 THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "C¢digo de Barras inv†lido. C¢digo de Barras coletado n∆o Ç correspondente ao volume/NF. Verifique.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.

        ASSIGN fi-etiq-volume = "".
        DISP fi-etiq-volume WITH FRAME fPage0.
        RUN pi_limpa.
        RETURN NO-APPLY.
    END.
    
    IF LENGTH(fi-etiq-volume) = 21 THEN DO:
        FIND FIRST bvolume-nf
            WHERE bvolume-nf.cod-estabel = SUBSTRING(fi-etiq-volume,1,3)
            AND   bvolume-nf.serie       = STRING(INT(SUBSTRING(fi-etiq-volume,4,3)))
            AND   bvolume-nf.nr-nota-fis = SUBSTRING(fi-etiq-volume,7,7)
            AND   bvolume-nf.nr-volume   = INT(SUBSTRING(fi-etiq-volume,14,4)) NO-LOCK NO-ERROR.        
    END.
    ELSE DO:
        FOR FIRST estabelec FIELDS(cod-estabel)
            WHERE estabelec.cgc = SUBSTRING(fi-etiq-volume,7,14) NO-LOCK,
            FIRST nota-fiscal FIELDS(cod-estabel serie nr-nota-fis)
            WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel
            AND   nota-fiscal.serie       = STRING(INTEGER(SUBSTRING(fi-etiq-volume,23,3)))
            AND   nota-fiscal.nr-nota-fis = SUBSTRING(fi-etiq-volume,28,7) NO-LOCK:
            
            ASSIGN c-text1:SCREEN-VALUE IN FRAME fPage0 = "F4 - Informar item".
                FIND FIRST bvolume-nf
                    WHERE bvolume-nf.cod-estabel = nota-fiscal.cod-estabel
                    AND   bvolume-nf.serie       = nota-fiscal.serie
                    AND   bvolume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                    AND   bvolume-nf.nr-volume   = 1 NO-LOCK NO-ERROR.                
            END.
    END.
    
    IF NOT AVAIL bvolume-nf THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Etiqueta inv†lida. Volume n∆o encontrado no sistema.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.

        ASSIGN fi-etiq-volume = "".
        DISP fi-etiq-volume WITH FRAME fPage0.
        RUN pi_limpa.
        RETURN NO-APPLY.
    END.

    ASSIGN fi-etiq-volume = ""
           fi-cod-estabel = bvolume-nf.cod-estabel
           fi-serie       = bvolume-nf.serie
           fi-nr-nota-fis = bvolume-nf.nr-nota-fis
           fi-nr-volume   = bvolume-nf.nr-volume
           lvarios        = bvolume-nf.varios-itens
           lcompleto      = YES.

    FIND FIRST embalag
        WHERE  embalag.sigla-emb = bvolume-nf.sigla-emb NO-LOCK NO-ERROR.
    
    IF  AVAIL  embalag THEN
        ASSIGN fi-embalagem = embalag.embalagem.
    ELSE
        ASSIGN fi-embalagem = "".

    FOR EACH bbvolume-nf 
        WHERE bbvolume-nf.cod-estab   = bvolume-nf.cod-estabel
        AND   bbvolume-nf.serie       = bvolume-nf.serie
        AND   bbvolume-nf.nr-nota-fis = bvolume-nf.nr-nota-fis
        AND   bbvolume-nf.nr-volume   = bvolume-nf.nr-volume NO-LOCK:

        IF bbvolume-nf.qtde <> bbvolume-nf.qtde-col OR bbvolume-nf.qtde = 0 THEN DO:
            ASSIGN lcompleto = NO.
            LEAVE.
        END.
    END.

    DISP fi-etiq-volume 
         fi-nr-nota-fis
         fi-nr-volume
         WITH FRAME fpage0.
    
    {&OPEN-QUERY-br-volume}

    br-volume:DESELECT-ROWS().

    IF lcompleto THEN DO:
        ASSIGN fi-etiq-volume = "".
        DISP fi-etiq-volume with frame fPage0.
        ASSIGN fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = NO
               rec-v:FGCOLOR = 2
               rec-v:BGCOLOR = 2.
    END.
    ELSE DO:
        ASSIGN fi-etiq-volume:VISIBLE IN FRAME {&FRAME-NAME} = NO
               fi-ean13:VISIBLE IN FRAME {&FRAME-NAME} = YES
               rec-v:FGCOLOR = 12
               rec-v:BGCOLOR = 12.
        APPLY "entry" TO fi-ean13 IN FRAME fPage0.
    END.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
    
  assign fi-ean13:VISIBLE = FALSE
         rec-v:FGCOLOR = 12
         rec-v:BGCOLOR = 12
         i-tipo-etiqueta = 1.   /*  */

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
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
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-caixa wWindow 
PROCEDURE pi-trata-caixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH bcaixa-ns-volume NO-LOCK
        WHERE bcaixa-ns-volume.volume-pai = fi-ean13:
    
        RUN pi-valida-rast (INPUT bcaixa-ns-volume.volume-filho).

        IF RETURN-VALUE <> "OK" THEN
            RETURN "NOK":u.

    END.

    /**/

    FIND FIRST bcaixa-ns-volume 
         WHERE bcaixa-ns-volume.volume-filho = fi-ean13 NO-LOCK NO-ERROR.
    
     IF AVAIL bcaixa-ns-volume THEN DO:
    
         {&WINDOW-NAME}:SENSITIVE = FALSE.
    
         ASSIGN c-selec = "".
    
         RUN esp/clt/esclt008b.w (OUTPUT c-selec).
    
         {&WINDOW-NAME}:SENSITIVE = TRUE.
    
         IF c-selec = "" THEN DO:
             
             APPLY "entry" TO fi-ean13 IN FRAME {&FRAME-NAME}.
    
             RETURN "NOK":U.
    
         END.
    
         IF c-selec = "uma" THEN DO:
         
             FOR EACH bcaixa-ns-volume 
                 WHERE bcaixa-ns-volume.volume-filho = fi-ean13:
    
                 DELETE bcaixa-ns-volume.
    
             END.
    
         END.
    
         IF c-selec = "todas" THEN DO:
    
             ASSIGN c-pallet = "".
         
             FOR EACH bcaixa-ns-volume 
                 WHERE bcaixa-ns-volume.volume-filho = fi-ean13:
    
                 ASSIGN c-pallet = bcaixa-ns-volume.volume-pai.
    
             END.
    
             IF c-pallet <> "" THEN DO:
    
                 FOR EACH bcaixa-ns-volume 
                     WHERE bcaixa-ns-volume.volume-pai = c-pallet:
    
                     DELETE bcaixa-ns-volume.
    
                 END.
    
             END.
    
         END.
    
     END.
    
    
     FIND FIRST bcaixa-ns-volume 
        WHERE bcaixa-ns-volume.volume-pai = fi-ean13 NO-LOCK NO-ERROR.
    
      IF NOT AVAIL bcaixa-ns-volume THEN DO:
    
          {&WINDOW-NAME}:SENSITIVE = FALSE.
    
          RUN esp/clt/esclt006.w (INPUT "Etiqueta de caixa n∆o relacionada a produto algum, ou a pallet algum.",
                                    INPUT NO).
    
          {&WINDOW-NAME}:SENSITIVE = TRUE.
    
          APPLY "entry" TO fi-ean13 IN FRAME {&FRAME-NAME}.
    
          RETURN "NOK":U.
    
      END.
    
    
    FOR EACH bcaixa-ns-volume NO-LOCK
        WHERE bcaixa-ns-volume.volume-pai = fi-ean13:
    
        RUN pi_leitura_num_serie (INPUT bcaixa-ns-volume.volume-filho).
    
        IF RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN fi-ean13 = "":U.
    
            DISPLAY fi-ean13
                WITH FRAME fPage0.
    
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-ean13 wWindow 
PROCEDURE pi-trata-ean13 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN vean       = 0
           pit-codigo = "":U.
    
    FOR EACH ttitem:
        DELETE ttitem.
    END.
    
    FOR EACH bitem-mat NO-LOCK
        WHERE bitem-mat.cod-ean = fi-ean13:
    
        FIND FIRST item
            WHERE item.it-codigo = bitem-mat.it-codigo NO-LOCK NO-ERROR.
    
        CREATE ttitem.
        ASSIGN ttitem.it-codigo = item.it-codigo
               ttitem.desc-item = item.desc-item
               vean             = vean + 1.
    END.
    
    IF vean = 0 THEN DO:
    
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "Item n∆o cadastrado. C¢digo EAN13 do item n∆o cadastrado. Procurar Engenharia Industrial.",
                                INPUT NO).
    
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    
        ASSIGN fi-ean13 = "":U.
    
        DISPLAY fi-ean13
            WITH FRAME fPage0.
    
        RETURN "NOK":U.
    END.
    
    IF vean > 1 THEN DO:
    
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "Atená∆o, EAN vinculado a mais de um produto. Verificar situaá∆o junto ao L°der de Operaá‰es Logistica.",
                                INPUT NO).
    
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    
        ASSIGN fi-ean13 = "":U.
    
        DISPLAY fi-ean13
            WITH FRAME fPage0.
    
        RETURN "NOK":U.

    END.
    
    IF vean = 1 THEN
        FIND FIRST item-mat
            WHERE item-mat.cod-ean = fi-ean13 NO-LOCK NO-ERROR.
    
    IF f-nota-export (fi-cod-estabel,
                      fi-serie,       
                      fi-nr-nota-fis) THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.

        RUN esp/clt/esclt006.w (INPUT "Nota de exportaá∆o. Itens com leitura obrigat¢ria do n£mero de sÇrie.",
                                INPUT NO).

        {&WINDOW-NAME}:SENSITIVE = TRUE.

        ASSIGN fi-ean13 = "":U.

        DISPLAY fi-ean13
            WITH FRAME fPage0.

        RETURN "NOK":U.

    END.

    IF f-cliente-rast (fi-cod-estabel,
                       fi-serie,       
                       fi-nr-nota-fis) THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.

        RUN esp/clt/esclt006.w (INPUT "Cliente com Rastreabilidade cadastrado. Leitura obrigat¢ria de numero de sÇrie",
                                INPUT NO).

        {&WINDOW-NAME}:SENSITIVE = TRUE.

        ASSIGN fi-ean13 = "":U.

        DISPLAY fi-ean13
            WITH FRAME fPage0.

        RETURN "NOK":U.

    END.

    IF f-item-rastr(item-mat.it-codigo) THEN DO:
        
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "Item com rastreabilidade. Ler o n£mero de sÇrie para este item.",
                                INPUT NO).
    
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    
        ASSIGN fi-ean13 = "":U.
    
        DISPLAY fi-ean13
            WITH FRAME fPage0.
    
        RETURN "NOK":U.

    END.
    
    FIND FIRST volume-nf
        WHERE volume-nf.cod-estabel = fi-cod-estabel
          AND volume-nf.serie       = fi-serie
          AND volume-nf.nr-nota-fis = fi-nr-nota-fis
          AND volume-nf.nr-volume   = fi-nr-volume
          AND volume-nf.it-codigo   = item-mat.it-codigo EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAILABLE volume-nf THEN DO:

        /* Tratamento para centrais configuradas */
        l-central = NO.
        FOR FIRST b-volume-nf NO-LOCK
            WHERE b-volume-nf.cod-estabel = fi-cod-estabel
              AND b-volume-nf.serie       = fi-serie
              AND b-volume-nf.nr-nota-fis = fi-nr-nota-fis
              AND b-volume-nf.nr-volume   = fi-nr-volume,
            EACH item-uni-estab
                WHERE item-uni-estab.cod-estabel = fi-cod-estabel
                  AND item-uni-estab.it-codigo   = b-volume-nf.it-codigo
                  AND item-uni-estab.nr-linha    = 20:
    
            FIND FIRST estrutura 
                WHERE estrutura.it-codigo = item-uni-estab.it-codigo
                  AND estrutura.data-inicio <= TODAY
                  AND estrutura.data-termino > TODAY NO-LOCK NO-ERROR.
    
            IF AVAIL estrutura THEN DO:
                IF estrutura.es-codigo <> item-mat.it-codigo THEN DO:
    
                    {&WINDOW-NAME}:SENSITIVE = FALSE.
    
                    RUN esp/clt/esclt006.w (INPUT "Item n∆o pode ser coletado. Item n∆o pertence a este Volume.",
                                            INPUT NO).
            
                    {&WINDOW-NAME}:SENSITIVE = TRUE.
            
                    ASSIGN fi-ean13 = "":U.
            
                    DISPLAY fi-ean13
                        WITH FRAME fPage0.
            
                    RETURN "NOK":U.

                END.
                ELSE DO:
                    l-central = YES.
                    FIND FIRST volume-nf
                        WHERE volume-nf.cod-estabel = fi-cod-estabel
                          AND volume-nf.serie       = fi-serie
                          AND volume-nf.nr-nota-fis = fi-nr-nota-fis
                          AND volume-nf.nr-volume   = fi-nr-volume
                          AND volume-nf.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK NO-ERROR.
                END.
            END.
        END.
        IF l-central = NO THEN DO:
        
            {&WINDOW-NAME}:SENSITIVE = FALSE.
    
            RUN esp/clt/esclt006.w (INPUT "Item n∆o pode ser coletado. Item n∆o pertence a este Volume.",
                                    INPUT NO).
    
            {&WINDOW-NAME}:SENSITIVE = TRUE.
    
            ASSIGN fi-ean13 = "":U.
    
            DISPLAY fi-ean13
                WITH FRAME fPage0.
    
            RETURN "NOK":U.

        END.
    END.
    
    IF volume-nf.qtde-col >= volume-nf.qtde THEN DO:
    
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "Item n∆o pode ser coletado. Quantidade do item j† esta completa para este Volume.",
                                INPUT NO).
    
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    
        ASSIGN fi-ean13 = "":U.
    
        DISPLAY fi-ean13
            WITH FRAME fPage0.
    
        RETURN "NOK":U.

    END.
    
    IF lvarios THEN
        ASSIGN volume-nf.qtde-col = volume-nf.qtde-col + 1
               volume-nf.tp-col   = 1.
    ELSE DO:
        FIND FIRST item-caixa
            WHERE item-caixa.sigla-emb = volume-nf.sigla-emb
              AND item-caixa.it-codigo = volume-nf.it-codigo NO-LOCK NO-ERROR.
    
        IF AVAILABLE item-caixa                AND
           item-caixa.qt-item = volume-nf.qtde THEN
            ASSIGN volume-nf.qtde-col = volume-nf.qtde
                   volume-nf.tp-col   = 2.
        ELSE
            ASSIGN volume-nf.qtde-col = volume-nf.qtde-col + 1
                   volume-nf.tp-col   = 1.
    END.
    
    ASSIGN volume-nf.usuario-col = v_cod_usuar_corren
           volume-nf.data-col    = TODAY
           volume-nf.char-1      = STRING(TIME,"hh:mm:ss").

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-ns wWindow 
PROCEDURE pi-trata-ns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-valida-rast (INPUT fi-ean13).

    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK":u.
    
    /**/
    
    FIND FIRST ns-volume
        WHERE ns-volume.volume-filho = fi-ean13 NO-ERROR.
    
    IF AVAIL ns-volume AND ns-volume.volume-pai <> "ECO-INDEFINIDA" THEN DO:
        
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "Produto n∆o pode ser relacionado a NF: produto relacionado a Caixa. Deseja Desvincular?",
                                INPUT YES).
    
        ASSIGN l-ok = RETURN-VALUE = "YES".
    
        {&WINDOW-NAME}:SENSITIVE = TRUE. 
    
        IF NOT l-ok THEN DO:
            APPLY "entry" TO fi-ean13 IN FRAME {&FRAME-NAME}.
            RETURN "NOK":U.
        END.
       
        ASSIGN c-caixa = ns-volume.volume-pai.
    
        FOR EACH ns-volume WHERE ns-volume.volume-pai = c-caixa:
            ASSIGN ns-volume.volume-pai = "ECO-INDEFINIDA".
        END.
    
        FOR EACH ns-volume WHERE ns-volume.volume-filho = c-caixa:
            DELETE ns-volume.
        END.
    
    END.
    
    
    /**** Leitura do N£m. de SÇrie ****/
    RUN pi_leitura_num_serie (INPUT fi-ean13).
    
    IF RETURN-VALUE = "NOK":U THEN DO:
        ASSIGN fi-ean13 = "":U.
    
        DISPLAY fi-ean13
            WITH FRAME fPage0.
    
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-pallet wWindow 
PROCEDURE pi-trata-pallet :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT CAN-FIND(FIRST bpallet-ns-volume
                    WHERE bpallet-ns-volume.volume-pai = fi-ean13) THEN DO:
    
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "Etiqueta de pallet n∆o relacionada a caixa alguma.",
                                INPUT NO).
    
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    
        APPLY "entry" TO fi-ean13 IN FRAME {&FRAME-NAME}.
        
        RETURN "NOK":U.
    
    END.
    
    /**/

    FOR EACH bpallet-ns-volume NO-LOCK
        WHERE bpallet-ns-volume.volume-pai = fi-ean13,
        EACH bcaixa-ns-volume NO-LOCK
        WHERE bcaixa-ns-volume.volume-pai = bpallet-ns-volume.volume-filho:

        RUN pi-valida-rast (INPUT bcaixa-ns-volume.volume-filho).

        IF RETURN-VALUE <> "OK" THEN
            RETURN "NOK":u.

    END.
    
    /**/
    
    FOR EACH bpallet-ns-volume NO-LOCK
        WHERE bpallet-ns-volume.volume-pai = fi-ean13,
        EACH bcaixa-ns-volume NO-LOCK
        WHERE bcaixa-ns-volume.volume-pai = bpallet-ns-volume.volume-filho:
    
        RUN pi_leitura_num_serie (INPUT bcaixa-ns-volume.volume-filho).
    
        IF RETURN-VALUE = "NOK":U THEN DO:
            ASSIGN fi-ean13 = "":U.
        
            DISPLAY fi-ean13 WITH FRAME fPage0.
        
            RETURN "NOK":U.
        END.
    END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-rast wWindow 
PROCEDURE pi-valida-rast :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-ns AS CHAR NO-UNDO.


    FOR FIRST num-serie-rast NO-LOCK
        WHERE num-serie-rast.cod-estabel = fi-cod-estabel
        AND   num-serie-rast.serie       = fi-serie
        AND   num-serie-rast.nr-nota-fis = fi-nr-nota-fis
        AND   num-serie-rast.n-serie     = p-ns:
    END.
    
    IF AVAIL num-serie-rast THEN DO:
    
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "N£mero de SÇrie j† vinculado ao volume: ":U + string(num-serie-rast.nr-volume) + " desta Nota Fiscal." + "Utilize outro N£mero de SÇrie.",
                                INPUT NO).
    
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    
        ASSIGN fi-ean13 = "":U.
    
        DISPLAY fi-ean13
            WITH FRAME fPage0.
    
        RETURN "NOK":U.
    
    END.
    
    /**/
    
    FOR EACH num-serie-rast NO-LOCK
       WHERE num-serie-rast.n-serie      = p-ns           AND
            (num-serie-rast.cod-estabel <> fi-cod-estabel OR
             num-serie-rast.serie       <> fi-serie       OR
             num-serie-rast.nr-nota-fis <> fi-nr-nota-fis),
       FIRST nota-fiscal NO-LOCK
       WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel
       AND   nota-fiscal.serie       = num-serie-rast.serie      
       AND   nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis
       AND   nota-fiscal.dt-cancela  = ?
       AND   nota-fiscal.dt-saida    = ?:
    
        {&WINDOW-NAME}:SENSITIVE = FALSE.
    
        RUN esp/clt/esclt006.w (INPUT "N£mero de SÇrie j† vinculado a outra Nota Fiscal: ":U + STRING(nota-fiscal.nr-nota-fis) + " Volume: " + string(num-serie-rast.nr-volume) + ".":U + CHR(10) + "Utilize outro N£mero de SÇrie.":U,
                                INPUT NO).
    
        {&WINDOW-NAME}:SENSITIVE = TRUE.
    
        ASSIGN fi-ean13 = "":U.
    
        DISPLAY fi-ean13
            WITH FRAME fPage0.
    
        RETURN "NOK":U.
    
    END. /* FOR FIRST num-serie-rast NO-LOCK */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piChamaItemManual wWindow 
PROCEDURE piChamaItemManual :
/*------------------------------------------------------------------------------
  Purpose: Chama dialog para informar item e quantidade    
  Notes:   Carlos Daniel - 12/04/2016
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-item AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p-qtde AS INTEGER   NO-UNDO.

DEFINE VARIABLE c-item       AS CHARACTER LABEL "Item"       FORMAT "X(16)" NO-UNDO.
DEFINE VARIABLE d-quantidade AS INTEGER   LABEL "Quantidade"                NO-UNDO.

DEFINE BUTTON btItemCancel AUTO-END-KEY
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE BUTTON btItemOK 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8.

DEFINE RECTANGLE rtItemButton
     EDGE-PIXELS 2 GRAPHIC-EDGE 
     SIZE 30 BY 1.42
     BGCOLOR 7.

DEFINE FRAME fItemRecord
    c-item       AT ROW 1.21 COL 7.92 COLON-ALIGNED VIEW-AS FILL-IN
    d-quantidade AT ROW 2.21 COL 7.92 COLON-ALIGNED VIEW-AS FILL-IN 

    btItemOK      AT ROW 3.63 COL 2.14
    btItemCancel  AT ROW 3.63 COL 13
    rtItemButton  AT ROW 3.38 COL 1
    SPACE(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
         THREE-D SCROLLABLE TITLE "Item" FONT 1
         DEFAULT-BUTTON btItemOK CANCEL-BUTTON btItemCancel.

/*tech1139 - FO 1338.917 - 10/07/2006  */
RUN utp/ut-trfrrp.p (input Frame fItemRecord:Handle).
{utp/ut-liter.i "Selecionar Item"}
ASSIGN FRAME fItemRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

ON "CHOOSE":U OF btItemOK IN FRAME fItemRecord DO:
    ASSIGN c-item
           d-quantidade.

    ASSIGN p-item = c-item
           p-qtde = d-quantidade.
    
    APPLY "GO":U TO FRAME fItemRecord.
END.

ENABLE c-item d-quantidade btItemCancel btItemOK
    WITH FRAME fItemRecord. 

WAIT-FOR "GO":U OF FRAME fItemRecord.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTrataItemManual wWindow 
PROCEDURE piTrataItemManual :
/*------------------------------------------------------------------------------
  Purpose: Tratamento para item informado manualmente     
  Notes:   Carlos Daniel - 12/04/2016
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-item   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-qtde   AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-acesso AS LOGICAL   NO-UNDO.

RUN esp/es0018p.p (INPUT "esclt008",
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

FOR EACH usuar_grp_usuar
    WHERE usuar_grp_usuar.cod_usuario = c-seg-usuario NO-LOCK:

    IF AVAIL tt-prog-ponto THEN DO:
        IF LOOKUP(usuar_grp_usuar.cod_grp_usuar,tt-prog-ponto.conteudo) > 0 THEN DO:
            ASSIGN l-acesso = YES.
            LEAVE.
        END.
    END.
END.

IF NOT l-acesso THEN
    RETURN.

/*RUN piChamaItemManual(OUTPUT c-item,
                      OUTPUT i-qtde).*/

RUN esp/clt/esclt008a.w (OUTPUT c-item,
                         OUTPUT i-qtde).

IF c-item = "CANCELAR" THEN DO:
    ASSIGN c-item = "".
    RETURN "NOK".
END.

IF c-item = "" OR
    NOT CAN-FIND(FIRST item
                 WHERE item.it-codigo = c-item) THEN DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Item inv†lido. Favor informar um item v†lido.",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = TRUE.
    RETURN "NOK".
END.

IF i-qtde <= 0 THEN DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Quantidade inv†lida. Favor informar uma quantidade v†lida.",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = TRUE.
    RETURN "NOK".
END.

IF f-nota-export (fi-cod-estabel,
                  fi-serie,       
                  fi-nr-nota-fis) THEN DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Nota de exportaá∆o. Itens com leitura obrigat¢ria do n£mero de sÇrie.",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = TRUE.
    RETURN "NOK":U.
END.

IF f-cliente-rast (fi-cod-estabel,
                   fi-serie,       
                   fi-nr-nota-fis) THEN DO:
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Cliente com Rastreabilidade cadastrado. Leitura obrigat¢ria de numero de sÇrie",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = TRUE.
    RETURN "NOK":U.
END.

IF f-item-rastr(c-item) THEN DO:    
    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/clt/esclt006.w (INPUT "Item com rastreabilidade. Ler o n£mero de sÇrie para este item.",
                            INPUT NO).
    {&WINDOW-NAME}:SENSITIVE = TRUE.
    RETURN "NOK":U.
END.

FOR FIRST volume-nf
    WHERE volume-nf.cod-estabel = fi-cod-estabel
    AND   volume-nf.serie       = fi-serie
    AND   volume-nf.nr-nota-fis = fi-nr-nota-fis
    AND   volume-nf.nr-volume   = fi-nr-volume
    AND   volume-nf.it-codigo   = c-item EXCLUSIVE-LOCK:

    IF volume-nf.qtde-col + i-qtde > volume-nf.qtde THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Item n∆o pode ser coletado. Quantidade do item n∆o confere com a quantidade do Volume.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN "NOK":U.
    END.

    ASSIGN volume-nf.qtde-col    = volume-nf.qtde-col + i-qtde
           volume-nf.tp-col      = 1
           volume-nf.usuario-col = v_cod_usuar_corren
           volume-nf.data-col    = TODAY
           volume-nf.char-1      = STRING(TIME,"hh:mm:ss").
END.

IF NOT AVAILABLE volume-nf THEN DO:
    /* Tratamento para centrais configuradas */
    l-central = NO.
    FOR FIRST b-volume-nf NO-LOCK
        WHERE b-volume-nf.cod-estabel = fi-cod-estabel
          AND b-volume-nf.serie       = fi-serie
          AND b-volume-nf.nr-nota-fis = fi-nr-nota-fis
          AND b-volume-nf.nr-volume   = fi-nr-volume,
        EACH item-uni-estab
            WHERE item-uni-estab.cod-estabel = fi-cod-estabel
              AND item-uni-estab.it-codigo   = b-volume-nf.it-codigo
              AND item-uni-estab.nr-linha    = 20:

        FIND FIRST estrutura 
            WHERE estrutura.it-codigo = item-uni-estab.it-codigo
              AND estrutura.data-inicio <= TODAY
              AND estrutura.data-termino > TODAY NO-LOCK NO-ERROR.

        IF AVAIL estrutura THEN DO:
            IF estrutura.es-codigo <> num-serie.it-codigo THEN DO:
                {&WINDOW-NAME}:SENSITIVE = FALSE.
                RUN esp/clt/esclt006.w (INPUT "Item n∆o pode ser coletado. Item n∆o pertence a este Volume.",
                                        INPUT NO).
                {&WINDOW-NAME}:SENSITIVE = TRUE.
                ASSIGN fi-ean13 = "":U.
                DISPLAY fi-ean13 WITH FRAME fPage0.
                RETURN "NOK":U.
            END.
            ELSE DO:
                ASSIGN l-central = YES.
                FIND FIRST volume-nf
                    WHERE volume-nf.cod-estabel = fi-cod-estabel
                      AND volume-nf.serie       = fi-serie
                      AND volume-nf.nr-nota-fis = fi-nr-nota-fis
                      AND volume-nf.nr-volume   = fi-nr-volume
                      AND volume-nf.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK NO-ERROR.
            END.
        END.
    END.

    IF l-central = NO THEN DO:
        {&WINDOW-NAME}:SENSITIVE = FALSE.
        RUN esp/clt/esclt006.w (INPUT "Item n∆o pode ser coletado. Item n∆o pertence a este Volume.",
                                INPUT NO).
        {&WINDOW-NAME}:SENSITIVE = TRUE.
        RETURN "NOK":U.
    END.
END.

{&OPEN-QUERY-br-volume}
ASSIGN lcompleto = YES.

FOR EACH bbvolume-nf
    WHERE bbvolume-nf.cod-estab   = fi-cod-estabel
    AND   bbvolume-nf.serie       = fi-serie
    AND   bbvolume-nf.nr-nota-fis = fi-nr-nota-fis
    AND   bbvolume-nf.nr-volume   = fi-nr-volume NO-LOCK:

    IF bbvolume-nf.qtde <> bbvolume-nf.qtde-col OR bbvolume-nf.qtde = 0 THEN DO:
        ASSIGN lcompleto = NO.
        LEAVE.
    END.
END.

ASSIGN fi-ean13 = "":U.

DISPLAY fi-ean13 WITH FRAME fpage0.

IF lcompleto THEN DO:
    BELL.
    ASSIGN fi-etiq-volume:VISIBLE IN FRAME fPage0 = YES
           fi-ean13:VISIBLE IN FRAME fpage0       = NO
           rec-v:FGCOLOR                            = 2  /* Verde */
           rec-v:BGCOLOR                            = 2.

    ASSIGN fi-etiq-volume = "":U.

    DISPLAY fi-etiq-volume WITH FRAME fPage0.
    APPLY "ENTRY":U TO fi-etiq-volume IN FRAME fPage0.
END.
ELSE DO:
    ASSIGN rec-v:FGCOLOR = 12  /* Vermelho */
           rec-v:BGCOLOR = 12.

    APPLY "ENTRY":U TO fi-ean13 IN FRAME fPage0.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_leitura_num_serie wWindow 
PROCEDURE pi_leitura_num_serie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  INPUT p-etiqueta-nro-serie AS CHARACTER
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-etiqueta-nro-serie AS CHARACTER   NO-UNDO.


    FOR FIRST num-serie NO-LOCK
        WHERE num-serie.n-serie = p-etiqueta-nro-serie:
    END.

    IF NOT AVAILABLE num-serie THEN DO:
        
        {&WINDOW-NAME}:SENSITIVE = FALSE.

        RUN esp/clt/esclt006.w (INPUT "N£m. de SÇrie n∆o cadastrado." + "N£m. de SÇrie ~"":U + p-etiqueta-nro-serie + "~" n∆o cadastrado.",
                                INPUT NO).

        {&WINDOW-NAME}:SENSITIVE = TRUE.

        RETURN "NOK":U.
    END.

    IF  NOT f-item-rastr   (num-serie.it-codigo)
    AND NOT f-nota-export  (fi-cod-estabel, fi-serie, fi-nr-nota-fis)
    AND NOT f-cliente-rast (fi-cod-estabel, fi-serie, fi-nr-nota-fis)
    THEN DO:

        {&WINDOW-NAME}:SENSITIVE = FALSE.

        RUN esp/clt/esclt006.w (INPUT "Item n∆o Ç de rastreabilidade." + "Ler o C¢d. EAN13 para este item (Nr. SÇrie: ":U + p-etiqueta-nro-serie + "). C¢d que comeáa com ~"789~".",
                                INPUT NO).

        {&WINDOW-NAME}:SENSITIVE = TRUE.

        RETURN "NOK":U.
    END.
    
    FIND FIRST volume-nf
        WHERE volume-nf.cod-estabel = fi-cod-estabel
          AND volume-nf.serie       = fi-serie
          AND volume-nf.nr-nota-fis = fi-nr-nota-fis
          AND volume-nf.nr-volume   = fi-nr-volume
          AND volume-nf.it-codigo   = num-serie.it-codigo EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE volume-nf THEN DO:
        /* Tratamento para centrais configuradas */
        l-central = NO.
        FOR FIRST b-volume-nf NO-LOCK
            WHERE b-volume-nf.cod-estabel = fi-cod-estabel
              AND b-volume-nf.serie       = fi-serie
              AND b-volume-nf.nr-nota-fis = fi-nr-nota-fis
              AND b-volume-nf.nr-volume   = fi-nr-volume,
            EACH item-uni-estab
                WHERE item-uni-estab.cod-estabel = fi-cod-estabel
                  AND item-uni-estab.it-codigo   = b-volume-nf.it-codigo
                  AND item-uni-estab.nr-linha    = 20:

            FIND FIRST estrutura 
                WHERE estrutura.it-codigo = item-uni-estab.it-codigo
                  AND estrutura.data-inicio <= TODAY
                  AND estrutura.data-termino > TODAY NO-LOCK NO-ERROR.

            IF AVAIL estrutura THEN DO:
                IF estrutura.es-codigo <> num-serie.it-codigo THEN DO:

                    {&WINDOW-NAME}:SENSITIVE = FALSE.
        
                    RUN esp/clt/esclt006.w (INPUT "Item n∆o pode ser coletado. Item n∆o pertence a este Volume.",
                                            INPUT NO).
            
                    {&WINDOW-NAME}:SENSITIVE = TRUE.
            
                    ASSIGN fi-ean13 = "":U.
            
                    DISPLAY fi-ean13
                        WITH FRAME fPage0.
            
                    RETURN "NOK":U.
                END.
                ELSE DO:
                    l-central = YES.
                    FIND FIRST volume-nf
                        WHERE volume-nf.cod-estabel = fi-cod-estabel
                          AND volume-nf.serie       = fi-serie
                          AND volume-nf.nr-nota-fis = fi-nr-nota-fis
                          AND volume-nf.nr-volume   = fi-nr-volume
                          AND volume-nf.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK NO-ERROR.
                END.
            END.
        END.
        IF l-central = NO THEN DO:
            {&WINDOW-NAME}:SENSITIVE = FALSE.
    
            RUN esp/clt/esclt006.w (INPUT "Item n∆o pode ser coletado." + "Item (Nr. SÇrie: ":U + p-etiqueta-nro-serie + ") n∆o pertence a este Volume.",
                                    INPUT NO).
    
            {&WINDOW-NAME}:SENSITIVE = TRUE.
    
            RETURN "NOK":U.
        END.
    END.

    IF volume-nf.qtde-col >= volume-nf.qtde THEN DO:

        {&WINDOW-NAME}:SENSITIVE = FALSE.

        RUN esp/clt/esclt006.w (INPUT "Item n∆o pode ser coletado" + "Quantidade do item (Nr. SÇrie: ":U + p-etiqueta-nro-serie + ") n∆o confere com a quantidade do Volume.",
                                INPUT NO).

        {&WINDOW-NAME}:SENSITIVE = TRUE.

        RETURN "NOK":U.
    END.

    ASSIGN volume-nf.qtde-col    = volume-nf.qtde-col + 1
           volume-nf.tp-col      = 1
           volume-nf.usuario-col = v_cod_usuar_corren
           volume-nf.data-col    = TODAY
           volume-nf.char-1      = STRING(TIME,"hh:mm:ss").

    FOR FIRST num-serie-rast NO-LOCK
        WHERE num-serie-rast.cod-estabel = fi-cod-estabel
        AND   num-serie-rast.serie = fi-serie
        AND   num-serie-rast.nr-nota-fis = fi-nr-nota-fis
        AND   num-serie-rast.n-serie = p-etiqueta-nro-serie:
    END.

    IF NOT AVAIL num-serie-rast THEN DO:

        CREATE num-serie-rast.
        ASSIGN num-serie-rast.cod-estabel   = fi-cod-estabel    
               num-serie-rast.serie         = fi-serie                
               num-serie-rast.nr-nota-fis   = fi-nr-nota-fis    
               num-serie-rast.nr-volume     = fi-nr-volume        
               num-serie-rast.n-serie       = p-etiqueta-nro-serie
               num-serie-rast.it-codigo     = num-serie.it-codigo
               num-serie-rast.data          = NOW
               num-serie-rast.usuario       = c-seg-usuario.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_limpa wWindow 
PROCEDURE pi_limpa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fi-cod-estabel = ""
           fi-serie       = ""
           fi-nr-nota-fis = ""
           fi-nr-volume   = 0
           c-text1        = ""
           rec-v:FGCOLOR IN FRAME fpage0 = 12
           rec-v:BGCOLOR IN FRAME fpage0 = 12.

    DISP /*fi-cod-estabel  
         fi-serie       */
         fi-nr-volume
         fi-nr-nota-fis
         c-text1 WITH FRAME fpage0.

    {&OPEN-QUERY-br-volume}

    APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-cliente-rast wWindow 
FUNCTION f-cliente-rast RETURNS LOGICAL
  ( INPUT p-estab AS CHAR,
    INPUT p-serie  AS CHAR,
    INPUT p-nota AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = p-estab
          AND nota-fiscal.serie       = p-serie
          AND nota-fiscal.nr-nota-fis = p-nota NO-ERROR.
    IF  AVAIL nota-fiscal THEN DO:
    
        FOR FIRST cliente-rast  NO-LOCK 
            WHERE cliente-rast.cod-emitente  = nota-fiscal.cod-emitente
            AND   cliente-rast.data-ini  <= TODAY
            AND   cliente-rast.data-fim   > TODAY:
    
            RETURN TRUE.
        END.

    END.

    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:

        RETURN ITEM.desc-item.

    END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-item-rastr wWindow 
FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST item-rast FIELDS(it-codigo data-ini data-fim) NO-LOCK 
        WHERE item-rast.it-codigo  = p-it-codigo
        AND   item-rast.data-ini  <= TODAY
        AND   item-rast.data-fim   > TODAY:

        RETURN TRUE.

    END.


    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-nota-export wWindow 
FUNCTION f-nota-export RETURNS LOGICAL
  ( INPUT p-estab AS CHAR,
    INPUT p-serie  AS CHAR,
    INPUT p-nota AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = p-estab
          AND nota-fiscal.serie       = p-serie
          AND nota-fiscal.nr-nota-fis = p-nota NO-ERROR.
    IF  AVAIL nota-fiscal AND SUBSTR(nota-fiscal.nat-operacao,1,1) = "7" THEN DO: /*Exportacao*/
    
        RETURN TRUE.

    END.

    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

