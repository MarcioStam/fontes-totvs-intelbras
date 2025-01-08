&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
 {include/i-prgvrs.i esft069 2.00.00.001}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/*:T Preprocessadores do Template de Relat¢rio                            */
/*:T Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */
{utp/utapi019.i}
define buffer b-emitente for emitente.    
define temp-table tt-param no-undo
    field destino       as integer
    field arquivo       as char format "x(35)"
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    field codEstabel    as char
    field cSerie        as char
    field cNrNotaFis    as char.
    

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
                    
/* Local Variable Definitions ---                                       */

def var l-ok               as LOGICAL NO-UNDO.
DEFINE VARIABLE c-terminal AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-per      AS DATE    NO-UNDO.
DEFINE VARIABLE c-email-destino AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-xml AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 rs-destino bt-arquivo ~
bt-config-impr c-arquivo rs-execucao 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE cNrNotaFis AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nota fiscal" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE codEstabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cSerie AS CHARACTER FORMAT "X(3)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-email AS CHARACTER FORMAT "X(200)":U 
     LABEL "E-Mail" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE BUTTON BUTTON-1 
     LABEL "Reenviar XML para Cliente" 
     SIZE 24 BY 1.13.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     BUTTON-1 AT ROW 14.5 COL 38 WIDGET-ID 2
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     im-pg-imp AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         FONT 4
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.

DEFINE FRAME f-pg-sel
     codEstabel AT ROW 1.58 COL 12.86 COLON-ALIGNED WIDGET-ID 30
     cSerie AT ROW 2.58 COL 12.86 COLON-ALIGNED WIDGET-ID 32
     cNrNotaFis AT ROW 3.58 COL 12.86 COLON-ALIGNED WIDGET-ID 36
     fi-email AT ROW 4.5 COL 12.86 COLON-ALIGNED WIDGET-ID 38
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.86 BY 10.62
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "Programa executor - NFE - ESFT069 - GATI"
         HEIGHT             = 15
         WIDTH              = 81.43
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-imp
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* Programa executor - NFE - ESFT069 - GATI */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* Programa executor - NFE - ESFT069 - GATI */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 w-relat
ON CHOOSE OF BUTTON-1 IN FRAME f-relat /* Reenviar XML para Cliente */
DO:
    
    FIND estabelec
         WHERE estabelec.cod-estabel = input frame f-pg-sel codEstabel NO-LOCK NO-ERROR.
    FIND FIRST gati-nfe-param
        WHERE gati-nfe-param.cod-estabel = input frame f-pg-sel codEstabel NO-LOCK NO-ERROR.
    FIND FIRST gati-nfe-param-ext
        WHERE gati-nfe-param-ext.cod-estabel = input frame f-pg-sel codEstabel NO-LOCK NO-ERROR.

/*     ASSIGN c-arquivo-xml =  gati-nfe-param.end-imp-nfe + '~\backup~\' + input frame f-pg-sel cSerie  + '_' + string(int(input frame f-pg-sel cNrNotaFis)) + '.xml'. */
/*     IF SEARCH(c-arquivo-xml) = ? THEN DO:                                                                                                                      */
/*         ASSIGN c-arquivo-xml =  gati-nfe-param.end-imp-nfe + '~\' + input frame f-pg-sel cSerie  + '_' + string(int(input frame f-pg-sel cNrNotaFis)) + '.xml'.     */
/*         IF SEARCH(c-arquivo-xml) = ? THEN DO:                                                                                                                  */
/*             MESSAGE "Xml n∆o encontrado "                                                                                                                      */
/*                                                                                                                                                                */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                             */
/*             LEAVE.                                                                                                                                             */
/*         END.                                                                                                                                                   */
/*     END.                                                                                                                                                       */
/*                                                                                                                                                                */
    
    FIND FIRST emsfnd.usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.

    find first nota-fiscal no-lock
    where nota-fiscal.cod-estabel = input frame f-pg-sel codEstabel
      and nota-fiscal.serie       = input frame f-pg-sel cSerie    
      and nota-fiscal.nr-nota-fis = input frame f-pg-sel cNrNotaFis no-error.

    IF avail nota-fiscal then do:


        IF opsys <> 'WIN32' THEN
            ASSIGN c-arquivo-xml         = REPLACE(gati-nfe-param-ext.end-imp-nfe-unix,'insercao/saida','idanfe') + '/' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro)) + '.pdf'.
        ELSE
            ASSIGN c-arquivo-xml         = REPLACE(gati-nfe-param.end-imp-nfe,'insercao~\saida','idanfe') + '~\' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro)) + '.pdf'   .

            
        
        IF opsys <> 'WIN32' THEN DO:
                                      
            IF  SEARCH(gati-nfe-param-ext.end-imp-nfe-unix + '/' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro)) + '.xml') <> ? THEN
                ASSIGN c-arquivo-xml         = c-arquivo-xml + ',' + gati-nfe-param-ext.end-imp-nfe-unix + '/' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro)) + '.xml'.
            ELSE
                IF SEARCH(gati-nfe-param-ext.end-imp-nfe-unix + '/backup/' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro)) + '.xml') <> ? THEN
                   ASSIGN c-arquivo-xml         = c-arquivo-xml + ',' + gati-nfe-param-ext.end-imp-nfe-unix + '/backup/' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro)) + '.xml'.
                ELSE
                    IF  SEARCH(gati-nfe-param-ext.end-imp-nfe-unix + '/' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml') <> ? THEN
                        ASSIGN c-arquivo-xml         = c-arquivo-xml + ',' + gati-nfe-param-ext.end-imp-nfe-unix + '/' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml'.
                    ELSE
                        IF SEARCH(gati-nfe-param-ext.end-imp-nfe-unix + '/backup/' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml') <> ? THEN
                           ASSIGN c-arquivo-xml         = c-arquivo-xml + ',' + gati-nfe-param-ext.end-imp-nfe-unix + '/backup/' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml'.
        END.
        ELSE
            IF  SEARCH(gati-nfe-param.end-imp-nfe + '\' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro)) + '.xml') <> ? THEN
                ASSIGN c-arquivo-xml         = c-arquivo-xml + ',' + gati-nfe-param.end-imp-nfe + '\' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro)) + '.xml'.
            ELSE
                IF SEARCH(gati-nfe-param.end-imp-nfe + '\backup\' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro))+ '.xml') <> ? THEN
                   ASSIGN c-arquivo-xml         = c-arquivo-xml + ',' + gati-nfe-param.end-imp-nfe + '\backup\' + TRIM(string(nota-fiscal.cod-chave-aces-nf-eletro)) + '.xml'.
                ELSE
                    IF  SEARCH(gati-nfe-param.end-imp-nfe + '\' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml') <> ? THEN
                        ASSIGN c-arquivo-xml         = c-arquivo-xml + ',' + gati-nfe-param.end-imp-nfe + '\' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml'.
                    ELSE
                        IF SEARCH(gati-nfe-param.end-imp-nfe + '\backup\' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml') <> ? THEN
                           ASSIGN c-arquivo-xml         = c-arquivo-xml + ',' + gati-nfe-param.end-imp-nfe + '\backup\' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml'.



        IF c-arquivo-xml         = ""  THEN DO:
            MESSAGE "Arquivos n∆o encontrados, Solicite para a Expediá∆o ou Controladoria baixar os arquivos DO sistema de NF-e (Gati)"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN.
        END.
        

        RUN pi-gera-email.

    END.
    ELSE DO:
        MESSAGE "Nota fiscal n∆o encontrada"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME fi-email
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-email w-relat
ON LEAVE OF fi-email IN FRAME f-pg-sel /* E-Mail */
DO:
    /*
  ON LEAVE OF cNrNotaFis IN FRAME f-pg-sel  DO:

   /* ASSIGN fi-email:SCREEN-VALUE IN FRAME f-pg-sel = . */
    ASSIGN fi-email = usuar_mestre.cod_e_mail_local + "," +  cont-emit.e-mail + "," .

    DISPLAY fi-email WITH FRAME f-pg-sel.


    END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

 {utp/ut9000.i "ESFT069" "1.00.00.001"} 

/*:T inicializaá‰es do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    ON LEAVE OF cNrNotaFis IN FRAME f-pg-sel DO:
        
        DEFINE BUFFER b-emitente FOR emitente.

        FIND estabelec NO-LOCK
            WHERE estabelec.cod-estabel = INPUT FRAME f-pg-sel codEstabel NO-ERROR.
        
        FIND FIRST param-global NO-LOCK NO-ERROR.
        
        FIND FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = INPUT FRAME f-pg-sel codEstabel
              AND nota-fiscal.serie       = INPUT FRAME f-pg-sel cSerie    
              AND nota-fiscal.nr-nota-fis = INPUT FRAME f-pg-sel cNrNotaFis NO-ERROR.
        ASSIGN fi-email = "".

        IF AVAIL nota-fiscal THEN DO:

            IF CAN-find(FIRST cont-emit no-lock
                    where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                      and (cont-emit.nome        BEGINS 'NFE'
                       or cont-emit.nome         BEGINS 'NF-e')) THEN DO:
               ASSIGN c-email-destino = "".
               FOR each cont-emit no-lock
                    where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                      and (cont-emit.nome        BEGINS 'NFE'
                       or cont-emit.nome         BEGINS 'NF-e'):
                   IF c-email-destino = "" THEN
                      ASSIGN c-email-destino = trim(cont-emit.e-mail).
                   ELSE
                      ASSIGN c-email-destino = trim(c-email-destino) + "," + trim(cont-emit.e-mail) + "," + trim(INPUT FRAME f-pg-sel fi-email).
               END.
            END.
            ELSE DO:
                find first b-emitente no-lock
                     where b-emitente.cod-emitente = nota-fiscal.cod-emitente no-error.       
                ASSIGN c-email-destino = b-emitente.e-mail.
                
            END.
    
            ASSIGN fi-email = usuar_mestre.cod_e_mail_local + "," + c-email-destino.
        END.
        
        DISPLAY fi-email WITH FRAME f-pg-sel. 
    
    END.

    RUN enable_UI.
      
    {include/i-rpmbl.i}
      
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
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
  ENABLE im-pg-imp im-pg-sel BUTTON-1 bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY codEstabel cSerie cNrNotaFis fi-email 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE codEstabel cSerie cNrNotaFis fi-email 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.
DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-ok66 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-ok67 AS LOGICAL     NO-UNDO.

do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}
    
    if input frame f-pg-imp rs-destino = 2 and
       input frame f-pg-imp rs-execucao = 1 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "").
            
            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.
    
    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse br-digita:SET-REPOSITIONED-ROW (browse br-digita:DOWN, "ALWAYS":U).*/

    
    create tt-param.
    assign tt-param.usuario     = c-seg-usuario
           tt-param.destino     = input frame f-pg-imp rs-destino
           tt-param.data-exec   = today
           tt-param.hora-exec   = TIME
           tt-param.codEstabel  = input frame f-pg-sel codEstabel
           tt-param.cSerie      = input frame f-pg-sel cSerie
           tt-param.cNrNotaFis  = input frame f-pg-sel cNrNotaFis.

    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {include/i-rpexb.i}
    
    SESSION:SET-WAIT-STATE("general":U).
    
    {include/i-rprun.i esp/ftp/esft069rp.p} 
    
    {include/i-rpexc.i} 
    
    SESSION:SET-WAIT-STATE("":U).         
      
    {include/i-rptrm.i}  
      
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-email w-relat 
PROCEDURE pi-gera-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 FIND first b-emitente no-lock
        where b-emitente.cod-emitente = nota-fiscal.cod-emitente no-error.       

    find first emitente no-lock 
        where emitente.cgc = estabelec.cgc no-error.

    find first param-global no-lock no-error.    

    create tt-envio.              
    ASSIGN 
        tt-envio.versao-integracao = 1
        tt-envio.exchange          = param-global.log-1
        tt-envio.servidor          = param-global.serv-mail
        tt-envio.porta             = param-global.porta-mail                
        tt-envio.assunto           = 'NFE AUTORIZADA'
        tt-envio.remetente         = usuar_mestre.cod_e_mail_local
        tt-envio.mensagem          = 'Esta mensagem refere-se a Nota Fiscal Eletrìnica Nacional de serie/n£mero [' + trim(nota-fiscal.serie) + '/' + trim(nota-fiscal.nr-nota-fis) + '] emitida para:'  + CHR(10) +  CHR(13) +
                                     'Raz∆o Social: ' + b-emitente.nome-emit  + CHR(10) +  CHR(13) +
                                     'CNPJ: ' + b-emitente.cgc + CHR(10) +  CHR(13) +
                                     '' + CHR(10) +  CHR(13) +
                                     'Para verificar a autorizaá∆o da SEFAZ referente Ö nota acima mencionada, acesse o sitio http://www.nfe.fazenda.gov.br/portal' + CHR(10) +  CHR(13) +
                                     '' + CHR(10) +  CHR(13) +
                                     'Chave de acesso: ' + nota-fiscal.cod-chave-aces-nf-eletro + CHR(10) +  CHR(13) + 
                                     '' + CHR(10) +  CHR(13) +
                                     'Este e-mail foi enviado automaticamente pelo Sistema de Nota Fiscal Eletrìnica (NF-e) da INTELBRAS SA'
        tt-envio.importancia       = 2
        tt-envio.log-enviada       = no
        tt-envio.log-lida          = no
        tt-envio.acomp             = no
        tt-envio.arq-anexo         = c-arquivo-xml. 



    ASSIGN tt-envio.destino       =  TRIM(INPUT FRAME f-pg-sel fi-email).
            
    /* API de envio de e-mail */    
    run utp/utapi009.p (input  table tt-envio,
                        output table tt-erros).

    /* Elimina a tabela temporaria para envio do e-mail */
    IF CAN-FIND(FIRST tt-erros) THEN
        FOR EACH tt-erros:
            MESSAGE tt-erros.desc-erro
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    ELSE
        MESSAGE "Email enviado para -> " tt-envio.destino SKIP
            c-arquivo-xml
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    delete tt-envio. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*:T------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-relat, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

