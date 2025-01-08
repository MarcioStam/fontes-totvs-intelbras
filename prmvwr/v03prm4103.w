&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-prm-regras-integrador NO-UNDO LIKE prm-regras-integrador
       FIELD r-rowid   AS ROWID
       FIELD desc-item AS CHARACTER
       FIELD linha AS INTEGER.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever† ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME br-regras

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES prm-projeto-integrador
&Scoped-define FIRST-EXTERNAL-TABLE prm-projeto-integrador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR prm-projeto-integrador.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-prm-regras-integrador

/* Definitions for BROWSE br-regras                                     */
&Scoped-define FIELDS-IN-QUERY-br-regras tt-prm-regras-integrador.cfop tt-prm-regras-integrador.tipo tt-prm-regras-integrador.estado tt-prm-regras-integrador.ind-contribuinte tt-prm-regras-integrador.it-codigo tt-prm-regras-integrador.origem-item tt-prm-regras-integrador.nat-operacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-regras   
&Scoped-define SELF-NAME br-regras
&Scoped-define QUERY-STRING-br-regras FOR EACH tt-prm-regras-integrador NO-LOCK                               BY tt-prm-regras-integrador.cfop                               BY tt-prm-regras-integrador.estado                               BY tt-prm-regras-integrador.ind-contribuinte                               BY tt-prm-regras-integrador.it-codigo
&Scoped-define OPEN-QUERY-br-regras OPEN QUERY {&SELF-NAME} FOR EACH tt-prm-regras-integrador NO-LOCK                               BY tt-prm-regras-integrador.cfop                               BY tt-prm-regras-integrador.estado                               BY tt-prm-regras-integrador.ind-contribuinte                               BY tt-prm-regras-integrador.it-codigo.
&Scoped-define TABLES-IN-QUERY-br-regras tt-prm-regras-integrador
&Scoped-define FIRST-TABLE-IN-QUERY-br-regras tt-prm-regras-integrador


/* Definitions for FRAME f-main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-main ~
    ~{&OPEN-QUERY-br-regras}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-regras bt-incluir bt-modificar ~
bt-eliminar bt-importar bt-exportar bt-layout bt-copiar-regra 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-copiar-regra 
     LABEL "Copiar Regra" 
     SIZE 14.43 BY 1.

DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-exportar 
     LABEL "Exportar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-importar 
     LABEL "Importar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-layout 
     LABEL "Layout" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar 
     LABEL "&Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-regras FOR 
      tt-prm-regras-integrador SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-regras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-regras V-table-Win _FREEFORM
  QUERY br-regras NO-LOCK DISPLAY
      tt-prm-regras-integrador.cfop             COLUMN-LABEL "CFOP"           FORMAT "x(4)":U     WIDTH 5
      tt-prm-regras-integrador.tipo             COLUMN-LABEL "Tipo"           FORMAT "x(9)":U     WIDTH 9
      tt-prm-regras-integrador.estado                                         FORMAT "x(4)":U
      tt-prm-regras-integrador.ind-contribuinte COLUMN-LABEL "Contribuinte"   FORMAT "Sim/Nao":U
      tt-prm-regras-integrador.it-codigo                                      FORMAT "x(16)":U    WIDTH 9
      tt-prm-regras-integrador.origem-item      COLUMN-LABEL "Origem Item"    FORMAT "x(12)":U
      tt-prm-regras-integrador.nat-operacao     COLUMN-LABEL "Nat Operacao"       FORMAT "x(06)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89.43 BY 14.21 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     br-regras AT ROW 1.33 COL 1.86 WIDGET-ID 200
     bt-incluir AT ROW 15.63 COL 1.72 WIDGET-ID 6
     bt-modificar AT ROW 15.63 COL 11.72 WIDGET-ID 8
     bt-eliminar AT ROW 15.63 COL 21.72 WIDGET-ID 4
     bt-importar AT ROW 15.63 COL 43 WIDGET-ID 12
     bt-exportar AT ROW 15.63 COL 53 WIDGET-ID 14
     bt-layout AT ROW 15.63 COL 63 WIDGET-ID 16
     bt-copiar-regra AT ROW 15.63 COL 77 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgdes.prm-projeto-integrador
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
   Temp-Tables and Buffers:
      TABLE: tt-prm-regras-integrador T "?" NO-UNDO mgdes prm-regras-integrador
      ADDITIONAL-FIELDS:
          FIELD r-rowid   AS ROWID
          FIELD desc-item AS CHARACTER
          FIELD linha AS INTEGER
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 16.21
         WIDTH              = 91.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br-regras 1 f-main */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-regras
/* Query rebuild information for BROWSE br-regras
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-prm-regras-integrador NO-LOCK
                              BY tt-prm-regras-integrador.cfop
                              BY tt-prm-regras-integrador.estado
                              BY tt-prm-regras-integrador.ind-contribuinte
                              BY tt-prm-regras-integrador.it-codigo.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-regras */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-regras
&Scoped-define SELF-NAME br-regras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-regras V-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-regras IN FRAME f-main
DO:
    APPLY "CHOOSE":U TO bt-modificar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-copiar-regra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-copiar-regra V-table-Win
ON CHOOSE OF bt-copiar-regra IN FRAME f-main /* Copiar Regra */
DO:
    IF  AVAIL tt-prm-regras-integrador 
    AND AVAIL prm-projeto-integrador
    AND ROWID(prm-projeto-integrador) <> ? THEN DO:

        RUN prmp/prm4103a.w(INPUT tt-prm-regras-integrador.r-rowid,
                            INPUT TRUE,
                            INPUT prm-projeto-integrador.cod-proj-int).

        RUN pi-carrega.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar V-table-Win
ON CHOOSE OF bt-eliminar IN FRAME f-main /* Eliminar */
DO:
    IF  AVAIL tt-prm-regras-integrador 
    AND AVAIL prm-projeto-integrador
    AND ROWID(prm-projeto-integrador) <> ? THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 27100, /* quest∆o */
                           INPUT "Excluir o registro selecionado?").
        IF RETURN-VALUE = "YES":U THEN DO:

            FIND FIRST prm-regras-integrador EXCLUSIVE-LOCK
                 WHERE ROWID(prm-regras-integrador) = tt-prm-regras-integrador.r-rowid NO-ERROR.
            IF AVAIL prm-regras-integrador THEN
                DELETE prm-regras-integrador.
            
            RELEASE prm-regras-integrador.
            RUN pi-carrega.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exportar V-table-Win
ON CHOOSE OF bt-exportar IN FRAME f-main /* Exportar */
DO:
    DEF VAR c-arquivo AS CHAR NO-UNDO.

    IF  AVAIL tt-prm-regras-integrador 
    AND AVAIL prm-projeto-integrador
    AND ROWID(prm-projeto-integrador) <> ? THEN DO:

        ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "PRM4103-regras-" + STRING(TODAY, "99-99-9999") + "-" + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + ".csv".

        OUTPUT TO VALUE(c-arquivo) CONVERT SOURCE "ISO8859-1" TARGET "UTF-8".
        PUT "CFOP;TIPO;ESTADO;CONTRIBUINTE;ITEM;ORIGEM ITEM;NATUREZA" SKIP.

        FOR EACH prm-regras-integrador NO-LOCK
           WHERE prm-regras-integrador.cod-proj-int = prm-projeto-integrador.cod-proj-int:
            PUT prm-regras-integrador.cfop     ";"
                prm-regras-integrador.tipo      ";"
                prm-regras-integrador.estado           ";"
                STRING(prm-regras-integrador.ind-contribuinte,"Sim/Nao") ";" 
                prm-regras-integrador.it-codigo        ";"
                prm-regras-integrador.origem-item      ";"
                prm-regras-integrador.nat-operacao   ";"
                SKIP.
        END.
        OUTPUT CLOSE.

        MESSAGE "Arquivo gerado: " c-arquivo
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.


            
        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar V-table-Win
ON CHOOSE OF bt-importar IN FRAME f-main /* Importar */
DO:
    DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-linha   AS CHAR        NO-UNDO.

    EMPTY TEMP-TABLE tt-prm-regras-integrador.
    ASSIGN i-cont = 0.

    /* Solicita arquivo que ser† importado */
    SYSTEM-DIALOG GET-FILE c-arquivo
            TITLE      "Importar Dados"
            FILTERS    "Arquivos de texto (*.csv)" "*.csv"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.


    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(c-arquivo) NO-ECHO.
    REPEAT:
        IMPORT UNFORMATTED c-linha.
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        //IF i-cont = 1 THEN NEXT.
        IF ENTRY(1,c-linha,";") = "CFOP" THEN NEXT.

        CREATE tt-prm-regras-integrador.
        ASSIGN tt-prm-regras-integrador.cod-proj-int     = "ML"
               tt-prm-regras-integrador.cfop             = ENTRY(1,c-linha,";")
               tt-prm-regras-integrador.tipo             = ENTRY(2,c-linha,";")
               tt-prm-regras-integrador.estado           = ENTRY(3,c-linha,";")
               tt-prm-regras-integrador.ind-contribuinte = IF ENTRY(4,c-linha,";") = "Sim" THEN TRUE ELSE FALSE
               tt-prm-regras-integrador.it-codigo        = ENTRY(5,c-linha,";")
               tt-prm-regras-integrador.origem-item      = ENTRY(6,c-linha,";")
               tt-prm-regras-integrador.nat-operacao     = ENTRY(7,c-linha,";")
               tt-prm-regras-integrador.linha            = i-cont.
    END.
    INPUT CLOSE.

    FOR EACH tt-prm-regras-integrador:

        IF CAN-FIND(FIRST prm-regras-integrador NO-LOCK
                    WHERE prm-regras-integrador.cfop             = tt-prm-regras-integrador.cfop            
                      AND prm-regras-integrador.tipo             = tt-prm-regras-integrador.tipo            
                      AND prm-regras-integrador.estado           = tt-prm-regras-integrador.estado          
                      AND prm-regras-integrador.ind-contribuinte = tt-prm-regras-integrador.ind-contribuinte
                      AND prm-regras-integrador.it-codigo        = tt-prm-regras-integrador.it-codigo       
                      AND prm-regras-integrador.origem-item      = tt-prm-regras-integrador.origem-item     
                      AND prm-regras-integrador.nat-operacao     = tt-prm-regras-integrador.nat-operacao) THEN DO:
            FOR FIRST prm-regras-integrador EXCLUSIVE-LOCK
                WHERE prm-regras-integrador.cfop             = tt-prm-regras-integrador.cfop            
                      AND prm-regras-integrador.tipo             = tt-prm-regras-integrador.tipo            
                      AND prm-regras-integrador.estado           = tt-prm-regras-integrador.estado          
                      AND prm-regras-integrador.ind-contribuinte = tt-prm-regras-integrador.ind-contribuinte
                      AND prm-regras-integrador.it-codigo        = tt-prm-regras-integrador.it-codigo       
                      AND prm-regras-integrador.origem-item      = tt-prm-regras-integrador.origem-item     
                      AND prm-regras-integrador.nat-operacao     = tt-prm-regras-integrador.nat-operacao:
                ASSIGN prm-regras-integrador.nat-operacao        = tt-prm-regras-integrador.nat-operacao.
            END.
        END.
        ELSE DO:
            CREATE prm-regras-integrador.
            ASSIGN prm-regras-integrador.cod-proj-int     = tt-prm-regras-integrador.cod-proj-int
                   prm-regras-integrador.cfop             = tt-prm-regras-integrador.cfop             
                   prm-regras-integrador.tipo             = tt-prm-regras-integrador.tipo             
                   prm-regras-integrador.estado           = tt-prm-regras-integrador.estado           
                   prm-regras-integrador.ind-contribuinte = tt-prm-regras-integrador.ind-contribuinte 
                   prm-regras-integrador.it-codigo        = tt-prm-regras-integrador.it-codigo        
                   prm-regras-integrador.origem-item      = tt-prm-regras-integrador.origem-item      
                   prm-regras-integrador.nat-operacao     = tt-prm-regras-integrador.nat-operacao.
        END.
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RUN pi-carrega.

    /*
        IF  AVAIL prm-projeto-integrador
    AND ROWID(prm-projeto-integrador) <> ?
    THEN DO:
        
        FOR EACH prm-regras-integrador NO-LOCK
           WHERE prm-regras-integrador.cod-proj-int = prm-projeto-integrador.cod-proj-int:
            
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = prm-regras-integrador.it-codigo NO-ERROR.
    
            CREATE tt-prm-regras-integrador.
            BUFFER-COPY prm-regras-integrador TO tt-prm-regras-integrador.
            ASSIGN tt-prm-regras-integrador.desc-item = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
                   tt-prm-regras-integrador.r-rowid   = ROWID(prm-regras-integrador).
        END.
    END.



    /* Efetivaá∆o dos dados */
    /* N∆o busca o £ltimo registro criado, com as informaá‰es em branco! */
    FOR EACH  tt-crm-un-tb-preco EXCLUSIVE-LOCK
        WHERE tt-crm-un-tb-preco.linha < i-cont
        BY    tt-crm-un-tb-preco.linha:

        IF  tt-crm-un-tb-preco.cd-unid-negoc = "0" OR
            tt-crm-un-tb-preco.cd-unid-negoc = ""  THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Unidade Comercial n∆o informada."
                   rowErrors.ErrorHelp        = "C¢digo da Unidade Comercial deve ser informada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST unid-comerc NO-LOCK
                             WHERE unid-comerc.cd-unid-comerc = INT(tt-crm-un-tb-preco.cd-unid-negoc)) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Unidade Comercial inv†lida (" + tt-crm-un-tb-preco.cd-unid-negoc + ")!"
                       rowErrors.ErrorHelp        = "Unidade Comercial informada n∆o est† cadastrada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
                NEXT.
            END.
        END.

        IF  tt-crm-un-tb-preco.nr-tabpre = "" THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Tabela de Preáo n∆o informada."
                   rowErrors.ErrorHelp        = "Tabela de Preáo deve ser informada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST tb-preco NO-LOCK
                             WHERE tb-preco.nr-tabpre = tt-crm-un-tb-preco.nr-tabpre) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Tabela de Preáo inv†lida (" + tt-crm-un-tb-preco.nr-tabpre + ")!"
                       rowErrors.ErrorHelp        = "Tabela de Preáo informada n∆o est† cadastrada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
                NEXT.
            END.
        END.

        IF  tt-crm-un-tb-preco.dt-vigencia-ini = ? THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Vigància Inicial n∆o informada!"
                   rowErrors.ErrorHelp        = "Vigància Inicial deve ser informada! Linha: " + STRING(tt-crm-un-tb-preco.linha).
            NEXT.
        END.

        IF  CAN-FIND(FIRST crm-un-tb-preco NO-LOCK
                     WHERE crm-un-tb-preco.cd-unid-negoc = tt-crm-un-tb-preco.cd-unid-negoc
                     AND   crm-un-tb-preco.nr-tabpre     = tt-crm-un-tb-preco.nr-tabpre) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Relacionamento j† cadastrado!"
                   rowErrors.ErrorHelp        = "Relacionamento entre Unidade Comercial e Tabela de Preáo j† est† cadastrado! Linha: " + STRING(tt-crm-un-tb-preco.linha).
            NEXT.
        END.

        CREATE crm-un-tb-preco.
        BUFFER-COPY tt-crm-un-tb-preco TO crm-un-tb-preco.
    END.

    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Importaá∆o conclu°da!":U).
    END.

    RUN displayFields IN THIS-PROCEDURE.
    */

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir V-table-Win
ON CHOOSE OF bt-incluir IN FRAME f-main /* Incluir */
DO:
    IF  AVAIL prm-projeto-integrador
    AND ROWID(prm-projeto-integrador) <> ? THEN DO:

        RUN prmp/prm4103a.w(INPUT ?,
                            INPUT FALSE,
                            INPUT prm-projeto-integrador.cod-proj-int).

        RUN pi-carrega.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-layout V-table-Win
ON CHOOSE OF bt-layout IN FRAME f-main /* Layout */
DO:
    DEFINE BUTTON btLayoutFechar AUTO-END-KEY 
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE c-editor AS CHARACTER   NO-UNDO.

    ASSIGN c-editor = FILL("-",124)                         + CHR(13) +
                      FILL(" ",46) + "Layout de Importaá∆o" + CHR(13) +
                      FILL("-",124)                         + CHR(13) + CHR(13) +
                      "O arquivo com os dados deve seguir o padr∆o abaixo:" + CHR(13) +
                      "CFOP;TIPO;ESTADO;CONTRIBUINTE;ITEM;ORIGEM ITEM;NATUREZA;" + CHR(13) + CHR(13) +
                      "5105;Venda;*;*;*;*;510501;" + CHR(13) +
                      "6105;Venda;MG;Sim;4013330;*;610504;" + CHR(13).
    
    DEFINE FRAME fLayout
        c-editor        AT ROW 1.21 COL 1 COLON-ALIGNED VIEW-AS EDITOR SIZE 54 BY 6.5 NO-LABEL
        btLayoutFechar  AT ROW 8.03 COL 2
        rtGoToButton    AT ROW 7.78 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Layout de Importaá∆o" FONT 1
              DEFAULT-BUTTON btLayoutFechar.

    DISPLAY c-editor
        WITH FRAME fLayout.

    ENABLE btLayoutFechar
        WITH FRAME fLayout. 
    
    WAIT-FOR "GO":U OF FRAME fLayout.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar V-table-Win
ON CHOOSE OF bt-modificar IN FRAME f-main /* Modificar */
DO:
    IF  AVAIL tt-prm-regras-integrador 
    AND AVAIL prm-projeto-integrador
    AND ROWID(prm-projeto-integrador) <> ? THEN DO:

        RUN prmp/prm4103a.w(INPUT tt-prm-regras-integrador.r-rowid,
                            INPUT FALSE,
                            INPUT prm-projeto-integrador.cod-proj-int).

        RUN pi-carrega.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "prm-projeto-integrador"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "prm-projeto-integrador"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    IF adm-new-record = YES THEN DO:
        IF  AVAIL prm-projeto-integrador
        AND ROWID(prm-projeto-integrador) <> ?
        THEN DO:

            FOR EACH prm-regras-integrador EXCLUSIVE-LOCK
               WHERE prm-regras-integrador.cod-proj-int = prm-projeto-integrador.cod-proj-int:
                DELETE prm-regras-integrador.
            END.

            RELEASE prm-regras-integrador.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    IF  AVAIL prm-projeto-integrador
    AND ROWID(prm-projeto-integrador) <> ?
    THEN DO:
        ASSIGN bt-incluir     :SENSITIVE IN FRAME {&FRAME-NAME} = TRUE  
               bt-modificar   :SENSITIVE IN FRAME {&FRAME-NAME} = TRUE  
               bt-eliminar    :SENSITIVE IN FRAME {&FRAME-NAME} = TRUE  
               bt-copiar-regra:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
        
        RUN pi-carrega.
    END.
    ELSE DO:
        ASSIGN bt-incluir     :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE  
               bt-modificar   :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE  
               bt-eliminar    :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE  
               bt-copiar-regra:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes THEN
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF adm-new-record = YES THEN DO:

        ASSIGN bt-incluir     :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
               bt-modificar   :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
               bt-eliminar    :SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
               bt-copiar-regra:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.

        EMPTY TEMP-TABLE tt-prm-regras-integrador.
        {&OPEN-QUERY-br-regras}
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega V-table-Win 
PROCEDURE pi-carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-prm-regras-integrador.

    IF  AVAIL prm-projeto-integrador
    AND ROWID(prm-projeto-integrador) <> ?
    THEN DO:
        
        FOR EACH prm-regras-integrador NO-LOCK
           WHERE prm-regras-integrador.cod-proj-int = prm-projeto-integrador.cod-proj-int:
            
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = prm-regras-integrador.it-codigo NO-ERROR.
    
            CREATE tt-prm-regras-integrador.
            BUFFER-COPY prm-regras-integrador TO tt-prm-regras-integrador.
            ASSIGN tt-prm-regras-integrador.desc-item = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
                   tt-prm-regras-integrador.r-rowid   = ROWID(prm-regras-integrador).
        END.
    END.

    {&OPEN-QUERY-br-regras}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */
    
/*:T    Segue um exemplo de validaá∆o de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "prm-projeto-integrador"}
  {src/adm/template/snd-list.i "tt-prm-regras-integrador"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

