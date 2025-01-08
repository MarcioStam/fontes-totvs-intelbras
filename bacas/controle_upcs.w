&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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


DEF TEMP-TABLE tt-arquivo
    FIELD tipo     AS CHAR FORMAT "x(15)"
    FIELD prog-tab AS CHAR FORMAT "x(75)"
    FIELD upc      AS CHAR FORMAT "x(75)".

{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 rs-tipo fi-arquivo bt-ok 
&Scoped-Define DISPLAYED-OBJECTS rs-tipo fi-arquivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok 
     LABEL "Executar" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE fi-arquivo AS CHARACTER FORMAT "X(256)":U INITIAL "c:~\temp~\Arquivo_upcs.csv" 
     LABEL "Exportar UPCs" 
     VIEW-AS FILL-IN 
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Recadastrar UPCs", 1,
"Retirar UPCs", 2,
"Listar UPCs", 3
     SIZE 66.86 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 2.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 2.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     rs-tipo AT ROW 2.67 COL 15 NO-LABEL WIDGET-ID 2
     fi-arquivo AT ROW 6.08 COL 23.57 COLON-ALIGNED WIDGET-ID 10
     bt-ok AT ROW 9 COL 35 WIDGET-ID 6
     RECT-2 AT ROW 2 COL 9 WIDGET-ID 8
     RECT-3 AT ROW 5.25 COL 9 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.83 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 9.83
         WIDTH              = 90
         MAX-HEIGHT         = 19
         MAX-WIDTH          = 95.57
         VIRTUAL-HEIGHT     = 19
         VIRTUAL-WIDTH      = 95.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok W-Win
ON CHOOSE OF bt-ok IN FRAME fpage0 /* Executar */
DO:
      
       
       /* VERIFICA QUAL A CONEXÇO */
       DEF VAR c-ambiente AS CHAR INIT "PRODUCAO" NO-UNDO.

       FIND FIRST ponto-programa NO-LOCK
           WHERE  ponto-programa.nome-programa = "ambiente"
           AND    ponto-programa.ponto         = 1 NO-ERROR.
       IF  AVAIL  ponto-programa THEN DO:
           FOR FIRST conteudo-programa NO-LOCK
               WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
               ASSIGN c-ambiente = conteudo-programa.conteudo.
           END. /* FOR FIRST conteudo-programa */
       END. /* IF  AVAIL  ponto-programa */

       CASE rs-tipo:SCREEN-VALUE IN FRAME fpage0:
           /* RECADASTRAR */
           WHEN "1" THEN DO:
               IF  c-ambiente = "PRODUCAO" THEN DO:
                   MESSAGE "NÆo ‚ permitido retirar ou recadastrar em ambiente de produ‡Æo"
                       VIEW-AS ALERT-BOX INFO BUTTONS OK.
                   RETURN.
               END.
               RUN PI-RECADASTRAR.
           END.
           
           /* RETIRAR */
           WHEN "2" THEN DO:
               IF  c-ambiente = "PRODUCAO" THEN DO:
                   MESSAGE "NÆo ‚ permitido retirar ou recadastrar em ambiente de produ‡Æo"
                       VIEW-AS ALERT-BOX INFO BUTTONS OK.
                   RETURN.
               END.

               RUN PI-RETIRAR.  
           END.

           /*LISTAR*/
           WHEN "3" THEN 
               RUN PI-LISTAR.
       END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo W-Win
ON VALUE-CHANGED OF rs-tipo IN FRAME fpage0
DO:
  DO WITH FRAME fpage0:
      CASE rs-tipo:SCREEN-VALUE IN FRAME fpage0:
          WHEN "1" THEN
              ASSIGN fi-arquivo:SENSITIVE    = YES
                     fi-arquivo:SCREEN-VALUE = "c:\temp\Arquivo_upcs.csv"
                     fi-arquivo:LABEL        = "Importar do Arquivo" 
                     bt-ok:LABEL             = "Importar".           
    
          WHEN "2" THEN
              ASSIGN fi-arquivo:SENSITIVE    = YES
                     fi-arquivo:SCREEN-VALUE = "c:\temp\Arquivo_upcs.csv"
                     fi-arquivo:LABEL        = "Exportar p/ Arquivo" 
                     bt-ok:LABEL             = "Exportar".           
    
          WHEN "3" THEN
              ASSIGN fi-arquivo:SENSITIVE    = NO
                     fi-arquivo:SCREEN-VALUE = "C:\TEMP\LISTA_UPCS.CSV"
                     fi-arquivo:LABEL     = "Listar UPCs"
                     bt-ok:LABEL          = "Listar".
      END CASE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

APPLY "Value-changed"  TO rs-tipo IN FRAME fpage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY rs-tipo fi-arquivo 
      WITH FRAME fpage0 IN WINDOW W-Win.
  ENABLE RECT-2 RECT-3 rs-tipo fi-arquivo bt-ok 
      WITH FRAME fpage0 IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PI-LISTAR W-Win 
PROCEDURE PI-LISTAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OUTPUT TO VALUE (FI-ARQUIVO:SCREEN-VALUE IN FRAME FPAGE0).    
    
    /* UPC */
    FOR EACH prog_dtsul 
        WHERE prog_dtsul.nom_prog_upc <> "":
        PUT  "UPC"                                    ";"
             prog_dtsul.cod_prog_dtsul format "x(60)" ";"
             prog_dtsul.nom_prog_upc   format "x(60)" SKIP.
    END.

    /* WIRTE */
    FOR EACH tab_dic_dtsul 
        WHERE tab_dic_dtsul.nom_prog_upc_gat_write <> "" :
          PUT  "TRIGGER WRITE"                                      ";"         
               tab_dic_dtsul.cod_tab_dic_dtsul       format "x(60)" ";"
               tab_dic_dtsul.nom_prog_upc_gat_write  format "x(60)" SKIP.
    END.

    /* UPC DELETE*/
    FOR EACH tab_dic_dtsul 
        WHERE tab_dic_dtsul.nom_prog_upc_gat_delete <> "":
           PUT "TRIGGER DELETE" ";"
               tab_dic_dtsul.cod_tab_dic_dtsul       format "x(60)" ";"
               tab_dic_dtsul.nom_prog_upc_gat_delete format "x(60)" SKIP.
    END.

    OUTPUT CLOSE. 
    
    DOS SILENT START excel VALUE(FI-ARQUIVO:SCREEN-VALUE IN FRAME FPAGE0).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PI-RECADASTRAR W-Win 
PROCEDURE PI-RECADASTRAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-tot AS INTEGER NO-UNDO.
    DEF VAR i-cont AS INTEGER NO-UNDO.
    DEF VAR c-line AS CHAR FORMAT "x(200)" NO-UNDO.

    /* CONTAR QUANTAS LINHAS "UTEIS" TEM O ARQUIVO */
    INPUT FROM VALUE(fi-arquivo:SCREEN-VALUE IN FRAME fpage0).    
    REPEAT:
        IMPORT UNFORMATTED c-line.
        IF  TRIM(ENTRY(1,c-line, ";")) = "UPC"
        OR  TRIM(ENTRY(1,c-line, ";")) = "TRIGGER WRITE" 
        OR  TRIM(ENTRY(1,c-line, ";")) = "TRIGGER DELETE" THEN
            ASSIGN i-tot = i-tot + 1.
    END.
    INPUT CLOSE.

    IF  i-tot = 0  THEN DO:
        MESSAGE "NÆo existem dados para importar!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    /* INICIA IMPORTA€ÇO */
    INPUT FROM VALUE(fi-arquivo:SCREEN-VALUE IN FRAME fpage0).    

    DO TRANS:
        REPEAT:
            IMPORT UNFORMATTED c-line.
    
            CASE TRIM(ENTRY(1,c-line, ";")):
                WHEN "UPC" THEN DO:
                    FOR FIRST prog_dtsul EXCLUSIVE-LOCK
                        WHERE prog_dtsul.cod_prog_dtsul   = ENTRY(2,c-line, ";") :

                           ASSIGN prog_dtsul.nom_prog_upc = ENTRY(3,c-line, ";")
                                  i-cont = i-cont + 1.
                    END.            
                    IF  NOT AVAIL prog_dtsul THEN DO:
                        MESSAGE "NÆo encontrado programa para recadastramento: " ENTRY(2,c-line, ";")
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        UNDO, RETURN.
                    END.
                END.
    
                WHEN "TRIGGER WRITE" THEN DO:
                    FOR FIRST tab_dic_dtsul 
                        WHERE tab_dic_dtsul.cod_tab_dic_dtsul           = ENTRY(2,c-line, ";"):

                            ASSIGN tab_dic_dtsul.nom_prog_upc_gat_write = ENTRY(3,c-line, ";")
                                   i-cont = i-cont + 1.
                    END.
                    IF  NOT AVAIL tab_dic_dtsul THEN DO:
                        MESSAGE "NÆo encontrada tabela para recadastramento: " ENTRY(2,c-line, ";")
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        UNDO, RETURN.
                    END.

                END.
    
                WHEN "TRIGGER DELETE" THEN DO:
                    FOR FIRST tab_dic_dtsul 
                        WHERE tab_dic_dtsul.cod_tab_dic_dtsul            = ENTRY(2,c-line, ";"):

                            ASSIGN tab_dic_dtsul.nom_prog_upc_gat_delete = ENTRY(3,c-line, ";")
                                   i-cont = i-cont + 1.
                    END.
                    IF  NOT AVAIL tab_dic_dtsul THEN DO:
                        MESSAGE "NÆo encontrado tabela para recadastramento: " ENTRY(2,c-line, ";")
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        UNDO, RETURN.
                    END.

                END.
    
            END CASE.
    
        END.
        
        IF  i-cont > 0 AND i-tot <> i-cont  THEN DO:
            MESSAGE "Nada foi importado, o n£mero de linhas a importar era " STRING(i-tot) 
                    ", por‚m s¢ foi poss¡vel gravar " STRING(i-cont)
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            UNDO, RETURN "NOK".
        END.


    END. /* TRANS */

    INPUT CLOSE.

     MESSAGE "Importa‡Æo Conclu¡da! UPCs de programa e de dicion rio foram recadastradas."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PI-RETIRAR W-Win 
PROCEDURE PI-RETIRAR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST prog_dtsul NO-LOCK
        WHERE prog_dtsul.nom_prog_upc <> "" NO-ERROR.
    IF  NOT AVAIL prog_dtsul THEN DO:
        MESSAGE "NÆo existem upcs para descadastrar. Processo j  foi feito em execu‡Æo anterior"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    FIND FIRST tab_dic_dtsul NO-LOCK
        WHERE tab_dic_dtsul.nom_prog_upc_gat_write <> "" NO-ERROR.
    IF  NOT AVAIL tab_dic_dtsul THEN DO:
        MESSAGE "NÆo existem upcs de trigger de write para descadastrar. Processo j  foi feito em execu‡Æo anterior"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.
    FIND FIRST tab_dic_dtsul NO-LOCK
        WHERE tab_dic_dtsul.nom_prog_upc_gat_delete <> "" NO-ERROR.
    IF  NOT AVAIL tab_dic_dtsul THEN DO:
        MESSAGE "NÆo existem upcs de trigger de write para descadastrar. Processo j  foi feito em execu‡Æo anterior"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    DO TRANS ON ERROR UNDO, RETURN:
        /* UPC DE PROGRAMA */    
        FOR EACH prog_dtsul EXCLUSIVE-LOCK
            WHERE prog_dtsul.nom_prog_upc <> "":
            CREATE tt-arquivo.
            ASSIGN tt-arquivo.tipo     = "UPC"
                   tt-arquivo.prog-tab = prog_dtsul.cod_prog_dtsul
                   tt-arquivo.upc      = prog_dtsul.nom_prog_upc.
            ASSIGN prog_dtsul.nom_prog_upc = "".
        END.

        /* UPC TRIGGER DE TABELA - W R I T E  */
        FOR EACH tab_dic_dtsul EXCLUSIVE-LOCK
            WHERE tab_dic_dtsul.nom_prog_upc_gat_write <> "":
            CREATE tt-arquivo.
            ASSIGN tt-arquivo.tipo     = "TRIGGER WRITE"
                   tt-arquivo.prog-tab = tab_dic_dtsul.cod_tab_dic_dtsul      
                   tt-arquivo.upc      = tab_dic_dtsul.nom_prog_upc_gat_write.
            ASSIGN tab_dic_dtsul.nom_prog_upc_gat_write = "".
        END.
        
        /* UPC TRIGGER DE TABELA - D E L E T E  */
        FOR EACH tab_dic_dtsul EXCLUSIVE-LOCK
            WHERE tab_dic_dtsul.nom_prog_upc_gat_delete <> "" :
            CREATE tt-arquivo.
            ASSIGN tt-arquivo.tipo     = "TRIGGER DELETE"
                   tt-arquivo.prog-tab = tab_dic_dtsul.cod_tab_dic_dtsul
                   tt-arquivo.upc      = tab_dic_dtsul.nom_prog_upc_gat_delete.
            ASSIGN tab_dic_dtsul.nom_prog_upc_gat_delete = "".
        END.

       
    
        IF NOT CAN-FIND (FIRST tt-arquivo  WHERE tt-arquivo.tipo = "UPC")
        OR NOT CAN-FIND (FIRST tt-arquivo  WHERE tt-arquivo.tipo = "TRIGGER WRITE")
        OR NOT CAN-FIND (FIRST tt-arquivo  WHERE tt-arquivo.tipo = "TRIGGER DELETE") THEN DO:
    
            MESSAGE "Algum problema impediu a retirada de uma ou mais upcs. NÆo ‚ poss¡vel exportar"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            UNDO,  RETURN "NOK".
        END.
    END.

    OUTPUT TO VALUE (fi-arquivo:SCREEN-VALUE IN FRAME fpage0).
    FOR EACH tt-arquivo:
        PUT tt-arquivo.tipo     ";"
            tt-arquivo.prog-tab ";"
            tt-arquivo.upc      SKIP.
    END.
    OUTPUT CLOSE.

    MESSAGE "Procedimento Conclu¡do. UPCs foram RETIRADAS! Para recadastr -las, dever  ser importado posteriormente o arquivo: " fi-arquivo:SCREEN-VALUE IN FRAME fpage0 
        VIEW-AS ALERT-BOX INFO BUTTONS OK.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

