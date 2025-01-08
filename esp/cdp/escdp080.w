&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escdp080 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escdp080
&GLOBAL-DEFINE Version        1.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2

&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE page6Widgets   

&GLOBAL-DEFINE page6Text      

&GLOBAL-DEFINE page2Fields    c-nome-matriz c-nome-cliente c-codigo-cliente
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */
/*Definiá∆o das temp-tables de validaá∆o - cdp/cdapi329.p*/
DEFINE TEMP-TABLE tt-versao-integr NO-UNDO
  FIELD cod-versao-integracao AS INTEGER FORMAT "999":U
  FIELD ind-origem-msg        AS INTEGER FORMAT "99":U.

DEFINE TEMP-TABLE tt-erros-geral NO-UNDO
  FIELD identif-msg        AS CHARACTER FORMAT "x(60)":U
  FIELD num-sequencia-erro AS INTEGER   FORMAT "999":U
  FIELD cod-erro           AS INTEGER   FORMAT "99999":U
  FIELD des-erro           AS CHARACTER FORMAT "x(60)":U
  FIELD cod-maq-origem     AS INTEGER   FORMAT "999":U
  FIELD num-processo       AS INTEGER   FORMAT "999999999":U.

DEFINE TEMP-TABLE tt-cliente-valid NO-UNDO LIKE emitente
  FIELD cod-maq-origem AS INTEGER   FORMAT "9999":U
  FIELD num-processo   AS INTEGER   FORMAT ">>>>>>>>9":U INITIAL 0
  FIELD num-sequencia  AS INTEGER   FORMAT ">>>>>9":U    INITIAL 0
  FIELD ind-tipo-movto AS INTEGER   FORMAT "99":U        INITIAL 1
  INDEX ch-codigo IS PRIMARY
        cod-maq-origem
        num-processo
        num-sequencia.

def temp-table tt-loc-entr-valid like loc-entr
  FIELD cod-maq-origem   as   integer format "9999"
  FIELD num-processo     as   integer format ">>>>>>>>9" initial 0
  FIELD num-sequencia    as   integer format ">>>>>9"    initial 0
  FIELD ind-tipo-movto   as   integer format "99"        initial 1
  INDEX ch-codigo IS PRIMARY  cod-maq-origem
                              num-processo
                              num-sequencia.  

DEFINE TEMP-TABLE tt-dist-emit-valid NO-UNDO LIKE dist-emitente
  FIELD cod-maq-origem AS INTEGER   FORMAT "9999":U
  FIELD num-processo   AS INTEGER   FORMAT ">>>>>>>>9":U INITIAL 0
  FIELD num-sequencia  AS INTEGER   FORMAT ">>>>>9":U    INITIAL 0
  FIELD ind-tipo-movto AS INTEGER   FORMAT "99":U        INITIAL 1
  INDEX ch-codigo IS PRIMARY
      cod-maq-origem
      num-processo
      num-sequencia.

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.


/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.
DEF VAR v_cod_erro_21      AS CHAR    NO-UNDO.
DEF VAR v_return_21        AS CHAR    NO-UNDO.
DEF VAR l-confirma         AS LOG     NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-codigo-cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-matriz AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 2.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 1.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     c-codigo-cliente AT ROW 3.25 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     c-nome-cliente AT ROW 3.25 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     c-nome-matriz AT ROW 5.25 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     "Altera Matriz do Cliente" VIEW-AS TEXT
          SIZE 38 BY 1 AT ROW 1.25 COL 5 WIDGET-ID 26
          FONT 0
     "Cliente:" VIEW-AS TEXT
          SIZE 14 BY .75 AT ROW 3.25 COL 19 RIGHT-ALIGNED WIDGET-ID 20
     "Nome Abreviado Matriz:" VIEW-AS TEXT
          SIZE 17 BY .75 AT ROW 5.5 COL 22 RIGHT-ALIGNED WIDGET-ID 22
     RECT-13 AT ROW 2.75 COL 5 WIDGET-ID 6
     RECT-14 AT ROW 5 COL 5 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-nome-cliente IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       c-nome-cliente:HIDDEN IN FRAME fPage2           = TRUE
       c-nome-cliente:READ-ONLY IN FRAME fPage2        = TRUE.

/* SETTINGS FOR TEXT-LITERAL "Cliente:"
          SIZE 14 BY .75 AT ROW 3.25 COL 19 RIGHT-ALIGNED               */

/* SETTINGS FOR TEXT-LITERAL "Nome Abreviado Matriz:"
          SIZE 17 BY .75 AT ROW 5.5 COL 22 RIGHT-ALIGNED                */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

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

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Alterar */
DO:
   do  on error undo, return no-apply:
       FIND emitente
           WHERE emitente.nome-abrev = c-nome-matriz:SCREEN-VALUE IN FRAME fpage2
           NO-LOCK NO-ERROR.
       IF NOT AVAIL emitente THEN DO:
           MESSAGE "Matriz Informada n∆o Existe"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           LEAVE.
       END.
        FIND emitente
           WHERE emitente.cod-emitente = INT(c-codigo-cliente:SCREEN-VALUE IN FRAME fpage2)
           EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            CREATE tt-cliente-valid.
            BUFFER-COPY emitente TO tt-cliente-valid.
            ASSIGN emitente.nome-matriz    = c-nome-matriz:SCREEN-VALUE IN FRAME fpage2.
            ASSIGN tt-cliente-valid.nome-matriz    = c-nome-matriz:SCREEN-VALUE IN FRAME fpage2
                   tt-cliente-valid.ind-tipo-movto = 2.
            EMPTY TEMP-TABLE tt-versao-integr.
            CREATE tt-versao-integr.
            ASSIGN tt-versao-integr.cod-versao-integracao = 001.
        

            RUN cdp/cdapi329.p (INPUT  TABLE tt-versao-integr,
                                OUTPUT TABLE tt-erros-geral,
                                INPUT  TABLE tt-cliente-valid,
                                INPUT  TABLE tt-loc-entr-valid,
                                INPUT  TABLE tt-dist-emit-valid).
            IF  NOT CAN-FIND(FIRST tt-erros-geral) THEN DO:
                
                MESSAGE "Alteraá∆o Efetuada com Sucesso !" VIEW-AS ALERT-BOX INFO BUTTONS OK.

                FIND FIRST int-emitente NO-LOCK
                     WHERE int-emitente.cod-emitente = emitente.cod-emit NO-ERROR.

                IF  AVAIL int-emitente THEN DO:
                    EMPTY TEMP-TABLE tt-prog-ponto.
                    RUN esp/es0018p.p (INPUT "dps-canal-vd", /* grupos tratados para pedidos */
                                       INPUT 1,              /* Ponto do programa */
                                       INPUT 0,
                                       INPUT "",
                                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
                    IF  CAN-FIND (FIRST tt-prog-ponto
                                  WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:
    
                        MESSAGE "Grupo de cobranáa: " int-emitente.cod-gr-cob SKIP
                                "Confirma integraá∆o com o DEPS ?"
                                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE l-confirma.
                    
                        IF  l-confirma = YES THEN DO:
                            RUN esp/wso/eswso0022.p (INPUT emitente.cod-emit). /* Envia cadastro atualizado ao DEPS */ 
        
                            RUN esp/wso/eswso0021.p (INPUT emitente.cod-emit, /* Envia nova requisá∆o de limite ao DEPS */
                                                     OUTPUT v_cod_erro_21,
                                                     OUTPUT v_return_21).
        
                            IF  v_return_21 = "NOK" THEN
                                MESSAGE "Erro ao requisitar limite para o novo grupo econìmico ! Erro: " v_cod_erro_21 VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            ELSE
                                MESSAGE "Integraá∆o com o DEPS efetuada com sucesso !" VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        END.
                    END.
                END.
            END.
            ELSE
                FOR EACH tt-erros-geral:
                    MESSAGE tt-erros-geral.cod-erro 
                            tt-erros-geral.des-erro 
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.
        END.

   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-codigo-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-codigo-cliente wReport
ON LEAVE OF c-codigo-cliente IN FRAME fPage2
DO:
  FIND EMITENTE
      WHERE emitente.cod-emitente = int(c-codigo-cliente:SCREEN-VALUE IN FRAME fPage2)
     NO-LOCK NO-ERROR.
  IF NOT AVAIL emitente THEN DO:
    ASSIGN c-nome-cliente:SCREEN-VALUE IN FRAME fpage2 = ""
             c-nome-matriz:SCREEN-VALUE IN FRAME fpage2 = "".
      MESSAGE "Cliente N∆o Cadastrado"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.
  ELSE DO:
      ASSIGN c-nome-cliente:SCREEN-VALUE IN FRAME fpage2 = emitente.nome-emit
             c-nome-matriz:SCREEN-VALUE IN FRAME fpage2 = emitente.nome-matriz.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome-matriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome-matriz wReport
ON LEAVE OF c-nome-matriz IN FRAME fPage2
DO:
  FIND emitente
           WHERE emitente.nome-abrev = c-nome-matriz:SCREEN-VALUE IN FRAME fpage2
           NO-LOCK NO-ERROR.
   IF NOT AVAIL emitente THEN DO:
       FIND emitente
           WHERE emitente.cod-emitente = int(c-nome-matriz:SCREEN-VALUE IN FRAME fpage2)
           NO-LOCK NO-ERROR.
       IF NOT AVAIL emitente THEN DO:
           MESSAGE "Matriz Informada n∆o Existe"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           LEAVE.

       END.
       ELSE
           ASSIGN c-nome-matriz:SCREEN-VALUE IN FRAME fpage2 = emitente.nome-abrev.
   END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializaá∆o
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/

/*Fim alteracao 17/02/2005*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:


    
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

