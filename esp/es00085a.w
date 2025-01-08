
RUN esp/es0008.r.

/*
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEF VAR l-acessa AS LOG.

DEF BUFFER bf-modul_rot_proced     FOR modul_rot_proced.
DEF BUFFER bf-modul_dtsul          FOR modul_dtsul.
DEF BUFFER bf-sist_dtsul           FOR sist_dtsul.
DEF BUFFER bf-sub_rot_dtsul_proced FOR sub_rot_dtsul_proced.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES grp_usuar PROCED_segur procedimento

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 grp_usuar.cod_grp_usuar grp_usuar.des_grp_usuar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH grp_usuar
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME} FOR EACH grp_usuar.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 grp_usuar
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 grp_usuar


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 PROCED_segur.cod_grp_usuar grp_usuar.des_grp_usuar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH PROCED_segur                            WHERE PROCED_segur.cod_proced = c_cod_proced:SCREEN-VALUE IN FRAME {&FRAME-NAME}, ~
                               EACH grp_usuar WHERE grp_usuar.cod_grp_usuar = PROCED_segur.cod_grp_usuar
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH PROCED_segur                            WHERE PROCED_segur.cod_proced = c_cod_proced:SCREEN-VALUE IN FRAME {&FRAME-NAME}, ~
                               EACH grp_usuar WHERE grp_usuar.cod_grp_usuar = PROCED_segur.cod_grp_usuar.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 PROCED_segur grp_usuar
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 PROCED_segur
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 grp_usuar


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}
&Scoped-define QUERY-STRING-DEFAULT-FRAME FOR EACH procedimento SHARE-LOCK
&Scoped-define OPEN-QUERY-DEFAULT-FRAME OPEN QUERY DEFAULT-FRAME FOR EACH procedimento SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DEFAULT-FRAME procedimento
&Scoped-define FIRST-TABLE-IN-QUERY-DEFAULT-FRAME procedimento


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btUpdate btCancel btSave bt-acesso bt-libero btExit BROWSE-1 BROWSE-2 ~
BUTTON-1 BUTTON-2 rtParent rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS c_cod_proced c_des_proced c-usuario c-nome ~
c-ramal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-acesso 
     IMAGE-UP FILE "adeicon/pages.bmp":U
     LABEL "Acesso" 
     SIZE 4 BY 1.25 TOOLTIP "Clique aqui para ver a lista de programas que vocà tem acesso"
     FONT 4.

DEFINE BUTTON bt-libero 
     IMAGE-UP FILE "adeicon/prospy9.ico":U
     LABEL "Libero" 
     SIZE 4 BY 1.25 TOOLTIP "Clique aqui para ver a lista de programas que vocà libera"
     FONT 4.

DEFINE BUTTON bt-sollib 
     IMAGE-UP FILE "adeicon/dog.bmp":U
     LABEL "Liberaá∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Clique aqui para solicitar acesso ao programa"
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela Alteraá∆o"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25 TOOLTIP "Primeiro".

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25 TOOLTIP "V† Para".

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25 TOOLTIP "Èltimo".

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25 TOOLTIP "Pr¢ximo".

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25 TOOLTIP "Anterior".

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25 TOOLTIP "Confirma Alteraá∆o"
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "adeicon/browse-u.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25 TOOLTIP "Busca por Programa".

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25 TOOLTIP "Modifica Respons†vel"
     FONT 4.

DEFINE BUTTON BUTTON-1 
     LABEL ">" 
     SIZE 5 BY 1.13.

DEFINE BUTTON BUTTON-2 
     LABEL "<" 
     SIZE 5 BY 1.13.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .79 NO-UNDO.

DEFINE VARIABLE c-ramal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ramal" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .79 NO-UNDO.

DEFINE VARIABLE c-usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Respons†vel" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE c_cod_proced AS CHARACTER FORMAT "x(32)" 
     LABEL "Procedimento" 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .79.

DEFINE VARIABLE c_des_proced AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 61.14 BY .79.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 112 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 112 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      grp_usuar SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      PROCED_segur, 
      grp_usuar SCROLLING.

DEFINE QUERY DEFAULT-FRAME FOR 
      procedimento SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _FREEFORM
  QUERY BROWSE-1 DISPLAY
      grp_usuar.cod_grp_usuar FORMAT "x(9)" 
 grp_usuar.des_grp_usuar
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 51 BY 16.5 EXPANDABLE TOOLTIP "Lista de Todos os Usu†rios".

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 C-Win _FREEFORM
  QUERY BROWSE-2 DISPLAY
      PROCED_segur.cod_grp_usuar FORMAT "x(9)"
 grp_usuar.des_grp_usuar
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 51 BY 16.5 EXPANDABLE TOOLTIP "Lista dos Usu†rios que tem Acesso".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btUpdate AT ROW 1.13 COL 25.72 HELP
          "Altera ocorrància corrente"
     btCancel AT ROW 1.13 COL 30 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 34 HELP
          "Confirma alteraá‰es"
     bt-sollib AT ROW 1.13 COL 50 HELP
          "Confirma alteraá‰es"
     bt-acesso AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     bt-libero AT ROW 1.13 COL 60 HELP
          "Confirma alteraá‰es"
     btExit AT ROW 1.13 COL 108 HELP
          "Sair"
     c_cod_proced AT ROW 3.25 COL 14 COLON-ALIGNED
     c_des_proced AT ROW 3.25 COL 48 COLON-ALIGNED HELP
          "Descriá∆o do Procedimento" NO-LABEL
     c-usuario AT ROW 4.25 COL 14 COLON-ALIGNED
     c-nome AT ROW 4.25 COL 26 COLON-ALIGNED NO-LABEL
     c-ramal AT ROW 4.25 COL 93 COLON-ALIGNED
     BROWSE-1 AT ROW 7 COL 2
     BROWSE-2 AT ROW 7 COL 62
     BUTTON-1 AT ROW 14 COL 55
     BUTTON-2 AT ROW 16 COL 55
     rtParent AT ROW 3 COL 1
     rtToolBar AT ROW 1 COL 1
     "Usu†rios" VIEW-AS TEXT
          SIZE 13 BY .67 AT ROW 6.25 COL 2
          FGCOLOR 12 
     "Usu†rios com Permiss∆o de Acesso" VIEW-AS TEXT
          SIZE 44 BY .67 AT ROW 6.25 COL 62
          FGCOLOR 9 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112.43 BY 22.67.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ES00085a - Seguranáa EMS5"
         HEIGHT             = 22.67
         WIDTH              = 112.43
         MAX-HEIGHT         = 22.67
         MAX-WIDTH          = 112.43
         VIRTUAL-HEIGHT     = 22.67
         VIRTUAL-WIDTH      = 112.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BROWSE-1 c-ramal DEFAULT-FRAME */
/* BROWSE-TAB BROWSE-2 BROWSE-1 DEFAULT-FRAME */
/* SETTINGS FOR BUTTON bt-sollib IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       bt-sollib:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN c-nome IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ramal IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-usuario IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c_cod_proced IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c_des_proced IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH grp_usuar.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH PROCED_segur
                           WHERE PROCED_segur.cod_proced = c_cod_proced:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        EACH grp_usuar WHERE grp_usuar.cod_grp_usuar = PROCED_segur.cod_grp_usuar.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _TblList          = "procedimento"
     _Query            is OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ES00085a - Seguranáa EMS5 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ES00085a - Seguranáa EMS5 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-acesso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-acesso C-Win
ON CHOOSE OF bt-acesso IN FRAME DEFAULT-FRAME /* Acesso */
DO:
  
    OUTPUT TO c:\temp\rel-acesso.txt CONVERT TARGET "iso8859-1".
    
    PUT "RELAÄ«O DE PROCEDIMENTOS LIBERADOS PARA : " v_cod_usuar_corren SKIP (1).

    FOR EACH PROCED_segur NO-LOCK
       WHERE PROCED_segur.cod_grp_usuar = v_cod_usuar_corren
          OR PROCED_segur.cod_grp_usuar = "*",
        EACH procedimento NO-LOCK
       WHERE procedimento.cod_proced = PROCED_segur.cod_proced
         BY procedimento.cod_proced:
        DISP procedimento.cod_proced
             procedimento.nom_proced.
            
    END.

    OUTPUT CLOSE.
    OS-COMMAND SILENT notepad c:\temp\rel-acesso.txt.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-libero
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-libero C-Win
ON CHOOSE OF bt-libero IN FRAME DEFAULT-FRAME /* Libero */
DO:
    OUTPUT TO c:\temp\rel-acesso.txt CONVERT TARGET "iso8859-1".

      PUT "RELAÄ«O DE PROCEDIMENTOS DE RESPONSABILIDADE DE: " v_cod_usuar_corren SKIP (1).

      FOR EACH int-procedimento NO-LOCK
         WHERE int-procedimento.cod_usuario = v_cod_usuar_corren,
          EACH procedimento NO-LOCK
         WHERE procedimento.cod_proced = int-procedimento.cod_proced
           BY procedimento.cod_proced:
          DISP procedimento.cod_proced
               procedimento.nom_proced.

      END.

      OUTPUT CLOSE.
      OS-COMMAND SILENT notepad c:\temp\rel-acesso.txt.
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sollib
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sollib C-Win
ON CHOOSE OF bt-sollib IN FRAME DEFAULT-FRAME /* Liberaá∆o */
DO:
  /*
    
  DEF VAR i-nr-out AS INT.
  DEF VAR c-from AS CHAR.
  DEF VAR c-to AS CHAR.
  DEF VAR c-prog AS CHAR.
  
  FIND procedimento NO-LOCK 
       WHERE procedimento.cod_proced = ttint-procedimento.cod_proced.

  ASSIGN c-prog = procedimento.cod_proced + " - " + procedimento.nom_proced_menu.

  FIND proced_segur NO-LOCK
       WHERE proced_segur.cod_proced = ttint-procedimento.cod_proced
         AND PROCED_segur.cod_grp_usuar = c-seg-usuario NO-ERROR.

  IF AVAIL PROCED_segur THEN DO:

      MESSAGE "Vocà j† tem acesso a este programa !"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
  END.

  FIND proced_segur NO-LOCK
       WHERE proced_segur.cod_proced = ttint-procedimento.cod_proced
         AND PROCED_segur.cod_grp_usuar = "*" NO-ERROR.

  IF AVAIL PROCED_segur THEN DO:

      MESSAGE "Este programa j† est† liberado para todos os usu†rios !"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
  END.




  MESSAGE "Confirma Solicitaá∆o de acesso ao programa: " c-prog " ?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                      TITLE "" UPDATE choice AS LOGICAL.
  
  IF CHOICE = NO THEN RETURN NO-APPLY.
  


  DEFINE BUTTON    btGoToOK       AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
  DEFINE RECTANGLE rtGoToFields   EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 60 BY 1.3 BGCOLOR 8.
  DEFINE RECTANGLE rtGoToButton   EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 60 BY 1.5 BGCOLOR 7.
  DEFINE VARIABLE  c-just         AS CHAR FORMAT 'x(40)' LABEL "Justificativa" VIEW-AS FILL-IN  SIZE 40 BY .88 NO-UNDO.

  DEFINE FRAME fjust
              c-just        AT ROW 1.17 COL 19 COLON-ALIGN 
              rtGoToFields      AT ROW 1    COL 1
              btGoToOK          AT ROW 2.7  COL 2.14
              rtGoToButton      AT ROW 2.5  COL 1
           SPACE(0.28)
           WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                THREE-D SCROLLABLE TITLE "Justificativa da solicitaá∆o" FONT 1
                DEFAULT-BUTTON btGoToOK.

  ON  "CHOOSE":U OF btGoToOK IN FRAME fjust DO:
           ASSIGN c-just = INPUT c-just.
  
         APPLY "GO":U TO FRAME fjust.
  END.

  DISP "" @ c-just WITH FRAME fjust.

  ENABLE c-just
        btGoToOK 
        WITH FRAME fjust.

  WAIT-FOR "GO":U OF FRAME fjust.


  
  FIND usuar_mestre NO-LOCK 
       WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
  IF AVAIL usuar_mestre THEN 
      ASSIGN c-from =  usuar_mestre.nom_usuario + " <" + trim(usuar_mestre.cod_e_mail_local) + ">".

  FIND usuar_mestre NO-LOCK 
       WHERE usuar_mestre.cod_usuario = ttint-procedimento.cod_usuario NO-ERROR.
  IF AVAIL usuar_mestre THEN 
      ASSIGN c-to =  usuar_mestre.nom_usuario + " <" + trim(usuar_mestre.cod_e_mail_local) + ">".

  FIND LAST out-box NO-LOCK NO-ERROR.
  IF AVAIL out-box THEN ASSIGN i-nr-out = out-box.mai-id + 1.
  ELSE ASSIGN i-nr-out = 1.
  CREATE out-box.
  ASSIGN out-box.mai-id = i-nr-out
         out-box.mai-date-queue = TODAY
         out-box.mai-time-queue = STRING(TIME,"HH:MM:SS")   
         out-box.mai-from = c-from
         out-box.mai-headers =

             "From: " + c-from + "~n" +
             "Reply-To: " + c-to + "~n" +
             "X-Sender: Intelbras S.A." + "~n" +
             "X-Mailer: eCenter Intelbras" + "~n" +
             "MIME-version: 1.0" + "~n" +
             "Content-Type: multipart/mixed; " + 
             'boundary="Message-Boundary"' +  "~n" + 
             "Content-Transfer-Encoding: 8BIT" + "~n" 

         out-box.mai-message = 

             "--Message-Boundary" + "~n" + 
             "Content-Type: text/html; charset=iso-8859-1" + "~n" +
             "Content-Transfer-Encoding: 8BIT" + "~n" + 
             "Content-Description: Mail message body" + "~n" +
             "~n" +
             "<html>" + "~n" +
             "<head>" + "~n" +
             "  <title>Solicitaá∆o de Liberaá∆o de programa</title>" + "~n" +
             "</head>" + "~n" +
             "~n" +
             "<body>" + "~n" +
             "<p>" + "~n" +
             "Ol†!" + "~n" +
             "<p>" + "~n" +
             "O usu†rio " + ENTRY(1,c-from,"<") + " est† solicitando autorizaá∆o de acesso para o 
             programa " + c-prog + "." + "~n" +
             "<p>" + "~n" +
             "Com a justificativa: " + c-just + "." + "~n" +
             "<br>" + "~n" +
             "<ul>" + "~n" +
             '<li><a 
             href="http://intelbrascorp.intelbras.com.br/javaws/liberaPrograma.php?uid=' 
             + c-seg-usuario + '&pid=' + ttint-procedimento.cod_proced + '">Clique aqui para acessar o programa de liberaá∆o</a>' + "~n" +
             "</ul>" + "~n" +
             "~n" +
             "</body>" + "~n" +
             "</html>" + "~n" +
             "~n" +
             "--Message-Boundary--" + "~n" 


         out-box.mai-priority = 2
         out-box.mai-status = "Q"
         out-box.mai-subject = "Solicitaá∆o de Liberaá∆o de Acesso a Programa"
         out-box.mai-to = c-to.

  RELEASE out-box.

  MESSAGE "Sua solicitaá∆o foi registrada e ser† enviada ao respons†vel pelo programa !"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:
  ASSIGN c-usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-usuario.
  ASSIGN c-usuario:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst C-Win
ON CHOOSE OF btFirst IN FRAME DEFAULT-FRAME /* First */
DO:
  FIND FIRST procedimento NO-LOCK.
  RUN posiciona.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo C-Win
ON CHOOSE OF btGoTo IN FRAME DEFAULT-FRAME /* Go To */
DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast C-Win
ON CHOOSE OF btLast IN FRAME DEFAULT-FRAME /* Last */
DO:
  FIND LAST procedimento NO-LOCK.
  RUN posiciona.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext C-Win
ON CHOOSE OF btNext IN FRAME DEFAULT-FRAME /* Next */
DO:
  FIND NEXT procedimento NO-LOCK NO-ERROR.
  IF AVAIL procedimento THEN RUN posiciona.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev C-Win
ON CHOOSE OF btPrev IN FRAME DEFAULT-FRAME /* Prev */
DO:
  FIND PREV procedimento NO-LOCK NO-ERROR.
  IF AVAIL procedimento THEN RUN posiciona.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave C-Win
ON CHOOSE OF btSave IN FRAME DEFAULT-FRAME /* Save */
DO:
  FIND int-procedimento 
       WHERE int-procedimento.cod_proced = c_cod_proced:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
  IF NOT AVAIL int-procedimento THEN DO:
      CREATE int-procedimento.
      ASSIGN int-procedimento.cod_proced = c_cod_proced:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             int-procedimento.cod_usuario = c-usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  END.
  ASSIGN c-usuario:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  
  ASSIGN int-procedimento.cod_usuario = c-usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch C-Win
ON CHOOSE OF btSearch IN FRAME DEFAULT-FRAME /* Search */
DO:
    

     RUN gotoprograma IN THIS-PROCEDURE.
/*
     DEF VAR l-implanta AS LOG.
     DEF VAR v_rec_procedimento AS RECID.
     ASSIGN l-implanta = NO.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    RUN prgtec/men/men011ja.w.

    FIND procedimento NO-LOCK WHERE RECID(procedimento) = v_rec_procedimento NO-ERROR.

    IF NOT AVAIL procedimento THEN NEXT.

    ASSIGN ttprocedimento.cod_proced = procedimento.cod_proced.

    RUN goToKey IN {&hDBOParent} (INPUT ttprocedimento.cod_proced ).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Procedimento":U).
        RETURN NO-APPLY.
    END.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
  
  */  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate C-Win
ON CHOOSE OF btUpdate IN FRAME DEFAULT-FRAME /* Update */
DO:

   IF NOT AVAIL int-procedimento THEN DO:
      CREATE int-procedimento.
      ASSIGN int-procedimento.cod_proced = c_cod_proced:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             int-procedimento.cod_usuario = c-usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
   END.
   IF int-procedimento.cod_usuario <> v_cod_usuar_corren
       AND v_cod_usuar_corren  <> "adm" 
       AND v_cod_usuar_corren  <> "super" 
        
        THEN RETURN NO-APPLY.
    
    
    ASSIGN c-usuario:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 C-Win
ON CHOOSE OF BUTTON-1 IN FRAME DEFAULT-FRAME /* > */
DO:
  FIND PROCED_segur NO-LOCK 
       WHERE PROCED_segur.cod_proced = c_cod_proced:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
         AND proced_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar NO-ERROR.

   IF AVAIL PROCED_segur THEN DO:
       MESSAGE "Usu†rio j† relacionado !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN NO-APPLY.
   END.
   CREATE PROCED_segur.
   ASSIGN PROCED_segur.cod_proced = c_cod_proced:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
          proced_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar.

   IF v_cod_usuar_corren <> c-usuario
        AND v_cod_usuar_corren <> "adm" 
        AND v_cod_usuar_corren <> "super" then do:
       MESSAGE "Usu†rio n∆o Ç o respons†vel pelo programa !" VIEW-AS ALERT-BOX INFO BUTTONS OK.

       RETURN NO-APPLY.
   end.

   RUN concede-permissao.

     {&open-query-browse-2}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 C-Win
ON CHOOSE OF BUTTON-2 IN FRAME DEFAULT-FRAME /* < */
DO:
  IF PROCED_segur.cod_grp_usuar = "adm" OR
     PROCED_segur.cod_grp_usuar = "super" OR
     PROCED_segur.cod_grp_usuar = c-usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN DO:
      MESSAGE "Este usu†rio n∆o pode ser retirado !"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
  END.

  IF v_cod_usuar_corren <> c-usuario
       AND v_cod_usuar_corren <> "adm" 
       AND v_cod_usuar_corren <> "super" then do:
      MESSAGE "Usu†rio n∆o Ç o respons†vel pelo programa !" VIEW-AS ALERT-BOX INFO BUTTONS OK.

      RETURN NO-APPLY.
  end.

  RUN retira-permissao.

  FIND CURRENT PROCED_segur EXCLUSIVE-LOCK.
  DELETE PROCED_segur.


  {&open-query-browse-2}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuario C-Win
ON LEAVE OF c-usuario IN FRAME DEFAULT-FRAME /* Respons†vel */
DO:
  IF NOT CAN-FIND(usuar_mestre WHERE usuar_mestre.cod_usuario = c-usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
      MESSAGE "Usu†rio n∆o cadastrado"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  FIND FIRST procedimento NO-LOCK.
  
  

    RUN posiciona.


  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE concede-permissao C-Win 
PROCEDURE concede-permissao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



    disable triggers for load of prog_dtsul_segur.
    disable triggers for load of sub_rot_dtsul_segur.
    disable triggers for load of modul_rot_segur.
    disable triggers for load of modul_dtsul_segur.
    disable triggers for load of sist_dtsul_segur.
    disable triggers for load of aplicat_dtsul_segur.

    FOR EACH prog_dtsul NO-LOCK
           WHERE prog_dtsul.cod_proced = c_cod_proced:screen-value in frame {&frame-name}:
               /*    MESSAGE "Programa: " prog_dtsul.cod_prog
                           VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                 */
          IF NOT can-find(prog_dtsul_segur OF prog_dtsul
             WHERE prog_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar) THEN DO:
                 CREATE prog_dtsul_segur.
                 ASSIGN prog_dtsul_segur.cod_prog = prog_dtsul.cod_prog
                        prog_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar.
          END.
    END.

        FOR EACH sub_rot_dtsul_proced where sub_rot_dtsul_proced.cod_proced = c_cod_proced:screen-value in frame {&frame-name} NO-LOCK,
            EACH sub_rot_dtsul OF sub_rot_dtsul_proced:
                            

             IF NOT CAN-FIND(sub_rot_dtsul_segur OF sub_rot_dtsul
             WHERE sub_rot_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar) THEN DO:
             CREATE sub_rot_dtsul_segur.
                ASSIGN sub_rot_dtsul_segur.cod_grp_usuar      = grp_usuar.cod_grp_usuar
                       sub_rot_dtsul_segur.num_sub_rot_dtsul  = 
                       sub_rot_dtsul.num_sub_rot_dtsul.
        END.



        FOR EACH modul_rot_proced OF sub_rot_dtsul NO-LOCK,
            EACH modul_rot OF modul_rot_proced NO-LOCK:
                                    
            RUN concede-sist.
     
        END.
     END.
     FOR EACH modul_rot_proced where modul_rot_proced.cod_proced = c_cod_proced:screen-value in frame {&frame-name}             NO-LOCK,
         EACH modul_rot OF modul_rot_proced NO-LOCK:
                            
         RUN concede-sist.
 
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE concede-sist C-Win 
PROCEDURE concede-sist :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT CAN-FIND(modul_rot_segur OF modul_rot
       WHERE modul_rot_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar) THEN DO:
        CREATE modul_rot_segur.
        ASSIGN modul_rot_segur.cod_modul_dtsul = modul_rot.cod_modul_dtsul
               modul_rot_segur.num_rot_dtsul   = modul_rot.num_rot_dtsul
               modul_rot_segur.cod_grp_usuar   = grp_usuar.cod_grp_usuar.
                                       
    END.
                                                                                   
    FOR EACH modul_dtsul OF modul_rot_proced NO-LOCK:
                
                  
        IF NOT CAN-FIND(modul_dtsul_segur OF modul_dtsul
           WHERE modul_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar) THEN DO: 
            CREATE modul_dtsul_segur.
            ASSIGN modul_dtsul_segur.cod_modul_dtsul = modul_dtsul.cod_modul_dtsul
                   modul_dtsul_segur.cod_grp_usuar   = grp_usuar.cod_grp_usuar.
        END.
                                               
                                                           
        FOR EACH sist_dtsul OF modul_dtsul NO-LOCK:
                    
                                                 
            IF NOT CAN-FIND(sist_dtsul_segur OF sist_dtsul
               WHERE sist_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar) THEN DO: 
                CREATE sist_dtsul_segur.
                ASSIGN sist_dtsul_segur.cod_sist_dtsul = sist_dtsul.cod_sist_dtsul
                       sist_dtsul_segur.cod_grp_usuar  = grp_usuar.cod_grp_usuar.
            END.
                        
                            
            FOR EACH aplicat_dtsul OF sist_dtsul NO-LOCK:
    
              IF NOT CAN-FIND(aplicat_dtsul_segur OF aplicat_dtsul
              WHERE aplicat_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar) THEN DO: 
                   CREATE aplicat_dtsul_segur.
                   ASSIGN aplicat_dtsul_segur.cod_aplicat_dtsul =                           aplicat_dtsul.cod_aplicat_dtsul
                          aplicat_dtsul_segur.cod_grp_usuar     =                           grp_usuar.cod_grp_usuar.
              END.
          END.
      END.
    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/

  {&OPEN-QUERY-DEFAULT-FRAME}
  GET FIRST DEFAULT-FRAME.
  DISPLAY c_cod_proced c_des_proced c-usuario c-nome c-ramal 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btFirst btPrev btNext btLast btGoTo btSearch btUpdate btCancel btSave 
         bt-acesso bt-libero btExit BROWSE-1 BROWSE-2 BUTTON-1 BUTTON-2 
         rtParent rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gotoprograma C-Win 
PROCEDURE gotoprograma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-cod_prog_dtsul  LIKE prog_dtsul.cod_prog_dtsul NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cod_prog_dtsul  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Procedimento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:

        ASSIGN c-cod_prog_dtsul.

        FIND prog_dtsul NO-LOCK
             WHERE prog_dtsul.cod_prog_dtsul = c-cod_prog_dtsul NO-ERROR.
        IF NOT AVAIL prog_dtsul THEN 
            RETURN NO-APPLY.
        
        FIND FIRST procedimento NO-LOCK
             WHERE procedimento.cod_proced = prog_dtsul.cod_proced NO-ERROR.
        
        IF NOT AVAIL procedimento THEN
            RETURN NO-APPLY.

        RUN posiciona.
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod_prog_dtsul btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GoToRecord C-Win 
PROCEDURE GoToRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-cod_proced  LIKE procedimento.cod_proced  NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cod_proced  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Procedimento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:

        ASSIGN c-cod_proced.

        FIND procedimento NO-LOCK
             WHERE procedimento.cod_proced = c-cod_proced NO-ERROR.
        IF NOT AVAIL procedimento THEN
            RETURN NO-APPLY.

        RUN posiciona.
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod_proced btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE posiciona C-Win 
PROCEDURE posiciona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN c_cod_proced = procedimento.cod_proced
         c_des_proced = procedimento.des_proced.
  
  FIND FIRST int-procedimento OF PROCEDimento NO-LOCK NO-ERROR.
  IF AVAIL int-procedimento THEN
      ASSIGN c-usuario = int-procedimento.cod_usuario.
  ELSE
      ASSIGN c-usuario = "adm".

  

  DISP c_cod_proced c_des_proced c-usuario c-nome c-ramal WITH FRAME {&FRAME-NAME}.



{&open-query-browse-1}
{&open-query-browse-2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retira-permissao C-Win 
PROCEDURE retira-permissao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    
    FOR EACH prog_dtsul NO-LOCK
       WHERE prog_dtsul.cod_proced = c_cod_proced:screen-value in frame {&frame-name},
        EACH prog_dtsul_segur OF prog_dtsul
       WHERE prog_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar:
        
                DELETE prog_dtsul_segur.
    END.
                        
    FOR EACH modul_rot_proced 
       where modul_rot_proced.cod_proced = c_cod_proced:screen-value in frame {&frame-name} no-lock,
        EACH modul_rot OF modul_rot_proced NO-LOCK,
        EACH modul_rot_segur OF modul_rot 
       WHERE modul_rot_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar:
        ASSIGN l-acessa = NO.
        FOR EACH bf-modul_rot_proced OF modul_rot NO-LOCK
           WHERE bf-modul_rot_proced.cod_proced <> c_cod_proced:screen-value in frame {&frame-name}:
            IF CAN-FIND(PROCED_segur 
                  WHERE PROCED_segur.cod_proced = bf-modul_rot_proced.cod_proced
                    AND PROCED_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar) THEN
               ASSIGN l-acessa = YES. 
        END.
                                                     
        IF NOT l-acessa THEN DO: 
                DELETE modul_rot_segur.
        END.
                                        
        FOR EACH modul_dtsul OF modul_rot_proced NO-LOCK:
            ASSIGN l-acessa = NO.
            IF CAN-FIND(FIRST modul_rot_segur
               WHERE modul_rot_segur.cod_modul_dtsul = modul_rot_proced.cod_modul_dtsul
                 AND modul_rot_segur.cod_grp_usuar   = grp_usuar.cod_grp_usuar) THEN
                ASSIGN l-acessa = YES.
                            
                IF NOT l-acessa THEN DO:
                   FIND modul_dtsul_segur OF modul_dtsul
                  WHERE modul_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar.
                    
                  DELETE modul_dtsul_segur.
                                           
                END.
                                                                                           FOR EACH sist_dtsul OF modul_dtsul NO-LOCK,
                EACH sist_dtsul_segur OF sist_dtsul
               WHERE sist_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar:
               
               
               FOR EACH bf-modul_dtsul OF sist_dtsul NO-LOCK:
                   ASSIGN l-acessa = NO.
                                                   
                   IF CAN-FIND(FIRST modul_dtsul_segur OF bf-modul_dtsul
                               WHERE modul_dtsul_segur.cod_grp_usuar =                                      grp_usuar.cod_grp_usuar) THEN
                    ASSIGN l-acessa = YES.
              END.
                                                   
              IF l-acessa THEN DO: 
                    DELETE sist_dtsul_segur.
              END.
                                                 
                                                 
              FOR EACH aplicat_dtsul OF sist_dtsul NO-LOCK,
                  EACH aplicat_dtsul_segur OF aplicat_dtsul
                 WHERE aplicat_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar:

                    FOR EACH bf-sist_dtsul OF aplicat_dtsul NO-LOCK:
                        ASSIGN l-acessa = NO.
                      IF CAN-FIND(FIRST sist_dtsul_segur OF bf-sist_dtsul
                                  WHERE sist_dtsul_segur.cod_grp_usuar =                                         grp_usuar.cod_grp_usuar) THEN 
                         ASSIGN l-acessa = YES.
                            
                    END.
                    IF l-acessa THEN DO:
                        DELETE aplicat_dtsul_segur.
                    END.
                END.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retira-permissao-1 C-Win 
PROCEDURE retira-permissao-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH prog_dtsul NO-LOCK
         WHERE prog_dtsul.cod_proced = c_cod_proced:screen-value in frame {&frame-name},
          EACH prog_dtsul_segur OF prog_dtsul
         WHERE prog_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar:
          DELETE prog_dtsul_segur.
      END.
            
      FOR EACH sub_rot_dtsul_proced where sub_rot_dtsul_proced.cod_proced =                 c_cod_proced:screen-value in frame {&frame-name} no-lock,
          EACH sub_rot_dtsul OF sub_rot_dtsul_proced NO-LOCK,
          EACH sub_rot_dtsul_segur OF sub_rot_dtsul
         WHERE sub_rot_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar:

            ASSIGN l-acessa = NO.
          FOR EACH bf-sub_rot_dtsul_proced OF sub_rot_dtsul NO-LOCK
             WHERE bf-sub_rot_dtsul_proced.cod_proced <> c_cod_proced:screen-value in frame {&frame-name}:                               IF CAN-FIND(PROCED_segur 
                      WHERE PROCED_segur.cod_proced =                         bf-sub_rot_dtsul_proced.cod_proced
                        AND PROCED_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar) THEN
                ASSIGN l-acessa = YES. 
          END.
                                                     
          IF NOT l-acessa THEN DO: 
                DELETE sub_rot_dtsul_segur.
          END.
                            
      END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

*/
