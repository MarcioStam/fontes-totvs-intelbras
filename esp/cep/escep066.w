&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
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
{include/i-prgvrs.i ESCEP066 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP066
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btHelp2 ~
                              bt-filtro bt-atualiza br-item-insp ~
                              bt-sobe bt-desce bt-inc bt-del
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE fi-item-fam-ini       AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-item-fam-fim       AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-cod-estabel-ini    AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-cod-estabel-fim    AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-it-codigo-ini      AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-it-codigo-fim      AS CHAR         NO-UNDO.
DEFINE VARIABLE fi-cod-fabric-ini     AS INT          NO-UNDO.
DEFINE VARIABLE fi-cod-fabric-fim     AS INT          NO-UNDO.
DEFINE VARIABLE fi-ativos             AS LOG          NO-UNDO.
DEFINE VARIABLE fi-vencidos           AS LOG          NO-UNDO.
DEFINE VARIABLE rw-item-insp          AS ROWID        NO-UNDO.
DEFINE VARIABLE h-esapi017            AS HANDLE       NO-UNDO.
DEFINE VARIABLE i-cor                 AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-ativo               AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-hora-ini            AS CHAR    NO-UNDO.
DEFINE VARIABLE c-hora-fim            AS CHAR    NO-UNDO.
DEFINE VARIABLE c-fabricante          AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-item-insp FOR item-insp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-item-insp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES item-insp

/* Definitions for BROWSE br-item-insp                                  */
&Scoped-define FIELDS-IN-QUERY-br-item-insp f-ativo(item-insp.dt-fim-val) @ c-ativo item-insp.it-fam item-insp.sequen item-insp.cod-estabel item-insp.it-codigo item-insp.cod-fabric f-fabric(item-insp.cod-fabric) @ c-fabricante item-insp.log-nec-inspec item-insp.dt-ini-val SUBSTRING(STRING(item-insp.dt-ini-val, "99/99/9999 HH:MM"),12,5) @ c-hora-ini item-insp.usuar-ini item-insp.dt-fim-val SUBSTRING(STRING(item-insp.dt-fim-val, "99/99/9999 HH:MM"),12,5) @ c-hora-fim item-insp.usuar-fim item-insp.just-ini item-insp.just-fim   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-item-insp   
&Scoped-define SELF-NAME br-item-insp
&Scoped-define QUERY-STRING-br-item-insp FOR EACH item-insp USE-INDEX seq       WHERE      item-insp.it-fam >= fi-item-fam-ini  AND item-insp.it-fam <= fi-item-fam-fim   AND ((item-insp.cod-estabel = "*") OR       (item-insp.cod-estabel >= fi-cod-estabel-ini AND            item-insp.cod-estabel <= fi-cod-estabel-fim))   AND ((item-insp.it-codigo = "*") OR       (item-insp.it-codigo >= fi-it-codigo-ini AND            item-insp.it-codigo <= fi-it-codigo-fim))   AND ((item-insp.cod-fabric = "*") OR      (int(item-insp.cod-fabric) >= fi-cod-fabric-ini AND       int(item-insp.cod-fabric) <= fi-cod-fabric-fim))   AND ((fi-ativos                and item-insp.dt-fim-val >= NOW) OR       (fi-vencidos      and item-insp.dt-fim-val <  NOW) or           (fi-ativos            and fi-vencidos))   NO-LOCK
&Scoped-define OPEN-QUERY-br-item-insp OPEN QUERY {&SELF-NAME} FOR EACH item-insp USE-INDEX seq       WHERE      item-insp.it-fam >= fi-item-fam-ini  AND item-insp.it-fam <= fi-item-fam-fim   AND ((item-insp.cod-estabel = "*") OR       (item-insp.cod-estabel >= fi-cod-estabel-ini AND            item-insp.cod-estabel <= fi-cod-estabel-fim))   AND ((item-insp.it-codigo = "*") OR       (item-insp.it-codigo >= fi-it-codigo-ini AND            item-insp.it-codigo <= fi-it-codigo-fim))   AND ((item-insp.cod-fabric = "*") OR      (int(item-insp.cod-fabric) >= fi-cod-fabric-ini AND       int(item-insp.cod-fabric) <= fi-cod-fabric-fim))   AND ((fi-ativos                and item-insp.dt-fim-val >= NOW) OR       (fi-vencidos      and item-insp.dt-fim-val <  NOW) or           (fi-ativos            and fi-vencidos))   NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-item-insp item-insp
&Scoped-define FIRST-TABLE-IN-QUERY-br-item-insp item-insp


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-item-insp}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 bt-filtro ~
bt-atualiza btQueryJoins btReportsJoins btExit btHelp br-item-insp bt-sobe ~
bt-desce bt-inc bt-del btOK btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-ativo wWindow 
FUNCTION f-ativo RETURNS CHARACTER
  ( INPUT p-fim-val AS DATETIME )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-fabric wWindow 
FUNCTION f-fabric RETURNS CHARACTER
  ( INPUT p-cod-fabric AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
DEFINE BUTTON bt-atualiza 
     IMAGE-UP FILE "image/im-relo.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Atualizar" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizar"
     FONT 4.

DEFINE BUTTON bt-del 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-desce 
     IMAGE-UP FILE "image/im-abx1.bmp":U
     LABEL "Desce Sequencia" 
     SIZE 4 BY 1.25 TOOLTIP "Desce Sequencia"
     FONT 4.

DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "image/im-fpv.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Filtro" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro"
     FONT 4.

DEFINE BUTTON bt-inc 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-sobe 
     IMAGE-UP FILE "image/im-acm1.bmp":U
     LABEL "Sobe Sequencia" 
     SIZE 4 BY 1.25 TOOLTIP "Sobe Sequencia"
     FONT 4.

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
     LABEL "Fechar" 
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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 20.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-item-insp FOR 
      item-insp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-item-insp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-item-insp wWindow _FREEFORM
  QUERY br-item-insp NO-LOCK DISPLAY
      f-ativo(item-insp.dt-fim-val) @ c-ativo   COLUMN-LABEL "Ativo" FORMAT "X(07)" WIDTH 8
      item-insp.it-fam COLUMN-LABEL "Fam C¢d Item" FORMAT "x(3)":U
            WIDTH 11.43
      item-insp.sequen FORMAT ">>>,>>9":U
      item-insp.cod-estabel FORMAT "x(3)":U
      item-insp.it-codigo FORMAT "x(7)":U WIDTH 11.43
      item-insp.cod-fabric FORMAT "x(6)":U
      f-fabric(item-insp.cod-fabric) @ c-fabricante FORMAT "X(20)" COLUMN-LABEL "Nome Fabric" WIDTH 24
      item-insp.log-nec-inspec FORMAT "Sim/NÆo"
      item-insp.dt-ini-val FORMAT "99/99/9999":U
      SUBSTRING(STRING(item-insp.dt-ini-val, "99/99/9999 HH:MM"),12,5) @ c-hora-ini  COLUMN-LABEL "Hr Ini"
      item-insp.usuar-ini FORMAT "x(12)":U
      item-insp.dt-fim-val FORMAT "99/99/9999":U
      SUBSTRING(STRING(item-insp.dt-fim-val, "99/99/9999 HH:MM"),12,5) @ c-hora-fim  COLUMN-LABEL "Hr Fim"
      item-insp.usuar-fim FORMAT "x(12)":U
      item-insp.just-ini FORMAT "x(1000)":U
      item-insp.just-fim FORMAT "x(1000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 106 BY 19
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-filtro AT ROW 1.13 COL 1.72 HELP
          "Filtro" WIDGET-ID 12
     bt-atualiza AT ROW 1.13 COL 56.29 HELP
          "Atualizar" WIDGET-ID 18
     btQueryJoins AT ROW 1.13 COL 98.43 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 102.43 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 106.43 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 110.43 HELP
          "Ajuda"
     br-item-insp AT ROW 3 COL 3 WIDGET-ID 200
     bt-sobe AT ROW 10.25 COL 109 HELP
          "Sobe Sequencia" WIDGET-ID 14
     bt-desce AT ROW 11.75 COL 109 HELP
          "Desce Sequencia" WIDGET-ID 16
     bt-inc AT ROW 22 COL 3 WIDGET-ID 6
     bt-del AT ROW 22 COL 13 WIDGET-ID 8
     btOK AT ROW 23.71 COL 2
     btHelp2 AT ROW 23.71 COL 104
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 23.5 COL 1
     RECT-1 AT ROW 2.75 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114 BY 24.04
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 74 ROW 22.04
         SIZE 4 BY 1.08
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 24.04
         WIDTH              = 114
         MAX-HEIGHT         = 24.04
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 24.04
         VIRTUAL-WIDTH      = 114.14
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
/* BROWSE-TAB br-item-insp btHelp fpage0 */
/* SETTINGS FOR FRAME fPage1
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME fPage1:SENSITIVE        = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-item-insp
/* Query rebuild information for BROWSE br-item-insp
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH item-insp USE-INDEX seq
      WHERE      item-insp.it-fam >= fi-item-fam-ini
 AND item-insp.it-fam <= fi-item-fam-fim

 AND ((item-insp.cod-estabel = "*") OR
      (item-insp.cod-estabel >= fi-cod-estabel-ini AND
           item-insp.cod-estabel <= fi-cod-estabel-fim))

 AND ((item-insp.it-codigo = "*") OR
      (item-insp.it-codigo >= fi-it-codigo-ini AND
           item-insp.it-codigo <= fi-it-codigo-fim))

 AND ((item-insp.cod-fabric = "*") OR
     (int(item-insp.cod-fabric) >= fi-cod-fabric-ini AND
      int(item-insp.cod-fabric) <= fi-cod-fabric-fim))

 AND ((fi-ativos                and item-insp.dt-fim-val >= NOW) OR
      (fi-vencidos      and item-insp.dt-fim-val <  NOW) or
          (fi-ativos            and fi-vencidos))
  NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "       item-insp.it-fam >= fi-item-fam-ini
 AND item-insp.it-fam <= fi-item-fam-fim
 
 AND ((item-insp.cod-estabel = ""*"") OR
      (item-insp.cod-estabel >= fi-cod-estabel-ini AND
           item-insp.cod-estabel <= fi-cod-estabel-fim))
           
 AND ((item-insp.it-codigo = ""*"") OR     
      (item-insp.it-codigo >= fi-it-codigo-ini AND 
           item-insp.it-codigo <= fi-it-codigo-fim))
 
 AND ((item-insp.cod-fabric = ""*"") OR
     (int(item-insp.cod-fabric) >= fi-cod-fabric-ini AND
      int(item-insp.cod-fabric) <= fi-cod-fabric-fim))
          
 AND ((fi-ativos                and item-insp.dt-fim-val >= NOW) OR
      (fi-vencidos      and item-insp.dt-fim-val <  NOW) or
          (fi-ativos            and fi-vencidos))
 "
     _Query            is OPENED
*/  /* BROWSE br-item-insp */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME br-item-insp
&Scoped-define SELF-NAME br-item-insp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-item-insp wWindow
ON ROW-DISPLAY OF br-item-insp IN FRAME fpage0
DO:

    IF AVAIL item-insp THEN DO:

        IF item-insp.dt-fim-val <> DATETIME(12, 31, 9999, 23, 59, 59, 999) THEN
            ASSIGN i-cor = 9.
        ELSE
            ASSIGN i-cor = ?.

        ASSIGN c-ativo:FGCOLOR                  IN BROWSE br-item-insp = i-cor
               item-insp.it-fam:FGCOLOR         IN BROWSE br-item-insp = i-cor
               item-insp.sequen:FGCOLOR         IN BROWSE br-item-insp = i-cor
               item-insp.cod-estabel:FGCOLOR    IN BROWSE br-item-insp = i-cor
               item-insp.it-codigo:FGCOLOR      IN BROWSE br-item-insp = i-cor
               item-insp.cod-fabric:FGCOLOR     IN BROWSE br-item-insp = i-cor
               c-fabricante:FGCOLOR             IN BROWSE br-item-insp = i-cor
               item-insp.log-nec-insp:FGCOLOR   IN BROWSE br-item-insp = i-cor
               item-insp.dt-ini-val:FGCOLOR     IN BROWSE br-item-insp = i-cor
               c-hora-ini:FGCOLOR               IN BROWSE br-item-insp = i-cor
               item-insp.usuar-ini:FGCOLOR      IN BROWSE br-item-insp = i-cor
               item-insp.just-ini:FGCOLOR       IN BROWSE br-item-insp = i-cor
               item-insp.dt-fim-val:FGCOLOR     IN BROWSE br-item-insp = i-cor
               c-hora-fim:FGCOLOR               IN BROWSE br-item-insp = i-cor
               item-insp.usuar-fim:FGCOLOR      IN BROWSE br-item-insp = i-cor
               item-insp.just-fim:FGCOLOR       IN BROWSE br-item-insp = i-cor .

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza wWindow
ON CHOOSE OF bt-atualiza IN FRAME fpage0 /* Atualizar */
DO:
    
    RUN pi-atualiza.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del wWindow
ON CHOOSE OF bt-del IN FRAME fpage0 /* Eliminar */
DO:

    IF AVAIL item-insp THEN DO:

        wWindow:SENSITIVE = FALSE.

        RUN esp/cep/escep066c.w (INPUT ROWID(item-insp)).

        IF RETURN-VALUE = "OK":U THEN DO:

            {&open-query-br-item-insp}
    
           /* RUN pi-atualiza.*/

        END.

        wWindow:SENSITIVE = TRUE.

    END.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desce
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desce wWindow
ON CHOOSE OF bt-desce IN FRAME fpage0 /* Desce Sequencia */
DO:

    IF AVAIL item-insp THEN DO:

        IF item-insp.sequen <> 0 THEN DO:

            FIND CURRENT item-insp EXCLUSIVE-LOCK.
    
            ASSIGN rw-item-insp = ROWID(item-insp).
    
            FOR FIRST b-item-insp USE-INDEX seq EXCLUSIVE-LOCK
                WHERE b-item-insp.it-fam = item-insp.it-fam
                AND   b-item-insp.sequen > item-insp.sequen:
    
                ASSIGN item-insp.sequen = item-insp.sequen + 1
                       b-item-insp.sequen = b-item-insp.sequen - 1.
    
                {&open-query-br-item-insp}
    
                REPOSITION br-item-insp TO rowid(rw-item-insp).
    
                /*br-item-insp:SCROLL-TO-CURRENT-ROW() IN FRAME fPage0.*/
    
            END.

        END.

    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro wWindow
ON CHOOSE OF bt-filtro IN FRAME fpage0 /* Filtro */
DO:

    wWindow:SENSITIVE = FALSE.

    RUN esp/cep/escep066a.w (INPUT-OUTPUT fi-item-fam-ini,
                             INPUT-OUTPUT fi-item-fam-fim,   
                             INPUT-OUTPUT fi-cod-estabel-ini,
                             INPUT-OUTPUT fi-cod-estabel-fim,
                             INPUT-OUTPUT fi-it-codigo-ini,  
                             INPUT-OUTPUT fi-it-codigo-fim,  
                             INPUT-OUTPUT fi-cod-fabric-ini, 
                             INPUT-OUTPUT fi-cod-fabric-fim, 
                             INPUT-OUTPUT fi-ativos,         
                             INPUT-OUTPUT fi-vencidos).

    DO WITH FRAME fPage0:
 
        IF fi-item-fam-ini     <> ""         OR
           fi-item-fam-fim     <> "ZZZ"      OR
           fi-cod-estabel-ini  <> ""         OR
           fi-cod-estabel-fim  <> "ZZZ"      OR
           fi-it-codigo-ini    <> ""         OR
           fi-it-codigo-fim    <> "ZZZZZZZ"  OR
           fi-cod-fabric-ini   <> 0          OR
           fi-cod-fabric-fim   <> 999999     OR
           fi-ativos           <> TRUE       OR
           fi-vencidos         <> FALSE THEN
            bt-filtro:LOAD-IMAGE-UP("image/toolbar/im-ran5.bmp").
        ELSE 
            bt-filtro:LOAD-IMAGE-UP("image/toolbar/im-fpv.bmp").

    END.

    {&open-query-br-item-insp}

    wWindow:SENSITIVE = TRUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inc wWindow
ON CHOOSE OF bt-inc IN FRAME fpage0 /* Incluir */
DO:

    wWindow:SENSITIVE = FALSE.

    RUN esp/cep/escep066b.w.

    IF RETURN-VALUE = "OK":U THEN DO:

        {&open-query-br-item-insp}

        /*RUN pi-atualiza.*/

    END.
  
    wWindow:SENSITIVE = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sobe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sobe wWindow
ON CHOOSE OF bt-sobe IN FRAME fpage0 /* Sobe Sequencia */
DO:

    IF AVAIL item-insp THEN DO:

        ASSIGN rw-item-insp = ROWID(item-insp).

        FIND CURRENT item-insp EXCLUSIVE-LOCK.

        IF item-insp.sequen > 1 THEN DO:

            FOR FIRST b-item-insp USE-INDEX seq EXCLUSIVE-LOCK
                WHERE b-item-insp.it-fam = item-insp.it-fam
                AND   b-item-insp.sequen = item-insp.sequen - 1:

                ASSIGN item-insp.sequen = item-insp.sequen - 1
                       b-item-insp.sequen = b-item-insp.sequen + 1.

                {&open-query-br-item-insp}

                REPOSITION br-item-insp TO rowid(rw-item-insp).

                /*br-item-insp:SCROLL-TO-CURRENT-ROW() IN FRAME fPage0.*/

            END.

        END.

    END.
    
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
ON CHOOSE OF btOK IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
   /*RUN showQueryJoins IN THIS-PROCEDURE.*/

    MESSAGE bt-filtro:IMAGE-UP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

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

    RUN esapi/esapi017.p PERSISTENT SET h-esapi017.

    ASSIGN fi-item-fam-ini     = ""
           fi-item-fam-fim     = "ZZZ"
           fi-cod-estabel-ini  = ""
           fi-cod-estabel-fim  = "ZZZ"
           fi-it-codigo-ini    = ""
           fi-it-codigo-fim    = "ZZZZZZZ"
           fi-cod-fabric-ini   = 0
           fi-cod-fabric-fim   = 999999
           fi-ativos           = TRUE
           fi-vencidos         = FALSE.

    {&open-query-br-item-insp}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDestroyInterface wWindow 
PROCEDURE BeforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-atualiza.

    DELETE PROCEDURE h-esapi017.
    ASSIGN h-esapi017 = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza wWindow 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN pi-atualiza IN h-esapi017.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-ativo wWindow 
FUNCTION f-ativo RETURNS CHARACTER
  ( INPUT p-fim-val AS DATETIME ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF p-fim-val <> DATETIME(12, 31, 9999, 23, 59, 59, 999) THEN 
        RETURN "Vencido".
    ELSE
        RETURN "Ativo".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-fabric wWindow 
FUNCTION f-fabric RETURNS CHARACTER
  ( INPUT p-cod-fabric AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-cod-fabric AS INTEGER     NO-UNDO.
    

    ASSIGN i-cod-fabric = INT(p-cod-fabric) NO-ERROR.

    IF NOT ERROR-STATUS:ERROR THEN DO:

        FOR FIRST fabricante NO-LOCK
            WHERE fabricante.cod-fabric = i-cod-fabric:
    
            RETURN fabricante.nome-abrev.
    
        END.

    END.

    IF p-cod-fabric = "*" THEN
        RETURN "Todos Fabricantes".

    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

