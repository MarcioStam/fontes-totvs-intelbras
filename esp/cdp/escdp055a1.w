&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ncm-origem NO-UNDO LIKE ncm-origem
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ncm-origem-sem-prot NO-UNDO LIKE ncm-origem-sem-prot
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
{include/i-prgvrs.i escdp055a1 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           escdp055a1
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      NCM Origem Sem Protocolo

&GLOBAL-DEFINE ttTable           tt-ncm-origem-sem-prot
&GLOBAL-DEFINE hDBOTable         h-bodi733
&GLOBAL-DEFINE DBOTable          ncm-origem-sem-prot

&GLOBAL-DEFINE ttParent          tt-ncm-origem
&GLOBAL-DEFINE DBOParentTable    h-bodi732

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-ncm-origem.cod-ncm ~
                                 tt-ncm-origem.codigo-orig
&GLOBAL-DEFINE page1Fields       tt-ncm-origem-sem-prot.uf-origem ~
                                 tt-ncm-origem-sem-prot.uf-destino ~
                                 tt-ncm-origem-sem-prot.per-sub-tri ~
                                 tt-ncm-origem-sem-prot.perc-red-sub ~
                                 tt-ncm-origem-sem-prot.perc-aliq-Interna ~
                                 tt-ncm-origem-sem-prot.perc-credito-icms ~
                                 tt-ncm-origem-sem-prot.protocolo ~
                                 tt-ncm-origem-sem-prot.l-tem-st ~
                                 tt-ncm-origem-sem-prot.l-gera-of ~
                                 tt-ncm-origem-sem-prot.cod-msg-nf ~
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
&Scoped-Define ENABLED-FIELDS tt-ncm-origem.cod-ncm ~
tt-ncm-origem.codigo-orig 
&Scoped-define ENABLED-TABLES tt-ncm-origem
&Scoped-define FIRST-ENABLED-TABLE tt-ncm-origem
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-ncm-origem.cod-ncm ~
tt-ncm-origem.codigo-orig 
&Scoped-define DISPLAYED-TABLES tt-ncm-origem
&Scoped-define FIRST-DISPLAYED-TABLE tt-ncm-origem


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
     SIZE 87 BY 9.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-ncm-origem.cod-ncm AT ROW 1.75 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88 NO-TAB-STOP 
     tt-ncm-origem.codigo-orig AT ROW 1.75 COL 36.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88 NO-TAB-STOP 
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
     tt-ncm-origem-sem-prot.uf-origem AT ROW 1.58 COL 18 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     tt-ncm-origem-sem-prot.uf-destino AT ROW 2.58 COL 18 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     tt-ncm-origem-sem-prot.l-tem-st AT ROW 3.5 COL 20 WIDGET-ID 22
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     tt-ncm-origem-sem-prot.l-gera-of AT ROW 4.25 COL 20 WIDGET-ID 24
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     fi-desc-msg AT ROW 2 COL 54.43 COLON-ALIGNED NO-LABEL WIDGET-ID 14 NO-TAB-STOP 
     tt-ncm-origem-sem-prot.per-sub-tri AT ROW 5.08 COL 18 COLON-ALIGNED WIDGET-ID 6 FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-ncm-origem-sem-prot.perc-red-sub AT ROW 6.08 COL 18 COLON-ALIGNED WIDGET-ID 10 FORMAT ">>9.999"
          VIEW-AS FILL-IN 
          SIZE 7.72 BY .88
     ed-msg AT ROW 3.25 COL 35 NO-LABEL WIDGET-ID 16 NO-TAB-STOP 
     tt-ncm-origem-sem-prot.perc-aliq-Interna AT ROW 7.13 COL 18 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     tt-ncm-origem-sem-prot.perc-credito-icms AT ROW 8.17 COL 18 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-ncm-origem-sem-prot.protocolo AT ROW 9.17 COL 18 COLON-ALIGNED WIDGET-ID 12 FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     tt-ncm-origem-sem-prot.cod-msg-nf AT ROW 2 COL 47.43 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     RECT-2 AT ROW 1.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3.75
         SIZE 89 BY 9.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ncm-origem T "?" NO-UNDO esIntelbras ncm-origem
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ncm-origem-sem-prot T "?" NO-UNDO esIntelbras ncm-origem-sem-prot
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
ASSIGN 
       ed-msg:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-msg IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-ncm-origem-sem-prot.per-sub-tri IN FRAME fPage1
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-ncm-origem-sem-prot.perc-red-sub IN FRAME fPage1
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN tt-ncm-origem-sem-prot.protocolo IN FRAME fPage1
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
    ASSIGN tt-ncm-origem-sem-prot.dt-ultima-rec    = TODAY
           tt-ncm-origem-sem-prot.usuar-ultima-rev = c-seg-usuario.
    if  pcAction = "ADD":U 
        AND CAN-FIND(FIRST ncm-origem-sem-prot 
                    WHERE  ncm-origem-sem-prot.cod-ncm = replace(tt-ncm-origem.cod-ncm:SCREEN-VALUE IN FRAME fPage0,'.','')
                    AND    ncm-origem-sem-prot.codigo-orig = INT(tt-ncm-origem.codigo-orig:SCREEN-VALUE IN FRAME fPage0)
                    AND    ncm-origem-sem-prot.uf-destino = tt-ncm-origem-sem-prot.uf-destino:SCREEN-VALUE IN FRAME fPage1
                    AND    ncm-origem-sem-prot.uf-origem = tt-ncm-origem-sem-prot.uf-origem:SCREEN-VALUE IN FRAME fPage1) THEN DO:
        EMPTY TEMP-TABLE RowErrors.
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = 1
               RowErrors.ErrorNumber      = 1055
               RowErrors.ErrorDescription = "J  existe uma ocorrˆncia com a chave informada!"
               RowErrors.ErrorHelp        = "NÆo ser  poss¡vel incluir o registros com estas informa‡äes.".
        {method/showmessage.i1}
        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        {method/showmessage.i2}

    END.
    ELSE DO:
        RUN saveRecord IN THIS-PROCEDURE.

        IF  RETURN-VALUE = "OK":U THEN DO:
            IF  tt-ncm-origem-sem-prot.l-tem-st:CHECKED  IN FRAME fPage1
            AND tt-ncm-origem-sem-prot.l-gera-of:CHECKED IN FRAME fPage1 THEN DO:
                RUN esp/cdp/escdp055api.p (INPUT tt-ncm-origem.cod-ncm:SCREEN-VALUE IN FRAME fPage0,          
                                           INPUT INT(tt-ncm-origem.codigo-orig:SCREEN-VALUE IN FRAME fPage0)).
            END.

            APPLY "CLOSE":U TO THIS-PROCEDURE.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    if  pcAction = "ADD":U 
        AND CAN-FIND(FIRST ncm-origem-sem-prot 
                    WHERE  ncm-origem-sem-prot.cod-ncm = replace(tt-ncm-origem.cod-ncm:SCREEN-VALUE IN FRAME fPage0,'.','')
                    AND    ncm-origem-sem-prot.codigo-orig = INT(tt-ncm-origem.codigo-orig:SCREEN-VALUE IN FRAME fPage0)
                    AND    ncm-origem-sem-prot.uf-destino = tt-ncm-origem-sem-prot.uf-destino:SCREEN-VALUE IN FRAME fPage1
                    AND    ncm-origem-sem-prot.uf-origem = tt-ncm-origem-sem-prot.uf-origem:SCREEN-VALUE IN FRAME fPage1) THEN DO:
        EMPTY TEMP-TABLE RowErrors.
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = 1
               RowErrors.ErrorNumber      = 1055
               RowErrors.ErrorDescription = "J  existe uma ocorrˆncia com a chave informada!"
               RowErrors.ErrorHelp        = "NÆo ser  poss¡vel incluir o registros com estas informa‡äes.".
        {method/showmessage.i1}
        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        {method/showmessage.i2}

    END.
    ELSE DO:
        RUN saveRecord IN THIS-PROCEDURE.
    
        IF  RETURN-VALUE = "OK":U THEN DO:
            IF  INPUT FRAME fPage1 tt-ncm-origem-sem-prot.l-tem-st = YES
            AND INPUT FRAME fPage1 tt-ncm-origem-sem-prot.l-gera-of = YES  THEN
                RUN esp\cdp\escdp055api.p (INPUT tt-ncm-origem.cod-ncm:SCREEN-VALUE IN FRAME fPage0,          
                                           INPUT INT(tt-ncm-origem.codigo-orig:SCREEN-VALUE IN FRAME fPage0)).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-ncm-origem-sem-prot.cod-msg-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ncm-origem-sem-prot.cod-msg-nf wMaintenanceNoNavigation
ON F5 OF tt-ncm-origem-sem-prot.cod-msg-nf IN FRAME fPage1 /* Mensagem NF */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad176.w
                       &campo=tt-ncm-origem-sem-prot.cod-msg-nf /*C¢digo mensagem da tela*/
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ncm-origem-sem-prot.cod-msg-nf wMaintenanceNoNavigation
ON LEAVE OF tt-ncm-origem-sem-prot.cod-msg-nf IN FRAME fPage1 /* Mensagem NF */
DO:
    FIND FIRST mensagem NO-LOCK
        WHERE mensagem.cod-mensagem = INPUT FRAME fpage1 tt-ncm-origem-sem-prot.cod-msg-nf
        NO-ERROR.

    IF  AVAIL mensagem AND INPUT FRAME fpage1 tt-ncm-origem-sem-prot.cod-msg-nf <> 0 THEN
        ASSIGN fi-desc-msg:SCREEN-VALUE IN FRAME fpage1 = mensagem.descricao
               ed-msg:SCREEN-VALUE IN FRAME fpage1 = mensagem.texto-mensag.
    ELSE
        ASSIGN fi-desc-msg:SCREEN-VALUE IN FRAME fpage1 = ""
               ed-msg:SCREEN-VALUE IN FRAME fpage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ncm-origem-sem-prot.cod-msg-nf wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-ncm-origem-sem-prot.cod-msg-nf IN FRAME fPage1 /* Mensagem NF */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-ncm-origem-sem-prot.uf-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ncm-origem-sem-prot.uf-destino wMaintenanceNoNavigation
ON F5 OF tt-ncm-origem-sem-prot.uf-destino IN FRAME fPage1 /* UF Destino */
DO:
   assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=unzoom/z01un007.w
                       &campo=tt-ncm-origem-sem-prot.uf-destino /*C¢digo mensagem da tela*/
                       &campozoom=estado
                       &frame=fpage1
                       &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ncm-origem-sem-prot.uf-destino wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-ncm-origem-sem-prot.uf-destino IN FRAME fPage1 /* UF Destino */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-ncm-origem-sem-prot.uf-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ncm-origem-sem-prot.uf-origem wMaintenanceNoNavigation
ON F5 OF tt-ncm-origem-sem-prot.uf-origem IN FRAME fPage1 /* UF Origem */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=unzoom/z01un007.w
                       &campo=tt-ncm-origem-sem-prot.uf-origem /*C¢digo mensagem da tela*/
                       &campozoom=estado
                       &frame=fpage1
                       &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ncm-origem-sem-prot.uf-origem wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-ncm-origem-sem-prot.uf-origem IN FRAME fPage1 /* UF Origem */
DO:         
    APPLY "F5" TO SELF.
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

/*     assign c-un = tt-ncm-origem.un.                                          */
/*                                                                        */
/*     display c-un with frame fPage1.                                    */
/*                                                                        */
     apply "LEAVE":U to tt-ncm-origem-sem-prot.cod-msg-nf in frame fPage1.  

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
        assign tt-ncm-origem-sem-prot.uf-origem:sensitive in frame fPage1 = NO
               tt-ncm-origem-sem-prot.uf-destino:sensitive in frame fPage1 = no.
    else
        apply "ENTRY":U to tt-ncm-origem-sem-prot.uf-origem in frame fPage1.

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

    tt-ncm-origem-sem-prot.uf-origem:load-mouse-pointer ("image/lupa.cur":U) in frame fPage1.
    tt-ncm-origem-sem-prot.uf-destino:load-mouse-pointer ("image/lupa.cur":U) in frame fPage1.
    tt-ncm-origem-sem-prot.cod-msg-nf:load-mouse-pointer ("image/lupa.cur":U) in frame fPage1.
    
    apply 'entry':U to btOK in frame fPage0.

    return "OK":U.

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
    
    ASSIGN tt-ncm-origem-sem-prot.cod-ncm          = tt-ncm-origem.cod-ncm
           tt-ncm-origem-sem-prot.codigo-orig      = tt-ncm-origem.codigo-orig.
                                                                 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

