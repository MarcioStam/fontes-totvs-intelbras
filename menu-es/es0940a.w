&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

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


DEF INPUT PARAMETER i-mes AS INT.
DEF INPUT PARAMETER i-ano AS INT.
DEF INPUT PARAMETER c-conta AS CHAR.
DEF INPUT PARAMETER c-cc-codigo AS CHAR.


/*
DEF VAR i-mes AS INT INITIAL 1.            
DEF VAR i-ano AS INT INITIAL 2006.
DEF VAR c-conta AS CHAR INITIAL "41510020".
DEF VAR c-cc-codigo AS CHAR INITIAL "00112100".
  */



DEF VAR c-conta-contabil AS CHAR.

DEF VAR da-data-ini AS DATE.
DEF VAR da-data-fim AS DATE.
DEF VAR i-data AS DATE.

DEF TEMP-TABLE tt-estoque
    FIELD dt-trans LIKE movto-estoq.dt-trans
    FIELD valor-mat AS DEC
    FIELD descricao AS CHAR FORMAT "x(60)"
    INDEX data IS PRIMARY dt-trans.

DEF TEMP-TABLE tt-dados
    FIELD cod_estab                     AS CHAR FORMAT "x(03)"
    FIELD origem                        AS CHAR FORMAT "x(3)"
    FIELD ind_natur_lancto_ctbl         AS CHAR FORMAT "X(3)"
    FIELD cod_emitente                  AS INT FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente                 AS CHAR FORMAT "X(40)"
    FIELD dt_transacao                  AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto               AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto                 AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap                    AS CHAR FORMAT "x(10)"
    FIELD cod_parcela                   AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl                AS DEC FORMAT ">>>,>>>,>>9.99".

DEF TEMP-TABLE tt-dados-aux
    FIELD origem                        AS CHAR FORMAT "x(3)"
    FIELD ind_natur_lancto_ctbl         AS CHAR FORMAT "X(3)"
    FIELD cod_emitente                  AS INT FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente                 AS CHAR FORMAT "X(40)"
    FIELD dt_transacao                  AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto               AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto                 AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap                    AS CHAR FORMAT "x(10)"
    FIELD cod_parcela                   AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl                AS DEC FORMAT ">>>,>>>,>>9.99".

{esp/es0018.i}

/* tt-dados para as informaá‰es da movto-estoq */
DEFINE TEMP-TABLE tt-dados-cep NO-UNDO LIKE tt-dados.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-dados

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-dados.cod_estab tt-dados.origem tt-dados.ind_natur_lancto_ctbl tt-dados.cod_emitente tt-dados.nome_emitente tt-dados.dt_transacao tt-dados.cod_espec_docto tt-dados.cod_ser_docto tt-dados.cod_tit_ap tt-dados.cod_parcela tt-dados.val_aprop_ctbl   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4   
&Scoped-define SELF-NAME BROWSE-4
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-dados
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY {&SELF-NAME} FOR EACH tt-dados.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-dados
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-dados


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-8 RECT-9 BROWSE-4 Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS de-tot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE de-tot AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Valor Total Atualizado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 3.77.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 4.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 4.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      tt-dados SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 gDialog _FREEFORM
  QUERY BROWSE-4 DISPLAY
      tt-dados.cod_estab      LABEL "EST"
     tt-dados.origem         LABEL "ORIGEM"                
     tt-dados.ind_natur_lancto_ctbl LABEL "E/S"  
     tt-dados.cod_emitente    LABEL "CODIGO"        
     tt-dados.nome_emitente   LABEL "FORNECEDOR"        
     tt-dados.dt_transacao    LABEL "DATA"        
     tt-dados.cod_espec_docto LABEL "ESP"        
     tt-dados.cod_ser_docto   LABEL "SER"        
     tt-dados.cod_tit_ap      LABEL "DOCTO"        
     tt-dados.cod_parcela     LABEL "P"        
     tt-dados.val_aprop_ctbl  LABEL "VALOR"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 114 BY 10.5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     de-tot AT ROW 1.5 COL 100 COLON-ALIGNED
     BROWSE-4 AT ROW 3 COL 2
     Btn_OK AT ROW 16.77 COL 101
     "** N∆o detalha Folha de Pagamento" VIEW-AS TEXT
          SIZE 33 BY .67 AT ROW 16.77 COL 3
     "E/S" VIEW-AS TEXT
          SIZE 5 BY .67 AT ROW 13.77 COL 39
     "DB = DêBITO" VIEW-AS TEXT
          SIZE 14 BY .67 AT ROW 15 COL 39
     "CR = CRêDITO" VIEW-AS TEXT
          SIZE 14 BY .67 AT ROW 16.27 COL 39
     "ACR = CONTAS A RECEBER" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 16 COL 6
     "APB = CONTAS A PAGAR" VIEW-AS TEXT
          SIZE 25 BY .67 AT ROW 15.27 COL 6
     "CEP = ESTOQUE" VIEW-AS TEXT
          SIZE 23 BY .67 AT ROW 14.5 COL 6
     "Verifique abaixo detalhes dos movimentos" VIEW-AS TEXT
          SIZE 42 BY .67 AT ROW 1.77 COL 3
     "Outros" VIEW-AS TEXT
          SIZE 7 BY .67 AT ROW 13.77 COL 56
     "SER = SêRIE" VIEW-AS TEXT
          SIZE 17 BY .67 AT ROW 14.5 COL 60
     "ESP = ESPêCIE" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 15.5 COL 60
     "P = PARCELA" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 16.5 COL 60
     "Origem" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 13.77 COL 2
     RECT-7 AT ROW 14 COL 2
     RECT-8 AT ROW 14 COL 38
     RECT-9 AT ROW 14 COL 55
     SPACE(16.99) SKIP(0.16)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "es0940a - Detalhamento de Movimentos"
         DEFAULT-BUTTON Btn_OK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-4 de-tot gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN de-tot IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-dados.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* es0940a - Detalhamento de Movimentos */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

   EMPTY TEMP-TABLE tt-estoque.
   EMPTY TEMP-TABLE tt-dados.

   ASSIGN da-data-ini = DATE("1" + "/" + STRING(i-mes) + "/" + STRING(i-ano))
          da-data-fim = da-data-ini + 30.

   DO WHILE MONTH(da-data-fim) <> MONTH(da-data-ini):
       ASSIGN da-data-fim = da-data-fim - 1.
   END.

   FIND FIRST centro-custo NO-LOCK
        WHERE centro-custo.cc-codigo = c-cc-codigo NO-ERROR.
   IF  AVAIL centro-custo THEN DO:

        ASSIGN c-conta-contabil = c-conta + centro-custo.cc-codigo.
        
        FOR EACH estabelecimento NO-LOCK
            WHERE estabelecimento.cod_empresa = '1':

            IF estabelecimento.cod_estab = '102' 
               THEN NEXT.

            RUN  menu-es\es0940aa.p (INPUT estabelecimento.cod_estab,
                                     INPUT "padrao",
                                     INPUT c-conta,
                                     INPUT centro-custo.cc-codigo,
                                     INPUT da-data-ini,
                                     INPUT da-data-fim,
                                     OUTPUT TABLE tt-dados-aux).     
            FOR EACH tt-dados-aux.
                CREATE tt-dados.
                ASSIGN tt-dados.cod_estab             =  estabelecimento.cod_estab
                       tt-dados.origem                =  tt-dados-aux.origem               
                       tt-dados.ind_natur_lancto_ctbl =  tt-dados-aux.ind_natur_lancto_ctbl
                       tt-dados.cod_emitente          =  tt-dados-aux.cod_emitente         
                       tt-dados.nome_emitente         =  tt-dados-aux.nome_emitente        
                       tt-dados.dt_transacao          =  tt-dados-aux.dt_transacao         
                       tt-dados.cod_espec_docto       =  tt-dados-aux.cod_espec_docto      
                       tt-dados.cod_ser_docto         =  tt-dados-aux.cod_ser_docto        
                       tt-dados.cod_tit_ap            =  tt-dados-aux.cod_tit_ap           
                       tt-dados.cod_parcela           =  tt-dados-aux.cod_parcela          
                       tt-dados.val_aprop_ctbl        =  tt-dados-aux.val_aprop_ctbl.
            END.
        END.

        RUN pi-estoque.
   END.

   FOR EACH tt-dados:
       IF tt-dados.ind_natur_lancto_ctbl = "DB" THEN
            ASSIGN de-tot = de-tot + tt-dados.val_aprop_ctbl.
       ELSE
            ASSIGN de-tot = de-tot - tt-dados.val_aprop_ctbl.
   END.

   ASSIGN de-tot:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(de-tot,"->>,>>>,>>9.99").

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY de-tot 
      WITH FRAME gDialog.
  ENABLE RECT-7 RECT-8 RECT-9 BROWSE-4 Btn_OK 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estoque gDialog 
PROCEDURE pi-estoque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-serv    AS HANDLE                    NO-UNDO.
    DEFINE VARIABLE c-connect LIKE servid_rpc.des_carg_rpc NO-UNDO.
    DEFINE VARIABLE dt-inicio AS DATE                      NO-UNDO.
    DEFINE VARIABLE dt-fim    AS DATE                      NO-UNDO.


    /* Monta a data inicial e final do periodo recebido como parametro */
    ASSIGN dt-inicio = DATE(i-mes, 01, i-ano)
           dt-fim    = ADD-INTERVAL(dt-inicio, 1, "month")
           dt-fim    = dt-fim - 1.


    /* Busca as informaá‰es para conectar o servidor RPC */
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "ambiente":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST tt-prog-ponto NO-ERROR.
    IF  AVAILABLE tt-prog-ponto               AND
        tt-prog-ponto.conteudo = "PRODUCAO":U THEN DO:
        FIND FIRST servid_rpc NO-LOCK
            WHERE  servid_rpc.des_servid_rpc MATCHES "*produ*"
            AND    servid_rpc.log_servid_rpc_dispon = TRUE NO-ERROR.
        IF  AVAIL  servid_rpc THEN
            ASSIGN c-connect = TRIM(servid_rpc.des_carg_rpc).
    END.
    ELSE DO:
        FIND FIRST servid_rpc NO-LOCK
            WHERE  servid_rpc.des_servid_rpc MATCHES "*teste*"
            AND    servid_rpc.log_servid_rpc_dispon = TRUE NO-ERROR.
        IF  AVAIL  servid_rpc THEN
            ASSIGN c-connect = TRIM(servid_rpc.des_carg_rpc).
    END.
    
    IF  c-connect = "" THEN DO:
        MESSAGE "N∆o existe servidor RPC cadastrado. Processo interrompido."
            VIEW-AS ALERT-BOX ERROR TITLE "Erro RPC".
        RETURN "NOK":U.
    END.


    /* Faz a conex∆o com o servidor RPC */
    CREATE SERVER h-serv.
    h-serv:CONNECT(c-connect).

    IF  NOT h-serv:CONNECTED() THEN DO:
        MESSAGE "Servidor RPC n∆o est† conectado. Processo interrompido."
            VIEW-AS ALERT-BOX ERROR TITLE "Erro RPC".

        RETURN "NOK":U.
    END.

    EMPTY TEMP-TABLE tt-dados-cep.
    RUN menu-es/es0940ab.p ON SERVER h-serv (INPUT  dt-inicio,
                                             INPUT  dt-fim,
                                             INPUT  c-conta,
                                             INPUT  c-cc-codigo,
                                             OUTPUT TABLE tt-dados-cep).

    FOR EACH tt-dados-cep NO-LOCK:
        CREATE tt-dados.
        BUFFER-COPY tt-dados-cep TO tt-dados.
    END.

    h-serv:DISCONNECT().

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

