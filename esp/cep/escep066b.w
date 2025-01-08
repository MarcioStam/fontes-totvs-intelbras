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
{include/i-prgvrs.i ESCEP066B 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP066B
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 fi-familia fi-cod-estabel fi-it-codigo fi-cod-fabricante tg-nec-inspec ed-motivo
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE BUFFER b-item-insp FOR item-insp.

DEFINE VARIABLE wh-pesquisa AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-it-codigo AS INT64     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-13 RECT-14 fi-familia ~
fi-cod-estabel fi-desc-estabel fi-it-codigo fi-desc-item fi-cod-fabricante ~
fi-desc-fabric tg-nec-inspec ed-motivo btOK btCancel btHelp2 lb-motivo 
&Scoped-Define DISPLAYED-OBJECTS fi-familia fi-cod-estabel fi-desc-estabel ~
fi-it-codigo fi-desc-item fi-cod-fabricante fi-desc-fabric tg-nec-inspec ~
ed-motivo lb-motivo 

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

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-motivo AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 61 BY 4.5 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-fabricante AS CHARACTER FORMAT "X(6)":U 
     LABEL "Fabricante" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-fabric AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .88 NO-UNDO.

DEFINE VARIABLE fi-familia AS CHARACTER FORMAT "X(3)":U 
     LABEL "Fam°lia de C¢digo de Item" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE lb-motivo AS CHARACTER FORMAT "X(256)":U INITIAL "Motivo da Inclus∆o da Regra:" 
      VIEW-AS TEXT 
     SIZE 20.43 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 4.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 7.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-nec-inspec AS LOGICAL INITIAL no 
     LABEL "Necessita Inspeá∆o na Origem" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-familia AT ROW 1.5 COL 23 COLON-ALIGNED WIDGET-ID 4
     fi-cod-estabel AT ROW 2.5 COL 23 COLON-ALIGNED WIDGET-ID 6
     fi-desc-estabel AT ROW 2.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     fi-it-codigo AT ROW 3.5 COL 23 COLON-ALIGNED WIDGET-ID 8
     fi-desc-item AT ROW 3.5 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     fi-cod-fabricante AT ROW 4.5 COL 23 COLON-ALIGNED WIDGET-ID 10
     fi-desc-fabric AT ROW 4.5 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     tg-nec-inspec AT ROW 6.25 COL 25 WIDGET-ID 14
     ed-motivo AT ROW 7.5 COL 25 NO-LABEL WIDGET-ID 30
     btOK AT ROW 13.46 COL 2
     btCancel AT ROW 13.46 COL 13
     btHelp2 AT ROW 13.46 COL 80
     lb-motivo AT ROW 7.67 COL 2.57 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     rtToolBar AT ROW 13.25 COL 1
     RECT-13 AT ROW 1.25 COL 2 WIDGET-ID 2
     RECT-14 AT ROW 6 COL 3 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.88
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 75 ROW 1.5
         SIZE 7.43 BY .75
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 13.88
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    RUN pi-valida.

    IF RETURN-VALUE = "OK" THEN DO:

        RUN pi-grava.

        APPLY "CLOSE":U TO THIS-PROCEDURE.

        RETURN "OK":U.

    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON F5 OF fi-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    {method/ZoomFields.i &ProgramZoom="adzoom/z11ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="fi-cod-estabel"
                         &Frame1="fPage0"
                         &FieldZoom2="nome"
                         &FieldScreen2="fi-desc-estabel"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON LEAVE OF fi-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    IF SELF:SCREEN-VALUE = "*" THEN
        ASSIGN fi-desc-estabel:SCREEN-VALUE = "Todos Estabelecimentos".

    ELSE DO:

        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = SELF:SCREEN-VALUE:
        END.
    
        IF AVAIL estabelec THEN
            ASSIGN fi-desc-estabel:SCREEN-VALUE = estabelec.nome.
        ELSE
            ASSIGN fi-desc-estabel:SCREEN-VALUE = "".

    END.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    APPLY "f5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-fabricante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabricante wWindow
ON F5 OF fi-cod-fabricante IN FRAME fpage0 /* Fabricante */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es077.w"
                         &FieldZoom1="cod-fabric"
                         &FieldScreen1="fi-cod-fabricante"
                         &Frame1="fPage0"
                         &FieldZoom2="nome-abrev"
                         &FieldScreen2="fi-desc-fabric"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabricante wWindow
ON LEAVE OF fi-cod-fabricante IN FRAME fpage0 /* Fabricante */
DO:

    IF SELF:SCREEN-VALUE = "*" THEN
        ASSIGN fi-desc-fabric:SCREEN-VALUE = "Todos Fabricantes".

    ELSE DO:

        FOR FIRST fabricante NO-LOCK
            WHERE fabricante.cod-fabric = int(SELF:SCREEN-VALUE):
        END.
    
        IF AVAIL fabricante THEN
            ASSIGN fi-desc-fabric:SCREEN-VALUE = fabricante.nome-abrev.
        ELSE
            ASSIGN fi-desc-fabric:SCREEN-VALUE = "".

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabricante wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-fabricante IN FRAME fpage0 /* Fabricante */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON F5 OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:

    {method/ZoomFields.i &ProgramZoom="inzoom/z24in172.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="fi-it-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="desc-item"
                         &FieldScreen2="fi-desc-item"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:

    IF SELF:SCREEN-VALUE = "*" THEN
        ASSIGN fi-desc-item:SCREEN-VALUE = "Todos Itens".

    ELSE DO:

        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = fi-it-codigo:SCREEN-VALUE:
        END.
    
        IF AVAIL ITEM THEN
            ASSIGN fi-desc-item:SCREEN-VALUE = ITEM.desc-item.
        ELSE 
            ASSIGN fi-desc-item:SCREEN-VALUE = "".

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:

    APPLY "f5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

fi-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
fi-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
fi-cod-fabricante:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DO WITH FRAME fPage0:

        ASSIGN lb-motivo:SCREEN-VALUE = "Motivo da Inclus∆o da Regra:".

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava wWindow 
PROCEDURE pi-grava :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DO WITH FRAME fPage0:

        FOR LAST b-item-insp USE-INDEX seq NO-LOCK
            WHERE b-item-insp.it-fam = fi-familia:SCREEN-VALUE:
        END.

        CREATE item-insp.
        ASSIGN item-insp.it-fam         = fi-familia:SCREEN-VALUE
               item-insp.sequen         = IF AVAIL b-item-insp THEN b-item-insp.sequen + 1 ELSE 1
               item-insp.cod-estabel    = fi-cod-estabel:SCREEN-VALUE
               item-insp.it-codigo      = fi-it-codigo:SCREEN-VALUE
               item-insp.cod-fabric     = fi-cod-fabricante:SCREEN-VALUE
               item-insp.log-nec-inspec = tg-nec-inspec:CHECKED
               item-insp.dt-ini-val     = NOW
               item-insp.dt-fim-val     = DATETIME(12, 31, 9999, 23, 59, 59, 999)
               item-insp.just-ini       = ed-motivo:SCREEN-VALUE
               item-insp.just-fim       = ?
               item-insp.usuar-ini      = c-seg-usuario
               item-insp.usuar-fim      = ?.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida wWindow 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        IF LENGTH(fi-familia:SCREEN-VALUE) <> 3 THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Fam°lia de C¢digo de Item deve possuir 3 d°gitos.").

            APPLY "entry" TO fi-familia.

            RETURN "NOK":U.

        END.

        /**/

        IF SUBSTR(fi-familia:SCREEN-VALUE,1,1) = '4' THEN DO:
            IF fi-familia:SCREEN-VALUE <> '4**' THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Fam°lia 4 deve ser sempre igual a (4**).").

                APPLY "entry" TO fi-familia.
    
                RETURN "NOK":U.

            END.          
        END.

        ELSE DO:
        
            FOR FIRST ITEM no-lock
                WHERE item.it-codigo BEGINS fi-familia:SCREEN-VALUE:
            END.
    
            IF NOT AVAIL ITEM THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "N∆o existe item para a Fam°lia de C¢digo de Item digitada.").
    
                APPLY "entry" TO fi-familia.
    
                RETURN "NOK":U.
    
            END.
        END.

        /**/

        IF fi-cod-estabel:SCREEN-VALUE <> "*" THEN DO:

            FOR FIRST estabelec NO-LOCK
                WHERE estabelec.cod-estabel = fi-cod-estabel:SCREEN-VALUE:
            END.
    
            IF NOT AVAIL estabelec THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 56,
                                   INPUT "Estabelecimento").
    
                APPLY "entry" TO fi-cod-estabel.
    
                RETURN "NOK":U.
    
            END.

        END.

        /**/

        IF fi-it-codigo:SCREEN-VALUE <> "*" THEN DO:

            ASSIGN i-it-codigo = INT64(fi-it-codigo:SCREEN-VALUE) NO-ERROR.

            IF ERROR-STATUS:ERROR OR
               fi-it-codigo:SCREEN-VALUE = "" THEN DO:

                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Insira somente c¢digo de itens NumÇricos.").
    
                APPLY "entry" TO fi-it-codigo.
    
                RETURN "NOK":U.

            END.

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = fi-it-codigo:SCREEN-VALUE:
            END.
    
            IF NOT AVAIL ITEM THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 56,
                                   INPUT "Item").
    
                APPLY "entry" TO fi-it-codigo.
    
                RETURN "NOK":U.
    
            END.

        END.

        /**/

        IF fi-cod-fabricante:SCREEN-VALUE <> "*" THEN DO:

            FOR FIRST fabricante NO-LOCK
                WHERE fabricante.cod-fabric = int(fi-cod-fabricante:SCREEN-VALUE):
            END.
    
            IF NOT AVAIL fabricante THEN DO:
    
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 56,
                                   INPUT "Fabricante").
    
                APPLY "entry" TO fi-cod-fabricante.
    
                RETURN "NOK":U.
    
            END.

        END.

        /**/

        IF ed-motivo:SCREEN-VALUE = "" THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Informe um motivo v†lido.").

            APPLY "entry" TO ed-motivo.

            RETURN "NOK":U.
    
        END.

        /**/

        FOR FIRST b-item-insp NO-LOCK
            WHERE b-item-insp.it-fam = fi-familia:SCREEN-VALUE
            AND   b-item-insp.cod-estabel = fi-cod-estabel:SCREEN-VALUE
            AND   b-item-insp.it-codigo = fi-it-codigo:SCREEN-VALUE
            AND   b-item-insp.cod-fabric = fi-cod-fabricante:SCREEN-VALUE
            AND   b-item-insp.dt-fim-val = DATETIME(12, 31, 9999, 23, 59, 59, 999):
        END.

        IF AVAIL b-item-insp THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 8,
                               INPUT "Regra de Inspeá∆o").

            APPLY "entry" TO fi-familia.

            RETURN "NOK":U.

        END.
        
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

