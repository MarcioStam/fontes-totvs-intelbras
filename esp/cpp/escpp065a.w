&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-it-mod-img-etiq NO-UNDO LIKE it-mod-img-etiq
       FIELD RowNum AS INTEGER INIT 1
       FIELD descricao as character
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-item NO-UNDO LIKE item
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-item-mod-etiq NO-UNDO LIKE item-mod-etiq
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP065A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESCPP065A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-item-mod-etiq
&GLOBAL-DEFINE hDBOTable         h-boes613
&GLOBAL-DEFINE DBOTable          item-mod-etiq

&GLOBAL-DEFINE ttParent          tt-item
&GLOBAL-DEFINE DBOParentTable    h-boin172

&GLOBAL-DEFINE page0KeyFields    tt-item-mod-etiq.cod-modelo
&GLOBAL-DEFINE page0Fields       tt-item-mod-etiq.cor tt-item-mod-etiq.padrao
&GLOBAL-DEFINE page0ParentFields tt-item.it-codigo 

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boes794     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-escpp065b   AS HANDLE NO-UNDO.

DEFINE VARIABLE i-cor AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-imagem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-it-mod-img-etiq

/* Definitions for BROWSE br-imagem                                     */
&Scoped-define FIELDS-IN-QUERY-br-imagem tt-it-mod-img-etiq.sequencia tt-it-mod-img-etiq.cod-imagem tt-it-mod-img-etiq.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-imagem   
&Scoped-define SELF-NAME br-imagem
&Scoped-define QUERY-STRING-br-imagem FOR EACH tt-it-mod-img-etiq BY tt-it-mod-img-etiq.sequencia
&Scoped-define OPEN-QUERY-br-imagem OPEN QUERY {&SELF-NAME} FOR EACH tt-it-mod-img-etiq BY tt-it-mod-img-etiq.sequencia.
&Scoped-define TABLES-IN-QUERY-br-imagem tt-it-mod-img-etiq
&Scoped-define FIRST-TABLE-IN-QUERY-br-imagem tt-it-mod-img-etiq


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-imagem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-item.it-codigo tt-item-mod-etiq.cod-modelo ~
tt-item-mod-etiq.cor tt-item-mod-etiq.padrao 
&Scoped-define ENABLED-TABLES tt-item tt-item-mod-etiq
&Scoped-define FIRST-ENABLED-TABLE tt-item
&Scoped-define SECOND-ENABLED-TABLE tt-item-mod-etiq
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar RECT-19 RECT-20 bt-cor ~
br-imagem btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-item.it-codigo ~
tt-item-mod-etiq.cod-modelo tt-item-mod-etiq.cor tt-item-mod-etiq.padrao 
&Scoped-define DISPLAYED-TABLES tt-item tt-item-mod-etiq
&Scoped-define FIRST-DISPLAYED-TABLE tt-item
&Scoped-define SECOND-DISPLAYED-TABLE tt-item-mod-etiq


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cor 
     IMAGE-UP FILE "ems2/image/mip-legenda.bmp":U
     LABEL "Cor" 
     SIZE 5 BY 1.13.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-imagem FOR 
      tt-it-mod-img-etiq SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-imagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-imagem wMaintenanceNoNavigation _FREEFORM
  QUERY br-imagem DISPLAY
      tt-it-mod-img-etiq.sequencia
    tt-it-mod-img-etiq.cod-imagem
    tt-it-mod-img-etiq.descricao   COLUMN-LABEL "Descriá∆o" FORMAT "X(60)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 3.67
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-item.it-codigo AT ROW 1.25 COL 37.86 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-item-mod-etiq.cod-modelo AT ROW 2.25 COL 37.86 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     bt-cor AT ROW 3.88 COL 60.29 WIDGET-ID 20
     tt-item-mod-etiq.cor AT ROW 4 COL 37.86 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-item-mod-etiq.padrao AT ROW 5 COL 39.86 WIDGET-ID 10
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .83
     br-imagem AT ROW 6.71 COL 17 WIDGET-ID 200
     btOK AT ROW 12.17 COL 2
     btSave AT ROW 12.17 COL 13
     btCancel AT ROW 12.17 COL 24
     btHelp AT ROW 12.17 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 11.92 COL 1
     RECT-19 AT ROW 3.75 COL 1 WIDGET-ID 8
     RECT-20 AT ROW 6.25 COL 1 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-it-mod-img-etiq T "?" NO-UNDO mgesp it-mod-img-etiq
      ADDITIONAL-FIELDS:
          FIELD RowNum AS INTEGER INIT 1
          FIELD descricao as character
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-item T "?" NO-UNDO mgcad item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-item-mod-etiq T "?" NO-UNDO mgesp item-mod-etiq
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 12.63
         WIDTH              = 90
         MAX-HEIGHT         = 28.79
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.79
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-imagem padrao fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-imagem
/* Query rebuild information for BROWSE br-imagem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-it-mod-img-etiq BY tt-it-mod-img-etiq.sequencia.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-imagem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cor wMaintenanceNoNavigation
ON CHOOSE OF bt-cor IN FRAME fpage0 /* Cor */
DO:

    ASSIGN i-cor = COLOR-TABLE:NUM-ENTRIES
           COLOR-TABLE:NUM-ENTRIES = i-cor + 1. 

    COLOR-TABLE:SET-DYNAMIC(i-cor,TRUE).
    COLOR-TABLE:SET-RED-VALUE(i-cor, 255).
    COLOR-TABLE:SET-GREEN-VALUE(i-cor, 0).
    COLOR-TABLE:SET-BLUE-VALUE(i-cor, 0). 
    SYSTEM-DIALOG COLOR i-cor.

    ASSIGN tt-item-mod-etiq.cor:BGCOLOR = i-cor
           tt-item-mod-etiq.cor:FGCOLOR = i-cor
           tt-item-mod-etiq.cor:SCREEN-VALUE = STRING(COLOR-TABLE:GET-RED-VALUE(i-cor)) + "," +
                                               STRING(COLOR-TABLE:GET-GREEN-VALUE(i-cor)) + "," +
                                               STRING(COLOR-TABLE:GET-BLUE-VALUE(i-cor)).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-item-mod-etiq.cod-modelo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-mod-etiq.cod-modelo wMaintenanceNoNavigation
ON F5 OF tt-item-mod-etiq.cod-modelo IN FRAME fpage0 /* Modelo */
DO:

    {method/zoomfields.i &ProgramZoom="eszoom/z01es612.w"
                         &FieldZoom1="cod-modelo"        
                         &FieldScreen1="tt-item-mod-etiq.cod-modelo"
                         &Frame1="fPage0"} 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-mod-etiq.cod-modelo wMaintenanceNoNavigation
ON LEAVE OF tt-item-mod-etiq.cod-modelo IN FRAME fpage0 /* Modelo */
DO:
    RUN esbo/boes794.p PERSISTENT SET h-boes794.
    IF DYNAMIC-FUNCTION("fnRetornaQtdeSelo" IN h-boes794,
                        INTEGER(tt-item-mod-etiq.cod-modelo:SCREEN-VALUE)) > 0 THEN DO:

        RUN piBuscaImagem IN h-boes794 (INPUT tt-item.it-codigo:SCREEN-VALUE,
                                        INPUT INTEGER(tt-item-mod-etiq.cod-modelo:SCREEN-VALUE),
                                        OUTPUT TABLE tt-it-mod-img-etiq).
        
        {&OPEN-QUERY-BR-IMAGEM}
    END.

    IF VALID-HANDLE(h-boes794) THEN
        DELETE PROCEDURE h-boes794.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-mod-etiq.cod-modelo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-item-mod-etiq.cod-modelo IN FRAME fpage0 /* Modelo */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-imagem
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-item-mod-etiq.cod-modelo:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL tt-item-mod-etiq AND tt-item-mod-etiq.cor <> "" THEN DO:
                          
    ASSIGN i-cor                   = COLOR-TABLE:NUM-ENTRIES 
           COLOR-TABLE:NUM-ENTRIES = i-cor + 1. 

    COLOR-TABLE:SET-DYNAMIC(i-cor,TRUE).
    COLOR-TABLE:SET-RED-VALUE(i-cor, int(ENTRY(1, INPUT FRAME fPage0 tt-item-mod-etiq.cor, ","))).
    COLOR-TABLE:SET-GREEN-VALUE(i-cor, int(ENTRY(2, INPUT FRAME fPage0 tt-item-mod-etiq.cor, ","))).
    COLOR-TABLE:SET-BLUE-VALUE(i-cor, int(ENTRY(3, INPUT FRAME fPage0 tt-item-mod-etiq.cor, ","))).

    ASSIGN tt-item-mod-etiq.cor:BGCOLOR = i-cor
           tt-item-mod-etiq.cor:FGCOLOR = i-cor.
END.

IF AVAIL tt-item-mod-etiq AND tt-item.it-codigo:SCREEN-VALUE <> "" AND
    INTEGER(tt-item-mod-etiq.cod-modelo:SCREEN-VALUE) <> 0 THEN
    APPLY "LEAVE" TO tt-item-mod-etiq.cod-modelo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:
        ASSIGN tt-item-mod-etiq.cor:SENSITIVE = FALSE
               bt-cor:SENSITIVE = TRUE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

    ASSIGN tt-item-mod-etiq.it-codigo = tt-item.it-codigo.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord wMaintenanceNoNavigation 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-boes794  AS HANDLE  NO-UNDO.
DEFINE VARIABLE i-qtdeselo AS INTEGER NO-UNDO.

DO WITH FRAME fPage0:
    IF tt-item-mod-etiq.padrao:CHECKED THEN DO:
        IF CAN-FIND(FIRST item-mod-etiq
                    WHERE item-mod-etiq.it-codigo = tt-item.it-codigo
                    AND   item-mod-etiq.padrao AND
                        (pcAction = "ADD" OR
                         pcAction = "COPY" OR
                         ROWID(item-mod-etiq) <> tt-item-mod-etiq.r-rowid)) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 27100,
                               INPUT 'Alterar este Modelo para Padr∆o do Item ? ~~ J† existe outro modelo marcado como padr∆o para este item. Para confirmar que este ser† o novo Modelo Padr∆o do Item responda "Sim". Para retornar a tela e desmarcar o parÉmetro "Padr∆o" responda "N∆o".').

            IF RETURN-VALUE = "NO" THEN DO:
                APPLY "ENTRY" TO tt-item-mod-etiq.padrao.
                RETURN "NOK":U.
            END.
        END.
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

