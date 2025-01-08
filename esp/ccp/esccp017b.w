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
{include/i-prgvrs.i esccp017B 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp017B
&GLOBAL-DEFINE Version        001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   it-codigo cod-emitente cod-fabric it-fabric ref-biblio ~
                              solicitante motivo quantidade cb-tipo
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO. 

def buffer b-homologacao for homologacao.

def var i-nr-processo       like homologacao.nr-processo        no-undo.
DEF VAR c-cod-comprado LIKE ITEM.cod-comprado NO-UNDO.
DEF VAR c-nome-comprador LIKE comprador.nome NO-UNDO.

{utp/utapi019.i}
{upc/btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp btOK btCancel btHelp2 

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

DEFINE BUTTON btOK 
     LABEL "OK" 
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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cb-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Amostra" 
     LABEL "Tipo de Lote" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Amostra","Primeiro Lote" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE cod-fabric AS INTEGER FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Fabricante" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE data-inicio AS DATE FORMAT "99/99/9999":U 
     LABEL "Data In°cio" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE data-termino AS DATE FORMAT "99/99/9999":U 
     LABEL "Data TÇrmino" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE data-ult-sit AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Situaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE ds-situacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE it-codigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE it-fabric AS CHARACTER FORMAT "x(36)" 
     LABEL "Part Number" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE motivo AS CHARACTER FORMAT "X(60)" 
     LABEL "Motivo" 
     VIEW-AS FILL-IN 
     SIZE 65 BY .88 NO-UNDO.

DEFINE VARIABLE nome AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE nome-abrev-fabric AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE quantidade AS DECIMAL FORMAT ">>,>>>,>>9.9999" INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE ref-biblio AS CHARACTER FORMAT "x(30)" 
     LABEL "Ref.Biblio" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE situacao AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "situacao" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE solicitante AS CHARACTER FORMAT "X(12)" 
     LABEL "Solicitante" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     it-codigo AT ROW 1.5 COL 11 COLON-ALIGNED WIDGET-ID 2
     desc-item AT ROW 1.5 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     cod-emitente AT ROW 2.5 COL 11 COLON-ALIGNED WIDGET-ID 6
     nome-emit AT ROW 2.5 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     cod-fabric AT ROW 3.5 COL 11 COLON-ALIGNED HELP
          "Informe o codigo do fabricante" WIDGET-ID 10
     nome-abrev-fabric AT ROW 3.5 COL 21 COLON-ALIGNED HELP
          "Informe o nome do fabricante" NO-LABEL WIDGET-ID 12
     it-fabric AT ROW 4.5 COL 11 COLON-ALIGNED HELP
          "Informe o codigo do fabricante" WIDGET-ID 14
     ref-biblio AT ROW 5.5 COL 11 COLON-ALIGNED WIDGET-ID 16
     solicitante AT ROW 6.5 COL 11 COLON-ALIGNED WIDGET-ID 18
     nome AT ROW 6.5 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     motivo AT ROW 7.5 COL 11 COLON-ALIGNED WIDGET-ID 20
     cb-tipo AT ROW 8.5 COL 11.14 COLON-ALIGNED WIDGET-ID 36
     data-inicio AT ROW 9.5 COL 11 COLON-ALIGNED WIDGET-ID 22
     data-termino AT ROW 9.5 COL 34 COLON-ALIGNED WIDGET-ID 24
     situacao AT ROW 10.5 COL 11 COLON-ALIGNED WIDGET-ID 26
     ds-situacao AT ROW 10.5 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     data-ult-sit AT ROW 11.5 COL 11 COLON-ALIGNED WIDGET-ID 30
     quantidade AT ROW 11.5 COL 66 COLON-ALIGNED WIDGET-ID 34
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90.29
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN data-inicio IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN data-termino IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN data-ult-sit IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-item IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ds-situacao IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN nome IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN nome-abrev-fabric IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN nome-emit IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN situacao IN FRAME fPage1
   NO-ENABLE                                                            */
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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
     
    run piValidaDados.
    if return-value = 'NOK'
    then return no-apply.
    
    find last homologacao no-lock no-error.
    if avail homologacao
    then assign i-nr-processo = homologacao.nr-processo + 1.
    else assign i-nr-processo = 1.
    
    create homologacao.
    assign homologacao.nr-processo  = i-nr-processo
           homologacao.data-inicio  = today
           homologacao.situacao     = 1
           homologacao.data-ult-sit = today.
  
    assign homologacao.it-codigo    = frame fPage1 it-codigo
           homologacao.cod-emitente = frame fPage1 cod-emitente
           homologacao.cod-fabric   = frame fPage1 cod-fabric
           homologacao.it-fabric    = frame fPage1 it-fabric
           homologacao.ref-biblio   = frame fPage1 ref-biblio
           homologacao.solicitante  = frame fPage1 solicitante
           homologacao.motivo       = frame fPage1 motivo.
    
    create lote-hml.
    assign lote-hml.nr-processo = homologacao.nr-processo
           lote-hml.cod-lote    = IF cb-tipo:SCREEN-VALUE IN FRAME fPage1 = "Amostra" THEN 1 ELSE 2
           lote-hml.nr-lote     = 1
           lote-hml.quantidade  = frame fPage1 quantidade.
    
    create teste.
    assign teste.nr-processo = homologacao.nr-processo
           teste.nr-lote     = IF cb-tipo:SCREEN-VALUE IN FRAME fPage1 = "Amostra" THEN 1 ELSE 2.
            
    find first ponto-programa
         where ponto-programa.nome-programa = "esccp017"
           and ponto-programa.ponto         = 1
           and ponto-programa.tipo          = 4     /*conta*/ 
           no-lock no-error.
    if avail ponto-programa
    then do:
        if homologacao.it-codigo begins "104"
        or homologacao.it-codigo begins "115"
        or homologacao.it-codigo begins "116"
        or homologacao.it-codigo begins "117"
        or homologacao.it-codigo begins "123"
        or homologacao.it-codigo begins "124"
        or homologacao.it-codigo begins "134"
        or homologacao.it-codigo begins "156"
        then do:
            find first conteudo-programa
                 where conteudo-programa.cod-programa = ponto-programa.cod-programa
                   and conteudo-programa.sequencia    = 4
                   no-lock no-error.
            if avail conteudo-programa
            then assign teste.cc-codigo = ENTRY(1,conteudo-programa.conteudo,",").
        end.
        else
        if homologacao.it-codigo begins "112"
        or homologacao.it-codigo begins "122"
        then do:
            find first conteudo-programa
                 where conteudo-programa.cod-programa = ponto-programa.cod-programa
                   and conteudo-programa.sequencia    = 3
                   no-lock no-error.
            if avail conteudo-programa
            then assign teste.cc-codigo = ENTRY(1,conteudo-programa.conteudo,",").
        end.
        else
        if homologacao.it-codigo begins "126"
        then do:
            find first conteudo-programa
                 where conteudo-programa.cod-programa = ponto-programa.cod-programa
                   and conteudo-programa.sequencia    = 5
                   no-lock no-error.
            if avail conteudo-programa
            then assign teste.cc-codigo = ENTRY(1,conteudo-programa.conteudo,",").

        end.
        else do:
            find first conteudo-programa
                 where conteudo-programa.cod-programa = ponto-programa.cod-programa
                   and conteudo-programa.sequencia    = 2
                   no-lock no-error.
            if avail conteudo-programa
            then assign teste.cc-codigo = ENTRY(1,conteudo-programa.conteudo,",").

        end.
        
    end.       

    find first item where item.it-codigo = homologacao.it-codigo no-lock no-error. 
    FIND FIRST item-uni-estab WHERE 
               item-uni-estab.it-codigo   = homologacao.it-codigo AND
               item-uni-estab.cod-estabel = v_cod_estab_usuar NO-LOCK NO-ERROR.

    ASSIGN c-cod-comprado = IF AVAIL item-uni-estab THEN item-uni-estab.cod-comprado ELSE "".

    find first fabricante where fabricante.cod-fabric = homologacao.cod-fabric no-lock no-error.
    find first comprador where comprador.cod-comprado = c-cod-comprado no-lock no-error.

    IF AVAIL comprador THEN
        ASSIGN c-nome-comprador = comprador.nome.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 15825, 
                           INPUT "Comprador em branco ou n∆o cadastrado. Verifique no cc0120").
    END.
    
    RUN piEnviaEmail(INPUT "ems@intelbras.com.br",
                     INPUT "grupo.eqf@intelbras.com.br",
                     INPUT "Entrada de Itens na Homologaá∆o",
                     INPUT "Item: " + homologacao.it-codigo  + " - " + item.descricao-1 + item.descricao-2 + chr(10) +
                           "Fabricante: " + string(homologacao.cod-fabric) + " - " + fabricante.nome + chr(10) +
                           "Comprador: " + c-cod-comprado + " - " + c-nome-comprador + chr(10) +
                           "Quantidade: " + string(lote-hml.quantidade),
                     INPUT "").

    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-emitente wWindow
ON F5 OF cod-emitente IN FRAME fPage1 /* Fornecedor */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098"
                       &campo="cod-emitente"
                       &campozoom="cod-emitente"
                       &campo2="nome-emit"
                       &campozoom2="nome-emit"
                       &frame="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-emitente wWindow
ON LEAVE OF cod-emitente IN FRAME fPage1 /* Fornecedor */
DO:
  find emitente where emitente.cod-emitente = frame fPage1 cod-emitente
                    no-lock no-error.
  if avail emitente
  then assign nome-emit:screen-value in frame fPage1 = emitente.nome-emit.
  else assign nome-emit:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-emitente wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-emitente IN FRAME fPage1 /* Fornecedor */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-fabric
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-fabric wWindow
ON F5 OF cod-fabric IN FRAME fPage1 /* Fabricante */
DO:
  {include/zoomvar.i &prog-zoom="eszoom/z01es077"
                     &campo="cod-fabric"
                     &campozoom="cod-fabric"
                     &campo2="nome-abrev-fabric"
                     &campozoom2="nome-abrev"
                     &frame="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-fabric wWindow
ON LEAVE OF cod-fabric IN FRAME fPage1 /* Fabricante */
DO:
  find first fabricante
       where fabricante.cod-fabric = frame fPage1 cod-fabric
       no-lock no-error.
  if avail fabricante
  then assign nome-abrev-fabric:screen-value in frame fPage1 = fabricante.nome-abrev.
  else assign nome-abrev-fabric:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-fabric wWindow
ON MOUSE-SELECT-DBLCLICK OF cod-fabric IN FRAME fPage1 /* Fabricante */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-codigo wWindow
ON F5 OF it-codigo IN FRAME fPage1 /* Item */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172"
                       &campo="it-codigo"
                       &campozoom="it-codigo"
                       &campo2="desc-item"
                       &campozoom2="desc-item"
                       &frame="fPage1"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-codigo wWindow
ON LEAVE OF it-codigo IN FRAME fPage1 /* Item */
DO:
    find item where item.it-codigo = frame fPage1 it-codigo
              no-lock no-error.
    if avail item
    then assign desc-item:screen-value in frame fPage1 = item.desc-item.
    else assign desc-item:screen-value in frame fPage1 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF it-codigo IN FRAME fPage1 /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solicitante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solicitante wWindow
ON F5 OF solicitante IN FRAME fPage1 /* Solicitante */
DO:
    /*
   {include/zoomvar.i &prog-zoom="eszoom/z01es198.w"
                      &campo="solicitante"
                      &campozoom="usuario-magnus"
                      &campo2="nome"
                      &campozoom2="nome"
                      &frame="fPage1"}
    */                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solicitante wWindow
ON LEAVE OF solicitante IN FRAME fPage1 /* Solicitante */
DO:
  find usuar_mestre no-lock 
      where usuar_mestre.cod_usuario = frame fPage1 solicitante no-error.

  if avail usuar_mestre 
  then assign nome:screen-value in frame fPage1 = usuar_mestre.nom_usuario.
  else assign nome:screen-value in frame fPage1 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solicitante wWindow
ON MOUSE-SELECT-DBLCLICK OF solicitante IN FRAME fPage1 /* Solicitante */
DO:
    /*
  apply 'F5' to self.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
cod-fabric:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
solicitante:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayWidgets wWindow 
PROCEDURE beforeDisplayWidgets :
assign data-inicio  = today
       situacao     = 1
       ds-situacao  = "Aberto"
       data-ult-sit = today
       cb-tipo:SCREEN-VALUE IN FRAME fpage1 = "Amostra".

disp data-inicio
     situacao
     ds-situacao
     data-ult-sit
     with frame fPage1.
     
apply 'entry' to it-codigo in frame fPage1.   



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmail wWindow 
PROCEDURE piEnviaEmail :
DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pdestino                 /* Destinat†rio       */ 
           tt-envio2.remetente         = pRemetente               /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                 /* Arquivo Tempor†rio */
           tt-envio2.formato           = "TEXTO".
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail.          /* Mensagem           */


    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN run cdp/cd0666.w (input table tt-erros).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDados wWindow 
PROCEDURE piValidaDados :
find item where item.it-codigo = frame fPage1 it-codigo
                no-lock no-error.
    if not avail item
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Item n∆o cadastrado.").
        return 'NOK'.
    end.
    
    find emitente where emitente.cod-emitente = frame fPage1 cod-emitente
                    and emitente.identific    > 1
                    no-lock no-error.
    if not avail emitente
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Fornecedor n∆o cadastrado.").
        return 'NOK'.
    end.
            
    find first fabricante
         where fabricante.cod-fabric = frame fPage1 cod-fabric
         no-lock no-error.
    if not avail fabricante
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Fabricante n∆o cadastrado.").
        return 'NOK'.
    end.                       
    
    if frame fPage1 ref-biblio = ""
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "A Referància deve ser informada.").
        return 'NOK'.
    end.
    
    FIND usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = FRAME fPage1 solicitante NO-ERROR.
    if not avail usuar_mestre
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Solicitante n∆o cadastrado.").
        return 'NOK'.
    end.
    
    
    /* retirado a pedido de Brand∆o 19/03 - Evandro    
    find first b-homologacao
         where b-homologacao.it-codigo    = frame fPage1 it-codigo
           and b-homologacao.cod-fabric   = frame fPage1 cod-fabric
           no-lock no-error.
    if avail b-homologacao 
    then do:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17567, 
                           INPUT "Este item j† est† em homologaá∆o com este fabricante no processo: " + string(b-homologacao.nr-processo)).
        return 'NOK'.
    end.
    */
    
    return 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

