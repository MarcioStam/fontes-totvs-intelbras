&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttae-item NO-UNDO LIKE ae-item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escep016 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep016
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Impress∆o,Reimpress∆o,Destino

&GLOBAL-DEFINE page0Widgets   btExit btHelp ~
                              btImprimir ~
                              btReimprimir

&GLOBAL-DEFINE page1Widgets   fi-cod-depos fi-contenedor  ~
                              fi-desc-item fi-it-codigo fi-nf fi-nome fi-nr-ae ~
                              fi-nr-ae-novo fi-nr-ficha fi-quantidade 
&GLOBAL-DEFINE page2Widgets   fi-nr-ae fi-sequencia-fim fi-sequencia-ini
&GLOBAL-DEFINE page3Widgets   btConfigImpr fiPrinter
&GLOBAL-DEFINE ttTable        ttae-item
&GLOBAL-DEFINE hDBOTable      dboae-item
&GLOBAL-DEFINE DBOTable       boes010

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cPrinter    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER   NO-UNDO.

DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR i-campo AS INT NO-UNDO.
DEF VAR i-quantidade AS INTEGER NO-UNDO.
DEF VAR i-page AS INT NO-UNDO INIT 1.

{upc\btb910za-upc.i}

DEFINE VARIABLE i-seq      AS INTEGER NO-UNDO.
DEFINE VARIABLE h_esapi020 AS HANDLE  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtToolBar-2 btExit btHelp ~
btImprimir btReimprimir 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fi-it-codigo fi-nr-ae-novo fi-cod-depos fi-nf ~
fi-quantidade fi-contenedor fi-nr-ficha 
&Scoped-define List-2 fi-contenedor 

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

DEFINE BUTTON btImprimir 
     LABEL "&Imprimir" 
     SIZE 10 BY 1.

DEFINE BUTTON btReimprimir 
     LABEL "&Reimprimir" 
     SIZE 11 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87.43 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-contenedor AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Contenedor" 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 49.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nf AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ae AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "N£mero do AE" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ae-novo AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "AE" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ficha AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Roteiro" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quantidade AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sequencia-fim AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "SeqÅància Final" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88.

DEFINE VARIABLE fi-sequencia-ini AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "SeqÅància Inicial" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 2.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     btImprimir AT ROW 16.25 COL 3.57
     btReimprimir AT ROW 16.25 COL 16
     rtToolBar AT ROW 16 COL 1.72
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.

DEFINE FRAME fPage3
     btConfigImpr AT ROW 3.67 COL 62.57 HELP
          "Configuraá∆o da impressora" WIDGET-ID 32
     fiPrinter AT ROW 3.75 COL 18 NO-LABEL WIDGET-ID 34 NO-TAB-STOP 
     "Destino:" VIEW-AS TEXT
          SIZE 7.29 BY .54 AT ROW 2.83 COL 12.72 WIDGET-ID 28
     RECT-4 AT ROW 3.04 COL 11 WIDGET-ID 22
    WITH 1 DOWN OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.

DEFINE FRAME fPage2
     fi-nr-ae AT ROW 1.17 COL 16.72 COLON-ALIGNED
          LABEL "N£mero do AE" FORMAT "9999999"
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     fi-sequencia-ini AT ROW 2.17 COL 16.72 COLON-ALIGNED
     fi-sequencia-fim AT ROW 3.17 COL 16.72 COLON-ALIGNED
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.

DEFINE FRAME fPage1
     fi-nr-ae AT ROW 1.17 COL 16.72 COLON-ALIGNED
     fi-it-codigo AT ROW 2.17 COL 16.72 COLON-ALIGNED HELP
          "C¢digo do Item"
     fi-desc-item AT ROW 2.17 COL 33.57 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fi-nr-ae-novo AT ROW 3.17 COL 16.72 COLON-ALIGNED
     fi-cod-depos AT ROW 4.17 COL 16.72 COLON-ALIGNED
     fi-nome AT ROW 4.17 COL 20.86 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL NO-TAB-STOP 
     fi-nf AT ROW 5.17 COL 16.72 COLON-ALIGNED
     fi-quantidade AT ROW 6.17 COL 16.72 COLON-ALIGNED
     fi-contenedor AT ROW 7.17 COL 16.72 COLON-ALIGNED
     fi-nr-ficha AT ROW 8.17 COL 16.72 COLON-ALIGNED HELP
          "N£mero do Roteiro de Inspeá∆o"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttae-item T "?" NO-UNDO mgesp ae-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 16.96
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{esp/ShowMsg.i}
{window/window.i}
/*{esp/eslib.i}*/
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN fi-cod-depos IN FRAME fPage1
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-contenedor IN FRAME fPage1
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fPage1
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-nf IN FRAME fPage1
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-nr-ae-novo IN FRAME fPage1
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-nr-ficha IN FRAME fPage1
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-quantidade IN FRAME fPage1
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR BUTTON btConfigImpr IN FRAME fPage3
   NO-ENABLE                                                            */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fPage3        = TRUE.

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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


&Scoped-define SELF-NAME fPage1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage1 wWindow
ON ENTRY OF FRAME fPage1
DO:
    btImprimir:SENSITIVE IN FRAME fpage0 = TRUE.
    btReimprimir:SENSITIVE IN FRAME fpage0 = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage2 wWindow
ON ENTRY OF FRAME fPage2
DO:
    btImprimir:SENSITIVE IN FRAME fpage0 = FALSE.
    btReimprimir:SENSITIVE IN FRAME fpage0 = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fPage3 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON CHOOSE OF btImprimir IN FRAME fpage0 /* Imprimir */
DO:
    DEF VAR i-qtd-lote AS INT NO-UNDO.
    DEF VAR i-qtd-resto AS INT NO-UNDO.
    DEF VAR i-cont AS INT NO-UNDO.
    DEF VAR i-nr-ae LIKE ttae-item.nr-ae NO-UNDO.


    RUN pi-valida-impressao.

    IF RETURN-VALUE = "NOK" THEN DO:
       CASE i-campo:
            WHEN 1 THEN DO:
                 ASSIGN INPUT FRAME fPage1 fi-nr-ae.
                 CLEAR FRAME fPage1 ALL.
                 DISP fi-nr-ae WITH FRAME fPage1.
            END.
            WHEN 2 THEN 
                 APPLY "entry" TO fi-it-codigo IN FRAME fPage1.
            WHEN 5 THEN 
                 APPLY "entry" TO fi-nf IN FRAME fPage1.
            WHEN 6 THEN 
                 APPLY "entry" TO fi-quantidade IN FRAME fPage1.
            WHEN 8 THEN 
                 APPLY "entry" TO fi-nr-ficha IN FRAME fPage1.
       END CASE.

       RETURN NO-APPLY.
    END.

    ELSE DO:
       IF NOT AVAIL ae-inspecao THEN DO:
          ASSIGN i-qtd-lote  = trunc((INPUT fi-quantidade / INPUT fi-contenedor),0)
                 i-qtd-resto = ((INPUT fi-quantidade / INPUT fi-contenedor) -  i-qtd-lote) * INPUT fi-contenedor
                 i-nr-ae     = INPUT fi-nr-ae-novo. 
          
          FIND FIRST aviso-entrada EXCLUSIVE-LOCK 
            where aviso-entrada.cod-estabel = v_cod_estab_usuar NO-ERROR.
          IF AVAIL aviso-entrada THEN
              ASSIGN fi-nr-ae-novo = aviso-entrada.ultimo-ae + 1 
                     aviso-entrada.ultimo-ae = fi-nr-ae-novo. 
          ELSE DO:
              CREATE aviso-entrada.
              ASSIGN aviso-entrada.cod-estabel = v_cod_estab_usuar
                     aviso-entrada.ultimo-ae   = 1.
          END.
          FIND CURRENT aviso-entrada NO-LOCK.


          DISP fi-nr-ae-novo WITH FRAME fPage1.
          
          DO i-cont = 1 to i-qtd-lote:
             EMPTY TEMP-TABLE ttae-item.
             CREATE ttae-item.
                    ASSIGN  ttae-item.it-codigo   = item.it-codigo
                            ttae-item.quantidade  = INPUT fi-contenedor
                            ttae-item.nr-ae       = INPUT fi-nr-ae-novo
                            ttae-item.sequencia   = i-cont
                            ttae-item.nf          = INPUT fi-nf
                            ttae-item.data        = today
                            ttae-item.localizacao = item.cod-localiz
                            ttae-item.roteiro     = INPUT fi-nr-ficha
                            ttae-item.cod-depos   = INPUT fi-cod-depos.
                    RUN piCriaAEItem.
          END.

          IF i-qtd-resto > 0 THEN DO:
             EMPTY TEMP-TABLE ttae-item.
             CREATE ttae-item.
                    ASSIGN  ttae-item.it-codigo  = item.it-codigo
                            ttae-item.quantidade = i-qtd-resto           
                            ttae-item.nr-ae      = INPUT fi-nr-ae-novo
                            ttae-item.sequencia   = i-cont
                            ttae-item.nf          = INPUT fi-nf
                            ttae-item.data        = today
                            ttae-item.localizacao = item.cod-localiz
                            ttae-item.roteiro     = INPUT fi-nr-ficha
                            ttae-item.cod-depos   = INPUT fi-cod-depos.
                    RUN piCriaAEItem.
          END.
       END.

       ELSE DO:

          ASSIGN i-qtd-lote  = trunc((i-quantidade / INPUT fi-contenedor),0)
                 i-qtd-resto = ((i-quantidade / INPUT fi-contenedor) - i-qtd-lote) * INPUT fi-contenedor.
                 i-nr-ae     = INPUT fi-nr-ae. 
          DO i-cont = 1 to i-qtd-lote:
             EMPTY TEMP-TABLE ttae-item.
             CREATE ttae-item.
                    ASSIGN  ttae-item.it-codigo  = item.it-codigo
                            ttae-item.quantidade = input fi-contenedor
                            ttae-item.nr-ae      = INPUT fi-nr-ae
                            ttae-item.sequencia  = i-cont
                            ttae-item.nf         = ae-inspecao.nro-docto
                            ttae-item.data       = TODAY
                            ttae-item.localizacao = item.cod-localiz
                            ttae-item.cod-depos   = item.deposito-pad.
                    RUN piCriaAEItem.
          END.

          IF i-qtd-resto > 0 THEN DO:
             EMPTY TEMP-TABLE ttae-item.
             CREATE ttae-item.
                    ASSIGN ttae-item.it-codigo  = item.it-codigo
                           ttae-item.quantidade = i-qtd-resto
                           ttae-item.nr-ae      = INPUT fi-nr-ae
                           ttae-item.sequencia  = i-cont
                           ttae-item.nf         = ae-inspecao.nro-docto
                           ttae-item.data       = TODAY
                           ttae-item.localizacao = item.cod-localiz
                           ttae-item.cod-depos   = item.deposito-pad.
                    RUN piCriaAEItem.
          END.

          FOR FIRST item-fornec NO-LOCK WHERE 
                    item-fornec.it-codigo = ae-inspecao.it-codigo AND
                    item-fornec.cod-emitente = ae-inspecao.cod-emitente:
                    IF INPUT fi-contenedor NE item-fornec.lote-mul-for THEN DO:
                       FOR FIRST emitente OF item-fornec NO-LOCK:
                           RUN enviaMail(INPUT "intelbras@intelbras.com.br", 
                                         INPUT "nicholas@intelbras.com.br",
                                         INPUT "Alteraá∆o de Contenedor no Recebimento",
                                         INPUT substitute("O contenedor do item : &1 - &2~nDo comprador : &3~nDo fornecedor: &4 - &5~nFoi alterado de: &6 para: 50 no recebimento.~nFavor verificar os cadastros do item.",
                                               TRIM(item-fornec.it-codigo),
                                                TRIM(ITEM.desc-item),
                                                TRIM(item.cod-comprado),
                                                trim(STRING(item-fornec.cod-emit)),
                                                TRIM(emitente.nome-abrev),
                                                TRIM(STRING(item-fornec.lote-mul-for))),
                                         INPUT "").
                       END.
                    END.
          END.

       END.
    END.

    /*
    RUN imprimeAE(INPUT cb-impressora:SCREEN-VALUE IN FRAME fpage3,
                  INPUT INPUT FRAME fpage3 rs-destino,
                  INPUT i-nr-ae,
                  INPUT 1,
                  INPUT 999).
    */

    IF NOT valid-handle(h_esapi020) THEN RUN esapi/esapi020.p PERSISTENT SET h_esapi020.

    DO  i-seq = 1 TO 999:
        RUN pi-imprime-AE IN h_esapi020 (INPUT fiPrinter:SCREEN-VALUE IN FRAME fpage3,
                                         INPUT v_cod_estab_usuar,
                                         INPUT i-nr-ae,
                                         INPUT i-seq,
                                         INPUT c-seg-usuario).
    END. /* DO  i-seq */


    CLEAR FRAME fPage1 ALL.
    APPLY "entry" TO fi-nr-ae IN FRAME fPage1.
    RUN ShowMessage (2, "Etiquetas impressas com sucesso", "").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReimprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReimprimir wWindow
ON CHOOSE OF btReimprimir IN FRAME fpage0 /* Reimprimir */
DO:

    DEF VAR i-qtd-lote AS INT NO-UNDO.
    DEF VAR i-qtd-resto AS INT NO-UNDO.
    DEF VAR i-cont AS INT NO-UNDO.
    DEF VAR i-nr-ae LIKE ttae-item.nr-ae NO-UNDO.
    DEF VAR cont AS INTEGER.

    IF NOT valid-handle(h_esapi020) THEN RUN esapi/esapi020.p PERSISTENT SET h_esapi020.
    FOR EACH ae-item NO-LOCK                                          WHERE
             ae-item.cod-estabel = v_cod_estab_usuar and
             ae-item.nr-ae     =  INPUT FRAME fPage2 fi-nr-ae         AND
             ae-item.sequencia >= INPUT FRAME fPage2 fi-sequencia-ini AND
             ae-item.sequencia <= INPUT FRAME fPage2 fi-sequencia-fim AND
             /*ae-item.impresso  =  YES                                 AND /*retirado pois estava ocorrendo de n∆o imprimir algumas sequencias por buffer de impressora e n∆o marcar ae como impressa n∆o sendo poss°vel a reimpress∆o*/*/
             ae-item.situacao  =  NO                                  BY  ae-item.sequencia:

            /*
             RUN imprimeAE(INPUT cb-impressora:SCREEN-VALUE IN FRAME fpage3,
                           INPUT INPUT FRAME fpage3 rs-destino,
                           INPUT ae-item.nr-ae,
                           INPUT ae-item.sequencia,
                           INPUT ae-item.sequencia).
            */                           
            
            RUN pi-imprime-AE IN h_esapi020 (INPUT fiPrinter:SCREEN-VALUE IN FRAME fpage3,
                                             INPUT v_cod_estab_usuar,
                                             INPUT ae-item.nr-ae,   
                                             INPUT ae-item.sequencia,
                                             INPUT c-seg-usuario).
            
            ASSIGN cont = cont + 1.
    END.
    IF cont > 0 THEN
       RUN ShowMessage (2, "Etiquetas impressas com sucesso", "").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON F5 OF fi-cod-depos IN FRAME fPage1 /* Dep¢sito */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in084"
                       &campo="fi-nome"
                       &campozoom="nome"
                       &frame="fPage1"
                       &campo2="fi-cod-depos"
                       &campozoom2="cod-depos"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON LEAVE OF fi-cod-depos IN FRAME fPage1 /* Dep¢sito */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=fi-nome
                     &where="deposito.cod-depos = fi-cod-depos:screen-value in frame fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME fPage1 /* Dep¢sito */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON F5 OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z04in172"
                       &campo="fi-desc-item"
                       &campozoom="desc-item"
                       &frame="fPage1"
                       &campo2="fi-it-codigo"
                       &campozoom2="it-codigo"
                       &frame2="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = fi-it-codigo:screen-value in frame fPage1"}
                     
    IF NOT AVAIL ae-inspecao THEN DO:
        assign fi-contenedor = item.lote-multipl WHEN AVAIL ITEM.
        DISP fi-contenedor WITH FRAME fPage1.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME fPage1 /* Item */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-ae
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ae wWindow
ON LEAVE OF fi-nr-ae IN FRAME fPage1 /* N£mero do AE */
DO:

    IF INPUT fi-nr-ae > 0 THEN DO:
        ASSIGN INPUT FRAME fPage1 fi-nr-ae.
        CLEAR FRAME fPage1 ALL.
        DISP fi-nr-ae WITH FRAME fPage1.
        find first ae-inspecao no-lock
             where ae-inspecao.cod-estabel = v_cod_estab_usuar
             and   ae-inspecao.nr-ae = INPUT fi-nr-ae no-error.
        IF NOT AVAIL ae-inspecao THEN DO:
            find first aviso-entrada NO-LOCK 
            where aviso-entrada.cod-estabel = v_cod_estab_usuar no-error.
            assign fi-nr-ae-novo = aviso-entrada.ultimo-ae + 1.
            DISP fi-nr-ae-novo WITH FRAME fPage1.
            ENABLE {&List-1} WITH FRAME fPage1.
            APPLY "entry" TO fi-it-codigo IN FRAME fPage1.
            RETURN NO-APPLY.
        END.
        ELSE DO:
            find item-fornec 
                 where item-fornec.it-codigo = ae-inspecao.it-codigo 
                 and item-fornec.cod-emitente = ae-inspecao.cod-emitente NO-LOCK NO-ERROR.
            assign fi-contenedor = item-fornec.lote-mul-for WHEN AVAIL item-fornec.
            DISP fi-contenedor WITH FRAME fPage1.
            DISABLE {&List-1} WITH FRAME fPage1.
            ENABLE {&List-2} WITH FRAME fPage1.
            APPLY "entry" TO fi-contenedor IN FRAME fPage1.
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ae wWindow
ON VALUE-CHANGED OF fi-nr-ae IN FRAME fPage1 /* N£mero do AE */
DO:
  SELF:PRIVATE-DATA = "yes".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-ficha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ficha wWindow
ON F5 OF fi-nr-ficha IN FRAME fPage1 /* Roteiro */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in124"
                       &campo="fi-nr-ficha"
                       &campozoom="nr-ficha"
                       &frame="fPage1"
                       &campo2="fi-it-codigo" 
                       &campozoom2="it-codigo"
                       &frame2="fPage1"}     

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ficha wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-nr-ficha IN FRAME fPage1 /* Roteiro */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
fi-it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-cod-depos:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-nr-ficha:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterchangePage wWindow 
PROCEDURE AfterchangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INTEGER NO-UNDO.
  RUN getCurrentFolder IN hFolder (OUTPUT i).
  ASSIGN i-page = i WHEN i < 3.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdestroyInterface wWindow 
PROCEDURE AfterdestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
    {btb/btb008za.i3}
        
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari†vel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* carrega impressora padr∆o do usu†rio */
    FOR FIRST imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = c-seg-usuario
        AND   imprsor_usuar.log_imprsor_princ:

        FOR FIRST layout_impres NO-LOCK
            WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
            AND   layout_impres.log_layout_impres_princ:

            ASSIGN fiPrinter:SCREEN-VALUE IN FRAME fPage3 = layout_impres.nom_impressora + ":" +
                                                            layout_impres.cod_layout_impres.

        END.

    END.
    
    
    DISABLE {&List-1} WITH FRAME fPage1.
    
    FOR FIRST param-global NO-LOCK:
    END.
    
    RUN initializeDBOs.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedestroyInterface wWindow 
PROCEDURE BeforedestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        &IF "{&hDBOTable}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable}) THEN
                RUN destroy IN {&hDBOTable}.
        &ENDIF

        &IF "{&hDBOTable2}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable2}) THEN
                RUN destroy IN {&hDBOTable2}.
        &ENDIF

        &IF "{&hDBOTable3}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable3}) THEN
                RUN destroy IN {&hDBOTable3}.
        &ENDIF

        &IF "{&hDBOTable4}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable4}) THEN
                RUN destroy IN {&hDBOTable4}.
        &ENDIF

        &IF "{&hDBOTable5}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable5}) THEN
                RUN destroy IN {&hDBOTable5}.
        &ENDIF
        
        &IF "{&hDBOTable6}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable6}) THEN
                RUN destroy IN {&hDBOTable6}.
        &ENDIF

        &IF "{&hDBOTable7}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable7}) THEN
                RUN destroy IN {&hDBOTable7}.
        &ENDIF

        &IF "{&hDBOTable8}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable8}) THEN
                RUN destroy IN {&hDBOTable8}.
        &ENDIF

        &IF "{&hDBOTable9}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable9}) THEN
                RUN destroy IN {&hDBOTable9}.
        &ENDIF
        
        &IF "{&hDBOTable10}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable10}) THEN
                RUN destroy IN {&hDBOTable10}.
        &ENDIF


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
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes010.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes010.p YES}
        {btb/btb008za.i2 esbo/boes010.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} (v_cod_estab_usuar) NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-impressao wWindow 
PROCEDURE pi-valida-impressao PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME fPage1:
        FIND FIRST ae-item WHERE
                   ae-item.cod-estabel = v_cod_estab_usuar and 
                   ae-item.nr-ae = INPUT fi-nr-ae NO-LOCK NO-ERROR.
        IF AVAIL ae-item THEN DO:
            RUN ShowMessage (2, "AE j† foi gerado. Utilize a Reimpress∆o", "").
            i-campo = 1.
            DISABLE {&List-1} WITH FRAME fPage1.
            RETURN "NOK".
        END.

        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = INPUT fi-it-codigo NO-LOCK NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            RUN ShowMessage (1, "Item n∆o cadastrado", "").
            i-campo = 2.
            RETURN "NOK".
        END.

        FIND FIRST ae-inspecao WHERE
                   ae-inspecao.cod-estabel = v_cod_estab_usuar and
                   ae-inspecao.nr-ae = INPUT fi-nr-ae NO-LOCK NO-ERROR.
        IF NOT AVAIL ae-inspecao THEN DO:
            IF fi-nr-ae:PRIVATE-DATA = "yes" THEN DO:
               fi-nr-ae:PRIVATE-DATA = "no".
               RUN ShowMessage (3, "AE n∆o possui registro de entrada via Recebimento", 
                                   "Continua mesmo assim?").
                i-campo = 1.
                IF RETURN-VALUE = "no" THEN RETURN "NOK".
            END.
            IF INPUT fi-nf = 0 THEN DO:
                RUN ShowMessage (1, "N£mero da nota n∆o informado", "Informe um n£mero de nota").
                i-campo = 5.
                RETURN "NOK".
            END.
            IF INPUT fi-quantidade = 0 THEN DO:
                RUN ShowMessage (1, "Quantidade nula", "Informe uma quantidade positiva").
                i-campo = 6.
                RETURN "NOK".
            END.
            IF INPUT fi-cod-depos NE "ast" THEN DO:
                FIND ficha-cq USE-INDEX item-ficha NO-LOCK    WHERE
                     ficha-cq.it-codigo = INPUT fi-it-codigo  AND
                     ficha-cq.nr-ficha  = INPUT fi-nr-ficha   NO-ERROR.
                IF NOT AVAIL ficha-cq THEN DO:
                     RUN ShowMessage (1, "Roteiro n∆o pertence ao item informado", "").
                     i-campo = 8.
                     RETURN "NOK".
                END.     
            END.
        END.
        ELSE DO:
            FIND ITEM WHERE
                 ITEM.it-codigo = ae-inspecao.it-codigo NO-LOCK NO-ERROR.
            IF NOT AVAIL ITEM THEN DO:
                RUN ShowMessage (1, "Item n∆o cadastrado", "").
                RETURN "NOK".
            END.
            IF ITEM.lote-multipl <= 0 THEN DO:
                RUN ShowMessage (1, "Contenedor do item est† zerado", "").
                i-campo = 2.
                RETURN "NOK".
            END.

            FIND ficha-cq WHERE
                 ficha-cq.nr-ficha  = ae-inspecao.nr-ficha    AND 
                 ficha-cq.it-codigo   = ae-inspecao.it-codigo NO-LOCK NO-ERROR.
            i-quantidade = ficha-cq.qt-aprovada + ficha-cq.qt-apr-cond.
            IF i-quantidade = 0 THEN DO:
                RUN ShowMessage (1, SUBSTITUTE("Item &1 n∆o foi liberado", TRIM(ITEM.it-codigo)), "").
                RETURN "NOK".
            END.

            IF i-quantidade <= 0 THEN DO:
                RUN ShowMessage (1, "Erro na geraá∆o de quantidade complementar", "").
                RETURN "NOK".
            END.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaAEItem wWindow 
PROCEDURE piCriaAEItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.      

    RUN openQueryStatic IN {&hDBOTable} (INPUT "first":U) NO-ERROR.
    
    RUN setrecord IN {&hDBOTable} (INPUT TABLE ttae-item).  

    RUN createRecord IN {&hDBOTable}.        

 
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
        {method/ShowMessage.i1}.
        {method/ShowMessage.i2 &Modal="YES"}.
        {method/ShowMessage.i3}.
        RETURN "NOK".
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

    ASSIGN INPUT FRAME fPage3 fiPrinter.

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
        WITH FRAME fPage3.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

