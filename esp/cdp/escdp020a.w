&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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

DEF INPUT PARAMETER pi-cod-emitente AS INTEGER.
DEF INPUT PARAMETER pc-cod-cpf-cnpj AS CHAR.
DEF INPUT PARAMETER pl-inclusao AS LOGICAL.
DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.
DEFINE VARIABLE p-cgc-cpf AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-endereco  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-cdapi704 AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi_cod-cpf-cnpj fi_nro-identidade ~
fi_nome-socio fi_endereco fi_nro-endereco fi_compl-endereco fi_bairro ~
fi_cidade fi_estado fi_cep fi_pais fi_telefone fi_celular fi_e-mail ~
fi_nacionalidade cb_estado-civil fi_profissao fi_perc-participacao btOK ~
btSalvar btCancel-2 btHelp2 btQueryJoins btReportsJoins btExit btHelp ~
c-cod-emitente c-nome-emitente rtToolBar-2 rtToolBar RECT-3 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS fi_cod-cpf-cnpj fi_nro-identidade ~
fi_nome-socio fi_endereco fi_nro-endereco fi_compl-endereco fi_bairro ~
fi_cidade fi_estado fi_cep fi_pais fi_telefone fi_celular fi_e-mail ~
fi_nacionalidade cb_estado-civil fi_profissao fi_perc-participacao ~
c-cod-emitente c-nome-emitente 

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
DEFINE BUTTON btCancel-2 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.08
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.08
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
     SIZE 4 BY 1.08
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.08
     FONT 4.

DEFINE BUTTON btSalvar 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb_estado-civil AS INTEGER FORMAT "99" INITIAL 1 
     LABEL "Estado Civil" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Solteiro  ",01,
                     "Casado    ",02,
                     "Viuvo     ",03,
                     "Divorciado",04,
                     "Separado  ",05
     DROP-DOWN-LIST
     SIZE 16 BY 1.

DEFINE VARIABLE c-cod-emitente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod.Emitente" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE c-nome-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .79 NO-UNDO.

DEFINE VARIABLE fi_bairro AS CHARACTER FORMAT "x(20)" 
     LABEL "Bairro" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .79 NO-UNDO.

DEFINE VARIABLE fi_celular AS CHARACTER FORMAT "x(12)" 
     LABEL "Celular" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .79.

DEFINE VARIABLE fi_cep AS CHARACTER FORMAT "99999-999" 
     LABEL "CEP" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .79.

DEFINE VARIABLE fi_cidade AS CHARACTER FORMAT "x(25)" 
     LABEL "Cidade" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .79.

DEFINE VARIABLE fi_cod-cpf-cnpj AS CHARACTER FORMAT "x(19)" 
     LABEL "CPF/CNPJ" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .79.

DEFINE VARIABLE fi_compl-endereco AS CHARACTER FORMAT "x(20)" 
     LABEL "Complemento Endereco" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .79.

DEFINE VARIABLE fi_e-mail AS CHARACTER FORMAT "x(150)" 
     LABEL "E-mail" 
     VIEW-AS FILL-IN 
     SIZE 96 BY .79.

DEFINE VARIABLE fi_endereco AS CHARACTER FORMAT "x(80)" 
     LABEL "Endereco" 
     VIEW-AS FILL-IN 
     SIZE 96 BY .79.

DEFINE VARIABLE fi_estado AS CHARACTER FORMAT "x(2)" 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79.

DEFINE VARIABLE fi_nacionalidade AS CHARACTER FORMAT "x(25)" 
     LABEL "Nacionalidade" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .79.

DEFINE VARIABLE fi_nome-socio AS CHARACTER FORMAT "x(100)" 
     LABEL "Nome Socio" 
     VIEW-AS FILL-IN 
     SIZE 96 BY .79.

DEFINE VARIABLE fi_nro-endereco AS CHARACTER FORMAT "x(15)" 
     LABEL "Numero Endereco" 
     VIEW-AS FILL-IN 
     SIZE 15.86 BY .79.

DEFINE VARIABLE fi_nro-identidade AS CHARACTER FORMAT "x(20)" 
     LABEL "Nro.Documento Identidade" 
     VIEW-AS FILL-IN 
     SIZE 33 BY .79.

DEFINE VARIABLE fi_pais AS CHARACTER FORMAT "x(20)" 
     LABEL "Pais" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .79 NO-UNDO.

DEFINE VARIABLE fi_perc-participacao AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Percentual Participacao" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79.

DEFINE VARIABLE fi_profissao AS CHARACTER FORMAT "x(40)" 
     LABEL "Profissao" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .79.

DEFINE VARIABLE fi_telefone AS CHARACTER FORMAT "(99) 9999-9999" 
     LABEL "Telefone" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .79.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 1.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 116 BY 12.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 117 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 117 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi_cod-cpf-cnpj AT ROW 6.5 COL 16 COLON-ALIGNED WIDGET-ID 2
     fi_nro-identidade AT ROW 6.5 COL 66 COLON-ALIGNED WIDGET-ID 32
     fi_nome-socio AT ROW 7.5 COL 16 COLON-ALIGNED WIDGET-ID 4
     fi_endereco AT ROW 8.5 COL 16 COLON-ALIGNED WIDGET-ID 6
     fi_nro-endereco AT ROW 9.5 COL 16 COLON-ALIGNED WIDGET-ID 8
     fi_compl-endereco AT ROW 9.5 COL 66 COLON-ALIGNED WIDGET-ID 10
     fi_bairro AT ROW 10.5 COL 16 COLON-ALIGNED HELP
          "Bairro" WIDGET-ID 50
     fi_cidade AT ROW 11.5 COL 16 COLON-ALIGNED WIDGET-ID 12
     fi_estado AT ROW 11.5 COL 66 COLON-ALIGNED WIDGET-ID 14
     fi_cep AT ROW 11.5 COL 86 COLON-ALIGNED WIDGET-ID 16
     fi_pais AT ROW 12.5 COL 16 COLON-ALIGNED HELP
          "Pais" WIDGET-ID 48
     fi_telefone AT ROW 13.5 COL 16 COLON-ALIGNED WIDGET-ID 18
     fi_celular AT ROW 13.5 COL 66 COLON-ALIGNED WIDGET-ID 20
     fi_e-mail AT ROW 14.5 COL 16 COLON-ALIGNED WIDGET-ID 22
     fi_nacionalidade AT ROW 15.5 COL 16 COLON-ALIGNED WIDGET-ID 24
     cb_estado-civil AT ROW 15.5 COL 86 COLON-ALIGNED WIDGET-ID 30
     fi_profissao AT ROW 16.5 COL 16 COLON-ALIGNED WIDGET-ID 34
     fi_perc-participacao AT ROW 16.5 COL 86 COLON-ALIGNED WIDGET-ID 36
     btOK AT ROW 19.21 COL 2
     btSalvar AT ROW 19.21 COL 13
     btCancel-2 AT ROW 19.21 COL 24 WIDGET-ID 46
     btHelp2 AT ROW 19.21 COL 107
     btQueryJoins AT ROW 1.25 COL 101 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.25 COL 105 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.25 COL 109 HELP
          "Sair"
     btHelp AT ROW 1.25 COL 113 HELP
          "Ajuda"
     c-cod-emitente AT ROW 3.75 COL 24 COLON-ALIGNED WIDGET-ID 38
     c-nome-emitente AT ROW 3.75 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 19 COL 1
     RECT-3 AT ROW 3.25 COL 2 WIDGET-ID 42
     RECT-4 AT ROW 5.25 COL 1 WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 117.86 BY 19.63
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
         HEIGHT             = 19.63
         WIDTH              = 117.86
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 142.29
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
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


&Scoped-define SELF-NAME btCancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel-2 wWindow
ON CHOOSE OF btCancel-2 IN FRAME fpage0 /* Cancelar */
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
    ASSIGN l-erro = NO.
    RUN piSalvar.
    IF l-erro = NO THEN
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


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0 /* Salvar */
DO:
   RUN piSalvar.
   APPLY "ENTRY" to fi_cod-cpf-cnpj IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi_cod-cpf-cnpj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_cod-cpf-cnpj wWindow
ON LEAVE OF fi_cod-cpf-cnpj IN FRAME fpage0 /* CPF/CNPJ */
DO:
  
  IF  pl-inclusao = YES THEN DO:
      FIND emit-partic-societaria
           WHERE emit-partic-societaria.cod-cpf-cnpj = replace(replace(replace(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0,".",""),"/",""),"-","")
             AND emit-partic-societaria.cod-emitente = int(c-cod-emitente:SCREEN-VALUE IN FRAME fpage0)
           NO-LOCK NO-ERROR.
      IF AVAIL emit-partic-societaria THEN DO:
           RUN utp/ut-msgs.p ('show', 17006, 'Emitente x Socio ja cadastrado.~~O Relacionamento deste CPF/CNPJ ja foi efetuado anteriormente para este cliente').

          ASSIGN fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0 = "".
      END.
      ELSE DO:
          FIND partic-societaria
              WHERE partic-societaria.cod-cpf-cnpj = fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0
              NO-LOCK NO-ERROR.
          IF AVAIL partic-societaria THEN DO:
            ASSIGN fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0      =  partic-societaria.cod-cpf-cnpj
                   fi_nro-identidade:SCREEN-VALUE IN FRAME fpage0    =  partic-societaria.nro-identidade              
                   fi_nome-socio:SCREEN-VALUE IN FRAME fpage0        =  partic-societaria.nome-socio                  
                   fi_endereco:SCREEN-VALUE IN FRAME fpage0          =  partic-societaria.endereco                    
                   fi_bairro:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.bairro            
                   fi_nro-endereco:SCREEN-VALUE IN FRAME fpage0      =  partic-societaria.nro-endereco                
                   fi_compl-endereco:SCREEN-VALUE IN FRAME fpage0    =  partic-societaria.compl-endereco              
                   fi_cidade:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.cidade                      
                   fi_estado:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.estado                      
                   fi_pais:SCREEN-VALUE IN FRAME fpage0              =  partic-societaria.pais
                   fi_cep:SCREEN-VALUE IN FRAME fpage0               =  partic-societaria.cep                         
                   fi_telefone:SCREEN-VALUE IN FRAME fpage0          =  partic-societaria.telefone                    
                   fi_celular:SCREEN-VALUE IN FRAME fpage0           =  partic-societaria.celular                     
                   fi_e-mail:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.e-mail                      
                   fi_nacionalidade:SCREEN-VALUE IN FRAME fpage0     =  partic-societaria.nacionalidade               
                   fi_estado:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.estado                      
                   cb_estado-civil:SCREEN-VALUE IN FRAME fpage0      =  string(partic-societaria.estado-civil)
                   fi_profissao:SCREEN-VALUE IN FRAME fpage0         =  partic-societaria.profissao                   
                   fi_perc-participacao:SCREEN-VALUE IN FRAME fpage0 =  string(emit-partic-societaria.perc-participacao).  
          END.
          ELSE DO:
              FIND emitente
                   WHERE emitente.cgc = fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0
                   NO-LOCK NO-ERROR.
              IF AVAIL emitente THEN DO:

                  ASSIGN c-rua      = ""
                         c-nro      = ""
                         c-comp     = ""
                         c-endereco = emitente.endereco.
                  IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
                      ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").

                  RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                  RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                                       OUTPUT c-rua, 
                                                       OUTPUT c-nro, 
                                                       OUTPUT c-comp).
                  DELETE PROCEDURE h-cdapi704.


                  ASSIGN fi_nro-identidade:SCREEN-VALUE IN FRAME fpage0    =  ""
                         fi_nome-socio:SCREEN-VALUE IN FRAME fpage0        =  emitente.nome-emit
                         fi_endereco:SCREEN-VALUE IN FRAME fpage0          =  c-rua
                         fi_bairro:SCREEN-VALUE IN FRAME fpage0            =  emitente.bairro            
                         fi_nro-endereco:SCREEN-VALUE IN FRAME fpage0      =  c-nro
                         fi_compl-endereco:SCREEN-VALUE IN FRAME fpage0    =  c-comp
                         fi_cidade:SCREEN-VALUE IN FRAME fpage0            =  emitente.cidade                      
                         fi_estado:SCREEN-VALUE IN FRAME fpage0            =  emitente.estado                      
                         fi_pais:SCREEN-VALUE IN FRAME fpage0              =  emitente.pais
                         fi_cep:SCREEN-VALUE IN FRAME fpage0               =  string(emitente.cep)
                         fi_telefone:SCREEN-VALUE IN FRAME fpage0          =  emitente.telefone[1]
                         fi_celular:SCREEN-VALUE IN FRAME fpage0           =  emitente.telefone[2]
                         fi_e-mail:SCREEN-VALUE IN FRAME fpage0            =  emitente.e-mail                      
                         fi_nacionalidade:SCREEN-VALUE IN FRAME fpage0     =  ""
                         cb_estado-civil:SCREEN-VALUE IN FRAME fpage0      =  "1"
                         fi_profissao:SCREEN-VALUE IN FRAME fpage0         =  ""
                         fi_perc-participacao:SCREEN-VALUE IN FRAME fpage0 =  "0".  

              END.
          END.

      END.
  END.
  
  
  ASSIGN p-cgc-cpf =  replace(replace(replace(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0,".",""),"/",""),"-","").

  IF p-cgc-cpf <> "" THEN DO:
      IF LENGTH(p-cgc-cpf) = 14 THEN DO:
          RUN cdp/cd6666.p (INPUT p-cgc-cpf, INPUT 2).
      END.
      ELSE DO:
          RUN cdp/cd6666.p (INPUT p-cgc-cpf, INPUT 1).
      END.
  END.
  ELSE DO:
      RUN utp/ut-msgs.p ('show', 17006, 'Informe o CPF/CNPJ.~~Este campo Ç obrigat¢rio informe corretamente').
      APPLY "ENTRY" to fi_cod-cpf-cnpj IN FRAME fpage0.
  END.
  IF RETURN-VALUE = "nok" THEN DO: 
     ASSIGN fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0 = "".
     APPLY "ENTRY" to fi_cod-cpf-cnpj IN FRAME fpage0.

  END.
  ELSE DO:
  
      IF  fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0 <> "" THEN DO:
          ASSIGN fi_cod-cpf-cnpj:SENSITIVE = NO.
          IF length(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0) = 11 THEN 
              ASSIGN fi_cod-cpf-cnpj:FORMAT IN FRAME fpage0 = "999.999.999-99".
          ELSE
              IF length(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0) = 14 THEN 
                ASSIGN fi_cod-cpf-cnpj:FORMAT IN FRAME fpage0 = "99.999.999/9999-99".
              ELSE
                  ASSIGN fi_cod-cpf-cnpj:FORMAT IN FRAME fpage0 = "x(20)".
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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
  RUN mostraCampos.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
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
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraCampos wWindow 
PROCEDURE mostraCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN c-cod-emitente:SENSITIVE  IN FRAME fpage0 = NO
       c-nome-emitente:SENSITIVE IN FRAME fpage0 = NO.
FIND emitente
     WHERE emitente.cod-emitente = pi-cod-emitente
     NO-LOCK NO-ERROR.
IF AVAIL emitente THEN DO:
    ASSIGN c-cod-emitente:SCREEN-VALUE IN FRAME fpage0 = string(emitente.cod-emitente)
           c-nome-emitente:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.
    IF pl-inclusao = YES THEN DO:
        RUN pi-limpa-campos.
    END.
    ELSE DO:
        FIND emit-partic-societaria
             WHERE emit-partic-societaria.cod-emitente = emitente.cod-emitente
               AND emit-partic-societaria.cod-cpf-cnpj = pc-cod-cpf-cnpj
             NO-LOCK NO-ERROR.
        FIND partic-societaria
             WHERE partic-societaria.cod-cpf-cnpj = pc-cod-cpf-cnpj
            EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN fi_cod-cpf-cnpj:SENSITIVE = NO.
        ASSIGN fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0      =  partic-societaria.cod-cpf-cnpj
               fi_nro-identidade:SCREEN-VALUE IN FRAME fpage0    =  partic-societaria.nro-identidade              
               fi_nome-socio:SCREEN-VALUE IN FRAME fpage0        =  partic-societaria.nome-socio                  
               fi_endereco:SCREEN-VALUE IN FRAME fpage0          =  partic-societaria.endereco                    
               fi_nro-endereco:SCREEN-VALUE IN FRAME fpage0      =  partic-societaria.nro-endereco                
               fi_compl-endereco:SCREEN-VALUE IN FRAME fpage0    =  partic-societaria.compl-endereco              
               fi_bairro:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.bairro
               fi_cidade:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.cidade                      
               fi_estado:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.estado                      
               fi_cep:SCREEN-VALUE IN FRAME fpage0               =  partic-societaria.cep    
               fi_pais:SCREEN-VALUE IN FRAME fpage0              =  partic-societaria.pais              
               fi_telefone:SCREEN-VALUE IN FRAME fpage0          =  partic-societaria.telefone                    
               fi_celular:SCREEN-VALUE IN FRAME fpage0           =  partic-societaria.celular                     
               fi_e-mail:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.e-mail                      
               fi_nacionalidade:SCREEN-VALUE IN FRAME fpage0     =  partic-societaria.nacionalidade               
               fi_estado:SCREEN-VALUE IN FRAME fpage0            =  partic-societaria.estado                      
               cb_estado-civil:SCREEN-VALUE IN FRAME fpage0      =  string(partic-societaria.estado-civil)
               fi_profissao:SCREEN-VALUE IN FRAME fpage0         =  partic-societaria.profissao                   
               fi_perc-participacao:SCREEN-VALUE IN FRAME fpage0 =  string(emit-partic-societaria.perc-participacao)  .  

    END.
   IF pl-inclusao = NO THEN
      IF length(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0) = 11 THEN 
          ASSIGN fi_cod-cpf-cnpj:FORMAT IN FRAME fpage0 = "999.999.999-99".
      ELSE
          ASSIGN fi_cod-cpf-cnpj:FORMAT IN FRAME fpage0 = "99.999.999/9999-99".
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Limpa-Campos wWindow 
PROCEDURE pi-Limpa-Campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        ASSIGN fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0      = ""
               fi_nro-identidade:SCREEN-VALUE IN FRAME fpage0    = ""
               fi_nome-socio:SCREEN-VALUE IN FRAME fpage0        = ""
               fi_endereco:SCREEN-VALUE IN FRAME fpage0          = ""
               fi_nro-endereco:SCREEN-VALUE IN FRAME fpage0      = ""
               fi_compl-endereco:SCREEN-VALUE IN FRAME fpage0    = ""
               fi_nro-endereco:SCREEN-VALUE IN FRAME fpage0      = ""
               fi_cidade:SCREEN-VALUE IN FRAME fpage0            = ""
               fi_bairro:SCREEN-VALUE IN FRAME fpage0            = ""
               fi_estado:SCREEN-VALUE IN FRAME fpage0            = ""
               fi_pais:SCREEN-VALUE IN FRAME fpage0              = ""
               fi_cep:SCREEN-VALUE IN FRAME fpage0               = ""
               fi_telefone:SCREEN-VALUE IN FRAME fpage0          = ""
               fi_celular:SCREEN-VALUE IN FRAME fpage0           = ""
               fi_e-mail:SCREEN-VALUE IN FRAME fpage0            = ""
               fi_nacionalidade:SCREEN-VALUE IN FRAME fpage0     = ""
               fi_estado:SCREEN-VALUE IN FRAME fpage0            = ""
               cb_estado-civil:SCREEN-VALUE IN FRAME fpage0      = "1"
               fi_profissao:SCREEN-VALUE IN FRAME fpage0         = ""
               fi_perc-participacao:SCREEN-VALUE IN FRAME fpage0 = "".
        ASSIGN fi_cod-cpf-cnpj:FORMAT = "x(20)"
               fi_celular:FORMAT = "x(15)".
        ASSIGN fi_cod-cpf-cnpj:SENSITIVE IN FRAME fpage0 = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSalvar wWindow 
PROCEDURE piSalvar :
ASSIGN p-cgc-cpf =  replace(replace(replace(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0,".",""),"/",""),"-","").
      
      IF LENGTH(p-cgc-cpf) = 14 THEN DO:
          RUN cdp/cd6666.p (INPUT p-cgc-cpf, INPUT 2).
      END.
      ELSE DO:
          RUN cdp/cd6666.p (INPUT p-cgc-cpf, INPUT 1).
      END.
      IF RETURN-VALUE = "NOK" THEN DO:
          ASSIGN l-erro = YES.
          APPLY "ENTRY" to fi_cod-cpf-cnpj IN FRAME fpage0.
          undo, next.
      END.
     IF fi_nome-socio:SCREEN-VALUE IN FRAME fpage0 = "" THEN DO:   
         ASSIGN l-erro = YES.
         RUN utp/ut-msgs.p ('show', 17006, 'Nome do S¢cio n∆o informado.~~O campo Nome do S¢cio Ç um campo obrigat¢rio, por favor informe corretamente esta informaá∆o').
         APPLY "ENTRY" to fi_nome-socio IN FRAME fpage0.
         undo, next.
     END.
     IF fi_cidade:SCREEN-VALUE IN FRAME fpage0  <> "" THEN DO:
         IF NOT CAN-FIND(FIRST mgcad.cidade
                     WHERE cidade.cidade = fi_cidade:SCREEN-VALUE IN FRAME fpage0            
                       AND cidade.estado = fi_estado:SCREEN-VALUE IN FRAME fpage0            
                       AND cidade.pais   = fi_pais:SCREEN-VALUE IN FRAME fpage0) THEN DO:
             ASSIGN l-erro = YES.
             RUN utp/ut-msgs.p ('show', 17006, 'Cidade/Estado/Pais n∆o localizado no cadastro de cidades.~~Informe uma Cidade cadastrada no programa cd0330 - Manutená∆o de Cidades').
    
             APPLY "ENTRY" to fi_cidade IN FRAME fpage0.
             undo, next.
         END.
     END.
/*      IF LENGTH(p-cgc-cpf) = 11 THEN DO:                                                                                                     */
/*          IF fi_nro-identidade:SCREEN-VALUE IN FRAME fpage0  = ""  THEN DO:                                                                  */
/*             ASSIGN l-erro = YES.                                                                                                            */
/*             RUN utp/ut-msgs.p ('show', 17006, 'Identidade nao informada.~~O Campo Identidade Ç obrigatorio, informe o campo corretamente'). */
/*             APPLY "ENTRY" to fi_nro-identidade IN FRAME fpage0.                                                                             */
/*             UNDO, next.                                                                                                                     */
/*          END.                                                                                                                               */
/*      END.                                                                                                                                   */
/*      IF fi_endereco:SCREEN-VALUE IN FRAME fpage0  = ""  THEN DO:                                                                            */
/*         ASSIGN l-erro = YES.                                                                                                                */
/*         RUN utp/ut-msgs.p ('show', 17006, 'Endereáo n∆o informado.~~O Campo Endereáo Ç obrigatorio, informe o campo corretamente').         */
/*         APPLY "ENTRY" to fi_endereco IN FRAME fpage0.                                                                                       */
/*         UNDO, next.                                                                                                                         */
/*      END.                                                                                                                                   */
/*      IF fi_nro-endereco:SCREEN-VALUE IN FRAME fpage0  = ""  THEN DO:                                                                        */
/*         ASSIGN l-erro = YES.                                                                                                                */
/*         RUN utp/ut-msgs.p ('show', 17006, 'Nro Endereáo n∆o informado.~~O Campo Nro Endereáo Ç obrigatorio, informe o campo corretamente'). */
/*         APPLY "ENTRY" to fi_nro-endereco IN FRAME fpage0.                                                                                   */
/*         UNDO, next.                                                                                                                         */
/*      END.                                                                                                                                   */

     IF dec(fi_perc-participacao:SCREEN-VALUE IN FRAME fpage0) = 0 THEN DO:   
         ASSIGN l-erro = YES.
         RUN utp/ut-msgs.p ('show', 17006, '% Participaá∆o Societ†ria n∆o informada.~~O campo Percentual de participaá∆o societ†ria Ç um campo obrigat¢rio, por favor informe corretamente esta informaá∆o').
         APPLY "ENTRY" to fi_perc-participacao IN FRAME fpage0.
         undo, next.
     END.
/*                                                                                                                                                        */
/*      IF fi_profissao:SCREEN-VALUE IN FRAME fpage0  = ""  THEN DO:                                                                                      */
/*         ASSIGN l-erro = YES.                                                                                                                           */
/*         RUN utp/ut-msgs.p ('show', 17006, 'Profiss∆o n∆o informado.~~O Campo Profiss∆o Ç obrigatorio, informe o campo corretamente').                  */
/*         APPLY "ENTRY" to fi_profissao IN FRAME fpage0.                                                                                                 */
/*         UNDO, next.                                                                                                                                    */
/*      END.                                                                                                                                              */
/*      IF fi_nacionalidade:SCREEN-VALUE IN FRAME fpage0  = ""  THEN DO:                                                                                  */
/*         ASSIGN l-erro = YES.                                                                                                                           */
/*         RUN utp/ut-msgs.p ('show', 17006, 'Nacionalidade n∆o informado.~~O Campo Nacionalidade Telefone Ç obrigatorio, informe o campo corretamente'). */
/*         APPLY "ENTRY" to fi_nacionalidade IN FRAME fpage0.                                                                                             */
/*         UNDO, next.                                                                                                                                    */
/*      END.                                                                                                                                              */

     FIND emit-partic-societaria
          WHERE emit-partic-societaria.cod-emitente = int(c-cod-emitente:SCREEN-VALUE IN FRAME fpage0)
            AND emit-partic-societaria.cod-cpf-cnpj = replace(replace(replace(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0,".",""),"/",""),"-","")
          exclusive-LOCK NO-ERROR.

     IF pl-inclusao  THEN DO:
        IF NOT AVAIL emit-partic-societaria THEN DO:
            CREATE emit-partic-societaria.
            ASSIGN emit-partic-societaria.cod-emitente = int(c-cod-emitente:SCREEN-VALUE IN FRAME fpage0)
                   emit-partic-societaria.cod-cpf-cnpj = replace(replace(replace(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0,".",""),"/",""),"-","").
        END.
        ELSE DO:
            ASSIGN l-erro = YES.
            RUN utp/ut-msgs.p ('show', 17006, 'Ja esta cadastrado este socio para este cliente.~~Este s¢cio ja foi cadastrado anteriormente para este cliente, n∆o Ç possivel informar em duplicidade').
            UNDO, next.
        END.
    END.

    FIND FIRST partic-societaria 
         WHERE partic-societaria.cod-cpf-cnpj = replace(replace(replace(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0,".",""),"/",""),"-","")
         EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL partic-societaria THEN DO:
        CREATE partic-societaria.
        ASSIGN partic-societaria.cod-cpf-cnpj      = replace(replace(replace(fi_cod-cpf-cnpj:SCREEN-VALUE IN FRAME fpage0,".",""),"/",""),"-","").
    END.
    
        
    ASSIGN partic-societaria.nro-identidade    = fi_nro-identidade:SCREEN-VALUE IN FRAME fpage0   
           partic-societaria.nome-socio        = fi_nome-socio:SCREEN-VALUE IN FRAME fpage0        
           partic-societaria.endereco          = fi_endereco:SCREEN-VALUE IN FRAME fpage0          
           partic-societaria.nro-endereco      = fi_nro-endereco:SCREEN-VALUE IN FRAME fpage0      
           partic-societaria.compl-endereco    = fi_compl-endereco:SCREEN-VALUE IN FRAME fpage0    
           partic-societaria.bairro            = fi_bairro:SCREEN-VALUE IN FRAME fpage0           
           partic-societaria.cidade            = fi_cidade:SCREEN-VALUE IN FRAME fpage0            
           partic-societaria.estado            = fi_estado:SCREEN-VALUE IN FRAME fpage0            
           partic-societaria.pais              = fi_pais:SCREEN-VALUE IN FRAME fpage0           
           partic-societaria.cep               = fi_cep:SCREEN-VALUE IN FRAME fpage0               
           partic-societaria.telefone          = fi_telefone:SCREEN-VALUE IN FRAME fpage0          
           partic-societaria.celular           = fi_celular:SCREEN-VALUE IN FRAME fpage0           
           partic-societaria.e-mail            = fi_e-mail:SCREEN-VALUE IN FRAME fpage0            
           partic-societaria.nacionalidade     = fi_nacionalidade:SCREEN-VALUE IN FRAME fpage0     
           partic-societaria.estado            = fi_estado:SCREEN-VALUE IN FRAME fpage0            
           partic-societaria.estado-civil      = int(cb_estado-civil:SCREEN-VALUE IN FRAME fpage0)      
           partic-societaria.profissao         = fi_profissao:SCREEN-VALUE IN FRAME fpage0         
           emit-partic-societaria.perc-participacao = dec(fi_perc-participacao:SCREEN-VALUE IN FRAME fpage0).
    IF pl-inclusao  THEN DO:
        RUN pi-limpa-campos.
    END.
    MESSAGE "Informaá∆o Salva com Sucesso".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

