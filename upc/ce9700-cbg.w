&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/***********************************************************************
**  Programa..: UPC\CE9700-CBG
**  Autor.....: Nicolas Martinez
**  Data......: Dezembro/2021 - Desenvolvimento
**  Descricao.: Bot∆o de Cubagem
**  Vers o....: 001 08/12/2021
**                  Desenvolvimento Programa
************************************************************************/
{include/i-prgvrs.i CE9700-CBG 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        CE9700-CBG
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel text-entrada br-itens
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Local Variable Definitions ---                                       */
DEFINE INPUT PARAM p-num-docto-transf AS INTEGER NO-UNDO.

&GLOBAL-DEFINE ROW-NUM-DEFINED YES

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD seq         AS INTE
    FIELD it-codigo   AS CHAR
    FIELD qtd-cbg-ind AS DECI
    FIELD qtd-tot-ind AS DECI
    FIELD qtd-cbg-col LIKE item.volume
    FIELD qtd-tot-col AS DECI
    FIELD embalagem   AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-itens

/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens tt-itens.seq tt-itens.it-codigo tt-itens.embalagem tt-itens.qtd-cbg-ind tt-itens.qtd-tot-ind tt-itens.qtd-cbg-col tt-itens.qtd-tot-col   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens   
&Scoped-define SELF-NAME br-itens
&Scoped-define QUERY-STRING-br-itens FOR EACH tt-itens
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY {&SELF-NAME} FOR EACH tt-itens.
&Scoped-define TABLES-IN-QUERY-br-itens tt-itens
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens tt-itens


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-itens}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-12 br-itens btOK btCancel 

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

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Informaá‰es Cubagem Itens" 
      VIEW-AS TEXT 
     SIZE 19.72 BY .63
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.14 BY 9.21.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 85 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens FOR 
      tt-itens SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens wWindow _FREEFORM
  QUERY br-itens DISPLAY
      tt-itens.seq         COLUMN-LABEL "Nr Seq"
 tt-itens.it-codigo   COLUMN-LABEL "Item" FORMAT "x(12)"
 tt-itens.embalagem   COLUMN-LABEL "Embalagem"
 tt-itens.qtd-cbg-ind COLUMN-LABEL "Cubagem Ind" FORMAT "zzzzz9.999999999"
 tt-itens.qtd-tot-ind COLUMN-LABEL "Cub Tot Ind" FORMAT "zzzzz9.999999999"
 tt-itens.qtd-cbg-col COLUMN-LABEL "Cubagem Col" FORMAT "zzzzz9.999999999"
 tt-itens.qtd-tot-col COLUMN-LABEL "Cub Tot Col" FORMAT "zzzzz9.999999999"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81.14 BY 8.08
         FONT 1 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-itens AT ROW 1.75 COL 2.86 WIDGET-ID 200
     btOK AT ROW 10.79 COL 2
     btCancel AT ROW 10.79 COL 13
     text-entrada AT ROW 1.04 COL 3.29 NO-LABEL WIDGET-ID 8
     rtToolBar AT ROW 10.58 COL 1
     RECT-12 AT ROW 1.29 COL 1.57 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.14 BY 11.2
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
         HEIGHT             = 11.08
         WIDTH              = 85.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 111.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 111.86
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-itens RECT-12 fpage0 */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fpage0
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fpage0     = 
                "Informaá‰es Cubagem Itens".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-itens.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-itens */
&ANALYZE-RESUME

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


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
 APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-itens.

    FOR EACH docto-transf-depos WHERE 
             docto-transf-depos.num-docto-transf = p-num-docto-transf
             NO-LOCK,
        EACH Item-docto-transf-depos OF docto-transf-depos
             NO-LOCK.

        CREATE tt-itens.
        ASSIGN tt-itens.seq       = Item-docto-transf-depos.num-seq
               tt-itens.it-codigo = Item-docto-transf-depos.cod-item
               .

        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = Item-docto-transf-depos.cod-item
                   NO-LOCK NO-ERROR.

        IF AVAIL ITEM 
        THEN ASSIGN tt-itens.qtd-cbg-ind = ((item.altura / 1000) * (item.largura / 1000) * (item.comprim / 1000))
                    tt-itens.qtd-tot-ind = (((item.altura / 1000) * (item.largura / 1000) * (item.comprim / 1000)) * Item-docto-transf-depos.qtd-item).

        FIND FIRST item-caixa WHERE
                   item-caixa.it-codigo = Item-docto-transf-depos.cod-item
                   NO-LOCK NO-ERROR.

        IF AVAIL item-caixa 
        THEN DO:
            FIND FIRST embalag OF item-caixa NO-LOCK NO-ERROR.

            IF AVAIL embalag 
            THEN ASSIGN tt-itens.qtd-cbg-col = ((embalag.altura / 1000) * (embalag.largura / 1000) * (embalag.comprim / 1000))
                        tt-itens.embalagem   = embalag.embalagem
                        tt-itens.qtd-tot-col = (Item-docto-transf-depos.qtd-item / item-caixa.qt-item) * tt-itens.qtd-cbg-col.

        END.
    END.

    {&OPEN-QUERY-br-itens}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

