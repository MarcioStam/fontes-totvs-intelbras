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
{include/i-prgvrs.i ESCPP118 2.00.00.000}
{include/i-license-manager.i ESCPP104 FGL}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP118
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btCancel btHelp2 c-it-codigo  ~
                              btConfigImpr c-mac
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-carregou  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-esapi016  AS HANDLE      NO-UNDO.
 

{esp/es0018.i}
{upc/btb910za-upc.i}
{esapi/esapi016.i}
{cdp/cd0666.i}

DEFINE VARIABLE l-teste       AS LOGICAL   NO-UNDO.

DEFINE VARIABLE i-cont-tot    AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-qtd-embalag AS INTEGER   NO-UNDO.

DEFINE VARIABLE i-cor         AS INTEGER   NO-UNDO.
DEFINE VARIABLE fc-mac        AS CHARACTER NO-UNDO.

DEFINE VARIABLE wh-pesquisa  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_nom_disposit_so AS CHAR NO-UNDO.

DEF TEMP-TABLE tt-mac-impresso
    FIELD mac LIKE mac-address.mac 
    INDEX idx mac.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-it-codigo btQueryJoins btReportsJoins ~
btExit btHelp c-desc-item btConfigImpr btCancel btHelp2 fiPrinter ~
rtToolBar-2 rtToolBar RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo c-mac c-desc-item fiPrinter 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-mac AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mac Address" 
     VIEW-AS FILL-IN 
     SIZE 23 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 2.46.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-it-codigo AT ROW 3 COL 18.72 COLON-ALIGNED WIDGET-ID 4
     c-mac AT ROW 5.58 COL 19 COLON-ALIGNED WIDGET-ID 44
     btQueryJoins AT ROW 1.13 COL 82.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 86.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 90.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 94.57 HELP
          "Ajuda"
     c-desc-item AT ROW 3 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     btConfigImpr AT ROW 4.5 COL 65 HELP
          "Configuraá∆o da impressora" WIDGET-ID 22
     btCancel AT ROW 7.04 COL 1.72
     btHelp2 AT ROW 7.04 COL 88.43
     fiPrinter AT ROW 4.58 COL 21 NO-LABEL WIDGET-ID 24 NO-TAB-STOP 
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 4.83 COL 12.86 WIDGET-ID 26
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 6.83 COL 1
     RECT-1 AT ROW 2.75 COL 1 WIDGET-ID 2
     RECT-2 AT ROW 4.29 COL 1 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98.72 BY 7.25
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
         HEIGHT             = 7.25
         WIDTH              = 98.72
         MAX-HEIGHT         = 28
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28
         VIRTUAL-WIDTH      = 195.14
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-mac IN FRAME fpage0
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
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
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


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON F5 OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    {method/zoomfields.i &ProgramZoom="inzoom/z20in172.w"
                         &FieldZoom1="it-codigo"        
                         &FieldScreen1="c-it-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="desc-item"        
                         &FieldScreen2="c-desc-item"
                         &Frame2="fPage0"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON LEAVE OF c-it-codigo IN FRAME fpage0 /* Item */
DO:
    DO WITH FRAME fPage0:
        ASSIGN c-desc-item:SCREEN-VALUE = "".
    
        FOR FIRST item NO-LOCK
            WHERE item.it-codigo = SELF:SCREEN-VALUE:
    
            ASSIGN c-desc-item:SCREEN-VALUE = item.desc-item.

        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wWindow
ON RETURN OF c-it-codigo IN FRAME fpage0 /* Item */
DO:

    ASSIGN SELF:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,1,7).

    IF SELF:SCREEN-VALUE BEGINS "8" THEN DO:
        FIND FIRST it-altern NO-LOCK
             WHERE it-altern.it-altern = SELF:SCREEN-VALUE NO-ERROR.
        IF AVAIL it-altern THEN
            ASSIGN SELF:SCREEN-VALUE = it-altern.it-codigo.
    END.

    APPLY "LEAVE" TO SELF.

    
    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-mac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-mac wWindow
ON RETURN OF c-mac IN FRAME fpage0 /* Mac Address */
DO:
    ASSIGN fc-mac = INPUT FRAME fPage0 c-mac.

    
    IF INPUT FRAME fPage0 c-it-codigo = ""
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Informe um item.'
                                 + '~~' + 'Informe um item.').
        RETURN "NOK":U.
    END.

    FIND FIRST mac-address WHERE mac-address.mac = fc-mac NO-LOCK NO-ERROR.

    IF NOT AVAIL mac-address
    THEN DO:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT 'Mac Address n∆o encontrado.'
                                 + '~~' + 'Verifique se o MAC digitado esta correto').
        RETURN "NOK":U.
    END.
    ELSE DO:
        
        IF mac-address.it-codigo <> INPUT FRAME fPage0 c-it-codigo 
        THEN DO:
           RUN utp/ut-msgs.p (INPUT 'show':U,
                              INPUT 17006,
                              INPUT 'Item do MAC (' + STRING(mac-address.it-codigo) + ') diferente do item selecionado'
                                    + '~~' + 'O Item selecionado Ç diferente do item do Mac Address').
           RETURN "NOK":U.
        END.
    END.

    FIND FIRST tt-mac-impresso
         WHERE tt-mac-impresso.mac = input frame fPage0 c-mac:screen-value
    NO-ERROR.

    IF AVAIL tt-mac-impresso THEN DO:

       RUN utp/ut-msgs.p (INPUT 'show':U,
                          INPUT 17006,
                          INPUT 'Mac Address ja foi impresso.').
       RETURN "NOK":U. 
    END.                          
    
    RUN piImpressao.

    assign input frame fPage0 c-mac:screen-value = "". 
    
    ASSIGN fc-mac = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-mac wWindow
ON VALUE-CHANGED OF c-mac IN FRAME fpage0 /* Mac Address */
DO:
/*
   //    assign input frame fPage0 c-mac:SCREEN-VALUE = SUBSTRING(INPUT FRAME fPage0 c-mac,1,12).

    IF LENGTH(INPUT FRAME fPage0 c-mac) = 12  
    THEN DO:

        ASSIGN fc-mac = INPUT FRAME fPage0 c-mac.

        assign input frame fPage0 c-mac:screen-value = "". 

        IF INPUT FRAME fPage0 c-it-codigo = ""
        THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT 'Informe um item.'
                                     + '~~' + 'Informe um item.').
            RETURN "NOK":U.
        END.

        IF INPUT FRAME fPage0 cb-modelo = 000
        THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT 'M¢delo invalido.'
                                     + '~~' + 'Modelo informado n∆o cadastrado ou item sem m¢delo vinculado.').
            RETURN "NOK":U.
        END.

        FIND FIRST mac-address WHERE
                   mac-address.mac = fc-mac
                   EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAIL mac-address
        THEN DO:
            RUN utp/ut-msgs.p (INPUT 'show':U,
                               INPUT 17006,
                               INPUT 'Mac Address n∆o encontrado.'
                                     + '~~' + 'Verifique se o MAC digitado esta correto').
            RETURN "NOK":U.
        END.
        ELSE DO:
            IF mac-address.n-serie <> "" 
            THEN DO:
                RUN utp/ut-msgs.p (INPUT 'show':U,
                                   INPUT 17006,
                                   INPUT 'Mac Address j† vinculado a um Numero de Serie.'
                                         + '~~' + 'O Mac ' + string(fc-mac) + ' j† vinculado ao NS ' 
                                         + STRING(mac-address.n-serie)).
                RETURN "NOK":U.
            END.

            IF mac-address.it-codigo <> INPUT FRAME fPage0 c-it-codigo 
            THEN DO:
               RUN utp/ut-msgs.p (INPUT 'show':U,
                                  INPUT 17006,
                                  INPUT 'Item do MAC (' + STRING(mac-address.it-codigo) + ') diferente do item selecionado'
                                        + '~~' + 'O Item selecionado Ç diferente do item do Mac Address').
               RETURN "NOK":U.
            END.

            RUN piImpressao.
        END.

         ASSIGN fc-mac = "".
    END.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}


IF c-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

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
FOR FIRST imprsor_usuar NO-LOCK
    WHERE imprsor_usuar.cod_usuario = c-seg-usuario
    AND   imprsor_usuar.log_imprsor_princ:

    FOR FIRST layout_impres NO-LOCK
        WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
        AND   layout_impres.log_layout_impres_princ:

        ASSIGN fiPrinter:SCREEN-VALUE IN FRAME fPage0 = layout_impres.nom_impressora + ":" +
                                                        layout_impres.cod_layout_impres.
    END.
END.

ASSIGN c-mac:SENSITIVE IN FRAME fPage0 = NO.

APPLY "ENTRY" TO c-it-codigo IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImpressao wWindow 
PROCEDURE piImpressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
    DEFINE VARIABLE cFormataSenha     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cSenhaWIFI        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cSenhaADM         AS CHARACTER   NO-UNDO.

    FIND FIRST item-ean 
         WHERE item-ean.it-codigo = INPUT FRAME fPage0 c-it-codigo 
    NO-LOCK NO-ERROR.

    IF AVAIL item-ean THEN DO:

        ASSIGN cFormataSenha = TRIM(item-ean.texto[5]) + '||' + INPUT FRAME fPage0 c-mac. 

        ASSIGN cFormataSenha = LOWER(REPLACE(cFormataSenha,' ','')).

        RUN esapi\esapi016x.p (INPUT cFormataSenha,
                               OUTPUT cSenhaWIFI ,
                               OUTPUT cSenhaADM ).

        /*
        MESSAGE ' cSenhaWIFI ' cSenhaWIFI skip
                ' cSenhaADM  ' cSenhaADM  skip
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
        
        
        if input frame {&frame-name} fiPrinter = "":U then do:
            message "Informe uma impressora v†lida.":U view-as alert-box.
            return no-apply.
        end.
         
        RUN piSetaImpressora(INPUT input frame {&frame-name} fiPrinter).

        OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET "IBM850" SOURCE "ISO8859-1".

        /*inicializa par≥metros impressora*/   
        {esapi/esapi016inic.i}
       
        PUT "^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ^XA" SKIP.  

        PUT UNFORMATTED "^FT30,30^A0N,28,28^FH\^FDUSU\B5RIO:^FS"      SKIP.
        PUT UNFORMATTED "^FT145,30^A0N,28,40^FH\^FDadmin^FS"          SKIP.
        PUT UNFORMATTED "^FT30,60^A0N,28,28^FH\^FDSENHA:^FS"          SKIP.
        PUT UNFORMATTED "^FT120,60^A0N,28,30^FH\^FD" cSenhaADM "^FS"  SKIP.
    
        PUT UNFORMATTED
             "^PQ" STRING(1, "99999") SKIP /* Repetiá‰es */
             "^XZ".  
        
        OUTPUT CLOSE.



        CREATE tt-mac-impresso.
        ASSIGN tt-mac-impresso.mac = INPUT FRAME fPage0 c-mac.

        OUTPUT TO VALUE('\\erpapp\spool\lu050023\senhaMAC.txt') APPEND NO-CONVERT.
            PUT UNFORMATTED 
                tt-mac-impresso.mac " - "  
                cFormataSenha       " - "  
                cSenhaWIFI          " - "  
                cSenhaADM  SKIP.          
        OUTPUT CLOSE.

    END.


   

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

    ASSIGN c-mac:SENSITIVE IN FRAME fPage0 = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaImpressora wWindow 
PROCEDURE piSetaImpressora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-impressora  AS CHAR NO-UNDO.

DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.

IF NUM-ENTRIES(p-impressora, ":":U) = 2 THEN DO:

    ASSIGN cPrinter = SUBSTRING(p-impressora, 1, INDEX(p-impressora, ":":U) - 1)
           cLayout  = SUBSTRING(p-impressora, INDEX(p-impressora, ":":U) + 1, LENGTH(p-impressora) - INDEX(p-impressora, ":":U)).

    FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
        WHERE imprsor_usuar.nom_impressora = cPrinter
          AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

    IF NOT AVAILABLE imprsor_usuar THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).

    END.

    FIND FIRST layout_impres
        WHERE layout_impres.nom_impressora    = cPrinter
          AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

    IF NOT AVAILABLE layout_impres THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).
    END.
END.
ELSE DO:
    IF NUM-ENTRIES(p-impressora, ":":U) < 2 THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).

    END.

    ASSIGN cPrinter = ENTRY(1, p-impressora, ":":U)
           cLayout  = ENTRY(2, p-impressora, ":":U).

    FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
        WHERE imprsor_usuar.nom_impressora = cPrinter
          AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

    IF NOT AVAILABLE imprsor_usuar THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).
    END.

    FIND FIRST layout_impres
        WHERE layout_impres.nom_impressora = cPrinter
          AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

    IF NOT AVAILABLE layout_impres THEN DO:

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 4306,
                           INPUT c-seg-usuario).
    END.
END.


ASSIGN v_nom_disposit_so = "".

IF AVAIL imprsor_usuar THEN
    ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.

/*
MESSAGE 'Pi Seta Impressora' v_nom_disposit_so
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidate wWindow 
PROCEDURE piValidate :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

