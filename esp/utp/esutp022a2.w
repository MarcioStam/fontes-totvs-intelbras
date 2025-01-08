&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-pagto-vpc NO-UNDO LIKE pagto-vpc
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
{include/i-prgvrs.i esutp022a2 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esutp022a2
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 ~
                              tt-pagto-vpc.valor tt-pagto-vpc.nr-pedcli tt-pagto-vpc.cod-estab-nf ~
                              tt-pagto-vpc.serie tt-pagto-vpc.nr-nota-fis tt-pagto-vpc.observacoes ~
                              tt-pagto-vpc.data-pagto
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p-nr-vpc       AS INTEGER NO-UNDO.
/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-pagto-vpc-aux NO-UNDO LIKE tt-pagto-vpc.

def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda_1              as character format "x(250)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9".

DEFINE VARIABLE de-valor-nota AS DECIMAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-pagto-vpc.nr-vpc tt-pagto-vpc.sequencia ~
tt-pagto-vpc.data-trans tt-pagto-vpc.usuario tt-pagto-vpc.nr-pedcli ~
tt-pagto-vpc.cod-estab-nf tt-pagto-vpc.serie tt-pagto-vpc.nr-nota-fis ~
tt-pagto-vpc.data-pagto tt-pagto-vpc.valor tt-pagto-vpc.observacoes 
&Scoped-define ENABLED-TABLES tt-pagto-vpc
&Scoped-define FIRST-ENABLED-TABLE tt-pagto-vpc
&Scoped-Define ENABLED-OBJECTS fi-cod-emitente fi-nome-emit btOK btCancel ~
btHelp2 btQueryJoins btReportsJoins btExit btHelp rtToolBar-2 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-pagto-vpc.nr-vpc tt-pagto-vpc.sequencia ~
tt-pagto-vpc.data-trans tt-pagto-vpc.usuario tt-pagto-vpc.nr-pedcli ~
tt-pagto-vpc.cod-estab-nf tt-pagto-vpc.serie tt-pagto-vpc.nr-nota-fis ~
tt-pagto-vpc.data-pagto tt-pagto-vpc.valor tt-pagto-vpc.observacoes 
&Scoped-define DISPLAYED-TABLES tt-pagto-vpc
&Scoped-define FIRST-DISPLAYED-TABLE tt-pagto-vpc
&Scoped-Define DISPLAYED-OBJECTS fi-cod-emitente fi-nome-emit 

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

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 46.14 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-pagto-vpc.nr-vpc AT ROW 4 COL 13 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-cod-emitente AT ROW 3 COL 13 COLON-ALIGNED WIDGET-ID 20
     fi-nome-emit AT ROW 3 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     tt-pagto-vpc.sequencia AT ROW 5 COL 13 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-pagto-vpc.data-trans AT ROW 6 COL 47 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-pagto-vpc.usuario AT ROW 7 COL 47 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-pagto-vpc.nr-pedcli AT ROW 6 COL 13 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-pagto-vpc.cod-estab-nf AT ROW 7 COL 13 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-pagto-vpc.serie AT ROW 8 COL 13 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-pagto-vpc.nr-nota-fis AT ROW 9 COL 13 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-pagto-vpc.data-pagto AT ROW 10 COL 13 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-pagto-vpc.valor AT ROW 10 COL 47 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-pagto-vpc.observacoes AT ROW 11.13 COL 15 NO-LABEL WIDGET-ID 26
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 72 BY 3.29
     btOK AT ROW 15.25 COL 2
     btCancel AT ROW 15.25 COL 13
     btHelp2 AT ROW 15.25 COL 80
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     "Observaá‰es:" VIEW-AS TEXT
          SIZE 9.57 BY .54 AT ROW 12.29 COL 5.43 WIDGET-ID 28
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 15.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.58
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-pagto-vpc T "?" NO-UNDO mgesp pagto-vpc
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
         HEIGHT             = 15.58
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

{window/window.i}

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
    ASSIGN INPUT FRAME fPage0 tt-pagto-vpc.valor.

    IF de-valor-nota < tt-pagto-vpc.valor THEN DO:
        MESSAGE "Valor informado maior que valor total da nota: " de-valor-nota
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
        RUN pi-cria-pagto.
    END.
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


&Scoped-define SELF-NAME tt-pagto-vpc.nr-nota-fis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-pagto-vpc.nr-nota-fis wWindow
ON LEAVE OF tt-pagto-vpc.nr-nota-fis IN FRAME fpage0 /* Nota Fiscal */
DO:
    ASSIGN INPUT FRAME fPage0 tt-pagto-vpc.cod-estab-nf
           INPUT FRAME fPage0 tt-pagto-vpc.serie
           INPUT FRAME fPage0 tt-pagto-vpc.nr-nota-fis
           de-valor-nota = 0.


    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = tt-pagto-vpc.cod-estab-nf 
           AND nota-fiscal.serie       = tt-pagto-vpc.serie        
           AND nota-fiscal.nr-nota-fis = tt-pagto-vpc.nr-nota-fis NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        ASSIGN tt-pagto-vpc.data-pagto:SCREEN-VALUE IN FRAME fPage0 = TRIM(STRING(nota-fiscal.dt-emis-nota,"99/99/9999"))
               tt-pagto-vpc.valor:SCREEN-VALUE IN FRAME fPage0 = TRIM(STRING(nota-fiscal.vl-tot-nota,"->>>,>>9.99"))
               de-valor-nota = nota-fiscal.vl-tot-nota.
    END.
    ELSE DO:
        MESSAGE "Nota fiscal n∆o cadastrada, valores foram zerados!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ASSIGN tt-pagto-vpc.valor:SCREEN-VALUE IN FRAME fPage0 = "0,00".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

RUN pi-carrega-informacoes.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-informacoes wWindow 
PROCEDURE pi-carrega-informacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

    FIND FIRST vpc NO-LOCK
         WHERE vpc.nr-vpc = p-nr-vpc NO-ERROR.
    IF NOT AVAIL vpc THEN DO:
        MESSAGE "VPC " + STRING(p-nr-vpc) + " inexistente ou foi eliminada! Programa ser† finalizado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "close" TO THIS-PROCEDURE.
    END.
    ELSE DO:
        FIND LAST pagto-vpc OF vpc NO-LOCK NO-ERROR.
        IF NOT AVAIL pagto-vpc THEN
            ASSIGN i-seq = 1.
        ELSE
            ASSIGN i-seq = pagto-vpc.sequencia + 1.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = vpc.cod-emitente NO-ERROR.

        CREATE tt-pagto-vpc.
        ASSIGN tt-pagto-vpc.nr-vpc       = vpc.nr-vpc
               tt-pagto-vpc.data-pagto   = TODAY
               tt-pagto-vpc.data-trans   = TODAY
               tt-pagto-vpc.sequencia    = i-seq 
               tt-pagto-vpc.usuario      = c-seg-usuario.

        ASSIGN tt-pagto-vpc.nr-vpc:SCREEN-VALUE       IN FRAME fPage0 = STRING(vpc.nr-vpc)
               fi-cod-emitente:SCREEN-VALUE           IN FRAME fPage0 = STRING(vpc.cod-emitente)
               fi-nome-emit:SCREEN-VALUE              IN FRAME fPage0 = IF AVAIL emitente THEN STRING(emitente.nome-emit) ELSE ""
               tt-pagto-vpc.data-pagto:SCREEN-VALUE   IN FRAME fPage0 = STRING(TODAY,"99/99/9999")
               tt-pagto-vpc.data-trans:SCREEN-VALUE   IN FRAME fPage0 = STRING(TODAY,"99/99/9999")
               tt-pagto-vpc.sequencia:SCREEN-VALUE    IN FRAME fPage0 = STRING(i-seq) 
               tt-pagto-vpc.usuario:SCREEN-VALUE      IN FRAME fPage0 = c-seg-usuario.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-pagto wWindow 
PROCEDURE pi-cria-pagto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-esapi015 AS HANDLE NO-UNDO.

    FOR EACH tt_log_erros_tit_ap_alteracao:
        DELETE tt_log_erros_tit_ap_alteracao.
    END.

    FOR EACH tt-pagto-vpc-aux:
        DELETE tt-pagto-vpc-aux.
    END.

    FOR EACH RowErrors: 
        DELETE RowErrors. 
    END. 

    IF AVAIL tt-pagto-vpc THEN DO:
        CREATE tt-pagto-vpc-aux.
        ASSIGN tt-pagto-vpc-aux.nr-vpc       = tt-pagto-vpc.nr-vpc
               tt-pagto-vpc-aux.sequencia    = tt-pagto-vpc.sequencia
               tt-pagto-vpc-aux.data-trans   = tt-pagto-vpc.data-trans
               tt-pagto-vpc-aux.usuario      = tt-pagto-vpc.usuario
               tt-pagto-vpc-aux.cod-estab-nf  = tt-pagto-vpc.cod-estab-nf:SCREEN-VALUE IN FRAME fPage0
               tt-pagto-vpc-aux.serie        = tt-pagto-vpc.serie:SCREEN-VALUE IN FRAME fPage0
               tt-pagto-vpc-aux.nr-nota-fis  = tt-pagto-vpc.nr-nota-fis:SCREEN-VALUE IN FRAME fPage0
               tt-pagto-vpc-aux.nr-pedcli    = tt-pagto-vpc.nr-pedcli:SCREEN-VALUE IN FRAME fPage0 
               tt-pagto-vpc-aux.data-pagto   = DATE(tt-pagto-vpc.data-pagto:SCREEN-VALUE IN FRAME fPage0)
               tt-pagto-vpc-aux.valor        = DEC(tt-pagto-vpc.valor:SCREEN-VALUE IN FRAME fPage0)
               tt-pagto-vpc-aux.observacoes  = tt-pagto-vpc.observacoes:SCREEN-VALUE IN FRAME fPage0.

        RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
        RUN pi-pagamento-vpc IN h-esapi015 (INPUT TABLE tt-pagto-vpc-aux,
                                            OUTPUT TABLE tt_log_erros_tit_ap_alteracao).

        DELETE PROCEDURE h-esapi015.

        IF CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao) THEN DO:
            FOR EACH tt_log_erros_tit_ap_alteracao:
                CREATE RowErrors.
                ASSIGN RowErrors.errorNumber      = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                       RowErrors.errorDescription = tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro
                       rowerrors.errorhelp        = tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda_1.
            END.
            {method/showmessage.i1}

            {method/showmessage.i2}

            WAIT-FOR CLOSE OF hShowMsg.
        END.
        ELSE DO:
            MESSAGE "Pagamento Efetuado. Acerto de Valor efetuado com sucesso!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY "close" TO THIS-PROCEDURE.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

