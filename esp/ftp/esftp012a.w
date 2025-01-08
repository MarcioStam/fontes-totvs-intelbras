&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttped-fiscal NO-UNDO LIKE ped-fiscal
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
{include/i-prgvrs.i esftp012a 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           esftp012a
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Detalhes

&GLOBAL-DEFINE ttTable           ttPed-fiscal
&GLOBAL-DEFINE hDBOTable         hDBPPed-fiscal
&GLOBAL-DEFINE DBOTable          mgesp.ped-fiscal

&GLOBAL-DEFINE ttParent          
&GLOBAL-DEFINE DBOParentTable    

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       fi-cod-emitente 
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       ttPed-fiscal.cod-transp    ttPed-fiscal.cod-rota       ttPed-fiscal.dt-emissao ~
                                 ttPed-fiscal.cod-estabel   ttPed-fiscal.nat-oper       ttPed-fiscal.nr-volumes        ttPed-fiscal.nr-contrato ~
                                 cb-frete                    ttPed-fiscal.sc-codigo      c-receptor                  c-destino-1 cb-destino ~
                                 ttPed-fiscal.observacao[1] ttPed-fiscal.observacao[2]  ttPed-fiscal.observacao[3]  ttPed-fiscal.observacao[4]  ttPed-fiscal.observacao[5] ~
                                 ttPed-fiscal.sc-codigo-rec ttPed-fiscal.prioridade     ttPed-fiscal.motivo-urg c-estab-destino
                                 

/*    ttPed-fiscal.notas */

/*&GLOBAL-DEFINE page2Fields            */
/*&GLOBAL-DEFINE page3Fields           ttPed-fiscal.cod-estabel ttPed-fiscal.serie ttPed-fiscal.nr-nota-fis ttPed-fiscal.seq-wt-docto */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
/*DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.*/
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
/*DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.*/

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}    AS HANDLE       NO-UNDO.
DEFINE VARIABLE hDBOEmitente    AS HANDLE       NO-UNDO.
DEFINE VARIABLE hDBOTransporte  AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-transp        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-emitente      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-sigla-transp  LIKE def-transportes.sigla-trans NO-UNDO.
DEFINE VARIABLE wh-pesquisa     AS HANDLE       NO-UNDO.
define variable c-contrato-ant  as char         no-undo.
define variable lg-habilita     as logi         no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl  AS HANDLE       NO-UNDO.


DEF NEW GLOBAL SHARED VAR novo AS INT NO-UNDO.

DEF VAR ccc AS CHAR.
DEF VAR iii AS CHAR.
{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttped-fiscal.nr-pedido ttped-fiscal.situacao 
&Scoped-define ENABLED-TABLES ttped-fiscal
&Scoped-define FIRST-ENABLED-TABLE ttped-fiscal
&Scoped-Define ENABLED-OBJECTS fi-cod-emitente cNome-emit btOK btSave ~
btCancel btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttped-fiscal.situacao 
&Scoped-define DISPLAYED-TABLES ttped-fiscal
&Scoped-define FIRST-DISPLAYED-TABLE ttped-fiscal
&Scoped-Define DISPLAYED-OBJECTS fi-cod-emitente cNome-emit 

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

DEFINE VARIABLE cNome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .88.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 98 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 98 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-destino AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "- Selecione Destino -",1,
                     "Produá∆o",2,
                     "Revenda",3,
                     "Testes",4,
                     "Consumo",5,
                     "Ativo Imobilizado",6
     DROP-DOWN-LIST
     SIZE 17 BY 1 TOOLTIP "Frete" NO-UNDO.

DEFINE VARIABLE cb-frete AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Frete" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "- Selecione Frete -",1,
                     "CIF - Frete Pago",2,
                     "FOB - Frete a Pagar",3
     DROP-DOWN-LIST
     SIZE 17 BY 1 TOOLTIP "Frete" NO-UNDO.

DEFINE VARIABLE c-destino-1 AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 350 SCROLLBAR-VERTICAL
     SIZE 42 BY 3.08 NO-UNDO.

DEFINE VARIABLE c-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-destino AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento Destino" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-receptor AS CHARACTER FORMAT "X(40)":U 
     LABEL "Quem Ira Receber?" 
     VIEW-AS FILL-IN 
     SIZE 71 BY .88 NO-UNDO.

DEFINE VARIABLE cCentroCusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE VARIABLE cNome-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62.57 BY .88 NO-UNDO.

DEFINE VARIABLE cRota AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96 BY 21.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.21.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttped-fiscal.nr-pedido AT ROW 1.17 COL 25.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-cod-emitente AT ROW 2.17 COL 25.86 COLON-ALIGNED
     ttped-fiscal.situacao AT ROW 1.17 COL 80 RIGHT-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "Digitado",0,
                     "A Liberar",1,
                     "A Relacionar",2,
                     "A Faturar",3,
                     "Atendido Parcialmente",4,
                     "Atendido",5,
                     "Reprovado",6
          DROP-DOWN-LIST
          SIZE 12 BY 1
     cNome-emit AT ROW 2.17 COL 37 COLON-ALIGNED NO-LABEL
     btOK AT ROW 26.92 COL 3.86
     btSave AT ROW 26.92 COL 14.86
     btCancel AT ROW 26.92 COL 25.86
     btHelp AT ROW 26.92 COL 89.86
     rtKeys AT ROW 1 COL 2.72
     rtToolBar AT ROW 26.67 COL 2.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 101.29 BY 27.08
         FONT 1.

DEFINE FRAME fPage1
     ttped-fiscal.dt-emissao AT ROW 1.63 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     ttped-fiscal.cod-estabel AT ROW 1.63 COL 94 RIGHT-ALIGNED
          LABEL "Estabelecimento Origem"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttped-fiscal.cod-transp AT ROW 2.58 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cNome-transp AT ROW 2.58 COL 30.43 COLON-ALIGNED NO-LABEL
     ttped-fiscal.cod-rota AT ROW 3.58 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .79
     cRota AT ROW 3.58 COL 32.14 COLON-ALIGNED NO-LABEL
     cb-frete AT ROW 4.54 COL 22 COLON-ALIGNED HELP
          "Frete" WIDGET-ID 2
     ttped-fiscal.nr-volumes AT ROW 4.58 COL 57.57 COLON-ALIGNED
          LABEL "Nr. de Volumes"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttped-fiscal.nr-contrato AT ROW 4.63 COL 94 RIGHT-ALIGNED WIDGET-ID 54
          LABEL "Contrato"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ttped-fiscal.nat-oper AT ROW 5.54 COL 22 COLON-ALIGNED
          LABEL "Natureza de Operaá∆o"
          VIEW-AS COMBO-BOX INNER-LINES 15
          LIST-ITEM-PAIRS "",0
          DROP-DOWN-LIST
          SIZE 49 BY 1
     ttped-fiscal.ct-codigo AT ROW 5.63 COL 94 RIGHT-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttped-fiscal.sc-codigo AT ROW 6.63 COL 22 COLON-ALIGNED HELP
          ""
          LABEL "Centro de Custo do Aprovador" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cCentroCusto AT ROW 6.63 COL 32.43 COLON-ALIGNED NO-LABEL
     ttped-fiscal.usuario-magnus AT ROW 6.63 COL 94 RIGHT-ALIGNED
          LABEL "Usu†rio"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ttped-fiscal.nro-docto AT ROW 7.63 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttped-fiscal.serie-docto AT ROW 7.63 COL 57.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-cod-depos AT ROW 7.63 COL 94 RIGHT-ALIGNED WIDGET-ID 4
     c-receptor AT ROW 8.63 COL 22 COLON-ALIGNED WIDGET-ID 6
     c-destino-1 AT ROW 9.67 COL 24 NO-LABEL WIDGET-ID 12
     cb-destino AT ROW 9.67 COL 94 RIGHT-ALIGNED HELP
          "Frete" NO-LABEL WIDGET-ID 10
     c-estab-destino AT ROW 11 COL 94 RIGHT-ALIGNED HELP
          "Estabelecimento Destino" WIDGET-ID 52
     ttped-fiscal.sc-codigo-rec AT ROW 12 COL 94 RIGHT-ALIGNED WIDGET-ID 36
          LABEL "Centro Custo Recebedor"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttped-fiscal.observacao[1] AT ROW 13.21 COL 18.71 WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 55.43 BY .88
     ttped-fiscal.observacao[2] AT ROW 14.21 COL 18.71 WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 55.43 BY .88
     ttped-fiscal.observacao[3] AT ROW 15.21 COL 18.71 WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 55.43 BY .88
     ttped-fiscal.observacao[4] AT ROW 16.21 COL 18.71 WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 55.43 BY .88
     ttped-fiscal.observacao[5] AT ROW 17.21 COL 18.71 WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 55.43 BY .88
     ttped-fiscal.prioridade AT ROW 18.46 COL 24.43 NO-LABEL WIDGET-ID 40
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Normal", 1,
"Urgente", 2
          SIZE 69 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.72 ROW 4.67
         SIZE 98 BY 21.58
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage1
     ttped-fiscal.motivo-urg AT ROW 19.58 COL 24 NO-LABEL WIDGET-ID 46
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 71 BY 2.21
     "Destino Transf:" VIEW-AS TEXT
          SIZE 10.29 BY .88 AT ROW 9.67 COL 67.43 WIDGET-ID 50
     "Finalidade da mercadoria:" VIEW-AS TEXT
          SIZE 18 BY .88 AT ROW 9.67 COL 5.86 WIDGET-ID 38
     "Prioridade:" VIEW-AS TEXT
          SIZE 7.43 BY .88 AT ROW 18.38 COL 16 WIDGET-ID 44
     "Motivo Urgente:" VIEW-AS TEXT
          SIZE 11.43 BY .88 AT ROW 19.75 COL 12.43 WIDGET-ID 48
     RECT-2 AT ROW 1.25 COL 1.86
     RECT-3 AT ROW 13.08 COL 5 WIDGET-ID 26
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.72 ROW 4.67
         SIZE 98 BY 21.58
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttped-fiscal T "?" NO-UNDO mgesp ped-fiscal
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
         HEIGHT             = 27.08
         WIDTH              = 101.29
         MAX-HEIGHT         = 39.67
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 39.67
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (cNome-emit:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FILL-IN ttped-fiscal.nr-pedido IN FRAME fpage0
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX ttped-fiscal.situacao IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-depos IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-estab-destino IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR COMBO-BOX cb-destino IN FRAME fPage1
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN ttped-fiscal.cod-estabel IN FRAME fPage1
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN ttped-fiscal.ct-codigo IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR COMBO-BOX ttped-fiscal.nat-oper IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttped-fiscal.nr-contrato IN FRAME fPage1
   NO-ENABLE ALIGN-R EXP-LABEL                                          */
/* SETTINGS FOR FILL-IN ttped-fiscal.nr-volumes IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttped-fiscal.observacao[1] IN FRAME fPage1
   ALIGN-L                                                              */
ASSIGN 
       ttped-fiscal.observacao[1]:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN ttped-fiscal.observacao[2] IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ttped-fiscal.observacao[3] IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ttped-fiscal.observacao[4] IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ttped-fiscal.observacao[5] IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ttped-fiscal.sc-codigo IN FRAME fPage1
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN ttped-fiscal.sc-codigo-rec IN FRAME fPage1
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN ttped-fiscal.serie-docto IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttped-fiscal.usuario-magnus IN FRAME fPage1
   ALIGN-R EXP-LABEL                                                    */
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


&Scoped-define SELF-NAME fPage1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage1 wMaintenanceNoNavigation
ON ENTRY OF FRAME fPage1
DO:
    ttPed-fiscal.ct-codigo:VISIBLE IN FRAME fpage1 = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:

    RUN "destroyinterface":U.
/*                                            */
/*     MESSAGE 1                              */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/*   APPLY "CLOSE":U TO THIS-PROCEDURE.       */
/*   RETURN NO-APPLY.                         */
/*   MESSAGE 2                                */
/*       VIEW-AS ALERT-BOX INFO BUTTONS OK.   */

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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-estab-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-destino wMaintenanceNoNavigation
ON F5 OF c-estab-destino IN FRAME fPage1 /* Estabelecimento Destino */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z06ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="c-estab-destino"
                         &Frame1="fPage1"
                         &EnableImplant="NO"}
                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-destino wMaintenanceNoNavigation
ON LEAVE OF c-estab-destino IN FRAME fPage1 /* Estabelecimento Destino */
DO:
  
    IF c-estab-destino:SCREEN-VALUE IN FRAME fPage1 <> '' THEN DO:
        ASSIGN ttped-fiscal.observacao[4]:SCREEN-VALUE IN FRAME fPage1 = ' Ativo Imobilizado' +
                                                                         ' - ' + c-estab-destino      :SCREEN-VALUE IN FRAME fPage1 +
                                                                         ' - CC Recebedor: '  + ttped-fiscal.sc-codigo-rec:SCREEN-VALUE IN FRAME fPage1 .
    END. /* IF c-receptor:SCREEN-VALUE IN FRAME fPage1 <> '' THEN DO: */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-destino wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-estab-destino IN FRAME fPage1 /* Estabelecimento Destino */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-receptor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-receptor wMaintenanceNoNavigation
ON LEAVE OF c-receptor IN FRAME fPage1 /* Quem Ira Receber? */
DO:
  
    IF c-receptor:SCREEN-VALUE IN FRAME fPage1 <> '' THEN DO:
        ASSIGN ttped-fiscal.observacao[2]:SCREEN-VALUE IN FRAME fPage1 = ' Receptor: ' +  c-receptor:SCREEN-VALUE IN FRAME fPage1 .
    END. /* IF c-receptor:SCREEN-VALUE IN FRAME fPage1 <> '' THEN DO: */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-destino wMaintenanceNoNavigation
ON VALUE-CHANGED OF cb-destino IN FRAME fPage1
DO:
    IF  cb-destino:SCREEN-VALUE IN FRAME fPage1 = '6' /* Ativo Imobilizado */ 
    THEN ASSIGN ttped-fiscal.sc-codigo-rec:SENSITIVE    IN FRAME fPage1 = TRUE
                c-estab-destino:SENSITIVE               IN FRAME fPage1 = TRUE.
    ELSE ASSIGN ttped-fiscal.sc-codigo-rec:SENSITIVE    IN FRAME fPage1 = FALSE
                c-estab-destino:SENSITIVE               IN FRAME fPage1 = FALSE
                ttped-fiscal.sc-codigo-rec:SCREEN-VALUE IN FRAME fPage1 = ''
                c-estab-destino:SCREEN-VALUE            IN FRAME fPage1 = ''
                cCentroCusto              :SCREEN-VALUE IN FRAME fPage1 = ''.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttped-fiscal.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.cod-estabel wMaintenanceNoNavigation
ON F5 OF ttped-fiscal.cod-estabel IN FRAME fPage1 /* Estabelecimento Origem */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z06ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="ttped-fiscal.cod-estabel"
                         &Frame1="fPage1"
                         &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF ttped-fiscal.cod-estabel IN FRAME fPage1 /* Estabelecimento Origem */
DO:
  
    ASSIGN c-transp = "":U.

    IF  pcAction <> "UPDATE" THEN DO:
        FIND FIRST emitente 
            WHERE emitente.cod-emitente = int(fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0) NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            /* Busca Transportadora */ 
            IF  ttPed-fiscal.cod-estabel :SCREEN-VALUE IN FRAME fPage1 <> ''
            AND fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0 <> '' THEN DO:

                IF fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0 = "103748" AND ttPed-fiscal.cod-estabel :SCREEN-VALUE IN FRAME fPage1 = "104"  THEN
                   ASSIGN ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1 = "668".
                ELSE DO:
                    RUN esp/crm/escrm107.p(INPUT ttPed-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fPage1,
                                           INPUT fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0,
                                           INPUT emitente.cidade,
                                           INPUT emitente.estado,
                                           INPUT 0,
                                           INPUT emitente.cep,
                                           OUTPUT c-transp,
                                           OUTPUT c-sigla-transp).
                   
                     IF c-transp = ? THEN DO:
                         RUN utp/ut-msgs.p (INPUT "show":U,
                                            INPUT 17567,
                                            INPUT "N∆o encontrada transportadora para relacionamento UF x Cidade x Cliente.").
                   
                         ASSIGN ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1 = "".
                   
                         RETURN "NOK":U.
                     END.
                     ELSE
                         ASSIGN ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1 = c-transp.
                END.
            END.
    
            APPLY "LEAVE" TO ttPed-fiscal.cod-transp IN FRAME fPage1.
    
            FOR FIRST loc-entr NO-LOCK
                WHERE loc-entr.nome-abrev  = emitente.nome-abrev
                AND   loc-entr.cod-entrega = "Padr∆o",
                FIRST transporte
                WHERE transporte.nome-abrev = loc-entr.nome-transp:
    
                IF ttPed-fiscal.cod-rota:SCREEN-VALUE IN FRAME fPage1 = "" THEN DO:
                    ASSIGN ttPed-fiscal.cod-rota:SCREEN-VALUE IN FRAME fPage1 = loc-entr.cod-rota.
                    APPLY "LEAVE" TO ttPed-fiscal.cod-rota IN FRAME fPage1 .
                END.
            END.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttped-fiscal.cod-estabel IN FRAME fPage1 /* Estabelecimento Origem */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttped-fiscal.cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.cod-rota wMaintenanceNoNavigation
ON F5 OF ttped-fiscal.cod-rota IN FRAME fPage1 /* Rota */
DO:
    {include/zoomvar.i &prog-zoom=dizoom/z01di181.w
                        &campo=ttPed-fiscal.cod-rota
                        &campozoom=cod-rota
                        &FRAME=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.cod-rota wMaintenanceNoNavigation
ON LEAVE OF ttped-fiscal.cod-rota IN FRAME fPage1 /* Rota */
DO:
    FIND FIRST rota WHERE rota.cod-rota = ttPed-fiscal.cod-rota:SCREEN-VALUE IN FRAME fPage1 NO-LOCK NO-ERROR.
    IF AVAIL rota THEN
        ASSIGN cRota:SCREEN-VALUE IN FRAME fPage1 = rota.descricao.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.cod-rota wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttped-fiscal.cod-rota IN FRAME fPage1 /* Rota */
DO:
    APPLY 'F5' TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttped-fiscal.cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.cod-transp wMaintenanceNoNavigation
ON F5 OF ttped-fiscal.cod-transp IN FRAME fPage1 /* Transportadora */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad268.w
                        &campo=ttPed-fiscal.cod-transp
                        &campozoom=cod-transp
                        &FRAME=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.cod-transp wMaintenanceNoNavigation
ON LEAVE OF ttped-fiscal.cod-transp IN FRAME fPage1 /* Transportadora */
DO:
    {method/ReferenceFields.i
      &HandleDBOLeave="hDBOTransporte"
      &KeyValue1="ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1"
      &FieldName1="nome"
      &FieldScreen1="cNome-transp"
      &Frame1="fPage1"}
      DEF VAR c-cod-transp-padrao   AS INTEGER NO-UNDO.
      DEF VAR c-sigla-transp-padrao AS CHAR NO-UNDO.

      FIND emitente
          WHERE emitente.cod-emitente = int(fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0) NO-LOCK NO-ERROR.

      /* Busca Transportadora */ 
      RUN esp/crm/escrm107.p(INPUT ttPed-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fPage1,
                             INPUT string(emitente.cod-emitente),
                             INPUT emitente.cidade,
                             INPUT emitente.estado,
                             INPUT 0,
                             INPUT emitente.cep,
                             OUTPUT c-cod-transp-padrao,
                             OUTPUT c-sigla-transp-padrao).

       IF  c-cod-transp-padrao <> int(ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1) 
       AND int(fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0) <> 0 THEN DO:

           DEF VAR c-nome-transp-padrao AS CHAR FORMAT "X(12)" NO-UNDO.
           DEF VAR c-nome-transp-nova   AS CHAR FORMAT "X(12)" NO-UNDO.
           FOR FIRST transporte 
               WHERE transporte.cod-transp = INTEGER(c-cod-transp-padrao) NO-LOCK:
               ASSIGN c-nome-transp-padrao = transporte.nome-abrev.
           END.
           FOR FIRST transporte 
               WHERE transporte.cod-transp = INTEGER(ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1) NO-LOCK:
               ASSIGN c-nome-transp-nova = transporte.nome-abrev.
           END.
       
           RUN utp/ut-msgs.p (INPUT "show":U,
                              INPUT 17006,
                              INPUT "Vocà est† alterando a transportadora padr∆o estabelecida pela Log°stica Nacional. " + "~~" +
                                    "D£vidas entrar em contato com o setor."      + CHR(10) + 
                                    "Transportadora Padr∆o...: " + c-nome-transp-padrao + CHR(10) +
                                    "Transportadora Escolhida: " + c-nome-transp-nova).
       END.   

       IF ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1 = "0" AND ttPed-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fPage1 = "104" THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U,
                              INPUT 17006,
                              INPUT "Para a opá∆o retira no estab 104, favor utilizar a transportadora 668").
           RETURN NO-APPLY.
       END.
       ELSE IF ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1 = "668" AND ttPed-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fPage1 = "101" THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U,
                              INPUT 17006,
                              INPUT "Para a opá∆o retira no estab 101, favor utilizar a transportadora 0").
           RETURN NO-APPLY.
       END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.cod-transp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttped-fiscal.cod-transp IN FRAME fPage1 /* Transportadora */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME fi-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wMaintenanceNoNavigation
ON ENTRY OF fi-cod-emitente IN FRAME fpage0 /* Cliente */
DO:
    IF novo = 1 THEN DO:
        ASSIGN ttPed-fiscal.ct-codigo:VISIBLE IN FRAME fpage1 = NO.
    
        FIND FIRST usuar_univ NO-LOCK
            WHERE  usuar_univ.cod_usuario = c-seg-usuario NO-ERROR.
        IF AVAIL usuar_univ 
        THEN ASSIGN ttPed-Fiscal.sc-codigo:SCREEN-VALUE IN FRAME fpage1 = usuar_univ.cod_ccusto.
        ELSE ASSIGN ttPed-Fiscal.sc-codigo:SCREEN-VALUE IN FRAME fpage1 = ""
                    cCentroCusto:SCREEN-VALUE           IN FRAME fPage1 = "".              
    END. /* IF novo = 1 THEN DO: */

    APPLY "LEAVE" TO ttPed-Fiscal.sc-codigo IN FRAME fpage1.

    DISABLE ttped-fiscal.sc-codigo-rec c-estab-destino WITH FRAME fPage1.
    ASSIGN ttped-fiscal.sc-codigo-rec:SENSITIVE IN FRAME fPage1 = NO
           c-estab-destino:SENSITIVE            IN FRAME fPage1 = NO.

    ASSIGN ttped-fiscal.observacao[3]:SCREEN-VALUE IN FRAME fPage1 = ' Pedido nro: ' + ttped-fiscal.nr-pedido:SCREEN-VALUE IN FRAME fPage0.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wMaintenanceNoNavigation
ON F5 OF fi-cod-emitente IN FRAME fpage0 /* Cliente */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z02ad098.w
                        &campo=fi-cod-emitente
                        &campozoom=cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wMaintenanceNoNavigation
ON LEAVE OF fi-cod-emitente IN FRAME fpage0 /* Cliente */
DO:
    {method/ReferenceFields.i 
      &HandleDBOLeave="hDBOEmitente"
      &KeyValue1="fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="nome-emit"
      &FieldScreen1="cNome-emit"
      &Frame1="fPage0"}
      
   IF  ttped-fiscal.cod-emitente <> int(fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0) THEN
       FOR FIRST emitente NO-LOCK
           WHERE emitente.cod-emitente = int(fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0):
           FIND mgesp.int-emitente
                WHERE int-emitente.cod-emitente = emitente.cod-emitente
                NO-LOCK NO-ERROR.
           IF  NOT AVAIL int-emitente THEN DO:
               MESSAGE "Extens∆o do Cliente n∆o encontrada" VIEW-AS ALERT-BOX INFO BUTTONS OK. 
               RETURN "NOK".
           END.
           IF  emitente.cod-gr-cli <> 8 AND
               emitente.cod-gr-cli <> 9 and
               emitente.cod-gr-cli <> 10 and
               emitente.cod-gr-cli <> 15 and
               emitente.cod-gr-cli <> 16 then
               IF int-emitente.id-ativo = NO THEN DO:
                  MESSAGE "Atená∆o, Cliente est† Inativo" VIEW-AS ALERT-BOX INFO BUTTONS OK.
               END.
       END.
       ASSIGN c-transp = "":U.
       
       IF  pcAction <> "UPDATE" THEN DO:
           FIND FIRST emitente 
               WHERE emitente.cod-emitente = int(fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0) NO-LOCK NO-ERROR.
           IF  AVAIL emitente THEN DO:
               /* Busca Transportadora */ 
               IF  ttPed-fiscal.cod-estabel :SCREEN-VALUE IN FRAME fPage1 <> ''
               AND fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0 <> '' THEN DO:
                   RUN esp/crm/escrm107.p(INPUT ttPed-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fPage1,
                                          INPUT fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0,
                                          INPUT emitente.cidade,
                                          INPUT emitente.estado,
                                          INPUT 0,
                                          INPUT emitente.cep,
                                          OUTPUT c-transp,
                                          OUTPUT c-sigla-transp).
        
                    IF c-transp = ? THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 17567,
                                           INPUT "N∆o encontrada transportadora para relacionamento UF x Cidade x Cliente.").
        
                        ASSIGN ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1 = "".
        
                        RETURN "NOK":U.
                    END.
                    ELSE
                        ASSIGN ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1 = c-transp.
               END.
    
               APPLY "LEAVE" TO ttPed-fiscal.cod-transp IN FRAME fPage1.
    
               FOR FIRST loc-entr NO-LOCK
                   WHERE loc-entr.nome-abrev  = emitente.nome-abrev
                   AND   loc-entr.cod-entrega = "Padr∆o",
                   FIRST transporte
                   WHERE transporte.nome-abrev = loc-entr.nome-transp:
    
                   IF ttPed-fiscal.cod-rota:SCREEN-VALUE IN FRAME fPage1 = "" THEN DO:
                       ASSIGN ttPed-fiscal.cod-rota:SCREEN-VALUE IN FRAME fPage1 = loc-entr.cod-rota.
                       APPLY "LEAVE" TO ttPed-fiscal.cod-rota IN FRAME fPage1 .
                   END.
               END.
           END.
       END.

       ASSIGN c-emitente = fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-cod-emitente IN FRAME fpage0 /* Cliente */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttped-fiscal.motivo-urg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.motivo-urg wMaintenanceNoNavigation
ON LEAVE OF ttped-fiscal.motivo-urg IN FRAME fPage1
DO:

    IF LENGTH(ttped-fiscal.motivo-urg:SCREEN-VALUE IN FRAME fPage1) < 50 
    AND ttped-fiscal.prioridade:SCREEN-VALUE IN FRAME fPage1 = '2' THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Motivo Invalido!~~Motivo Urg. deve ter mais de 50 caracteres.").

        APPLY "entry" TO ttped-fiscal.motivo-urg IN FRAME fPage1.
        RETURN "NOK":U.
    END.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttped-fiscal.nat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.nat-oper wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttped-fiscal.nat-oper IN FRAME fPage1 /* Natureza de Operaá∆o */
DO:
    assign lg-habilita = no.

    do  with frame fpage1:

        FOR FIRST natureza-ped-fiscal NO-LOCK
            WHERE natureza-ped-fiscal.natureza = int(ttped-fiscal.nat-oper:SCREEN-VALUE):

            IF  natureza-ped-fiscal.informa-receptor  
            THEN ASSIGN c-receptor:SENSITIVE IN FRAME fPage1 = TRUE.
            ELSE ASSIGN c-receptor:SENSITIVE IN FRAME fPage1 = FALSE.

            IF  natureza-ped-fiscal.informa-finalidade
            THEN ASSIGN c-destino-1:SENSITIVE IN FRAME fPage1 = TRUE.
            ELSE ASSIGN c-destino-1:SENSITIVE IN FRAME fPage1 = FALSE.

        END. /* FOR FIRST natureza-ped-fiscal NO-LOCK */

       /* IF ttped-fiscal.cod-emitente:SCREEN-VALUE IN FRAME fpage0 = "103748"  AND 
           ttped-fiscal.cod-estabel:SCREEN-VALUE   = "104"    AND 
           ttped-fiscal.nat-oper:SCREEN-VALUE      = "25" THEN DO:

           ASSIGN ttped-fiscal.cod-transp:SCREEN-VALUE = "668".

           APPLY "leave":U TO ttped-fiscal.cod-transp.

        END. */
        
        /*
        CASE int(ttped-fiscal.nat-oper:SCREEN-VALUE):
            WHEN 04 THEN DO:
                ENABLE cb-destino.
                ASSIGN c-receptor:SCREEN-VALUE = "Setor de Controle Patrimonial"
                       cb-destino:SCREEN-VALUE = "6".
            END.
            WHEN 08 THEN DO:
                ENABLE cb-destino.
                ASSIGN c-destino-1:SCREEN-VALUE = "Sucateamento"
                       cb-destino:SCREEN-VALUE  = "1".
            END.
            WHEN 25 THEN DO:
                ENABLE cb-destino.
            END.
            OTHERWISE DO:
                ASSIGN c-receptor         = "".
                DISP c-receptor WITH FRAME fpage1.
            END. /* OTHERWISE DO: */
        END CASE.
        */

    END. /* do  with frame fpage1: */

    IF  CAN-FIND(FIRST natureza-ped-fiscal 
                 WHERE natureza-ped-fiscal.natureza = INT(SELF:SCREEN-VALUE IN FRAME fPage1)
                 AND   natureza-ped-fiscal.descricao MATCHES "*transfer*":U) 
    THEN do:
         ASSIGN cb-destino:SENSITIVE      IN FRAME fPage1 = TRUE
                c-estab-destino:SENSITIVE IN FRAME fPage1 = TRUE.

    end.
    ELSE ASSIGN cb-destino:SENSITIVE      IN FRAME fPage1 = FALSE
                c-estab-destino:SENSITIVE IN FRAME fPage1 = FALSE.

    if INT(SELF:SCREEN-VALUE IN FRAME fPage1) = 4 OR 
            INT(SELF:SCREEN-VALUE IN FRAME fPage1) = 22
       then assign lg-habilita = yes.

    if lg-habilita
    then assign ttped-fiscal.nr-contrato:sensitive    in frame fPage1 = yes
                ttped-fiscal.nr-contrato:screen-value in frame fPage1 = c-contrato-ant.
    else assign c-contrato-ant = input frame fPage1 ttped-fiscal.nr-contrato
                ttped-fiscal.nr-contrato:screen-value in frame fPage1 = ""
                ttped-fiscal.nr-contrato:sensitive    in frame fPage1 = no.

    IF  cb-destino:SENSITIVE    IN FRAME fPage1       THEN APPLY 'value-changed':U TO cb-destino IN FRAME fPage1.
    IF  c-receptor:SCREEN-VALUE IN FRAME fPage1 NE "" THEN APPLY 'leave':U         TO c-receptor IN FRAME fPage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttped-fiscal.prioridade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.prioridade wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttped-fiscal.prioridade IN FRAME fPage1
DO:
  
    IF ttped-fiscal.prioridade:SCREEN-VALUE IN FRAME fPage1 = '2' THEN
        ASSIGN ttped-fiscal.motivo-urg:SENSITIVE IN FRAME fPage1 = YES.
    ELSE 
        ASSIGN ttped-fiscal.motivo-urg:SENSITIVE IN FRAME fPage1 = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttped-fiscal.sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.sc-codigo wMaintenanceNoNavigation
ON F5 OF ttped-fiscal.sc-codigo IN FRAME fPage1 /* Centro de Custo do Aprovador */
DO:

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
    run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
        ASSIGN ttPed-fiscal.sc-codigo:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto
               cCentroCusto:SCREEN-VALUE IN FRAME fPage1 = v_des_titulo_ccusto.
               
        
    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.sc-codigo wMaintenanceNoNavigation
ON LEAVE OF ttped-fiscal.sc-codigo IN FRAME fPage1 /* Centro de Custo do Aprovador */
DO:
    
    ASSIGN cCentroCusto:SCREEN-VALUE IN FRAME fpage1 = "".  

    RUN prgint/utb/utb742za.py persistent set h_api_ccusto.

    ASSIGN v_cod_ccusto = INPUT FRAME fPage1 ttped-fiscal.sc-codigo.

    EMPTY TEMP-TABLE tt_log_erro.
    
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input TODAY,              /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    IF VALID-HANDLE(h_api_ccusto) THEN
        DELETE OBJECT h_api_ccusto.

    IF CAN-FIND(FIRST tt_log_erro) THEN DO:
        EMPTY TEMP-TABLE tt_log_erro.
        RETURN.
    END.

    ASSIGN cCentroCusto  :SCREEN-VALUE IN FRAME fpage1 = v_des_titulo_ccusto.  
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.sc-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttped-fiscal.sc-codigo IN FRAME fPage1 /* Centro de Custo do Aprovador */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttped-fiscal.sc-codigo-rec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.sc-codigo-rec wMaintenanceNoNavigation
ON F5 OF ttped-fiscal.sc-codigo-rec IN FRAME fPage1 /* Centro Custo Recebedor */
DO:
  
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
    run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
        ASSIGN ttPed-fiscal.sc-codigo-rec:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto
               cCentroCusto:SCREEN-VALUE IN FRAME fPage1             = v_des_titulo_ccusto.
               
        
    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.sc-codigo-rec wMaintenanceNoNavigation
ON LEAVE OF ttped-fiscal.sc-codigo-rec IN FRAME fPage1 /* Centro Custo Recebedor */
DO:
  
    ASSIGN cCentroCusto:SCREEN-VALUE IN FRAME fpage1 = "".  

    RUN prgint/utb/utb742za.py persistent set h_api_ccusto.

    ASSIGN v_cod_ccusto = INPUT FRAME fPage1 ttped-fiscal.sc-codigo-rec.

    EMPTY TEMP-TABLE tt_log_erro.
    
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,       /* CCUSTO */
                                               input TODAY,              /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */

    IF ttped-fiscal.sc-codigo-rec:SCREEN-VALUE IN FRAME fPage1 <> '' THEN DO:
        ASSIGN ttped-fiscal.observacao[4]:SCREEN-VALUE IN FRAME fPage1 = ' Ativo Imobilizado' +
                                                                         ' - ' + c-estab-destino      :SCREEN-VALUE IN FRAME fPage1 +
                                                                         ' - CC Recebedor: ' + ttped-fiscal.sc-codigo-rec:SCREEN-VALUE IN FRAME fPage1 .
    END. /* IF c-receptor:SCREEN-VALUE IN FRAME fPage1 <> '' THEN DO: */

    IF VALID-HANDLE(h_api_ccusto) THEN
        DELETE OBJECT h_api_ccusto.

    IF CAN-FIND(FIRST tt_log_erro) THEN DO:
        EMPTY TEMP-TABLE tt_log_erro.
        RETURN.
    END.

    ASSIGN cCentroCusto:SCREEN-VALUE IN FRAME fpage1 = v_des_titulo_ccusto.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttped-fiscal.sc-codigo-rec wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttped-fiscal.sc-codigo-rec IN FRAME fPage1 /* Centro Custo Recebedor */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 25  
    THEN ASSIGN cb-destino:SCREEN-VALUE  IN FRAME fpage1 = TRIM(SUBSTRING(ttped-fiscal.char-1,88,2)).
    ELSE ASSIGN c-destino-1:SCREEN-VALUE IN FRAME fpage1 = TRIM(SUBSTRING(ttped-fiscal.char-1,150,500)).
    
    ASSIGN c-receptor:SCREEN-VALUE      IN FRAME fpage1 = TRIM(SUBSTRING(ttped-fiscal.char-1,90,40))
           c-estab-destino:SCREEN-VALUE IN FRAME fpage1 = TRIM(SUBSTRING(ttped-fiscal.char-2,01,05)).

    ASSIGN fi-cod-emitente:SCREEN-VALUE IN FRAME fpage0  = string(ttped-fiscal.cod-emitente).
    
    DISPLAY ttPed-fiscal.situacao ttPed-fiscal.nr-pedido WITH FRAME fPage0.
    DISPLAY ttPed-fiscal.usuario-magnus ttPed-fiscal.nro-docto ttPed-fiscal.serie-docto WITH FRAME fpage1.

    ASSIGN cb-frete = 1.
    DISP cb-frete WITH FRAME fPage1.

    APPLY 'Leave' TO ttPed-fiscal.cod-transp   IN FRAME fPage1.
    APPLY 'Leave' TO ttPed-fiscal.cod-rota     IN FRAME fPage1.
    APPLY 'Leave' TO fi-cod-emitente           IN FRAME fPage0.
    APPLY 'Leave' TO c-receptor                IN FRAME fPage1.

    DISABLE ttped-fiscal.sc-codigo-rec c-estab-destino ttped-fiscal.nr-contrato WITH FRAME fPage1.

    APPLY 'value-chnaged':U TO ttped-fiscal.nat-oper IN FRAME fPage1.

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

    IF pcAction = "ADD" THEN DO:
       assign ttPed-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fpage1  = v_cod_estab_usuar.

       ASSIGN cb-frete = 1.
       DISP cb-frete WITH FRAME fPage1.

       IF ttped-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fpage1 = "104" THEN
           ASSIGN ttped-fiscal.cod-transp:SCREEN-VALUE IN FRAME fpage1 = "668".
       ELSE IF ttped-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fpage1 = "101" THEN
               ASSIGN ttped-fiscal.cod-transp:SCREEN-VALUE IN FRAME fpage1 = "0".

       APPLY 'Entry' TO fi-cod-emitente IN FRAME {&FRAME-NAME}.
    END. /* IF pcAction = "ADD" ... */
    ELSE DO:
        IF ttPed-fiscal.frete THEN ASSIGN cb-frete = 2.
                              ELSE ASSIGN cb-frete = 3.

        DISP cb-frete WITH FRAME fPage1.

        IF  pcAction = "COPY":U 
        THEN ENABLE c-cod-depos WITH FRAME fPage1.
        ELSE DO:
            IF  CAN-FIND(FIRST it-ped-fiscal NO-LOCK
                         WHERE it-ped-fiscal.nr-pedido = ttped-fiscal.nr-pedido) THEN
                DISABLE ttped-fiscal.cod-estabel WITH FRAME fPage1.
        END. /* ELSE DO: */
    END. /* ELSE DO: */

    ASSIGN c-emitente = fi-cod-emitente:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    IF pcAction = "Create" OR pcAction = "Copy" THEN
       ASSIGN ttPed-fiscal.dt-emissao:SCREEN-VALUE IN FRAME fpage1 = STRING(TODAY,"99/99/9999").

    DISABLE ttPed-fiscal.dt-emissao WITH FRAME fPage1. /* chamado 11364 */

    DISABLE cb-destino c-estab-destino ttped-fiscal.sc-codigo-rec WITH FRAME fPage1.
    ASSIGN ttped-fiscal.sc-codigo-rec:SENSITIVE IN FRAME fPage1 = NO.              

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
                                                         
ASSIGN OVERLAY(ttped-fiscal.char-1,90,40) = c-receptor:SCREEN-VALUE IN FRAME fpage1.
       
IF  int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 25  
THEN ASSIGN OVERLAY(ttped-fiscal.char-1,88,2)  = cb-destino:SCREEN-VALUE IN FRAME fpage1.
ELSE ASSIGN OVERLAY(ttped-fiscal.char-1,150,500) = TRIM(c-destino-1:SCREEN-VALUE IN FRAME fpage1).

IF  cb-destino:SCREEN-VALUE IN FRAME fPage1 = '6' /* Ativo Imobilizado */ 
THEN ASSIGN OVERLAY(ttped-fiscal.char-2,01,05) = c-estab-destino:SCREEN-VALUE IN FRAME fPage1.


ASSIGN ttped-fiscal.cod-emitente = INT(fi-cod-emitente:SCREEN-VALUE IN FRAME fpage0).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-naturezas AS CHARACTER   NO-UNDO.

    FOR EACH natureza-ped-fiscal NO-LOCK:
        IF c-naturezas <> '' THEN
            ASSIGN c-naturezas = c-naturezas + ',' + string(natureza-ped-fiscal.natureza) + ' - ' + natureza-ped-fiscal.descricao + ',' + string(natureza-ped-fiscal.natureza).
        ELSE 
            ASSIGN c-naturezas = string(natureza-ped-fiscal.natureza) + ' - ' + natureza-ped-fiscal.descricao + ',' + string(natureza-ped-fiscal.natureza).
    END. /* FOR EACH natureza-ped-fiscal NO-LOCK: */
    ASSIGN ttped-fiscal.nat-oper:LIST-ITEM-PAIRS IN FRAME fpage1 = ',0,' + c-naturezas.

    FIND FIRST param-global NO-LOCK.

    ASSIGN ttPed-fiscal.sc-codigo:FORMAT IN FRAME fPage1 = "X(20)".
           
    fi-cod-emitente :LOAD-MOUSE-POINTER  ('image/lupa.cur') IN FRAME fPage0.
    ttped-fiscal.cod-estabel  :LOAD-MOUSE-POINTER  ('image/lupa.cur') IN FRAME fPage1.
    ttPed-fiscal.cod-transp   :LOAD-MOUSE-POINTER  ('image/lupa.cur') IN FRAME fPage1.
    ttPed-fiscal.cod-rota     :LOAD-MOUSE-POINTER  ('image/lupa.cur') IN FRAME fPage1.
    ttPed-fiscal.sc-codigo    :LOAD-MOUSE-POINTER  ('image/lupa.cur') IN FRAME fPage1.
    ttPed-fiscal.sc-codigo-rec:LOAD-MOUSE-POINTER  ('image/lupa.cur') IN FRAME fPage1.
    c-estab-destino           :LOAD-MOUSE-POINTER  ('image/lupa.cur') IN FRAME fPage1.

    DISABLE c-receptor cb-destino c-estab-destino ttPed-fiscal.sc-codigo-rec ttPed-fiscal.motivo-urg WITH FRAME fPage1.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    CASE INPUT FRAME fPage1 cb-frete:
        WHEN 2 THEN ASSIGN ttped-fiscal.frete = YES.
        WHEN 3 THEN ASSIGN ttped-fiscal.frete = NO.
        OTHERWISE   ASSIGN ttped-fiscal.frete = ?.
    END CASE.



    IF  cb-destino                :SCREEN-VALUE IN FRAME fPage1 = '6'
    AND ttped-fiscal.nat-oper     :SCREEN-VALUE IN FRAME fPage1 = '25 - Transferància entre Estab.' 
    AND ttped-fiscal.sc-codigo-rec:SCREEN-VALUE IN FRAME fPage1 = '' THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Centro de Custo Recebedor Inv†lido!":U + "~~":U +
                                 "Informar Centro de Custo Recebedor.":U).
        APPLY "ENTRY":U TO ttped-fiscal.sc-codigo-rec IN FRAME fPage1.
        RETURN "NOK":U.
    END.
    
    IF  ttped-fiscal.prioridade:SCREEN-VALUE IN FRAME fPage1 = '2' 
    AND ttped-fiscal.motivo-urg:SCREEN-VALUE IN FRAME fPage1 = '' THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Motivo Urgente Inv†lido!":U + "~~":U +
                                 "Informar Motivo pelo qual o pedido Ç urgente.":U).
        APPLY "ENTRY":U TO ttped-fiscal.motivo-urg IN FRAME fPage1.
        RETURN "NOK":U.
    END.
    

    /* Grava o dep¢sito somente quando Ç c¢pia e o dep¢sito deve ser alterado (foi informado) */
    IF  pcAction = "COPY":U THEN DO:
        IF  INPUT FRAME fPage1 c-cod-depos <> "" THEN DO:
            IF NOT CAN-FIND(FIRST deposito NO-LOCK
                            WHERE deposito.cod-depos = INPUT FRAME fPage1 c-cod-depos) THEN DO:
                MESSAGE "Dep¢sito informado inexistente!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "NOK":U.
            END.
        END.

        ASSIGN OVERLAY(ttPed-fiscal.char-1,7,3) = INPUT FRAME fPage1 c-cod-depos.
    END.
    
    FIND emitente
        WHERE emitente.cod-emitente = INPUT FRAME fpage0 fi-cod-emitente NO-LOCK NO-ERROR.

    FIND mgesp.int-emitente
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    IF NOT AVAIL int-emitente THEN DO:
        MESSAGE "Extens∆o do Cliente n∆o encontrada" VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    IF emitente.identific = 2 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Destinatario Habilitado somente como Fornecedor, Transforme em Cliente no CRM para permitir emitir nota fiscal extra!":U + "~~":U +
                                 "Destinatario Habilitado somente como Fornecedor, Transforme em Cliente no CRM para permitir emitir nota fiscal extra":U).
        APPLY "ENTRY":U TO cb-frete IN FRAME fPage1.
        RETURN "NOK":U.
    END.

    FIND natureza-ped-fiscal NO-LOCK
        WHERE natureza-ped-fiscal.natureza = INT(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) NO-ERROR.

    IF emitente.cod-gr-cli <> 8  and
       emitente.cod-gr-cli <> 9  and
       emitente.cod-gr-cli <> 10 and
       emitente.cod-gr-cli <> 15 and
       emitente.cod-gr-cli <> 16 then
        IF (int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 26 OR
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 27 OR
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 01 OR       /* Incidente 5054 Tarefa 8937 */
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 06 OR
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 07 OR
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 09 OR
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 15 OR
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 16 OR
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 18 OR
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 21 OR
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 11 OR       /* 11 e 08 Incidente 5056 Tarefa 8941 */
            int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) = 08) THEN DO:
            IF (emitente.natureza = 1 or
                emitente.ins-estadual = "ISENTO" OR
                emitente.ins-estadual = "ISENTA" OR
                emitente.ins-estadual = "") AND
                emitente.contrib-icms = NO THEN .
            ELSE DO:
                IF int-emitente.id-ativo = NO THEN DO:
                    MESSAGE "Cliente Inativo, N∆o Ç Poss°vel incluir solicitaá∆o de NF" VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN "NOK".
                END.
            END.
        END.
        ELSE
            IF int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) <> 6 AND
               int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) <> 10 THEN
                IF int-emitente.id-ativo = NO THEN DO:
                    MESSAGE "Cliente Inativo, N∆o Ç Poss°vel incluir solicitaá∆o de NF" VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN "NOK".
                END.

    IF  pcAction = "Create" OR pcAction = "Copy" THEN
        ASSIGN ttPed-fiscal.serie        = ""
               ttPed-fiscal.nr-nota-fis  = ""
               ttPed-fiscal.seq-wt-docto = 0
               ttPed-fiscal.motivo       = "".

    IF ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1 = "08" OR ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1 = "09" THEN DO:
        ASSIGN ttped-fiscal.situacao          = 2   
               ttped-fiscal.supervisor        = ""
               ttped-fiscal.dt-aprovacao      = TODAY.
    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(hDBOEmitente) OR
       hDBOEmitente:TYPE <> "PROCEDURE":U OR
       hDBOEmitente:FILE-NAME <> "adbo/boad098na.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad098na.p YES}
        {btb/btb008za.i2 adbo/boad098na.p '' hDBOEmitente} 
    END.
    RUN openQueryStatic IN hDBOEmitente (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(hDBOTransporte) OR
       hDBOTransporte:TYPE <> "PROCEDURE":U OR
       hDBOTransporte:FILE-NAME <> "adbo/boad268na.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad268na.p YES}
        {btb/btb008za.i2 adbo/boad268na.p '' hDBOTransporte} 
    END.
    RUN openQueryStatic IN hDBOTransporte (INPUT "Main":U) NO-ERROR.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord wMaintenanceNoNavigation 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-tem-cc-mapa AS LOGICAL     NO-UNDO.

    FIND FIRST natureza-ped-fiscal NO-LOCK
        WHERE  natureza-ped-fiscal.natureza = int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1) NO-ERROR.

    IF  NOT AVAIL natureza-ped-fiscal 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Natureza n∆o cadastrada.":U + "~~":U +
                                 "Natureza informada n∆o existe cadastrada no programa ESFTP059. Verifique.":U).
        APPLY "ENTRY":U TO ttped-fiscal.nat-oper IN FRAME fPage1.
        RETURN "NOK":U.
    END.


    IF LENGTH(ttped-fiscal.motivo-urg:SCREEN-VALUE IN FRAME fPage1) < 50 
    AND ttped-fiscal.prioridade:SCREEN-VALUE IN FRAME fPage1 = '2' THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Motivo Invalido!~~Motivo Urg. deve ter mais de 50 caracteres.").

        APPLY "entry" TO ttped-fiscal.motivo-urg IN FRAME fPage1.
        RETURN "NOK":U.
    END.

    IF INPUT FRAME fPage1 cb-frete = 1 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Frete (CIF ou FOB) n∆o selecionado!":U + "~~":U +
                                 "O Frete (CIF - Frete Pago ou FOB - Frete a pagar) n∆o foi selecionado.":U).
        APPLY "ENTRY":U TO cb-frete IN FRAME fPage1.
        RETURN "NOK":U.
    END.


    IF  natureza-ped-fiscal.informa-receptor    = YES AND 
        c-receptor:SCREEN-VALUE IN FRAME fpage1 = "" 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Receptor da Mercadoria n∆o informado!":U + "~~":U +
                                 "Receptor da Mercadoria n∆o informado":U).
        RETURN "NOK":U.
    END.

    IF  cb-destino:SENSITIVE IN FRAME fpage1 AND 
        int(cb-destino:SCREEN-VALUE IN FRAME fpage1) = 1 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Destino n∆o selecionado!":U + "~~":U +
                                 "Destino n∆o selecionado":U).
        RETURN "NOK":U.
    END.


    IF  natureza-ped-fiscal.informa-receptor            = YES AND
        LENGTH(c-receptor:SCREEN-VALUE IN FRAME fpage1) < 10
    THEN DO:
        run utp/ut-msgs.p (input "show", 
                           input 17006, 
                           input "Preencha o campo quem ir† receber com mais detalhes, informando no m°nimo 10 posiá‰es.").
        return 'NOK':U.
    END.

    IF  natureza-ped-fiscal.informa-finalidade = YES AND
        LENGTH(TRIM(c-destino-1:SCREEN-VALUE IN FRAME fpage1)) < 20 
    THEN DO:
        run utp/ut-msgs.p (input "show":U, 
                           input 17006, 
                           input "Preencha o campo finalidade com mais detalhes, informando no m°nimo 20 posiá‰es").
        return 'NOK':U.
    END.


    IF  NOT CAN-FIND(FIRST int-natur-est-mapa
                     WHERE int-natur-est-mapa.natureza    = int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1)
                     AND   int-natur-est-mapa.cod-estabel = STRING(INPUT FRAME fPage1 ttped-fiscal.cod-estabel)) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Mapa de Distribuiá∆o de Centro de Custo n∆o relacionado.":U + "~~":U +
                                 "N∆o existe relacionamento de Mapa de Distribuiá∆o de Centro de Custo no programa ESFTP059. Verifique com o GRUPO CONTµBIL.":U).
        APPLY "ENTRY":U TO ttped-fiscal.cod-estabel IN FRAME fPage1.
        RETURN "NOK":U.                
    END.
    ELSE DO:
        ASSIGN l-tem-cc-mapa = NO.
        bloco-mapa-1:
        FOR EACH  int-natur-est-mapa NO-LOCK
            WHERE int-natur-est-mapa.natureza    = int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1)
            AND   int-natur-est-mapa.cod-estabel = STRING(INPUT FRAME fPage1 ttped-fiscal.cod-estabel):

            FOR EACH  item_lista_ccusto NO-LOCK
                WHERE item_lista_ccusto.cod_estab               = int-natur-est-mapa.cod-estabel
                  AND item_lista_ccusto.cod_mapa_distrib_ccusto = int-natur-est-mapa.cod-mapa-distrib-cc
                  AND item_lista_ccusto.cod_empresa             = i-ep-codigo-usuario
                  AND item_lista_ccusto.cod_plano_ccusto        = 'Padrao':U
                  AND item_lista_ccusto.cod_ccusto              = STRING(INPUT FRAME fPage1 ttped-fiscal.sc-codigo):

                ASSIGN l-tem-cc-mapa = YES.
                LEAVE bloco-mapa-1.
            END. /* IF  NOT CAN-FIND(FIRST item_lista_ccusto */
        END. /* FOR EACH  int-natur-est-mapa NO-LOCK */

        IF  l-tem-cc-mapa = NO
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Centro de Custo inv†lido.":U + "~~":U +
                                     "Centro de Custo n∆o consta na lista do Mapa relacionado no programa ESFTP059 ou o Mapa informado n∆o est† relacionado ao estabelecimento " + 
                                     STRING(INPUT FRAME fPage1 ttped-fiscal.cod-estabel) + ". Verifique com o GRUPO CONTµBIL.":U).
            APPLY "ENTRY":U TO ttped-fiscal.sc-codigo IN FRAME fPage1.
            RETURN "NOK":U.
        END.
    END. /* ELSE DO: */


    /*---[  ESTABELECIMENTO RECEBEDOR ( DESTINO ) ]-------------------------------------*/
    IF  ttped-fiscal.sc-codigo-rec:SENSITIVE IN FRAME fPage1 
    AND STRING(INPUT FRAME fPage1 ttped-fiscal.sc-codigo-rec) NE "" THEN DO:
        IF  NOT CAN-FIND(FIRST int-natur-est-mapa
                         WHERE int-natur-est-mapa.natureza    = int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1)
                         AND   int-natur-est-mapa.cod-estabel = STRING(INPUT FRAME fPage1 c-estab-destino)) THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Mapa de Distrib.CCusto n∆o relacionado ao estabelecimento destino.":U + "~~":U +
                                     "N∆o existe relacionamento de Mapa de Distribuiá∆o de Centro de Custo no programa ESFTP059 com esta natureza e estabelecimento destino. Verifique com o GRUPO CONTµBIL.":U).
            APPLY "ENTRY":U TO c-estab-destino IN FRAME fPage1.
            RETURN "NOK":U.                
        END.
        ELSE DO:
            ASSIGN l-tem-cc-mapa = NO.
            bloco-mapa-2:
            FOR EACH  int-natur-est-mapa NO-LOCK
                WHERE int-natur-est-mapa.natureza    = int(ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1)
                AND   int-natur-est-mapa.cod-estabel = STRING(INPUT FRAME fPage1 c-estab-destino):

                FOR EACH item_lista_ccusto 
                    WHERE item_lista_ccusto.cod_estab               = int-natur-est-mapa.cod-estabel
                      AND item_lista_ccusto.cod_mapa_distrib_ccusto = int-natur-est-mapa.cod-mapa-distrib-cc
                      AND item_lista_ccusto.cod_empresa             = i-ep-codigo-usuario
                      AND item_lista_ccusto.cod_plano_ccusto        = 'Padrao':U
                      AND item_lista_ccusto.cod_ccusto              = STRING(INPUT FRAME fPage1 ttped-fiscal.sc-codigo-rec):

                    ASSIGN l-tem-cc-mapa = YES.
                    LEAVE bloco-mapa-2.
                END. /* IF  NOT CAN-FIND(FIRST item_lista_ccusto */
            END. /* FOR EACH  int-natur-est-mapa NO-LOCK */

            IF  l-tem-cc-mapa = NO
            THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Centro de Custo inv†lido.":U + "~~":U +
                                         "Centro de Custo n∆o consta na lista do Mapa relacionado no programa ESFTP059 ou o Mapa informado n∆o est† relacionado ao estabelecimento destino" + 
                                         STRING(INPUT FRAME fPage1 c-estab-destino) + ". Verifique com o GRUPO CONTµBIL.":U).
                APPLY "ENTRY":U TO ttped-fiscal.sc-codigo-rec IN FRAME fPage1.
                RETURN "NOK":U.
            END.
        END. /* ELSE DO: */
    END. /* IF  ttped-fiscal.sc-codigo-rec:SENSITIVE IN FRAME fPage1 THEN DO: */

    IF ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1 = "04" THEN DO: /*Transfer imobilizado*/
       for EACH mgesp.ponto-programa
          where ponto-programa.nome-programa = "esftp012a"
            AND ponto-programa.ponto         = 1,
          FIRST mgesp.conteudo-programa NO-LOCK
          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
            AND conteudo-programa.conteudo     = fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0 :

           IF conteudo-programa.seq <> int(ttPed-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fPage1) THEN DO:

                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Pedidos com natureza 4 devem ser criados para o mesmo cliente e estabelecimento de origem.":U + "~~":U +
                                         "Cliente 103748 Œ Estabelecimento Origem: 101" + CHR(13) +
                                         "Cliente 141000 - Estabelecimento Origem: 104"  ).
                APPLY "ENTRY":U TO fi-cod-emitente IN FRAME fPage0.
                RETURN "NOK":U.

           END.
       END.

       FOR EACH mgesp.ponto-programa
           WHERE ponto-programa.nome-programa = "esftp012a"
            AND ponto-programa.ponto         = 2,
          FIRST mgesp.conteudo-programa NO-LOCK
          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
            AND conteudo-programa.seq = int(ttPed-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fPage1):

           IF ttPed-fiscal.cod-transp:SCREEN-VALUE IN FRAME fPage1 <> ENTRY(1,conteudo-programa.conteudo,";") THEN DO:

               RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Pedidos com natureza 4 deve se usar transportadora correta de acordo com estabelecimento de origem.":U + "~~":U +
                                         " Transportadora - 0   Œ Estabelecimento Origem: 101" + CHR(13) +
                                         " Transportadora - 123 - Estabelecimento Origem: 103" + CHR(13) +
                                         " Transportadora - 668 - Estabelecimento Origem: 104" + CHR(13) +  
                                         " Transportadora - 105 - Estabelecimento Origem: 105" + CHR(13) + 
                                         " Transportadora - 899 - Estabelecimento Origem: 110" ).
                APPLY "ENTRY":U TO ttped-fiscal.cod-transp IN FRAME fPage1.
                RETURN "NOK":U.

           END.
           
       END. 
    END.
    
    IF ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1 = "25" OR
       ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1 = "26" OR
       ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1 = "36" OR
       ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1 = "37" THEN DO: /*Transferencia entre estabelecimentos*/
      FOR EACH mgesp.ponto-programa
          WHERE ponto-programa.nome-programa = "esftp012a"
            AND ponto-programa.ponto         = 1,
          FIRST mgesp.conteudo-programa NO-LOCK
          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
            AND conteudo-programa.conteudo     = fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0:

         IF conteudo-programa.seq = int(ttPed-fiscal.cod-estabel:SCREEN-VALUE IN FRAME fPage1) THEN DO:
              
             RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                 INPUT 17006,
                                 INPUT "Pedidos com natureza 25 26 36 37 nío devem ser criados para mesmo cliente e estabelecimento de origem.":U + "~~":U +
                                       "Cliente 103748 - Estabelecimento Origem: 101" + CHR(13) +
                                       "Cliente 159767 - Estabelecimento Origem: 103" + CHR(13) +
                                       "Cliente 141000 - Estabelecimento Origem: 104" + CHR(13) +
                                       "Cliente 143524 - Estabelecimento Origem: 105" + CHR(13) +
                                       "Cliente 280498 - Estabelecimento Origem: 110" ).
              APPLY "ENTRY":U TO fi-cod-emitente IN FRAME fPage0.
              RETURN "NOK":U.
         END.
      END.
    END.
    
    IF ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1 = "25" OR ttped-fiscal.nat-oper:SCREEN-VALUE IN FRAME fpage1 = "26" THEN DO: /*Transfer imobilizado*/ 
       for EACH mgesp.ponto-programa                                                                                                                            
          where ponto-programa.nome-programa = "esftp012a"                                                                                                      
            AND ponto-programa.ponto         = 1,                                                                                                               
          EACH mgesp.conteudo-programa NO-LOCK                                                                                                                  
          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:                                                                                   
                                                                                                                                                                
           IF fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0 = ENTRY(1,conteudo-programa.conteudo,";") AND INPUT FRAME fPage1 cb-frete <> 3 THEN DO:    
                RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                                                                              
                                   INPUT 17006,                                                                                                                 
                                   INPUT "Pedidos com natureza 25 ou 26 deve conter frete tipo FOB.").                                                          
                APPLY "ENTRY":U TO fi-cod-emitente IN FRAME fPage0.                                                                                   
                RETURN "NOK":U.                                                                                                                                 
           END.                                                                                                                                                 
        END.                                                                                                                                                    
    END. 

        
    empty temp-table tt_log_erro.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

    run pi_busca_dados_ccusto in h_api_ccusto (INPUT i-ep-codigo-usuario,
                                               INPUT "",
                                               input INPUT FRAME fPage1 ttped-fiscal.sc-codigo,
                                               INPUT TODAY,
                                               output v_des_titulo_ccusto,
                                               OUTPUT TABLE tt_log_erro).
    if  can-find (first tt_log_erro) 
    then do:
        run utp/ut-msgs.p (input "show", 
                           input 56, 
                           input "Centro de Custo / Refugo").
        return 'NOK':U.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

