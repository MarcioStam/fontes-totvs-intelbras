&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcomp-familia-item NO-UNDO LIKE comp-familia-item
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttfamilia-item NO-UNDO LIKE familia-item
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
{include/i-prgvrs.i ESCEP034D 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESCEP034D
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels        

&GLOBAL-DEFINE ttTable           ttcomp-familia-item
&GLOBAL-DEFINE hDBOTable         hboes032
&GLOBAL-DEFINE DBOTable          comp-familia-item

&GLOBAL-DEFINE ttParent          ttfamilia-item
&GLOBAL-DEFINE DBOParent         familia-item

&GLOBAL-DEFINE page0KeyFields    ttcomp-familia-item.cod-sub-familia ttcomp-familia-item.Descricao ttcomp-familia-item.cod-car-familia ttcomp-familia-item.cod-comp-familia
&GLOBAL-DEFINE page0Fields       ttcomp-familia-item.abreviatura ttcomp-familia-item.cod-sub-familia~
                                 ttcomp-familia-item.Descricao ttcomp-familia-item.cod-car-familia~
                                 ttcomp-familia-item.cod-comp-familia cb-tipo-requis fi-ciclo-contag~
                                 fi-deposito-pad fi-desc-ingles fi-meses-validade fi-nivel fi-pad-nomenc~
                                 fi-perc-nqa fi-perc-perda fi-periodo-fixo fi-res-for-comp fi-tempo-segur~
                                 fi-un rs-criticidade fi-cod-unid-negoc fi-descricao tb-contr-qualid tb-fraciona tb-loc-unica
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

&GLOBAL-DEFINE hDBOSon1         hboes174
&GLOBAL-DEFINE hDBOSon2         hboes026

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.
/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE shared VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE shared VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
def var hboin084 as handle no-undo.
def var hboin745 as handle no-undo.

def temp-table tt-comp-familia-ext no-undo
     field meses-validade like int-familia.meses-validade    
     field perc-nqa like familia.perc-nqa              
     field nivel like familia.nivel                 
     field contr-qualid like familia.contr-qualid          
     field criticidade like familia.criticidade           
     field deposito-pad like familia.deposito-pad          
     field loc-unica like familia.loc-unica             
     field tipo-requis like familia.tipo-requis           
     field ciclo-contag like familia.ciclo-contag          
     field fraciona like familia.fraciona              
     field un like familia.un                    
     field tempo-segur like familia.tempo-segur           
     field res-for-comp like familia.res-for-comp          
     field periodo-fixo like familia.periodo-fixo          
     field perc-perda like int-familia.perc-perda        
     field desc-ingles like int-familia.desc-ingles       
     field pad-nomenc like int-familia.pad-nomenc
     FIELD cod-unid-negoc LIKE familia-mat.cod-unid-negoc.

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.
def var wh-pesquisa as widget-handle no-undo.
{upc/btb910za-upc.i}

DEFINE VARIABLE i-nr-sub-familia AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-car-familia AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttcomp-familia-item.cod-sub-familia ~
ttcomp-familia-item.cod-car-familia ttcomp-familia-item.cod-comp-familia ~
ttcomp-familia-item.descricao ttcomp-familia-item.abreviatura 
&Scoped-define ENABLED-TABLES ttcomp-familia-item
&Scoped-define FIRST-ENABLED-TABLE ttcomp-familia-item
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtFields fi-ciclo-contag ~
fi-meses-validade tb-fraciona fi-perc-nqa fi-un fi-nivel fi-tempo-segur ~
tb-contr-qualid fi-res-for-comp rs-criticidade fi-periodo-fixo ~
fi-deposito-pad fi-perc-perda tb-loc-unica fi-desc-ingles cb-tipo-requis ~
fi-pad-nomenc fi-cod-unid-negoc btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttcomp-familia-item.cod-sub-familia ~
ttcomp-familia-item.cod-car-familia ttcomp-familia-item.cod-comp-familia ~
ttcomp-familia-item.descricao ttcomp-familia-item.abreviatura 
&Scoped-define DISPLAYED-TABLES ttcomp-familia-item
&Scoped-define FIRST-DISPLAYED-TABLE ttcomp-familia-item
&Scoped-Define DISPLAYED-OBJECTS fi-sub-Descricao fi-car-Descricao ~
fi-ciclo-contag fi-meses-validade tb-fraciona fi-perc-nqa fi-un fi-nivel ~
fi-tempo-segur tb-contr-qualid fi-res-for-comp rs-criticidade ~
fi-periodo-fixo fi-deposito-pad fi-nome fi-perc-perda tb-loc-unica ~
fi-desc-ingles cb-tipo-requis fi-pad-nomenc fi-cod-unid-negoc fi-descricao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fi-ciclo-contag fi-meses-validade tb-fraciona ~
fi-perc-nqa fi-un fi-nivel fi-tempo-segur tb-contr-qualid fi-res-for-comp ~
rs-criticidade fi-periodo-fixo fi-deposito-pad fi-perc-perda tb-loc-unica ~
fi-desc-ingles cb-tipo-requis fi-pad-nomenc fi-cod-unid-negoc fi-descricao 

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

DEFINE VARIABLE cb-tipo-requis AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "Tipo Requisiá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Normal","1",
                     "Transferància","2",
                     "DÇbito GGF","3"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-car-Descricao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 36.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ciclo-contag AS INTEGER FORMAT ">>9" INITIAL 180 
     LABEL "Ciclo Contagem":R17 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidade de Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-deposito-pad AS CHARACTER FORMAT "x(03)" INITIAL "ALM" 
     LABEL "Dep¢sito Padr∆o":R18 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-ingles AS CHARACTER FORMAT "x(30)" 
     LABEL "Desc. Inglàs" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19.71 BY .88 NO-UNDO.

DEFINE VARIABLE fi-meses-validade AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Meses Validade" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nivel AS INTEGER FORMAT "9" INITIAL 4 
     LABEL "N°vel":R7 
     VIEW-AS FILL-IN 
     SIZE 2.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fi-pad-nomenc AS CHARACTER FORMAT "x(25)" 
     LABEL "Padr∆o Nomenclatura" 
     VIEW-AS FILL-IN 
     SIZE 26.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-nqa AS DECIMAL FORMAT ">>>9.99" INITIAL 0 
     LABEL "NQA":R4 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-perda AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "% Perda" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-fixo AS INTEGER FORMAT ">>9" INITIAL 1 
     LABEL "Per°odo Fixo":R15 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-res-for-comp AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Ressupr Fornec":R17 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88.

DEFINE VARIABLE fi-sub-Descricao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 36.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tempo-segur AS INTEGER FORMAT ">>9" INITIAL 7 
     LABEL "Tempo Segur":R14 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-un AS CHARACTER FORMAT "xx" 
     LABEL "Unid Padr∆o":R14 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE rs-criticidade AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "X", 1,
"Y", 2,
"Z", 3
     SIZE 14.72 BY .83 NO-UNDO.

DEFINE RECTANGLE rtFields
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 10.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tb-contr-qualid AS LOGICAL INITIAL yes 
     LABEL "Controle Qualidade":R22 
     VIEW-AS TOGGLE-BOX
     SIZE 23.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-fraciona AS LOGICAL INITIAL no 
     LABEL "Quantidade Fracionada":L25 
     VIEW-AS TOGGLE-BOX
     SIZE 27.29 BY .83 NO-UNDO.

DEFINE VARIABLE tb-loc-unica AS LOGICAL INITIAL no 
     LABEL "Localizaá∆o Ènica":L21 
     VIEW-AS TOGGLE-BOX
     SIZE 22.86 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttcomp-familia-item.cod-sub-familia AT ROW 1.17 COL 13 COLON-ALIGNED WIDGET-ID 4
          LABEL "Sub Fam°lia"
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     fi-sub-Descricao AT ROW 1.17 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 14 NO-TAB-STOP 
     ttcomp-familia-item.cod-car-familia AT ROW 2.17 COL 13 COLON-ALIGNED WIDGET-ID 10
          LABEL "Car Fam°lia"
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     fi-car-Descricao AT ROW 2.17 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 16 NO-TAB-STOP 
     ttcomp-familia-item.cod-comp-familia AT ROW 3.17 COL 13 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 2.29 BY .88
     ttcomp-familia-item.descricao AT ROW 4.17 COL 13 COLON-ALIGNED WIDGET-ID 6
          LABEL "Descriá∆o"
          VIEW-AS FILL-IN 
          SIZE 36.14 BY .88
     ttcomp-familia-item.abreviatura AT ROW 5.38 COL 13 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     fi-ciclo-contag AT ROW 5.38 COL 56 COLON-ALIGNED WIDGET-ID 26
     fi-meses-validade AT ROW 6.38 COL 13 COLON-ALIGNED WIDGET-ID 20
     tb-fraciona AT ROW 6.38 COL 58 HELP
          "Informe se a quantidade pode ser fracionada" WIDGET-ID 36
     fi-perc-nqa AT ROW 7.38 COL 13 COLON-ALIGNED HELP
          "N°vel da Qualidade Aceit†vel" WIDGET-ID 42
     fi-un AT ROW 7.38 COL 56 COLON-ALIGNED HELP
          "Unidade Padr∆o da Fam°lia" WIDGET-ID 54
     fi-nivel AT ROW 8.38 COL 13 COLON-ALIGNED HELP
          "N°vel de Inspeá∆o a ser utilizado" WIDGET-ID 40
     fi-tempo-segur AT ROW 8.38 COL 56 COLON-ALIGNED WIDGET-ID 48
     tb-contr-qualid AT ROW 9.38 COL 15 HELP
          "Indica se item sofre CQ" WIDGET-ID 28
     fi-res-for-comp AT ROW 9.38 COL 56 COLON-ALIGNED HELP
          "Tempo de Ressuprimento do Fornecedor" WIDGET-ID 46
     rs-criticidade AT ROW 10.38 COL 15 NO-LABEL WIDGET-ID 30
     fi-periodo-fixo AT ROW 10.38 COL 56 COLON-ALIGNED HELP
          "ê o per°odo fixo padr∆o para os itens da fam°lia" WIDGET-ID 44
     fi-deposito-pad AT ROW 11.38 COL 13 COLON-ALIGNED WIDGET-ID 34
     fi-nome AT ROW 11.38 COL 20.72 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL WIDGET-ID 66 NO-TAB-STOP 
     fi-perc-perda AT ROW 11.38 COL 56 COLON-ALIGNED WIDGET-ID 24
     tb-loc-unica AT ROW 12.38 COL 15 HELP
          "Indica se localizaá∆o f°sica e £nica" WIDGET-ID 38
     fi-desc-ingles AT ROW 12.38 COL 56 COLON-ALIGNED WIDGET-ID 18
     cb-tipo-requis AT ROW 13.38 COL 13 COLON-ALIGNED WIDGET-ID 60
     fi-pad-nomenc AT ROW 13.38 COL 56 COLON-ALIGNED WIDGET-ID 22
     fi-cod-unid-negoc AT ROW 14.38 COL 56 COLON-ALIGNED WIDGET-ID 68
     fi-descricao AT ROW 14.38 COL 62.29 COLON-ALIGNED NO-LABEL WIDGET-ID 70 NO-TAB-STOP 
     btOK AT ROW 15.75 COL 2
     btSave AT ROW 15.75 COL 13
     btCancel AT ROW 15.75 COL 24
     btHelp AT ROW 15.75 COL 80
     "Criticidade:" VIEW-AS TEXT
          SIZE 7.43 BY .54 AT ROW 10.5 COL 7 WIDGET-ID 56
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 15.5 COL 1
     rtFields AT ROW 5.25 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcomp-familia-item T "?" NO-UNDO mgesp comp-familia-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttfamilia-item T "?" NO-UNDO mgesp familia-item
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
         HEIGHT             = 16
         WIDTH              = 90
         MAX-HEIGHT         = 24.13
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 24.13
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR COMBO-BOX cb-tipo-requis IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN ttcomp-familia-item.cod-car-familia IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttcomp-familia-item.cod-sub-familia IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttcomp-familia-item.descricao IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-car-Descricao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ciclo-contag IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-cod-unid-negoc IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-deposito-pad IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-desc-ingles IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fpage0
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-meses-validade IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-nivel IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pad-nomenc IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-perc-nqa IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-perc-perda IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-periodo-fixo IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-res-for-comp IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-sub-Descricao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tempo-segur IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FILL-IN fi-un IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR RADIO-SET rs-criticidade IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX tb-contr-qualid IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX tb-fraciona IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX tb-loc-unica IN FRAME fpage0
   1                                                                    */
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


&Scoped-define SELF-NAME ttcomp-familia-item.abreviatura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomp-familia-item.abreviatura wMaintenanceNoNavigation
ON LEAVE OF ttcomp-familia-item.abreviatura IN FRAME fpage0 /* Abreviatura */
DO:
    ASSIGN ttcomp-familia-item.descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
           ttcomp-familia-item.abreviatura:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
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
    
    RUN saveRecordCustom IN THIS-PROCEDURE.
    
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    ASSIGN i-nr-sub-familia = int(ttcomp-familia-item.cod-sub-familia:SCREEN-VALUE IN FRAME fPage0)
           i-nr-car-familia = int(ttcomp-familia-item.cod-car-familia:SCREEN-VALUE IN FRAME fPage0).

    RUN saveRecordCustom IN THIS-PROCEDURE.

    IF RETURN-VALUE = "OK" THEN DO:
        ASSIGN ttcomp-familia-item.cod-sub-familia:SCREEN-VALUE IN FRAME fPage0  =  STRING(i-nr-sub-familia)
               ttcomp-familia-item.cod-car-familia:SCREEN-VALUE IN FRAME fPage0 =  STRING(i-nr-car-familia).

        if pcAction = "add" then do:
            ASSIGN fi-nivel:SCREEN-VALUE IN FRAME fPage0        = "4"
                   fi-ciclo-contag:SCREEN-VALUE IN FRAME fPage0 = "180"
                   tb-contr-qualid:SCREEN-VALUE IN FRAME fPage0 = "yes"
                   fi-deposito-pad:SCREEN-VALUE IN FRAME fPage0 = "alm".
            apply "leave" to fi-deposito-pad in frame fPage0.
        END.

        APPLY "leave" TO ttcomp-familia-item.cod-sub-familia IN FRAME fPage0.
        APPLY "leave" TO ttcomp-familia-item.cod-car-familia IN FRAME fPage0.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcomp-familia-item.cod-car-familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomp-familia-item.cod-car-familia wMaintenanceNoNavigation
ON F5 OF ttcomp-familia-item.cod-car-familia IN FRAME fpage0 /* Car Fam°lia */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es026.w"
                         &FieldZoom1="cod-car-familia"
                         &FieldScreen1="ttcomp-familia-item.cod-car-familia"
                         &Frame1="fPage0"
                         &FieldZoom2="Descricao"
                         &FieldScreen2="fi-car-Descricao"
                         &Frame2="fPage0"
                         &RunMethod="RUN setaVariable IN hProgramZoom (INPUT ttfamilia-item.cod-familia)."
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomp-familia-item.cod-car-familia wMaintenanceNoNavigation
ON LEAVE OF ttcomp-familia-item.cod-car-familia IN FRAME fpage0 /* Car Fam°lia */
DO:
    run gotoKey in {&hDBOSon2} (input ttfamilia-item.cod-familia,
                                input input frame fPage0 ttcomp-familia-item.cod-sub-familia, 
                                input input frame fPage0 ttcomp-familia-item.cod-car-familia).
                                
    if return-value = "OK" then 
        run getCharField in {&hDBOSon2} (input "descricao", output fi-car-Descricao). 
    ELSE
        ASSIGN fi-car-Descricao = "".

    disp fi-car-Descricao with frame fPage0.    
    
    if pcAction = "ADD":U then do with frame fPage0:
       find last comp-familia-item 
            where comp-familia-item.cod-familia = ttfamilia-item.cod-familia
              and comp-familia-item.cod-sub-familia = input frame fPage0 ttcomp-familia-item.cod-sub-familia
              and comp-familia-item.cod-car-familia = input frame fPage0 ttcomp-familia-item.cod-car-familia
                  no-lock no-error.
        if avail comp-familia-item then 
             assign ttcomp-familia-item.cod-comp-familia:screen-value = 
                string(comp-familia-item.cod-comp-familia + 1).
        else assign ttcomp-familia-item.cod-comp-familia:screen-value = "0".
    
    end.
    
    return "OK".
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomp-familia-item.cod-car-familia wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcomp-familia-item.cod-car-familia IN FRAME fpage0 /* Car Fam°lia */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcomp-familia-item.cod-sub-familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomp-familia-item.cod-sub-familia wMaintenanceNoNavigation
ON F5 OF ttcomp-familia-item.cod-sub-familia IN FRAME fpage0 /* Sub Fam°lia */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es174.w"
                         &FieldZoom1="cod-sub-familia"
                         &FieldScreen1="ttcomp-familia-item.cod-sub-familia"
                         &Frame1="fPage0"
                         &FieldZoom2="Descricao"
                         &FieldScreen2="fi-sub-Descricao"
                         &Frame2="fPage0"
                         &RunMethod="RUN setaVariable IN hProgramZoom (INPUT ttfamilia-item.cod-familia)."
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomp-familia-item.cod-sub-familia wMaintenanceNoNavigation
ON LEAVE OF ttcomp-familia-item.cod-sub-familia IN FRAME fpage0 /* Sub Fam°lia */
DO:
    run gotoKey in {&hDBOSon1} (input ttfamilia-item.cod-familia,
                                input input frame fPage0 ttcomp-familia-item.cod-sub-familia).
                                
    if return-value = "OK" then 
        run getCharField in {&hDBOSon1} (input "descricao", output fi-sub-Descricao).    
    ELSE
        ASSIGN fi-sub-Descricao = "".
        
    disp fi-sub-Descricao with frame fPage0.    
    
    return "OK".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcomp-familia-item.cod-sub-familia wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttcomp-familia-item.cod-sub-familia IN FRAME fpage0 /* Sub Fam°lia */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wMaintenanceNoNavigation
ON F5 OF fi-cod-unid-negoc IN FRAME fpage0 /* Unidade de Neg¢cio */
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                       &FieldZoom1="cod-unid-negoc"
                       &FieldScreen1="fi-cod-unid-negoc"
                       &Frame1="fPage0"
                       &FieldZoom2="des-unid-negoc"
                       &FieldScreen2="fi-descricao"
                       &Frame2="fPage0"
                       &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wMaintenanceNoNavigation
ON LEAVE OF fi-cod-unid-negoc IN FRAME fpage0 /* Unidade de Neg¢cio */
DO:
    def var c-desc-aux as char no-undo.
    RUN goToKey IN hboin745 (input  input frame fPage0 fi-cod-unid-negoc).

    IF RETURN-VALUE = "OK" THEN
       run getCharField in hboin745 ("des-unid-negoc",
                                   output c-desc-aux ).

    assign fi-descricao:screen-value in frame fPage0 = c-desc-aux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-cod-unid-negoc IN FRAME fpage0 /* Unidade de Neg¢cio */
DO:
    apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-deposito-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-deposito-pad wMaintenanceNoNavigation
ON F5 OF fi-deposito-pad IN FRAME fpage0 /* Dep¢sito Padr∆o */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo="fi-deposito-pad"
                       &campozoom="cod-depos"
                       &frame="fPage0"
                       &campo2="fi-nome"
                       &campozoom2="nome"
                       &frame2="fPage0"}    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-deposito-pad wMaintenanceNoNavigation
ON LEAVE OF fi-deposito-pad IN FRAME fpage0 /* Dep¢sito Padr∆o */
DO:
    {method/ReferenceFields.i 
      &HandleDBOLeave="hboin084"
      &KeyValue1="fi-deposito-pad:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="nome"
      &FieldScreen1="fi-nome"
      &Frame1="fPage0"}
      
      return "OK".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-deposito-pad wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-deposito-pad IN FRAME fpage0 /* Dep¢sito Padr∆o */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

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
    if VALID-HANDLE(hboin084) then
        run Destroy in hboin084.
    hboin084 = ?.    

    if VALID-HANDLE(hboin745) then
        run Destroy in hboin745.
    hboin745 = ?. 
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
    if pcAction = "Update" then do:
        disable {&page0KeyFields} with frame fPage0.
        
        for each tt-comp-familia-ext:
            delete tt-comp-familia-ext.
        end.
        
        run getFamilyInfo in {&hDBOTable} (input string(ttfamilia-item.cod-familia,"999") +
                                                 string(ttcomp-familia-item.cod-sub-familia,"99") +
                                                 string(ttcomp-familia-item.cod-car-familia,"99") +
                                                 string(ttcomp-familia-item.cod-comp-familia,"9"), 
                                           output table tt-comp-familia-ext).
                                           
                                
                                
                    
                                                  
        for first tt-comp-familia-ext:
                           
            assign cb-tipo-requis    = string(tt-comp-familia-ext.tipo-requis)
                   fi-ciclo-contag   = tt-comp-familia-ext.ciclo-contag
                   fi-deposito-pad   = tt-comp-familia-ext.deposito-pad
                   fi-desc-ingles    = tt-comp-familia-ext.desc-ingles
                   fi-meses-validade = tt-comp-familia-ext.meses-validade
                   fi-nivel          = tt-comp-familia-ext.nivel
                   fi-pad-nomenc     = tt-comp-familia-ext.pad-nomenc
                   fi-perc-nqa       = tt-comp-familia-ext.perc-nqa
                   fi-perc-perda     = tt-comp-familia-ext.perc-perda
                   fi-periodo-fixo   = tt-comp-familia-ext.periodo-fixo
                   fi-res-for-comp   = tt-comp-familia-ext.res-for-comp
                   fi-tempo-segur    = tt-comp-familia-ext.tempo-segur
                   fi-un             = tt-comp-familia-ext.un
                   rs-criticidade    = tt-comp-familia-ext.criticidade
                   tb-contr-qualid   = tt-comp-familia-ext.contr-qualid 
                   tb-fraciona       = tt-comp-familia-ext.fraciona
                   tb-loc-unica      = tt-comp-familia-ext.loc-unica
                   fi-cod-unid-negoc = tt-comp-familia-ext.cod-unid-negoc.
                   
        end.
    end.    
    disp {&List-1} with frame fPage0.
    apply "leave" to ttcomp-familia-item.cod-sub-familia in frame fPage0.       
    apply "leave" to ttcomp-familia-item.cod-car-familia in frame fPage0.
    apply "leave" to fi-deposito-pad in frame fPage0.
    apply "leave" to fi-cod-unid-negoc in frame fPage0.
    ttcomp-familia-item.cod-sub-familia:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
    ttcomp-familia-item.cod-car-familia:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
    fi-deposito-pad:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
    fi-cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
    
    disable ttcomp-familia-item.descricao 
            fi-descricao with frame fPage0.

    return "OK".    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first tt-comp-familia-ext no-error.
    if not avail tt-comp-familia-ext then create tt-comp-familia-ext.
    assign tt-comp-familia-ext.tipo-requis    = int(cb-tipo-requis)
           tt-comp-familia-ext.ciclo-contag   = fi-ciclo-contag
           tt-comp-familia-ext.deposito-pad   = fi-deposito-pad
           tt-comp-familia-ext.desc-ingles    = fi-desc-ingles
           tt-comp-familia-ext.meses-validade = fi-meses-validade
           tt-comp-familia-ext.nivel          = fi-nivel
           tt-comp-familia-ext.pad-nomenc     = fi-pad-nomenc
           tt-comp-familia-ext.perc-nqa       = fi-perc-nqa
           tt-comp-familia-ext.perc-perda     = fi-perc-perda
           tt-comp-familia-ext.periodo-fixo   = fi-periodo-fixo
           tt-comp-familia-ext.res-for-comp   = fi-res-for-comp
           tt-comp-familia-ext.tempo-segur    = fi-tempo-segur
           tt-comp-familia-ext.un             = fi-un
           tt-comp-familia-ext.criticidade    = rs-criticidade
           tt-comp-familia-ext.contr-qualid   = tb-contr-qualid
           tt-comp-familia-ext.fraciona       = tb-fraciona
           tt-comp-familia-ext.loc-unica      = tb-loc-unica
           tt-comp-familia-ext.cod-unid-negoc = fi-cod-unid-negoc.
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
    IF NOT VALID-HANDLE(hboin084) OR
       hboin084:TYPE <> "PROCEDURE":U OR
       hboin084:FILE-NAME <> "inbo/boin084.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin084.p YES}
        {btb/btb008za.i2 inbo/boin084.p '' hboin084} 
    END.
    RUN openQueryStatic IN hboin084 (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(hboin745) OR
       hboin084:TYPE <> "PROCEDURE":U OR
       hboin084:FILE-NAME <> "inbo/boin745.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin745.p YES}
        {btb/btb008za.i2 inbo/boin745.p '' hboin745} 
    END.
    RUN openQueryStatic IN hboin745 (INPUT "Main":U) NO-ERROR.

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
    ttcomp-familia-item.cod-familia = ttfamilia-item.cod-familia.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecordCustom wMaintenanceNoNavigation 
PROCEDURE saveRecordCustom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cod-sub-familia  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-car-familia  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-comp-familia AS INTEGER     NO-UNDO.

    /*Alteracao feita pois se clicado no salvar perdia o valor desses campos e dava problema de gravacao dos registros*/
    ASSIGN i-cod-sub-familia  = INT(ttcomp-familia-item.cod-sub-familia:SCREEN-VALUE IN FRAME fPage0)
           i-cod-car-familia  = INT(ttcomp-familia-item.cod-car-familia:SCREEN-VALUE IN FRAME fPage0)
           i-cod-comp-familia = INT(ttcomp-familia-item.cod-comp-familia:SCREEN-VALUE IN FRAME fPage0).

    IF fi-cod-unid-negoc:SCREEN-VALUE IN FRAME fPage0 = "" THEN DO:
        MESSAGE "Unidade de Neg¢cio deve ser informada."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        undo, return "NOK".
    END.
    
    
    do trans:
        RUN saveRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = "OK":U THEN DO:
            run setFamilyInfo in {&hDBOTable} (input v_cod_estab_usuar,
                                               input string(ttfamilia-item.cod-familia,"999") +
                                                     string(i-cod-sub-familia,"99") +
                                                     string(i-cod-car-familia,"99") +
                                                     string(i-cod-comp-familia,"9"), 
                                               input table tt-comp-familia-ext).
        END.
        else undo, return "NOK".
        
        if RETURN-VALUE = "NOK":U THEN do:
            run getRowErrors in {&hDBOTable} (output table rowErrors).
            {method/ShowMessage.i1}
            {method/ShowMessage.i2 &Modal="YES"}
            undo, return "NOK".
        end.             
    end.   
    if pcAction ne "Update" then
        clear frame fPage0 all.
    return "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

