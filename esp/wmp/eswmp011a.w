
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-wms-histor-bloq-box NO-UNDO LIKE wms-histor-bloq-box
       field r-Rowid as Rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright SCM S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da SCM, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESWMP011A 2.00.00.001} /*** 010001 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESWMP011A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Bloqueio

&GLOBAL-DEFINE page0Widgets   btOK btCancel rs-tipo-bloq mtv-obs-cartao mtv-obs-solicitante mtv-obs-responsavel mtv-obs-pedido mtv-obs-geral
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

DEF TEMP-TABLE ttBloqueio NO-UNDO
    FIELD cod-estabel      LIKE wm-box.cod-estabel 
    FIELD cod-local        LIKE wm-box.cod-local   
    FIELD id-box           LIKE wm-box.id-box  
    FIELD log-bloq-arm     LIKE wm-box.log-bloq-arm    
    FIELD log-bloq-retir   LIKE wm-box.log-bloq-retir
    FIELD idi-tip-bloq-box LIKE wms-histor-bloq-box.idi-tip-bloq-box.

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttBloqueio.
DEFINE INPUT        PARAMETER i-bloq-armazenagem AS INT INIT -1 NO-UNDO. /* 0. N∆o alterado, 1. Bloqueado, 2. Liberado */
DEFINE INPUT        PARAMETER i-bloq-retirada    AS INT INIT -1 NO-UNDO. /* 0. N∆o alterado, 1. Bloqueado, 2. Liberado */
DEFINE INPUT        PARAMETER c-it-codigo        AS CHAR        NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-bosc170 AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 RECT-2 RECT-3 RECT-4 RECT-5 ~
RECT-6 RECT-7 rs-tipo-bloq mtv-bloqueio-armazenamento mtv-obs-cartao ~
mtv-obs-solicitante mtv-obs-responsavel mtv-obs-pedido mtv-obs-geral btOK ~
btCancel 
&Scoped-Define DISPLAYED-OBJECTS rs-tipo-bloq mtv-bloqueio-armazenamento ~
mtv-obs-cartao mtv-obs-solicitante mtv-obs-responsavel mtv-obs-pedido ~
mtv-obs-geral 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE mtv-bloqueio-armazenamento AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 73.72 BY 3.38 NO-UNDO.

DEFINE VARIABLE mtv-obs-cartao AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 73.72 BY 2.71 NO-UNDO.

DEFINE VARIABLE mtv-obs-geral AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 73.72 BY 2.71 NO-UNDO.

DEFINE VARIABLE mtv-obs-pedido AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 73.72 BY 2.71 NO-UNDO.

DEFINE VARIABLE mtv-obs-responsavel AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 73.72 BY 2.71 NO-UNDO.

DEFINE VARIABLE mtv-obs-solicitante AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 73.72 BY 2.71 NO-UNDO.

DEFINE VARIABLE rs-tipo-bloq AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Preventivo", 1,
"Estoque", 2,
"Lote Recusado", 3,
"Aguardando lanáamento", 4,
"Inspeá∆o", 5,
"Previsto", 6
     SIZE 74 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 4.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 3.88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 3.88.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 3.88.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 3.88.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 3.88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79.14 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     rs-tipo-bloq AT ROW 1.75 COL 5 NO-LABEL WIDGET-ID 12
     mtv-bloqueio-armazenamento AT ROW 4.13 COL 4 NO-LABEL WIDGET-ID 2
     mtv-obs-cartao AT ROW 9.04 COL 4 NO-LABEL WIDGET-ID 20
     mtv-obs-solicitante AT ROW 13.42 COL 4 NO-LABEL WIDGET-ID 26
     mtv-obs-responsavel AT ROW 17.83 COL 4 NO-LABEL WIDGET-ID 32
     mtv-obs-pedido AT ROW 22.21 COL 4 NO-LABEL WIDGET-ID 38
     mtv-obs-geral AT ROW 26.5 COL 4 NO-LABEL WIDGET-ID 44
     btOK AT ROW 30.04 COL 2.43
     btCancel AT ROW 30.04 COL 13.43
     "Tipo Bloqueio:" VIEW-AS TEXT
          SIZE 10.86 BY .54 AT ROW 1.04 COL 4.14 WIDGET-ID 10
     "PO:" VIEW-AS TEXT
          SIZE 7.86 BY .54 AT ROW 21.29 COL 4.14 WIDGET-ID 42
     "Respons†vel pelo tratamento do bloqueio:" VIEW-AS TEXT
          SIZE 29.86 BY .54 AT ROW 16.92 COL 4.14 WIDGET-ID 36
     "Solicitante AQ:" VIEW-AS TEXT
          SIZE 22.86 BY .54 AT ROW 12.5 COL 4.14 WIDGET-ID 30
     "Motivo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 3.21 COL 4.14 WIDGET-ID 6
     "Num Cart∆o Laranja ou Amarelo:" VIEW-AS TEXT
          SIZE 22.86 BY .54 AT ROW 8.13 COL 4.14 WIDGET-ID 24
     "Observaá∆o:" VIEW-AS TEXT
          SIZE 10.86 BY .54 AT ROW 25.58 COL 4.14 WIDGET-ID 48
     rtToolBar AT ROW 29.83 COL 1.43
     RECT-1 AT ROW 3.46 COL 2.14 WIDGET-ID 4
     RECT-2 AT ROW 1.29 COL 2.14 WIDGET-ID 8
     RECT-3 AT ROW 8.38 COL 2.14 WIDGET-ID 22
     RECT-4 AT ROW 12.75 COL 2.14 WIDGET-ID 28
     RECT-5 AT ROW 17.17 COL 2.14 WIDGET-ID 34
     RECT-6 AT ROW 21.54 COL 2.14 WIDGET-ID 40
     RECT-7 AT ROW 25.83 COL 2.14 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.14 BY 30.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-wms-histor-bloq-box T "?" NO-UNDO mgscm wms-histor-bloq-box
      ADDITIONAL-FIELDS:
          field r-Rowid as Rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 30.38
         WIDTH              = 81.14
         MAX-HEIGHT         = 38.75
         MAX-WIDTH          = 194.86
         VIRTUAL-HEIGHT     = 38.75
         VIRTUAL-WIDTH      = 194.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "NOK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN validar IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN saveRecords IN THIS-PROCEDURE.
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN "OK":U.
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 36006, INPUT "").
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-bosc170) THEN DO:
        RUN destroy IN h-bosc170.
        DELETE OBJECT h-bosc170 NO-ERROR.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Habilita os campos dos motivos conforme */
    ENABLE mtv-bloqueio-armazenamento WITH FRAME fPage0.
    
    IF i-bloq-retirada    <> 1 
   // OR i-bloq-armazenagem > 1
    THEN DO:
        ASSIGN rs-tipo-bloq:SENSITIVE        IN FRAME fpage0 = NO
               mtv-obs-cartao:SENSITIVE      IN FRAME fpage0 = NO
               mtv-obs-solicitante:SENSITIVE IN FRAME fpage0 = NO
               mtv-obs-responsavel:SENSITIVE IN FRAME fpage0 = NO
               mtv-obs-pedido:SENSITIVE      IN FRAME fpage0 = NO
               mtv-obs-geral:SENSITIVE       IN FRAME fpage0 = NO.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-bosc170) THEN
        RUN scbo/bosc170.p PERSISTENT SET h-bosc170.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecords wWindow 
PROCEDURE saveRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN initializeDBOs IN THIS-PROCEDURE.

    FOR EACH ttBloqueio:
    
         FOR FIRST wm-box FIELDS(log-bloq-arm log-bloq-retir)  WHERE
                   wm-box.cod-estabel = ttBloqueio.cod-estabel AND
                   wm-box.cod-local   = ttBloqueio.cod-local   AND                     
                   wm-box.id-box      = ttBloqueio.id-box      EXCLUSIVE-LOCK.
         END.

        /* Bloquear Armazenamento */
        IF i-bloq-armazenagem = 1 THEN DO:
            IF AVAIL wm-box THEN 
                ASSIGN wm-box.log-bloq-arm = YES.    /** Endereco Bloqueado **/
            RUN bloquearArmazenamento IN h-bosc170 (INPUT ttBloqueio.cod-estabel,
                                                    INPUT ttBloqueio.cod-local,
                                                    INPUT ttBloqueio.id-box,
                                                    INPUT 1,
                                                    INPUT mtv-bloqueio-armazenamento:SCREEN-VALUE IN FRAME fPage0). 
            /*
            IF RETURN-VALUE = "OK":U 
            THEN DO:
                 FIND LAST wms-histor-bloq-box WHERE
                           wms-histor-bloq-box.cod-estabel      = ttBloqueio.cod-estabel AND
                           wms-histor-bloq-box.cod-local        = ttBloqueio.cod-local   AND
                           wms-histor-bloq-box.id-box           = ttBloqueio.id-box      AND
                           wms-histor-bloq-box.idi-tip-bloq-box = 1                      AND //bloquearArmazenamento
                           wms-histor-bloq-box.log-liber-box    = NO            
                           NO-LOCK NO-ERROR.

                 IF AVAIL wms-histor-bloq-box 
                 THEN DO:
                     CREATE int-wms-histor-bloq-box.
                     ASSIGN int-wms-histor-bloq-box.cod-estabel       = wms-histor-bloq-box.cod-estabel
                            int-wms-histor-bloq-box.cod-local         = wms-histor-bloq-box.cod-local
                            int-wms-histor-bloq-box.id-box            = wms-histor-bloq-box.id-box
                            int-wms-histor-bloq-box.dat-bloq-box      = wms-histor-bloq-box.dat-bloq-box
                            int-wms-histor-bloq-box.num-hora-bloq-box = wms-histor-bloq-box.num-hora-bloq-box
                            int-wms-histor-bloq-box.idi-tip-bloq-box  = wms-histor-bloq-box.idi-tip-bloq-box
                            int-wms-histor-bloq-box.tipo-bloq         = int(INPUT rs-tipo-bloq:SCREEN-VALUE IN FRAME fPage0)
                            int-wms-histor-bloq-box.obs-cartao        = INPUT mtv-obs-cartao:SCREEN-VALUE IN FRAME fPage0
                            int-wms-histor-bloq-box.obs-solicitante   = INPUT mtv-obs-solicitante:SCREEN-VALUE IN FRAME fPage0
                            int-wms-histor-bloq-box.obs-responsavel   = INPUT mtv-obs-responsavel:SCREEN-VALUE IN FRAME fPage0
                            int-wms-histor-bloq-box.obs-pedido        = INPUT mtv-obs-pedido:SCREEN-VALUE IN FRAME fPage0
                            int-wms-histor-bloq-box.obs-geral         = INPUT mtv-obs-geral:SCREEN-VALUE IN FRAME fPage0
                            .
                 END.
            END. */
        END.

        /* Liberar Armazenamento */
        IF i-bloq-armazenagem = 2 THEN DO:
            IF AVAIL wm-box THEN 
                ASSIGN wm-box.log-bloq-arm = NO. /** Endereco Bloqueado **/
            RUN liberarArmazenamento IN h-bosc170 (INPUT ttBloqueio.cod-estabel,
                                                   INPUT ttBloqueio.cod-local,
                                                   INPUT ttBloqueio.id-box,
                                                   INPUT mtv-bloqueio-armazenamento:SCREEN-VALUE IN FRAME fPage0).
        END.

        /*-------------------------------------------------------------------------------------------------------------------------*/

        /* Bloquear Retirada */
        IF i-bloq-retirada = 1 THEN DO:
            IF AVAIL wm-box THEN 
                ASSIGN wm-box.log-bloq-retir = YES.    /** Endereco Desbloqueado **/
            RUN bloquearRetirada IN h-bosc170 (INPUT ttBloqueio.cod-estabel,
                                               INPUT ttBloqueio.cod-local,
                                               INPUT ttBloqueio.id-box,
                                               INPUT 1,
                                               INPUT mtv-bloqueio-armazenamento:SCREEN-VALUE IN FRAME fPage0). 

            IF RETURN-VALUE = "OK":U 
            THEN DO:
                 FIND LAST wms-histor-bloq-box WHERE
                           wms-histor-bloq-box.cod-estabel      = ttBloqueio.cod-estabel AND
                           wms-histor-bloq-box.cod-local        = ttBloqueio.cod-local   AND
                           wms-histor-bloq-box.id-box           = ttBloqueio.id-box      AND
                           wms-histor-bloq-box.idi-tip-bloq-box = 2                      AND //bloquearRetirada
                           wms-histor-bloq-box.log-liber-box    = NO            
                           NO-LOCK NO-ERROR.

                 IF AVAIL wms-histor-bloq-box 
                 THEN DO:
                     CREATE int-wms-histor-bloq-box.
                     ASSIGN int-wms-histor-bloq-box.cod-estabel       = wms-histor-bloq-box.cod-estabel
                            int-wms-histor-bloq-box.cod-local         = wms-histor-bloq-box.cod-local
                            int-wms-histor-bloq-box.id-box            = wms-histor-bloq-box.id-box
                            int-wms-histor-bloq-box.dat-bloq-box      = wms-histor-bloq-box.dat-bloq-box
                            int-wms-histor-bloq-box.num-hora-bloq-box = wms-histor-bloq-box.num-hora-bloq-box
                            int-wms-histor-bloq-box.idi-tip-bloq-box  = wms-histor-bloq-box.idi-tip-bloq-box
                            int-wms-histor-bloq-box.tipo-bloq         = int(INPUT rs-tipo-bloq:SCREEN-VALUE IN FRAME fPage0)
                            int-wms-histor-bloq-box.obs-cartao        = INPUT mtv-obs-cartao:SCREEN-VALUE IN FRAME fPage0
                            int-wms-histor-bloq-box.obs-solicitante   = INPUT mtv-obs-solicitante:SCREEN-VALUE IN FRAME fPage0
                            int-wms-histor-bloq-box.obs-responsavel   = INPUT mtv-obs-responsavel:SCREEN-VALUE IN FRAME fPage0
                            int-wms-histor-bloq-box.obs-pedido        = INPUT mtv-obs-pedido:SCREEN-VALUE IN FRAME fPage0
                            int-wms-histor-bloq-box.obs-geral         = INPUT mtv-obs-geral:SCREEN-VALUE IN FRAME fPage0
                            int-wms-histor-bloq-box.it-codigo         = c-it-codigo
                            .
                 END.
            END.
        END.

        /* Liberar Retirada */
        IF i-bloq-retirada = 2 THEN DO:
            IF AVAIL wm-box THEN 
                ASSIGN wm-box.log-bloq-retir = NO.    /** Endereco Desbloqueado **/
            RUN liberarRetirada IN h-bosc170 (INPUT ttBloqueio.cod-estabel,
                                               INPUT ttBloqueio.cod-local,
                                               INPUT ttBloqueio.id-box,
                                               INPUT mtv-bloqueio-armazenamento:SCREEN-VALUE IN FRAME fPage0).
        END.
    END.

    RELEASE wm-box.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar wWindow 
PROCEDURE validar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF mtv-bloqueio-armazenamento:SCREEN-VALUE IN FRAME fPage0 = "" THEN RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


