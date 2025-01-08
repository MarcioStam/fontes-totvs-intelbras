&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item NO-UNDO LIKE item
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-item-uf-sem-prot NO-UNDO LIKE item-uf-sem-prot
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
{include/i-prgvrs.i ESCDP050a1 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESCDP050a1
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      ITEM UF Sem Protocolo

&GLOBAL-DEFINE ttTable           tt-item-uf-sem-prot
&GLOBAL-DEFINE hDBOTable         h-bodi616
&GLOBAL-DEFINE DBOTable          Item item-uf-sem-prot

&GLOBAL-DEFINE ttParent          tt-item
&GLOBAL-DEFINE DBOParentTable    h-bodi172

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-item.it-codigo ~
                                 tt-item.desc-item 
&GLOBAL-DEFINE page1Fields       tt-item-uf-sem-prot.cod-estado-orig ~
                                 tt-item-uf-sem-prot.estado ~
                                 tt-item-uf-sem-prot.per-sub-tri ~
                                 tt-item-uf-sem-prot.perc-red-sub ~
                                 tt-item-uf-sem-prot.dec-1 ~
                                 tt-item-uf-sem-prot.perc-credito-interno ~
                                 tt-item-uf-sem-prot.protocolo ~
                                 tt-item-uf-sem-prot.int-1 ~
                                 tt-item-uf-sem-prot.log-1 ~
                                 ed-msg

/* Parameters Definitions ---                                           */
define input parameter prTable         as rowid     no-undo.
define input parameter prParent        as rowid     no-undo.
define input parameter pcAction        as character no-undo.
define input parameter phCaller        as handle    no-undo.
define input parameter piSonPageNumber as integer   no-undo.

/* Local Variable Definitions ---                                       */
define variable wh-pesquisa        as widget-handle no-undo.
define variable c-return           as character     no-undo.
define variable c-cod-embal        as character     no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
define variable {&hDBOTable}   as handle no-undo.


/* Global Variable Definitions */
define new global shared variable adm-broker-hdl as handle no-undo.
define new global shared variable l-implanta as logical.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-item.it-codigo tt-item.desc-item 
&Scoped-define ENABLED-TABLES tt-item
&Scoped-define FIRST-ENABLED-TABLE tt-item
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-item.it-codigo tt-item.desc-item 
&Scoped-define DISPLAYED-TABLES tt-item
&Scoped-define FIRST-DISPLAYED-TABLE tt-item


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 1.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE ed-msg AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 52 BY 6 NO-UNDO.

DEFINE VARIABLE fi-desc-msg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 8.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-item.it-codigo AT ROW 1.75 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88 NO-TAB-STOP 
     tt-item.desc-item AT ROW 1.75 COL 34.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 44 BY .88 NO-TAB-STOP 
     btOK AT ROW 14 COL 2
     btSave AT ROW 14 COL 13
     btCancel AT ROW 14 COL 24
     btHelp AT ROW 14 COL 80
     rtKeys AT ROW 1.25 COL 3
     rtToolBar AT ROW 13.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 14.25
         FONT 1.

DEFINE FRAME fPage1
     tt-item-uf-sem-prot.log-1 AT ROW 8.63 COL 20.29 WIDGET-ID 30
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 4 BY .83
     tt-item-uf-sem-prot.per-sub-tri AT ROW 3.67 COL 18 COLON-ALIGNED WIDGET-ID 6 FORMAT ">>9.99999"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-item-uf-sem-prot.perc-red-sub AT ROW 4.67 COL 18 COLON-ALIGNED WIDGET-ID 10 FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.72 BY .88
     tt-item-uf-sem-prot.dec-1 AT ROW 5.67 COL 18.14 COLON-ALIGNED WIDGET-ID 2
          LABEL "ICMS Estadual ST" FORMAT ">>9.9999"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-desc-msg AT ROW 2 COL 54.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14 NO-TAB-STOP 
     tt-item-uf-sem-prot.perc-credito-interno AT ROW 6.67 COL 18.14 COLON-ALIGNED WIDGET-ID 8 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-item-uf-sem-prot.protocolo AT ROW 7.67 COL 18.14 COLON-ALIGNED WIDGET-ID 12 FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     ed-msg AT ROW 3.25 COL 35 NO-LABEL WIDGET-ID 16 NO-TAB-STOP 
     tt-item-uf-sem-prot.int-1 AT ROW 2 COL 47.43 COLON-ALIGNED WIDGET-ID 4
          LABEL "Mensag. Dispositivo" FORMAT ">>>>>9"
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     tt-item-uf-sem-prot.cod-estado-orig AT ROW 1.67 COL 18 COLON-ALIGNED WIDGET-ID 18
          LABEL "UF Origem" FORMAT "!!"
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     tt-item-uf-sem-prot.estado AT ROW 2.67 COL 18 COLON-ALIGNED WIDGET-ID 20
          LABEL "UF Destino":R2 FORMAT "!!"
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     "Destaque NF" VIEW-AS TEXT
          SIZE 9.86 BY 1 TOOLTIP "Com protocolo" AT ROW 8.54 COL 10 WIDGET-ID 28
     RECT-2 AT ROW 1.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 4.5
         SIZE 89 BY 9
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-item T "?" NO-UNDO mgind item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-item-uf-sem-prot T "?" NO-UNDO mgesp item-uf-sem-prot
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
         HEIGHT             = 14.42
         WIDTH              = 90.43
         MAX-HEIGHT         = 17.13
         MAX-WIDTH          = 95
         VIRTUAL-HEIGHT     = 17.13
         VIRTUAL-WIDTH      = 95
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN tt-item-uf-sem-prot.cod-estado-orig IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tt-item-uf-sem-prot.dec-1 IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       ed-msg:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN tt-item-uf-sem-prot.estado IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN fi-desc-msg IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-item-uf-sem-prot.int-1 IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR TOGGLE-BOX tt-item-uf-sem-prot.log-1 IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-item-uf-sem-prot.per-sub-tri IN FRAME fPage1
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-item-uf-sem-prot.perc-credito-interno IN FRAME fPage1
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-item-uf-sem-prot.perc-red-sub IN FRAME fPage1
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-item-uf-sem-prot.protocolo IN FRAME fPage1
   EXP-FORMAT                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

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
    
    RUN pi-validacao.
    IF RETURN-VALUE = "OK" THEN DO:
       RUN saveRecord IN THIS-PROCEDURE.
       
       IF RETURN-VALUE = "OK":U THEN
           APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-item-uf-sem-prot.int-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-uf-sem-prot.int-1 wMaintenanceNoNavigation
ON F5 OF tt-item-uf-sem-prot.int-1 IN FRAME fPage1 /* Mensag. Dispositivo */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad176.w
                       &campo=tt-item-uf-sem-prot.int-1 /*C¢digo mensagem da tela*/
                       &campozoom=cod-mensagem
                       &campo2=fi-desc-msg
                       &campozoom2=descricao
                       &campo3=ed-msg
                       &campozoom3=texto-mensag
                       &frame=fpage1
                       &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-uf-sem-prot.int-1 wMaintenanceNoNavigation
ON LEAVE OF tt-item-uf-sem-prot.int-1 IN FRAME fPage1 /* Mensag. Dispositivo */
DO:
    FIND FIRST mensagem NO-LOCK
        WHERE mensagem.cod-mensagem = INPUT FRAME fpage1 tt-item-uf-sem-prot.int-1
        NO-ERROR.

    IF  AVAIL mensagem AND INPUT FRAME fpage1 tt-item-uf-sem-prot.int-1 <> 0 THEN
        ASSIGN fi-desc-msg:SCREEN-VALUE IN FRAME fpage1 = mensagem.descricao
               ed-msg:SCREEN-VALUE IN FRAME fpage1 = mensagem.texto-mensag.
    ELSE
        ASSIGN fi-desc-msg:SCREEN-VALUE IN FRAME fpage1 = ""
               ed-msg:SCREEN-VALUE IN FRAME fpage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-uf-sem-prot.int-1 wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-item-uf-sem-prot.int-1 IN FRAME fPage1 /* Mensag. Dispositivo */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     assign c-un = tt-item.un.                                          */
/*                                                                        */
/*     display c-un with frame fPage1.                                    */
/*                                                                        */
     apply "LEAVE":U to tt-item-uf-sem-prot.int-1 in frame fPage1.  

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

    if  pcAction = "Update":U then 
        assign tt-item-uf-sem-prot.cod-estado-orig:sensitive in frame fPage1 = NO
               tt-item-uf-sem-prot.estado:sensitive in frame fPage1 = no.
    else
        apply "ENTRY":U to tt-item-uf-sem-prot.cod-estado-orig in frame fPage1.

    return "OK":U.
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

    tt-item-uf-sem-prot.cod-estado-orig:load-mouse-pointer ("image/lupa.cur":U) in frame fPage1.
    tt-item-uf-sem-prot.estado:load-mouse-pointer ("image/lupa.cur":U) in frame fPage1.
    tt-item-uf-sem-prot.int-1:load-mouse-pointer ("image/lupa.cur":U) in frame fPage1.
    
    assign tt-item-uf-sem-prot.estado:label in frame fPage1 = "Uf Destino".

    apply 'entry':U to btOK in frame fPage0.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validacao wMaintenanceNoNavigation 
PROCEDURE pi-validacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF tt-item-uf-sem-prot.cod-estado-orig:SCREEN-VALUE IN FRAME fpage1 = "" OR
   tt-item-uf-sem-prot.estado:SCREEN-VALUE IN FRAME fpage1          = "" THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Campos Estados nao podem ser brancos ! ~~ " +
                                 "Seraÿ necessario informar Estado diferente de branco.").
    APPLY "entry":U TO tt-item-uf-sem-prot.cod-estado-orig.
    RETURN "NOK".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    assign tt-item-uf-sem-prot.it-codigo = tt-item.it-codigo.
                                                                 
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

