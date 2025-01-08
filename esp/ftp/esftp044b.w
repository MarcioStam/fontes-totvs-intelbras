&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcat NO-UNDO LIKE cat
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttcat-item NO-UNDO LIKE cat-item
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
{include/i-prgvrs.i esftp044b 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           esftp044b
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            no
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      CatItens

&GLOBAL-DEFINE ttTable           ttcat-item
&GLOBAL-DEFINE hDBOTable         h-boes401
&GLOBAL-DEFINE DBOTable          boes401

&GLOBAL-DEFINE ttParent          ttcat
&GLOBAL-DEFINE DBOParentTable    boes401

&GLOBAL-DEFINE page0KeyFields    ttcat-item.it-codigo
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttcat.nr-cat ttcat.sequencia
      
&GLOBAL-DEFINE page2Fields       ttcat-item.quantidade ttcat-item.vl-unitario ttcat-item.vl-mao-obra ttcat-item.perc-desconto ttcat-item.tabela-mo ttcat-item.tabela-produtos


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
def var de-desconto-mo      as decimal initial 0 no-undo.
def var de-preco-mo         as decimal initial 0 no-undo.


/* nÆo exclua a linha abaixo !! */
/*
&scoped-define EXCLUDE-saveRecord
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttcat.nr-cat ttcat.sequencia ~
ttcat-item.it-codigo 
&Scoped-define ENABLED-TABLES ttcat ttcat-item
&Scoped-define FIRST-ENABLED-TABLE ttcat
&Scoped-define SECOND-ENABLED-TABLE ttcat-item
&Scoped-Define ENABLED-OBJECTS c-desc-item btOK btSave btCancel btHelp ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttcat.nr-cat ttcat.sequencia ~
ttcat-item.it-codigo 
&Scoped-define DISPLAYED-TABLES ttcat ttcat-item
&Scoped-define FIRST-DISPLAYED-TABLE ttcat
&Scoped-define SECOND-DISPLAYED-TABLE ttcat-item
&Scoped-Define DISPLAYED-OBJECTS c-desc-item 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
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

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .79 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttcat.nr-cat AT ROW 1.25 COL 41 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat.sequencia AT ROW 1.25 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     ttcat-item.it-codigo AT ROW 2.25 COL 41 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     c-desc-item AT ROW 2.25 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     ttcat-item.quantidade AT ROW 3.25 COL 38 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat-item.tabela-produtos AT ROW 4.25 COL 38 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat-item.vl-unitario AT ROW 5.25 COL 38 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat-item.perc-desconto AT ROW 6.25 COL 38 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat-item.vl-tot-item AT ROW 7.25 COL 38 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat-item.tabela-mo AT ROW 8.25 COL 38 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat-item.vl-mao-obra AT ROW 9.25 COL 38 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 4.7
         SIZE 84.43 BY 10.92
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcat T "?" NO-UNDO mgesp cat
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttcat-item T "?" NO-UNDO mgesp cat-item
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
         HEIGHT             = 17
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage2:MOVE-AFTER-TAB-ITEM (ttcat-item.it-codigo:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage2:MOVE-BEFORE-TAB-ITEM (c-desc-item:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage2
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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
    DEFINE VARIABLE l-ok AS LOGICAL    NO-UNDO.
    
    run pi-valida(output l-ok).   
    
    IF NOT l-ok THEN RETURN NO-APPLY.
    RUN saveRecord IN THIS-PROCEDURE.    
    
    run pi-calcula-cat.   
    
    RUN goToRecord2       in phCaller(INPUT ttcat.cod-estabel, input ttcat.nr-cat, input ttcat.sequencia). 
        
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    DEFINE VARIABLE l-ok AS LOGICAL    NO-UNDO.
    run pi-valida(output l-ok).
    IF NOT l-ok THEN RETURN NO-APPLY.
    RUN saveRecord IN THIS-PROCEDURE.
  
    run pi-calcula-cat.
        
    RUN goToRecord2       in phCaller(INPUT ttcat.cod-estabel, input ttcat.nr-cat, input ttcat.sequencia). 
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcat-item.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.it-codigo wMaintenanceNoNavigation
ON F5 OF ttcat-item.it-codigo IN FRAME fpage0 /* Item do Cat */
DO:
      {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=ttcat-item.it-codigo
                       &campozoom=it-codigo
                       &frame=fpage0}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.it-codigo wMaintenanceNoNavigation
ON LEAVE OF ttcat-item.it-codigo IN FRAME fpage0 /* Item do Cat */
DO:

      find item where item.it-codigo = ttcat-item.it-codigo:screen-value in frame fpage0 no-lock no-error.
      if avail item then
          assign c-desc-item:screen-value in frame fpage0            = item.desc-item.
      else
          assign c-desc-item:screen-value in frame fpage0            = "ITEM INEXISTENTE".


    find mgesp.int-emitente
         where mgesp.int-emitente.cod-emitente = ttcat.cod-emitente no-lock no-error.
    if avail mgesp.int-emitente then do:
       assign ttcat-item.perc-desconto:screen-value in frame fpage2 = string(mgesp.int-emitente.vl-desconto-cat).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.it-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcat-item.it-codigo IN FRAME fpage0 /* Item do Cat */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME ttcat-item.perc-desconto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.perc-desconto wMaintenanceNoNavigation
ON LEAVE OF ttcat-item.perc-desconto IN FRAME fPage2 /* Desconto do Item */
DO:
       run pi-calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcat-item.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.quantidade wMaintenanceNoNavigation
ON LEAVE OF ttcat-item.quantidade IN FRAME fPage2 /* Quantidade do item */
DO:
     run pi-calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcat-item.tabela-mo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.tabela-mo wMaintenanceNoNavigation
ON f5 OF ttcat-item.tabela-mo IN FRAME fPage2 /* Tab.Precos Mao de Obra */
DO:
        {include/zoomvar.i &prog-zoom=dizoom/z01di189.w
                       &campo=ttcat-item.tabela-mo
                       &campozoom=nr-tabpre
                       &frame=fpage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.tabela-mo wMaintenanceNoNavigation
ON LEAVE OF ttcat-item.tabela-mo IN FRAME fPage2 /* Tab.Precos Mao de Obra */
DO:
    if input frame fPage2 ttcat-item.tabela-mo <> "" then do:
       find tb-preco
            where tb-preco.nr-tabpre = input frame fPage2 ttcat-item.tabela-mo
            no-lock no-error.
       if avail tb-preco then
          assign de-desconto-mo = tb-preco.desconto.
        

        find tb-preco
             where tb-preco.nr-tabpre = input frame fPage2 ttcat-item.tabela-produtos
             no-lock no-error.
    
        find  last preco-item
              where preco-item.it-codigo  = input frame fPage0 ttcat-item.it-codigo
              and   preco-item.cod-refer  = ""
              and   preco-item.nr-tabpre  = input frame fPage2 ttcat-item.tabela-produtos
              and   preco-item.situacao   = 1
              and   preco-item.quant-min <= input frame fpage2 ttcat-item.quantidade
              no-lock no-error.
        if avail preco-item then  do:
           if preco-item.nr-tabpre = "DT" THEN
              assign de-preco-mo                                      = preco-item.preco-venda * 100 / 58.
           else
              assign de-preco-mo                                      = preco-item.preco-venda * 100 / 67.
           
           assign ttcat-item.vl-mao-obra                              = dec(input frame fPage2 ttcat-item.quantidade) * de-preco-mo * de-desconto-mo / 100
                  ttcat-item.vl-mao-obra:screen-value in frame fpage2 = string(ttcat-item.vl-mao-obra).
        end.
        else do:
              RUN utp/ut-msgs.p (INPUT "show":U,
                                 INPUT 2,
                                 INPUT "Item na Tabela").  
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.tabela-mo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcat-item.tabela-mo IN FRAME fPage2 /* Tab.Precos Mao de Obra */
DO:
  apply 'F5' TO  SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcat-item.tabela-produtos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.tabela-produtos wMaintenanceNoNavigation
ON F5 OF ttcat-item.tabela-produtos IN FRAME fPage2 /* Tab.Precos Produtos */
DO:
      {include/zoomvar.i &prog-zoom=dizoom/z01di189.w
                       &campo=ttcat-item.tabela-produtos
                       &campozoom=nr-tabpre
                       &frame=fpage2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.tabela-produtos wMaintenanceNoNavigation
ON LEAVE OF ttcat-item.tabela-produtos IN FRAME fPage2 /* Tab.Precos Produtos */
DO:
  if input frame fPage2 ttcat-item.tabela-produtos <> "" then do:
     find  last preco-item
          where preco-item.it-codigo  = input frame fPage0 ttcat-item.it-codigo
          and   preco-item.cod-refer  = ""
          and   preco-item.nr-tabpre  = input frame fPage2 ttcat-item.tabela-produtos
          and   preco-item.situacao   = 1
          and   preco-item.quant-min <= input frame fpage2 ttcat-item.quantidade
          no-lock no-error.
      if avail preco-item then 
         assign ttcat-item.vl-unitario:screen-value in frame fpage2 = string(preco-item.preco-venda).
      else do:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 2,
                               INPUT "Item na Tabela").  
      end.     
  end.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.tabela-produtos wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcat-item.tabela-produtos IN FRAME fPage2 /* Tab.Precos Produtos */
DO:
    apply 'F5' TO  SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcat-item.vl-unitario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat-item.vl-unitario wMaintenanceNoNavigation
ON LEAVE OF ttcat-item.vl-unitario IN FRAME fPage2 /* Valor Unitario do item */
DO:
       run pi-calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
ttcat-item.it-codigo:load-mouse-pointer("image/lupa.cur":U)       in frame fPage0.
ttcat-item.tabela-mo:load-mouse-pointer("image/lupa.cur":U)       in frame fPage2.
ttcat-item.tabela-produto:load-mouse-pointer("image/lupa.cur":U)  in frame fPage2.

{maintenancenonavigation/mainblock.i}

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
    find item where item.it-codigo = ttcat-item.it-codigo no-lock no-error.
     assign ttcat-item.vl-mao-obra:screen-value in frame fpage2 = string(ttcat-item.vl-mao-obra)
            ttcat-item.vl-tot-item:screen-value in frame fpage2 = string(ttcat-item.vl-tot-item) 
            c-desc-item:screen-value in frame fpage0            = item.desc-item.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-cat wMaintenanceNoNavigation 
PROCEDURE pi-calcula-cat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find cat where cat.cod-estabel = ttcat.cod-estabel
               and cat.nr-cat      = ttcat.nr-cat
               and cat.sequencia   = ttcat.sequencia
               exclusive-lock no-error.
    if avail cat then  do:        
       assign cat.vl-cat      = 0
              cat.vl-a-pagar  = 0
              cat.vl-desconto = 0
              cat.vl-mao-obra = 0.
    
       for each cat-item 
           where cat-item.cod-estabel = cat.cod-estabel
             and cat-item.nr-cat      = cat.nr-cat
             and cat-item.sequencia   = cat.sequencia exclusive-lock:   
           assign cat.vl-cat          = cat.vl-cat + cat-item.quantidade * cat-item.vl-unitario
                  cat.vl-desconto     = cat.vl-desconto + (cat-item.quantidade * cat-item.vl-unitario - cat-item.vl-tot-item)
                  cat.vl-mao-obra     = cat.vl-mao-obra +  cat-item.vl-mao-obra.
                  
       end.
       assign cat.vl-a-pagar  = cat.vl-cat - cat.vl-desconto +
                                             cat.vl-acrescimo + 
                                             cat.vl-mao-obra.
       
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calculo wMaintenanceNoNavigation 
PROCEDURE pi-calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign ttcat-item.vl-tot-item:screen-value in frame fpage2 = string(dec(ttcat-item.quantidade:screen-value in frame fpage2) *
                                                                        dec(ttcat-item.vl-unitario:screen-value in frame fpage2) -
    
                                                                        dec(ttcat-item.quantidade:screen-value in frame fpage2) *
                                                                        dec(ttcat-item.vl-unitario:screen-value in frame fpage2) *
                                                                        dec(ttcat-item.perc-desconto:screen-value in frame fpage2) / 100
                                                                        )
           ttcat-item.vl-tot-item = dec(ttcat-item.vl-tot-item:screen-value)
           ttcat-item.vl-mao-obra = dec(ttcat-item.vl-mao-obra:screen-value)           .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida wMaintenanceNoNavigation 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter p-ok as logical.
assign p-ok = yes.
    
IF  pcAction = "ADD" OR pcAction = "COPY" THEN DO WITH FRAME fPage0:
    find item
         where item.it-codigo = ttcat-item.it-codigo:screen-value in frame fpage0
         no-lock no-error.
    if not avail item then do:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 2,
                           INPUT "Item").
        assign p-ok = no.
    
    end.     
    find mgesp.int-item
         where mgesp.int-item.it-codigo = ttcat-item.it-codigo:screen-value in frame fpage0
         no-lock no-error.
    if not avail mgesp.int-item then do:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 2,
                           INPUT "mgesp.int-item").
        assign p-ok = no.
    
    end.       
    if avail mgesp.int-item and mgesp.int-item.ind-tipo-venda <> 2 and mgesp.int-item.ind-tipo-venda <> 3 then do:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Identificador de Venda ou Revenda nao informado no cadastro de itens (cd0204)":U ).
        ASSIGN p-ok = no.    
    end.
end.        

if dec(ttcat-item.quantidade:screen-value in frame fpage2) = 0 then do:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Quantidade deve ser Maior que Zeros":U ).
        ASSIGN p-ok = no.
end.   
if ttcat-item.tabela-mo:screen-value in frame fpage2 = "" then
    if dec(ttcat-item.vl-unitario:screen-value in frame fpage2) = 0 then do:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Valor Unitario deve ser Maior que Zeros":U ).
            ASSIGN p-ok = no.
    end.   
    
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

    assign ttcat-item.cod-estabel = ttcat.cod-estabel
           ttcat-item.nr-cat      = ttcat.nr-cat
           ttcat-item.sequencia   = ttcat.sequencia.
           
    find first mgesp.int-item
         where mgesp.int-item.it-codigo = ttcat-item.it-codigo:screen-value in frame fpage0 
         no-lock no-error.
    if avail mgesp.int-item then 
       assign  ttcat-item.ind-tipo-faturamento = mgesp.int-item.ind-tipo-venda. /* 2 = Venda e 3 = Revenda */

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

