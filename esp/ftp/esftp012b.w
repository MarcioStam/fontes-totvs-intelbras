&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttit-ped-fiscal NO-UNDO LIKE it-ped-fiscal
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttped-fiscal NO-UNDO LIKE ped-fiscal
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp012b 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           esftp012b
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            
&GLOBAL-DEFINE InitialPage       

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           ttIt-ped-fiscal
&GLOBAL-DEFINE hDBOTable         hDBOIt-ped-fiscal
&GLOBAL-DEFINE DBOTable          mgesp.it-ped-fiscal

&GLOBAL-DEFINE ttParent          ttPed-fiscal
&GLOBAL-DEFINE DBOParentTable    mgesp.ped-fiscal

&GLOBAL-DEFINE page0KeyFields    ttIt-ped-fiscal.seq ttIt-ped-fiscal.it-codigo
&GLOBAL-DEFINE page0Fields       ttIt-ped-fiscal.qtde ttIt-ped-fiscal.aliquota-ipi ttIt-ped-fiscal.cod-depos ttIt-ped-fiscal.cod-localizacao ttIt-ped-fiscal.vl-unit ttIt-ped-fiscal.narrativa ttIt-ped-fiscal.peso-bru-item ttit-ped-fiscal.peso-liq-item c-class-fiscal fi-conta-pat fi-bem-pat fi-seq-pat 
&GLOBAL-DEFINE page0ParentFields ttPed-fiscal.nr-pedido
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
def var de-qtde-antes as decimal.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}    AS HANDLE       NO-UNDO.

DEF VAR wh-pesquisa         AS HANDLE                           NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE         NO-UNDO.
DEF VAR l-aloca-estoque     AS LOG INIT NO                      NO-UNDO.
DEF VAR de-menor-valor-item AS DEC                              NO-UNDO.
DEF VAR de-sdo-liq-bem      LIKE sdo_bem_pat.val_dpr_val_origin NO-UNDO.
DEFINE TEMP-TABLE tt-erro-aloc  NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

{upc\btb910za-upc.i}

{cdp/cd0666.i}          /* Definicao da temp-table de erros */
DEF VAR p-qtd-total      LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEF VAR p-qtd-disp       LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEF VAR p-qtd-bloq       LIKE wm-saldo-estoque.qtd-atual     NO-UNDO.
DEF VAR l-ok             AS LOGICAL   INIT NO  NO-UNDO.
DEFINE VARIABLE de-saldo AS DECIMAL     NO-UNDO.

DEF VAR i AS INTEGER NO-UNDO.
DEF VAR de-fator AS DEC DECIMALS 4 NO-UNDO.
DEF VAR c-cliente AS CHAR NO-UNDO.
DEF VAR c-origem  AS CHAR NO-UNDO.
DEF VAR l-inf-narrativa AS LOG NO-UNDO.

def new global shared var v_rec_cta_pat as RECID format ">>>>>>9" initial ? no-undo.
def new global shared var v_rec_bem_pat as RECID format ">>>>>>9" initial ? no-undo.
{esp/es0018.i}

DEF TEMP-TABLE tt-fator
    FIELD emitente AS INTEGER 
    FIELD origem   AS CHAR
    FIELD fator    AS DEC DECIMALS 4.

EMPTY TEMP-TABLE tt-fator.

RUN esp/es0018p.p (INPUT "esftp012", /* Nome do programa */
                   INPUT 5,          /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FOR EACH tt-prog-ponto:

    DO  i = 1 TO NUM-ENTRIES(tt-prog-ponto.conteudo, ";"):

       /* IF  i = 1  THEN
            ASSIGN de-fator = dec(ENTRY(i, tt-prog-ponto.conteudo, ";")).
        ELSE DO:
            CREATE tt-fator.
            ASSIGN tt-fator.emitente = INT(ENTRY(i, tt-prog-ponto.conteudo, ";"))
                   tt-fator.fator    = de-fator.
        END. */


        IF i = 1 THEN
           ASSIGN de-fator = dec(ENTRY(i, tt-prog-ponto.conteudo, ";")).
        ELSE DO:
            IF i = 2 THEN
                ASSIGN c-cliente = ENTRY(i, tt-prog-ponto.conteudo, ";").
            ELSE
                ASSIGN c-origem  = ENTRY(i, tt-prog-ponto.conteudo, ";").
        END.

    END.

    RUN pi-cria-tt(INPUT de-fator,
                   INPUT c-cliente,
                   INPUT c-origem).

END.


/*
OUTPUT TO v:\ti\marcio\fator.txt.
FOR EACH tt-fator:
    DISP tt-fator WITH WIDTH 300.
END.
OUTPUT CLOSE.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttped-fiscal.nr-pedido ttit-ped-fiscal.seq ~
ttit-ped-fiscal.it-codigo ttit-ped-fiscal.un ttit-ped-fiscal.qtde ~
ttit-ped-fiscal.aliquota-ipi ttit-ped-fiscal.peso-liq-item ~
ttit-ped-fiscal.vl-unit ttit-ped-fiscal.peso-bru-item ~
ttit-ped-fiscal.cod-depos ttit-ped-fiscal.cod-localizacao ~
ttit-ped-fiscal.narrativa 
&Scoped-define ENABLED-TABLES ttped-fiscal ttit-ped-fiscal
&Scoped-define FIRST-ENABLED-TABLE ttped-fiscal
&Scoped-define SECOND-ENABLED-TABLE ttit-ped-fiscal
&Scoped-Define ENABLED-OBJECTS RECT-4 rtKeys rtToolBar cDesc-item ~
c-class-fiscal fi-conta-pat fi-bem-pat fi-seq-pat btOK btSave btCancel ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS ttped-fiscal.nr-pedido ttit-ped-fiscal.seq ~
ttit-ped-fiscal.it-codigo ttit-ped-fiscal.un ttit-ped-fiscal.qtde ~
ttit-ped-fiscal.aliquota-ipi ttit-ped-fiscal.peso-liq-item ~
ttit-ped-fiscal.vl-unit ttit-ped-fiscal.peso-bru-item ~
ttit-ped-fiscal.cod-depos ttit-ped-fiscal.cod-localizacao ~
ttit-ped-fiscal.narrativa 
&Scoped-define DISPLAYED-TABLES ttped-fiscal ttit-ped-fiscal
&Scoped-define FIRST-DISPLAYED-TABLE ttped-fiscal
&Scoped-define SECOND-DISPLAYED-TABLE ttit-ped-fiscal
&Scoped-Define DISPLAYED-OBJECTS cDesc-item c-class-fiscal fi-conta-pat ~
fi-bem-pat fi-seq-pat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-class-fiscal AS CHARACTER FORMAT "x(10)":U 
     LABEL "Classificaá∆o Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE cDesc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-bem-pat AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Bem Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE fi-conta-pat AS CHARACTER FORMAT "x(18)" 
     LABEL "Conta Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE fi-seq-pat AS INTEGER FORMAT ">>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 7.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttped-fiscal.nr-pedido AT ROW 1.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttit-ped-fiscal.seq AT ROW 2.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     ttit-ped-fiscal.it-codigo AT ROW 3.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.29 BY .88
     cDesc-item AT ROW 3.5 COL 42 COLON-ALIGNED NO-LABEL
     ttit-ped-fiscal.un AT ROW 3.5 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     ttit-ped-fiscal.qtde AT ROW 5.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .88
     c-class-fiscal AT ROW 5.5 COL 60 COLON-ALIGNED WIDGET-ID 2
     ttit-ped-fiscal.aliquota-ipi AT ROW 6.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .88
     ttit-ped-fiscal.peso-liq-item AT ROW 6.5 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttit-ped-fiscal.vl-unit AT ROW 7.5 COL 27 COLON-ALIGNED FORMAT "->>>>>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttit-ped-fiscal.peso-bru-item AT ROW 7.5 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttit-ped-fiscal.cod-depos AT ROW 8.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     ttit-ped-fiscal.cod-localizacao AT ROW 8.5 COL 60 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttit-ped-fiscal.narrativa AT ROW 9.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     fi-conta-pat AT ROW 10.5 COL 27 COLON-ALIGNED WIDGET-ID 14
     fi-bem-pat AT ROW 11.5 COL 27 COLON-ALIGNED WIDGET-ID 16
     fi-seq-pat AT ROW 11.5 COL 38.43 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     btOK AT ROW 13 COL 2
     btSave AT ROW 13 COL 13
     btCancel AT ROW 13 COL 25
     btHelp AT ROW 13 COL 80
     RECT-4 AT ROW 5.25 COL 1
     rtKeys AT ROW 1.25 COL 1
     rtToolBar AT ROW 12.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 13.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttit-ped-fiscal T "?" NO-UNDO mgesp it-ped-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttped-fiscal T "?" NO-UNDO mgesp ped-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 13.5
         WIDTH              = 90.43
         MAX-HEIGHT         = 37.75
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 37.75
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttit-ped-fiscal.vl-unit IN FRAME fpage0
   EXP-FORMAT                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    DO TRANS:
        DEFINE VARIABLE l-ok AS LOGICAL    NO-UNDO.
        RUN piValidaInclusao(OUTPUT l-ok).
        IF NOT l-ok THEN RETURN NO-APPLY.

        IF l-inf-narrativa THEN DO:
            IF ttit-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:

               RUN utp/ut-msgs.p (INPUT "show":U,
                                  INPUT 17006,
                                  INPUT "Para o item":U 
                                         + " " + ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
                                         " o campo narrativa~~ê necessario informar o nome do item e o codigo similar do produto no estoque. EX: 4123130 Telefone TS 3130":U).
               APPLY "entry":U TO ttit-ped-fiscal.narrativa.
               RETURN NO-APPLY.
            END.

            IF length(ttit-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME {&FRAME-NAME}) < 7 THEN DO:

               RUN utp/ut-msgs.p (INPUT "show":U,
                                  INPUT 17006,
                                  INPUT "Narrativa nao pode ser menor que 7 caracteres").
               APPLY "entry":U TO ttit-ped-fiscal.narrativa.
               RETURN NO-APPLY.
            END.
        END.
        
        /* Chamado 22351 -> identificar menor valor unit†rio aceit†vel para o item. Nota fiscal exige que o total do item seja no m°nimo 0,01 */
        IF  ttit-ped-fiscal.vl-unit:SENSITIVE IN FRAME {&FRAME-NAME} = NO 
        AND INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.qtde          <> 0 
        AND INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.qtde * INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.vl-unit < 0.01 THEN DO:
            RUN pi-menor-valor-item (INPUT  INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.qtde,
                                     OUTPUT de-menor-valor-item).

            ASSIGN ttit-ped-fiscal.vl-unit = de-menor-valor-item.

            DISP ttit-ped-fiscal.vl-unit WITH FRAME {&FRAME-NAME}.
        END.
        
        RUN saveRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK" THEN DO:
            ASSIGN ttit-ped-fiscal.vl-unit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
            APPLY "LEAVE":U TO ttit-ped-fiscal.it-codigo.
            UNDO, LEAVE.
        END.
    
        IF RETURN-VALUE = "OK":U THEN
            APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO :

    DO TRANS:
        DEFINE VARIABLE l-ok AS LOGICAL    NO-UNDO.
        RUN piValidaInclusao(OUTPUT l-ok).
        IF NOT l-ok THEN RETURN NO-APPLY.
    
        RUN saveRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK" THEN DO:
            UNDO, LEAVE.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-fiscal wMaintenanceNoNavigation
ON F5 OF c-class-fiscal IN FRAME fpage0 /* Classificaá∆o Fiscal */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in046.w
                        &campo=c-class-fiscal
                        &campozoom=class-fiscal}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-fiscal wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF c-class-fiscal IN FRAME fpage0 /* Classificaá∆o Fiscal */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttit-ped-fiscal.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttit-ped-fiscal.cod-depos wMaintenanceNoNavigation
ON LEAVE OF ttit-ped-fiscal.cod-depos IN FRAME fpage0 /* Deposito */
DO:

/*     FIND FIRST deposito WHERE deposito.cod-depos = ttit-ped-fiscal.cod-depos:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR. */
/*     IF AVAIL deposito AND deposito.alocado = NO THEN DO:                                                                    */
/*         RUN utp/ut-msgs.p (INPUT "show":U,                                                                                  */
/*                                INPUT 17567,                                                                                 */
/*                                INPUT "Deposito Invalido!":U + "~~" +                                                        */
/*                                      "Deposito informado nao permite Alocacao, verifique atraves do programa cd0601":U).    */
/*         APPLY "ENTRY" TO ttit-ped-fiscal.cod-depos IN FRAME fPage0.                                                         */
/*         RETURN NO-APPLY.                                                                                                    */
/*     END.                                                                                                                    */

    for first mgesp.ponto-programa
      where ponto-programa.nome-programa = "esftp012b"
        AND ponto-programa.ponto         = 1,
       EACH mgesp.conteudo-programa NO-LOCK
      WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        IF STRING(ENTRY(1,conteudo-programa.conteudo,",")) = ttIt-ped-fiscal.cod-depos:SCREEN-VALUE IN FRAME fpage0 AND
           STRING(ENTRY(2,conteudo-programa.conteudo,",")) = v_cod_usuar_corren THEN DO:
            ASSIGN ttIt-ped-fiscal.cod-localizacao:SENSITIVE = YES.
            APPLY "ENTRY" TO ttIt-ped-fiscal.cod-localizacao IN FRAME fPage0.
            RETURN NO-APPLY.

        END.
        ELSE 
            ASSIGN ttIt-ped-fiscal.cod-localizacao:SENSITIVE = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-bem-pat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-bem-pat wMaintenanceNoNavigation
ON F5 OF fi-bem-pat IN FRAME fpage0 /* Bem Patrimonial */
DO:
    v_rec_bem_pat = ?.
    run prgfin/fas/fas701ka.p /*prg_sea_bem_pat*/.

    FIND bem_pat 
        WHERE RECID(bem_pat) = v_rec_bem_pat NO-LOCK NO-ERROR.
    IF  AVAIL bem_pat THEN
        ASSIGN fi-conta-pat:SCREEN-VALUE IN FRAME fpage0 = bem_pat.cod_cta_pat
               fi-bem-pat:SCREEN-VALUE IN FRAME fpage0   = string(bem_pat.num_bem_pat)
               fi-seq-pat:SCREEN-VALUE IN FRAME fpage0   = string(bem_pat.num_seq_bem_pat).
    ELSE
        ASSIGN fi-conta-pat:SCREEN-VALUE IN FRAME fpage0 = ""
               fi-bem-pat:SCREEN-VALUE IN FRAME fpage0   = "0"
               fi-seq-pat:SCREEN-VALUE IN FRAME fpage0   = "0".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-bem-pat wMaintenanceNoNavigation
ON LEAVE OF fi-bem-pat IN FRAME fpage0 /* Bem Patrimonial */
DO:

    RUN pi-leave-bem.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-bem-pat wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-bem-pat IN FRAME fpage0 /* Bem Patrimonial */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-conta-pat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-pat wMaintenanceNoNavigation
ON F5 OF fi-conta-pat IN FRAME fpage0 /* Conta Patrimonial */
DO:
   
    run prgfin/fas/fas011ka.p.

    find cta_pat where recid(cta_pat) = v_rec_cta_pat no-lock no-error.
    IF  AVAIL cta_pat THEN
        fi-conta-pat:SCREEN-VALUE IN FRAME fpage0 = cta_pat.cod_cta_pat.
    ELSE
        fi-conta-pat:SCREEN-VALUE IN FRAME fpage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-pat wMaintenanceNoNavigation
ON LEAVE OF fi-conta-pat IN FRAME fpage0 /* Conta Patrimonial */
DO:

    RUN pi-leave-bem.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-pat wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-conta-pat IN FRAME fpage0 /* Conta Patrimonial */
DO:
     APPLY "f5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-seq-pat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-seq-pat wMaintenanceNoNavigation
ON LEAVE OF fi-seq-pat IN FRAME fpage0
DO:

    RUN pi-leave-bem.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttit-ped-fiscal.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttit-ped-fiscal.it-codigo wMaintenanceNoNavigation
ON F5 OF ttit-ped-fiscal.it-codigo IN FRAME fpage0 /* Item */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                        &campo=ttIt-ped-fiscal.it-codigo
                        &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttit-ped-fiscal.it-codigo wMaintenanceNoNavigation
ON LEAVE OF ttit-ped-fiscal.it-codigo IN FRAME fpage0 /* Item */
DO:

    FIND natureza-ped-fiscal NO-LOCK
        WHERE natureza-ped-fiscal.natureza = INT(ttped-fiscal.nat-oper) NO-ERROR.
    
    FIND ITEM NO-LOCK WHERE ITEM.it-codigo = INPUT FRAME {&FRAME-NAME} ttIt-ped-fiscal.it-codigo NO-ERROR.

    FIND FIRST it-natureza-ped-fiscal
        WHERE it-natureza-ped-fiscal.natureza  = ttped-fiscal.nat-oper
          AND it-natureza-ped-fiscal.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF NOT AVAIL it-natureza-ped-fiscal AND ITEM.tipo-contr = 4 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Item Invalido!":U + "~~" +
                                     "Item " + ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
                                     " n∆o vinculado com a natureza " + string(ttped-fiscal.nat-oper) + ". Entrar em contato com o Grupo Fiscal.":U).
        APPLY "ENTRY" TO ttit-ped-fiscal.it-codigo IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.


    IF  pcAction = "ADD" OR pcAction = "COPY" THEN DO:
        ASSIGN cDesc-item               = ''
               ttIt-ped-fiscal.un       = ''
               ttIt-ped-fiscal.vl-unit  = 0.
        
        IF NOT AVAIL ITEM THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Item Invalido!":U + "~~" +
                                         "Item nao cadastrado no CD0204.":U).
            APPLY "ENTRY" TO ttit-ped-fiscal.it-codigo IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.

        IF AVAILABLE ITEM THEN DO:
            ASSIGN cDesc-item           = ITEM.desc-item
                   ttIt-ped-fiscal.un   = ITEM.un
                   ttIt-ped-fiscal.peso-liq-item:SCREEN-VALUE = STRING(ITEM.peso-liquido)
                   ttIt-ped-fiscal.peso-bru-item:SCREEN-VALUE = STRING(ITEM.peso-bruto)
                   ttit-ped-fiscal.aliquota-ipi:screen-value = string(ITEM.aliquota-ipi).

            FIND FIRST it-natureza-ped-fiscal
                 WHERE it-natureza-ped-fiscal.natureza  = ttped-fiscal.nat-oper
                   AND it-natureza-ped-fiscal.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.

            IF AVAIL it-natureza-ped-fiscal THEN DO:
                IF it-natureza-ped-fiscal.log-sugere-ncm THEN DO:
                    ASSIGN c-class-fiscal:screen-value in frame fpage0      = item.class-fiscal.
                    disable c-class-fiscal WITH FRAME fpage0.
                END.
                ELSE DO:
                    ASSIGN c-class-fiscal:screen-value in frame fpage0 = "".
                    ENABLE c-class-fiscal WITH FRAME fpage0.
                END.
    
                /*IF ITEM.tipo-contr = 4 THEN
                    ENABLE c-class-fiscal with FRAME fpage0.
                ELSE
                    disable c-class-fiscal with FRAME fpage0.*/
            END.
            ELSE DO:
                ASSIGN c-class-fiscal:screen-value in frame fpage0      = item.class-fiscal.
                disable c-class-fiscal WITH FRAME fpage0.
            END.

            FIND item-estab NO-LOCK 
                 WHERE item-estab.it-codigo = ITEM.it-codigo 
                   AND item-estab.cod-estabel = ttPed-fiscal.cod-estabel NO-ERROR.
            IF AVAILABLE item-estab THEN DO:
                ASSIGN ttIt-ped-fiscal.vl-unit  = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]. 
            END.
            IF not AVAILABLE item-estab or
                ttIt-ped-fiscal.vl-unit = 0 THEN DO:
                FIND FIRST item-estab NO-LOCK 
                     WHERE item-estab.it-codigo = ITEM.it-codigo 
                       AND item-estab.cod-estabel <> ttPed-fiscal.cod-estabel
                        AND (item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]) > 0 NO-ERROR.
                 IF AVAILABLE item-estab THEN DO:
                    ASSIGN ttIt-ped-fiscal.vl-unit  = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]. 
                 END.
       
            END.
            IF  AVAIL natureza-ped-fiscal AND natureza-ped-fiscal.Ind-nat-transf 
            OR ttped-fiscal.nat-oper = 32 THEN DO:
               IF ttIt-ped-fiscal.vl-unit = 0 THEN DO:
                  ASSIGN ttIt-ped-fiscal.vl-unit = ITEM.preco-ul-ent.  
               END.
            END.
            
            IF   ttIt-ped-fiscal.vl-unit > 0
            AND (ttped-fiscal.nat-oper = 35
              OR ttped-fiscal.nat-oper = 08) THEN DO:
                FIND FIRST tt-fator
                     WHERE tt-fator.emitente = ttped-fiscal.cod-emitente
                       AND tt-fator.origem   = STRING(ITEM.codigo-orig) NO-ERROR.
                IF AVAIL tt-fator THEN
                    ASSIGN ttIt-ped-fiscal.vl-unit = ttIt-ped-fiscal.vl-unit / tt-fator.fator.  
            END.
            IF ttIt-ped-fiscal.vl-unit = 0  THEN DO:
                FOR EACH preco-item NO-LOCK
                    WHERE preco-item.it-codigo = ITEM.it-codigo
                      AND preco-item.nr-tabpre = "Minimo"
                      AND preco-item.situacao = 1
                      AND preco-item.dt-inival <= TODAY,
                    FIRST tb-preco NO-LOCK
                    WHERE tb-preco.nr-tabpre = preco-item.nr-tabpre
                      AND tb-preco.situacao = 1
                      AND tb-preco.dt-inival <= TODAY
                      AND tb-preco.dt-fimval >= TODAY
                    BREAK BY preco-item.preco-venda:
                    ASSIGN ttIt-ped-fiscal.vl-unit = preco-item.preco-venda.
                    LEAVE.
                END.
            END.
            if ttped-fiscal.nat-oper = 8 OR 
               ttped-fiscal.nat-oper = 35 then do:
                DISABLE ttIt-ped-fiscal.vl-unit WITH FRAME {&FRAME-NAME}.
            END.
        END.
    END.

    

/*     IF ttIt-ped-fiscal.vl-unit < 0.01 THEN     */
/*         ASSIGN ttIt-ped-fiscal.vl-unit = 0.01. */

    DISPLAY cDesc-item ttIt-ped-fiscal.un ttIt-ped-fiscal.vl-unit WITH FRAME {&FRAME-NAME}.
    IF ITEM.tipo-contr <> 4 and
       item.baixa-estoq = YES THEN DO:
       DISABLE ttit-ped-fiscal.peso-bru-item ttit-ped-fiscal.peso-liq-item WITH FRAME fpage0.
    END.
    ELSE
        enable ttit-ped-fiscal.peso-bru-item ttit-ped-fiscal.peso-liq-item WITH FRAME fpage0.


   ASSIGN l-inf-narrativa = NO.
   FOR first mgesp.ponto-programa
       where ponto-programa.nome-programa = "esftp012b"
         AND ponto-programa.ponto         = 2,
        EACH mgesp.conteudo-programa NO-LOCK
       WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
         AND conteudo-programa.conteudo     = INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.it-codigo:

       ASSIGN l-inf-narrativa = YES.
       LEAVE.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttit-ped-fiscal.it-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttit-ped-fiscal.it-codigo IN FRAME fpage0 /* Item */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttit-ped-fiscal.narrativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttit-ped-fiscal.narrativa wMaintenanceNoNavigation
ON ENTRY OF ttit-ped-fiscal.narrativa IN FRAME fpage0 /* Narrativa */
DO:
  IF l-inf-narrativa THEN DO:
      IF ttit-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:

         RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 17006,
                            INPUT "Para o item":U 
                                   + " " + ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
                                   " no campo narrativa~~ê necessario informar o nome do item e o codigo similar do produto no estoque. EX: 4123130 Telefone TS 3130":U).
         APPLY "entry":U TO ttit-ped-fiscal.narrativa.
         RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/MainBlock.i}

    for first mgesp.ponto-programa
        where ponto-programa.nome-programa = "esftp012"
          AND ponto-programa.ponto         = 1,
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          and conteudo-programa.conteudo = "Sim":
        assign l-aloca-estoque = yes.
    end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  ttIt-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
        APPLY 'Leave' TO ttIt-ped-fiscal.it-codigo IN FRAME {&FRAME-NAME}.
        assign de-qtde-antes =  ttit-ped-fiscal.qtde
               c-class-fiscal:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = substring(ttit-ped-fiscal.char-1,11,8).
    END.

    DEF VAR c-chave-bem AS CHAR NO-UNDO.
    ASSIGN c-chave-bem = substr(ttit-ped-fiscal.char-1, 79, 35). /* chave do bem (conta/bem/seq)*/

    IF  NUM-ENTRIES(c-chave-bem,";") > 0
    AND TRIM(c-chave-bem) <> "" THEN
        ASSIGN fi-conta-pat:screen-value in frame fpage0         = ENTRY(1,c-chave-bem,";")
               fi-bem-pat:screen-value in frame fpage0           = ENTRY(2,c-chave-bem,";")
               fi-seq-pat:screen-value in frame fpage0           = ENTRY(3,c-chave-bem,";")
               /*fi-prev-fim-contrato:SCREEN-VALUE IN FRAME fpage0 = STRING(ttit-ped-fiscal.data-1)*/.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ttIt-ped-fiscal.it-codigo:LOAD-MOUSE-POINTER('image/lupa.cur') IN FRAME fPage0.
    c-class-fiscal:LOAD-MOUSE-POINTER('image/lupa.cur') IN FRAME fPage0.
    fi-conta-pat:LOAD-MOUSE-POINTER('image/lupa.cur') IN FRAME fPage0.
    fi-bem-pat:LOAD-MOUSE-POINTER('image/lupa.cur') IN FRAME fPage0.

    ASSIGN ttIt-ped-fiscal.cod-localizacao:SENSITIVE IN FRAME fPage0 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-itens AS CHARACTER   NO-UNDO.

FIND natureza-ped-fiscal NO-LOCK
    WHERE natureza-ped-fiscal.natureza = INT(ttped-fiscal.nat-oper) NO-ERROR.

if l-aloca-estoque THEN DO:
    IF ITEM.tipo-contr <> 4 and
       item.baixa-estoq = YES THEN DO:
        find first saldo-estoq
           where saldo-estoq.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0
                and saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                and saldo-estoq.cod-depos   = ttit-ped-fiscal.cod-depos:screen-value in frame fpage0
                and saldo-estoq.cod-localiz = ttit-ped-fiscal.cod-localizacao:screen-value in frame fpage0
                no-lock no-error.
        
        FIND ITEM 
            WHERE ITEM.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0
            NO-LOCK NO-ERROR.

        FIND FIRST in-grup-estoq NO-LOCK
             WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
    
        IF  pcAction = "ADD" OR pcAction = "COPY" THEN DO WITH FRAME fPage0: 

            /*Alocaá∆o por lote*/
            IF  ITEM.tipo-con-est = 3 THEN DO:
                RUN esp/ftp/esftp012f.p (INPUT YES,                                                    /*p-log-aloca  */
                                         INPUT ttit-ped-fiscal.nr-pedido,                              /*p-nr-pedido  */
                                         INPUT ttit-ped-fiscal.it-codigo,                              /*p-it-codigo  */
                                         INPUT ttit-ped-fiscal.seq,                                    /*p-seq        */
                                         INPUT ttPed-fiscal.cod-estabel,                               /*p-cod-estabel*/
                                         INPUT ttit-ped-fiscal.cod-localizacao,                        /*p-cod-localiz*/
                                         INPUT ttit-ped-fiscal.cod-depos,                              /*p-cod-depos  */
                                         INPUT dec(ttit-ped-fiscal.qtde:screen-value in frame fpage0), /*p-qtde-alocar*/
                                         OUTPUT TABLE tt-erro-aloc).         
            END.
            /*Alocaá∆o sem lote*/
            ELSE DO:
                find current saldo-estoq exclusive-lock no-error.
                assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + dec(ttit-ped-fiscal.qtde:screen-value in frame fpage0).  
                find current saldo-estoq no-lock no-error.
            END.

            IF (AVAIL natureza-ped-fiscal AND natureza-ped-fiscal.Ind-nat-transf) AND 
               CAN-FIND(FIRST prod-composto WHERE prod-composto.it-codigo-pai = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0) THEN DO:
                ASSIGN c-itens = "".
                FOR EACH prod-composto
                    WHERE prod-composto.it-codigo-pai = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0 NO-LOCK:
                    ASSIGN c-itens = c-itens + prod-composto.it-codigo-filho + ", ".
                END.
                IF c-itens <> "" THEN DO:
                    MESSAGE "Quando Transferido Item Composto Devera ser Transferido seus componentes : " skip
                            c-itens

                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.
            END.

        END.
        ELSE IF pcAction = "UPDATE" THEN DO:
            /*Alocaá∆o por lote*/
            IF  ITEM.tipo-con-est = 3 THEN DO:
                RUN esp/ftp/esftp012f.p (INPUT YES,                                                          /*p-log-aloca  */
                                         INPUT int(ttped-fiscal.nr-pedido:SCREEN-VALUE IN FRAME fpage0),     /*p-nr-pedido  */
                                         INPUT ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME fpage0,       /*p-it-codigo  */
                                         INPUT int(ttit-ped-fiscal.seq:SCREEN-VALUE IN FRAME fpage0),        /*p-seq        */
                                         INPUT ttPed-fiscal.cod-estabel,                                     /*p-cod-estabel*/
                                         INPUT ttit-ped-fiscal.cod-localizacao:SCREEN-VALUE IN FRAME fpage0, /*p-cod-localiz*/
                                         INPUT ttit-ped-fiscal.cod-depos:SCREEN-VALUE IN FRAME fpage0,       /*p-cod-depos  */
                                         INPUT dec(ttit-ped-fiscal.qtde:SCREEN-VALUE IN FRAME fpage0),       /*p-qtde-alocar*/
                                         OUTPUT TABLE tt-erro-aloc).         
            END.
            /*Alocaá∆o sem lote*/
            ELSE DO:
                FIND it-ped-fiscal
                     WHERE it-ped-fiscal.nr-pedido = int(ttped-fiscal.nr-pedido:SCREEN-VALUE in frame fpage0)
                       AND it-ped-fiscal.seq       = int(ttit-ped-fiscal.seq:SCREEN-VALUE in frame fpage0)
                       AND it-ped-fiscal.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0
                     EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL it-ped-fiscal                                                                              AND
                    (it-ped-fiscal.cod-depos       <> ttit-ped-fiscal.cod-depos:screen-value in frame fpage0        or
                     it-ped-fiscal.cod-localizacao <> ttit-ped-fiscal.cod-localizacao:screen-value in frame fpage0) THEN DO:

                    find current saldo-estoq exclusive-lock no-error.
                    ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + dec(ttit-ped-fiscal.qtde:screen-value in frame fpage0).
                    release saldo-estoq.

                    FIND FIRST saldo-estoq
                       where saldo-estoq.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0
                            and saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                            and saldo-estoq.cod-depos   = it-ped-fiscal.cod-depos
                            and saldo-estoq.cod-localiz = it-ped-fiscal.cod-localizacao
                            exclusive-lock no-error.

                    IF AVAIL SALDO-ESTOQ
                    then do:
                        if saldo-estoq.qt-alocada >= it-ped-fiscal.qtde 
                        THEN ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada - it-ped-fiscal.qtde.

                        release saldo-estoq.
                    END.
                    ELSE DO:
                        MESSAGE "Nao encontrado saldo estoque para o deposito anterior " it-ped-fiscal.cod-depos       SKIP
                                                                                         it-ped-fiscal.cod-localizacao 
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        UNDO, LEAVE.
                    END.
                END.
                ELSE do:
                    find current saldo-estoq exclusive-lock no-error.
                    ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada + dec(ttit-ped-fiscal.qtde:screen-value in frame fpage0) - de-qtde-antes.
                    release saldo-estoq.
                end.
            END.
        END.
    END.
END.
    //Aplica percentual 2% valor unit†rio do item.
    IF ttped-fiscal.nat-oper = 25 OR ttped-fiscal.nat-oper = 26 THEN DO:            
       ASSIGN ttit-ped-fiscal.vl-unit = (ttit-ped-fiscal.vl-unit) / (1 - (2 / 100)).
       DISP ttit-ped-fiscal.vl-unit WITH FRAME {&FRAME-NAME}.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME {&FRAME-NAME} ttIt-ped-fiscal.un
           OVERLAY(ttit-ped-fiscal.char-1,11,8) = c-class-fiscal:SCREEN-VALUE IN FRAME fpage0.

    FIND FIRST bem_pat NO-LOCK
        WHERE bem_pat.cod_cta_pat     = fi-conta-pat:SCREEN-VALUE IN FRAME fpage0
        AND   bem_pat.num_bem_pat     = INT(fi-bem-pat:SCREEN-VALUE IN FRAME fpage0)
        AND   bem_pat.num_seq_bem_pat = INT(fi-seq-pat:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.

    IF  AVAIL bem_pat THEN
        OVERLAY (ttit-ped-fiscal.char-1, 79,35) = bem_pat.cod_cta_pat + ";" + string(bem_pat.num_bem_pat) + ";" + string(bem_pat.num_seq_bem_pat).
    ELSE DO:
        OVERLAY (ttit-ped-fiscal.char-1, 79,35) = "                                   ".
        ASSIGN ttit-ped-fiscal.data-1 = ?.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt wMaintenanceNoNavigation 
PROCEDURE pi-cria-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pFator   AS DEC.
    DEFINE INPUT PARAM pCliente AS CHAR.
    DEFINE INPUT PARAM pOrigem  AS CHAR.

    DEFINE VAR i-orig AS INT NO-UNDO.

    DO i-orig = 1 TO NUM-ENTRIES(pOrigem,"-"):

       CREATE tt-fator.
       ASSIGN tt-fator.fator    = pFator
              tt-fator.emitente = int(pCliente)
              tt-fator.origem   = entry(i-orig,pOrigem,"-").

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-bem wMaintenanceNoNavigation 
PROCEDURE pi-leave-bem :
DEF VAR v_val_incorp_bem_pat LIKE incorp_bem_pat.val_incorp_bem_pat NO-UNDO.

ASSIGN v_val_incorp_bem_pat = 0.

FIND FIRST bem_pat NO-LOCK
        WHERE bem_pat.cod_cta_pat     = fi-conta-pat:SCREEN-VALUE IN FRAME fpage0
        AND   bem_pat.num_bem_pat     = int(fi-bem-pat:SCREEN-VALUE IN FRAME fpage0)  
        AND   bem_pat.num_seq_bem_pat = int(fi-seq-pat:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.  

    IF  AVAIL bem_pat THEN DO:

        IF (ttit-ped-fiscal.it-codigo:SCREEN-VALUE  = "IMOBILE" 
        OR  ttit-ped-fiscal.it-codigo:SCREEN-VALUE  = "9930050"
        OR   ttit-ped-fiscal.it-codigo:SCREEN-VALUE = "9890001") THEN DO:
            FOR EACH incorp_bem_pat
                WHERE incorp_bem_pat.num_id_bem_pat = bem_pat.num_id_bem_pat NO-LOCK:
                ASSIGN v_val_incorp_bem_pat = v_val_incorp_bem_pat + incorp_bem_pat.val_incorp_bem_pat.
            END.

            /*
            ASSIGN v_val_incorp_bem_pat = v_val_incorp_bem_pat + INPUT FRAME fpage0 ttIt-ped-fiscal.vl-unit.

            ASSIGN ttIt-ped-fiscal.vl-unit:SCREEN-VALUE IN FRAME fpage0 = string(v_val_incorp_bem_pat).*/
        END.

        IF  ttit-ped-fiscal.it-codigo:SCREEN-VALUE = "9930050" THEN DO:            
            IF  ttped-fiscal.nat-oper                                = 43
            AND dec(ttIt-ped-fiscal.vl-unit:SCREEN-VALUE IN FRAME fpage0) > 0 THEN
                ASSIGN ttIt-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME fpage0 = bem_pat.des_bem_pat.
            ELSE DO:
                IF  ttped-fiscal.nat-oper = 41
                OR  ttped-fiscal.nat-oper = 42
                OR  ttped-fiscal.nat-oper = 44 THEN DO:
                    FIND LAST sdo_bem_pat NO-LOCK
                        WHERE sdo_bem_pat.num_id_bem_pat   = bem_pat.num_id_bem_pat
                        AND   sdo_bem_pat.cod_finalid_econ = "corrente"
                        AND   sdo_bem_pat.cod_cenar_ctbl   = "IFRS" NO-ERROR.

                    IF  AVAIL sdo_bem_pat THEN DO:
                        ASSIGN de-sdo-liq-bem = sdo_bem_pat.val_origin_corrig - ((sdo_bem_pat.val_dpr_val_origin + sdo_bem_pat.val_dpr_cm +
                                                sdo_bem_pat.val_cm_dpr) + (sdo_bem_pat.val_dpr_val_origin_amort + sdo_bem_pat.val_dpr_cm_amort +
                                                sdo_bem_pat.val_cm_dpr_amort)).

                        IF  de-sdo-liq-bem <= 0 THEN
                            ASSIGN de-sdo-liq-bem = 0.01.

                        ASSIGN ttIt-ped-fiscal.vl-unit:SCREEN-VALUE   IN FRAME fpage0 = string(de-sdo-liq-bem + v_val_incorp_bem_pat)
                               ttIt-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME fpage0 = bem_pat.des_bem_pat.
                    END.
                    ELSE
                        ASSIGN ttIt-ped-fiscal.vl-unit:SCREEN-VALUE   IN FRAME fpage0 = string(bem_pat.val_original + v_val_incorp_bem_pat)
                               ttIt-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME fpage0 = bem_pat.des_bem_pat.
                END.
                ELSE DO:

                    IF  ttped-fiscal.nat-oper <> 22
                    AND ttped-fiscal.nat-oper <> 24
                    AND ttped-fiscal.nat-oper <> 43
                    AND (bem_pat.val_original + v_val_incorp_bem_pat) <> INPUT FRAME fpage0 ttIt-ped-fiscal.vl-unit THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 27100, 
                                           INPUT "Valor informado diferente do custo original. Confirma ?").

                        IF  RETURN-VALUE = "NO" THEN 
                            ASSIGN ttIt-ped-fiscal.vl-unit:SCREEN-VALUE IN FRAME fpage0 = string(bem_pat.val_original + v_val_incorp_bem_pat).
                    END.

                    ASSIGN ttIt-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME fpage0 = bem_pat.des_bem_pat.
                END.
            END.        
        END.
        ELSE DO:
            IF  ttit-ped-fiscal.it-codigo:SCREEN-VALUE = "IMOBILE" THEN DO:            
                IF (ttped-fiscal.nat-oper = 22
                OR  ttped-fiscal.nat-oper = 24)
                AND dec(ttIt-ped-fiscal.vl-unit:SCREEN-VALUE IN FRAME fpage0) > 0 THEN
                    ASSIGN ttIt-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME fpage0 = bem_pat.des_bem_pat.
                ELSE DO:
                    IF  ttped-fiscal.nat-oper <> 41
                    AND ttped-fiscal.nat-oper <> 42
                    AND ttped-fiscal.nat-oper <> 43
                    AND ttped-fiscal.nat-oper <> 44
                    AND (bem_pat.val_original + v_val_incorp_bem_pat) <> INPUT FRAME fpage0 ttIt-ped-fiscal.vl-unit THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 27100, 
                                           INPUT "Valor informado diferente do custo original. Confirma ?").

                        IF  RETURN-VALUE = "NO" THEN 
                            ASSIGN ttIt-ped-fiscal.vl-unit:SCREEN-VALUE IN FRAME fpage0 = string(bem_pat.val_original + v_val_incorp_bem_pat).
                    END.

                    ASSIGN ttIt-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME fpage0 = bem_pat.des_bem_pat.
                END.
            END.
            ELSE
                ASSIGN ttIt-ped-fiscal.vl-unit:SCREEN-VALUE   IN FRAME fpage0 = string(bem_pat.val_original + v_val_incorp_bem_pat)
                       ttIt-ped-fiscal.narrativa:SCREEN-VALUE IN FRAME fpage0 = bem_pat.des_bem_pat.
        END.

    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-menor-valor-item wMaintenanceNoNavigation 
PROCEDURE pi-menor-valor-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-qtd-pedido AS DEC NO-UNDO.
    DEF OUTPUT PARAM p-val-minimo AS DEC DECIMALS 5 NO-UNDO.

    ASSIGN p-val-minimo = 0.0001.

    REPEAT:
        IF (p-qtd-pedido * p-val-minimo) >= 0.01 THEN
            LEAVE.
        ELSE
            ASSIGN p-val-minimo = p-val-minimo * 10.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaInclusao wMaintenanceNoNavigation 
PROCEDURE piValidaInclusao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM p-ok AS LOGICAL INIT YES NO-UNDO.
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0 NO-ERROR.

    IF NOT AVAIL item  THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Item inexistente":U + "~~" +
                                 "Item Inexistente":U).
        ASSIGN p-ok = no.
        RETURN.
    END.

    FIND FIRST in-grup-estoq NO-LOCK
         WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
               
/*     IF  AVAIL in-grup-estoq                                                                            */
/*     AND in-grup-estoq.log-ckd THEN DO:                                                                 */
/*                                                                                                        */
/*         RUN esp/es0018p.p (INPUT "CKD-PO", /* Nome do programa */                                      */
/*                            INPUT 1,        /* Ponto do programa */                                     */
/*                            INPUT 0,                                                                    */
/*                            INPUT "",                                                                   */
/*                            OUTPUT TABLE tt-prog-ponto) NO-ERROR.                                       */
/*                                                                                                        */
/*         IF CAN-FIND (FIRST tt-prog-ponto                                                               */
/*                      WHERE tt-prog-ponto.conteudo = ttped-fiscal.cod-estabel) THEN DO:                 */
/*                                                                                                        */
/*             IF  ttPed-fiscal.nat-oper <> 8                                                             */
/*             AND ttPed-fiscal.nat-oper <> 9                                                             */
/*             AND ttped-fiscal.nat-oper <> 28 THEN DO:                                                   */
/*                 RUN utp/ut-msgs.p (INPUT "show":U,                                                     */
/*                                    INPUT 17006,                                                        */
/*                                    INPUT "Itens CKD s¢ podem ser adicionados atravÇs do bot∆o CKD":U). */
/*                                                                                                        */
/*                 ASSIGN p-ok = no.                                                                      */
/*                 RETURN.                                                                                */
/*             END.                                                                                       */
/*         END.                                                                                           */
/*     END.                                                                                               */
    
    IF  pcAction = "ADD" OR pcAction = "COPY" THEN DO WITH FRAME fPage0:
        FIND FIRST mgesp.it-ped-fiscal NO-LOCK
            WHERE mgesp.it-ped-fiscal.nr-pedido = INT(ttped-fiscal.nr-pedido:SCREEN-VALUE)
            AND   mgesp.it-ped-fiscal.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE NO-ERROR.
        
        IF  AVAIL mgesp.it-ped-fiscal THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 27100, 
                               INPUT "Item j† cadastrado para este pedido.":U + "~~" +
                                     "Item j† cadastrado para este pedido. Confirma inclus∆o?":U).
            ASSIGN p-ok = RETURN-VALUE = "yes".
        END.
    END.    

    IF (ttit-ped-fiscal.cod-depos:screen-value in frame fpage0        = "EXP" 
    OR  ttit-ped-fiscal.cod-depos:screen-value in frame fpage0        = "WEX")
    AND ttit-ped-fiscal.cod-localizacao:screen-value in frame fpage0  = "CST" THEN DO:  
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Nao Ç permitido alocar no deposito EXP ou WEX localizacao CST":U + "~~" +
                                 "Nao Ç permitido alocar no deposito EXP ou WEX localizacao CST":U).
        ASSIGN p-ok = no.
        RETURN.        
    end.

    IF (ttit-ped-fiscal.cod-depos:screen-value in frame fpage0        = "FAT" 
    AND ttit-ped-fiscal.cod-localizacao:screen-value in frame fpage0  <> "") THEN DO:  
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Nao Ç permitido alocar no deposito FAT com localizacao diferente de BRANCO":U).
        ASSIGN p-ok = no.
        RETURN.        
    end.

    FIND natureza-ped-fiscal NO-LOCK
        WHERE natureza-ped-fiscal.natureza = INT(ttped-fiscal.nat-oper) NO-ERROR.

    IF  AVAIL natureza-ped-fiscal 
    AND natureza-ped-fiscal.Ind-nat-transf THEN DO:
        
        IF  ttit-ped-fiscal.cod-depos:screen-value in frame fpage0 = "ALM" THEN DO:  
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Nao Ç permitido alocar no deposito ALM":U).
            ASSIGN p-ok = no.
            RETURN.        
        end.

        IF  ttit-ped-fiscal.cod-depos:screen-value in frame fpage0 = "WAL" THEN DO:  
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Nao Ç permitido alocar no deposito WAL":U).
            ASSIGN p-ok = no.
            RETURN.        
        end.
    END.
                       

    FIND ITEM
        WHERE item.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL item  THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Item inexistente":U + "~~" +
                                 "Item Inexistente":U).
        ASSIGN p-ok = no.
        RETURN.
    END.

    
    
    IF  item.baixa-estoq
    AND (ttped-fiscal.nat = 01
    OR   ttped-fiscal.nat = 06
    OR   ttped-fiscal.nat = 11
    OR   ttped-fiscal.nat = 12
    OR   ttped-fiscal.nat = 16
    OR   ttped-fiscal.nat = 18
    OR   ttped-fiscal.nat = 19
    OR   ttped-fiscal.nat = 27
    OR   ttped-fiscal.nat = 28) THEN DO:
        
        IF  item.ind-item-fat = NO  THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "ITEM N∆o esta parametrizado como fatur†vel.":U + "~~" +
                                     "Favor abrir solicitaá∆o no ESFTP031. D£vidas, procure o Grupo Tribut†rio.":U).
            ASSIGN p-ok = no.
            RETURN.
        END.
        
        FIND item-uni-estab
            WHERE item-uni-estab.cod-estabel = ttped-fiscal.cod-estabel
            AND   item-uni-estab.it-codigo   = item.it-codigo NO-LOCK NO-ERROR.
        
        IF  item-uni-estab.ind-item-fat = NO THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "ITEM N∆o esta parametrizado como fatur†vel.":U + "~~" +
                                     "Favor abrir solicitaá∆o no ESFTP031. D£vidas, procure o Grupo Tribut†rio.":U).
            ASSIGN p-ok = no.
            RETURN.
        END.
    END.

    IF ITEM.tipo-contr <> 4 and
       item.baixa-estoq = YES THEN DO:
       IF  pcAction = "UPDATE" THEN DO: 
           FIND it-ped-fiscal
                WHERE it-ped-fiscal.nr-pedido = int(ttped-fiscal.nr-pedido:SCREEN-VALUE in frame fpage0)
                  AND it-ped-fiscal.seq       = int(ttit-ped-fiscal.seq:SCREEN-VALUE in frame fpage0)
                  AND it-ped-fiscal.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0
                NO-LOCK NO-ERROR.
           IF AVAIL it-ped-fiscal and
               dec(ttit-ped-fiscal.qtde:screen-value in frame fpage0) <> de-qtde-antes and
              (it-ped-fiscal.cod-depos       <> ttit-ped-fiscal.cod-depos:screen-value in frame fpage0        or        
               it-ped-fiscal.cod-localizacao <> ttit-ped-fiscal.cod-localizacao:screen-value in frame fpage0) THEN DO:  
               RUN utp/ut-msgs.p (INPUT "show":U, 
                                  INPUT 17567, 
                                  INPUT "N∆o Ç possivel mudar quantidade juntamente com deposito/localizaá∆o, mude primeiro o deposito e apos a quantidade":U + "~~" +
                                        "N∆o Ç possivel mudar quantidade juntamente com deposito/localizaá∆o, mude primeiro o deposito e apos a quantidade":U).
               ASSIGN p-ok = no.  
              RETURN.

           END.
           if l-aloca-estoque then do: 
               FIND FIRST in-grup-estoq NO-LOCK
                    WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

               /*Alocaá∆o por lote*/
               IF ITEM.tipo-con-est = 3 THEN DO:
                   ASSIGN de-saldo = 0.
                   FOR EACH saldo-estoq NO-LOCK
                      WHERE saldo-estoq.it-codigo   = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0
                        AND saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                        AND saldo-estoq.cod-localiz = ttit-ped-fiscal.cod-localizacao:screen-value in frame fpage0
                        AND saldo-estoq.cod-depos   = ttit-ped-fiscal.cod-depos:screen-value in frame fpage0:
                      
                      ASSIGN de-saldo = de-saldo + (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod).
                   END.
                   IF de-saldo + de-qtde-antes < dec(ttit-ped-fiscal.qtde:SCREEN-VALUE IN FRAME fpage0) THEN DO:
                      RUN utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 17567, 
                                           INPUT "Item " + ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0 + " n∆o possui saldo suficiente para alocaá∆o.").
                        ASSIGN p-ok = no. 
                        RETURN.
                   END.
               END.
               ELSE DO:
                   IF (it-ped-fiscal.cod-depos       <> ttit-ped-fiscal.cod-depos:screen-value in frame fpage0        or        
                       it-ped-fiscal.cod-localizacao <> ttit-ped-fiscal.cod-localizacao:screen-value in frame fpage0) THEN DO:  
                       
                       find first saldo-estoq
                          where saldo-estoq.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0
                               and saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                               and saldo-estoq.cod-depos   = it-ped-fiscal.cod-depos
                               and saldo-estoq.cod-localiz = it-ped-fiscal.cod-localizacao
                               NO-LOCK no-error.
                       IF NOT AVAIL SALDO-ESTOQ OR
                          SALDO-ESTOQ.qt-alocada < dec(ttit-ped-fiscal.qtde:SCREEN-VALUE IN FRAME fpage0) THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17567, 
                                               INPUT "Saldo estoque alocado nao encontrado":U + "~~" +
                                                     "Saldo estoque alocado nao encontrado":U).
                            ASSIGN p-ok = no. 
                            RETURN.
                       END.
                       find first saldo-estoq
                          where saldo-estoq.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0
                               and saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                               and saldo-estoq.cod-depos   = ttit-ped-fiscal.cod-depos:SCREEN-VALUE in frame fpage0
                               and saldo-estoq.cod-localiz = ttit-ped-fiscal.cod-localizacao:SCREEN-VALUE in frame fpage0
                               NO-LOCK no-error.
                       IF NOT AVAIL SALDO-ESTOQ OR
                          (SALDO-ESTOQ.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped) < dec(ttit-ped-fiscal.qtde:SCREEN-VALUE IN FRAME fpage0) THEN DO:
                          RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17567, 
                                               INPUT "Saldo estoque no novo deposito informado nao encontrado":U + "~~" +
                                                     "Saldo estoque no novo deposito informado nao encontrado":U).
                            ASSIGN p-ok = no. 
                            RETURN.
                       END.
                   END.
               END.
           END. 
       END.
    END.
    ELSE DO:
       IF  ttped-fiscal.nat-oper = 5            /*     5  - Remessa Presidio                 */
       OR  ttped-fiscal.nat-oper = 10           /*     10 - Remessa Industrializaá∆o         */
       OR  ttped-fiscal.nat-oper = 14           /*     14 - Ret/Rem para Conserto            */     
       OR  ttped-fiscal.nat-oper = 15           /*     15 - Remessa Teste com Retorno        */     
       OR  ttped-fiscal.nat-oper = 21 THEN DO:  /*     21 - Remessa para Feira               */       
           IF  item.it-codigo  <> "ESTQ"
           AND item.it-codigo <> "IMOBILE"
           AND item.it-codigo <> "estq - imp" then do:
               RUN utp/ut-msgs.p (INPUT "show":U, 
                                  INPUT 17567, 
                                  INPUT "N∆o Ç Permitido informar item Debito Direto com Naturezas que controlam saldo em poder de terceiros":U + "~~" +
                                        "Usar ESTQ, IMOBILE ou o pr¢prio c¢digo do item (exemplo: 4070053, 4005009, etc). ":U).
               ASSIGN p-ok = no.
               RETURN.
           END.
       END.    
       
       IF  dec(ttIt-ped-fiscal.peso-bru-item:SCREEN-VALUE) = 0 THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U, 
                              INPUT 17567, 
                              INPUT "Item de Debito Direto, informaá∆o do peso bruto Ç obrigat¢rio":U + "~~" +
                                    "Item de Debito Direto, informaá∆o do peso bruto Ç obrigat¢rio":U).
           ASSIGN p-ok = no.
           RETURN.
       END.
       
       IF  dec(ttIt-ped-fiscal.peso-liq-item:SCREEN-VALUE) = 0 THEN DO:
           RUN utp/ut-msgs.p (INPUT "show":U, 
                              INPUT 17567, 
                              INPUT "Item de Debito Direto, informaá∆o do peso liquido Ç obrigat¢rio":U + "~~" +
                                    "Item de Debito Direto, informaá∆o do peso liquido Ç obrigat¢rio":U).
           ASSIGN p-ok = no.
           RETURN.
       END.
    END.
    
    IF  c-class-fiscal:SCREEN-VALUE in FRAME fPage0 = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Informe a Classificaá∆o Fiscal":U + "~~" +
                                 "Informe a Classificaá∆o Fiscal":U).
        ASSIGN p-ok = no.
        RETURN.
    END.
    
    FIND classif-fis
         WHERE classif-fis.class-fiscal = c-class-fiscal:SCREEN-VALUE in FRAME fPage0 NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL classif-fis THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Classificaá∆o Fiscal Inexistente":U + "~~" +
                                 "Classificaá∆o Fiscal Inexistente":U).
        ASSIGN p-ok = no.
        RETURN.
    END.

    IF AVAIL classif-fis AND classif-fis.descricao MATCHES "*SUPRIMIDA*"  THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "A NCM " + classif-fis.class-fiscal + " " + "do Item: " + ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0 + " " + 
                                 "nao e valida. Por gentileza procurar o grupo.ncm@intelbras.com.br":U).

        ASSIGN p-ok = no.
        RETURN.
    END.
    
    IF  dec(ttIt-ped-fiscal.peso-liq-item:SCREEN-VALUE) > dec(ttIt-ped-fiscal.peso-bru-item:SCREEN-VALUE) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Peso liquido informado maior que peso bruto":U + "~~" +
                                 "Peso liquido informado maior que peso bruto":U).
        ASSIGN p-ok = no.
        RETURN.
    END.
    
    if  l-aloca-estoque then do:    
        FIND ITEM 
            WHERE ITEM.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0 NO-LOCK NO-ERROR.
        
        IF  item.tipo-contr <> 4
        AND item.baixa-estoq = YES THEN DO:

            RUN piValidaWMS.
            
            IF  l-ok THEN DO:
                ASSIGN p-ok = l-ok.
                RETURN.
            END.

            FIND FIRST in-grup-estoq NO-LOCK
                 WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.

            /*Alocaá∆o por lote*/
            IF ITEM.tipo-con-est = 3 THEN DO:
                ASSIGN de-saldo = 0.
                FOR EACH saldo-estoq NO-LOCK
                   WHERE saldo-estoq.it-codigo   = ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0
                     AND saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                     AND saldo-estoq.cod-localiz = ttit-ped-fiscal.cod-localizacao:screen-value in frame fpage0
                     AND saldo-estoq.cod-depos   = ttit-ped-fiscal.cod-depos:screen-value in frame fpage0:
                   
                   ASSIGN de-saldo = de-saldo + (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod).
                END.
                
                IF de-saldo + de-qtde-antes < dec(ttit-ped-fiscal.qtde:SCREEN-VALUE IN FRAME fpage0) THEN DO:
                   RUN utp/ut-msgs.p (INPUT "show":U, 
                                        INPUT 17567, 
                                        INPUT "Item " + ttit-ped-fiscal.it-codigo:SCREEN-VALUE in frame fpage0 + " n∆o possui saldo suficiente para alocaá∆o.").
                     ASSIGN p-ok = no. 
                     RETURN.
                END.
            END.
            ELSE DO:
                find first saldo-estoq
                     where saldo-estoq.it-codigo = ttit-ped-fiscal.it-codigo:SCREEN-VALUE
                       and saldo-estoq.cod-estabel = ttPed-fiscal.cod-estabel
                       and saldo-estoq.cod-depos   = ttit-ped-fiscal.cod-depos:screen-value
                       AND saldo-estoq.cod-localiz = ttIt-ped-fiscal.cod-localizacao:SCREEN-VALUE
                       no-lock no-error.
                if not avail saldo-estoq then do:
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17567, 
                                       INPUT "Item sem saldo em estoque":U ).
                    ASSIGN p-ok = no.
                    return.
                end. 
                if saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                   saldo-estoq.qt-aloc-prod < dec(ttit-ped-fiscal.qtde:SCREEN-VALUE) - de-qtde-antes
                  then do:
                     RUN utp/ut-msgs.p (INPUT "show":U, 
                                        INPUT 17567, 
                                        INPUT "Item com saldo " + string(saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped - 
                   saldo-estoq.qt-aloc-prod) + " em estoque menor que a quantidade informada " + string(dec(ttit-ped-fiscal.qtde:SCREEN-VALUE) - de-qtde-antes) + ", inclus∆o n∆o permitida":U ).
                     ASSIGN p-ok = no.
                     return.
                   
                END.    
            END.
        END.
    END.

    /* Chamado 22351 -> identificar menor valor unit†rio aceit†vel para o item. Nota fiscal exige que o total do item seja no m°nimo 0,01 */
    IF  ttit-ped-fiscal.vl-unit:SENSITIVE IN FRAME {&FRAME-NAME} = YES
    AND INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.qtde           <> 0 
    AND INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.qtde * INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.vl-unit < 0.01 THEN DO:
        RUN pi-menor-valor-item (INPUT  INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.qtde,
                                 OUTPUT de-menor-valor-item).

        RUN utp/ut-msgs.p (INPUT "show", 
                           INPUT 17567, 
                           INPUT "Valor informado " + STRING(INPUT FRAME {&FRAME-NAME} ttit-ped-fiscal.vl-unit, ">>>,>>9.9999") + 
                                 " Ç inferior ao m°nimo aceito pelo sistema " + string(de-menor-valor-item,">>>,>>9.9999")     + ", inclus∆o n∆o permitida").
        ASSIGN p-ok = no.
        RETURN.
    END.

    FIND natureza-ped-fiscal NO-LOCK
        WHERE natureza-ped-fiscal.natureza = ttped-fiscal.nat-oper NO-ERROR.
    
    IF  AVAIL natureza-ped-fiscal
    AND natureza-ped-fiscal.Ind-valida-it-fatur
    AND NOT item.ind-item-fat THEN DO:        
        RUN utp/ut-msgs.p (INPUT "show", 
                           INPUT 17567, 
                           INPUT "Natureza s¢ permite itens fatur†veis."). 
        ASSIGN p-ok = NO.
        RETURN.
    END.

    FIND FIRST bem_pat NO-LOCK
        WHERE bem_pat.cod_cta_pat     = fi-conta-pat:SCREEN-VALUE   IN FRAME fpage0
        AND   bem_pat.num_bem_pat     = int(fi-bem-pat:SCREEN-VALUE IN FRAME fpage0)  
        AND   bem_pat.num_seq_bem_pat = int(fi-seq-pat:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.  

    IF  NOT AVAIL bem_pat THEN DO:

        IF  ttit-ped-fiscal.it-codigo:SCREEN-VALUE = "imobile" 
        OR  ttit-ped-fiscal.it-codigo:SCREEN-VALUE = "9930050" 
        OR  ttit-ped-fiscal.it-codigo:SCREEN-VALUE = "9890001" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 17006, 
                       INPUT "Conta e Bem Patrimonial devem ser informados.").
            ASSIGN p-ok = NO.
            RETURN.
        END.
        ELSE DO:
            IF  trim(fi-conta-pat:SCREEN-VALUE IN FRAME fpage0) <> "" OR  int(fi-bem-pat:SCREEN-VALUE IN FRAME fpage0) > 0 OR  int(fi-seq-pat:SCREEN-VALUE IN FRAME fpage0) > 0 THEN DO:
                run utp/ut-msgs.p (input "show", input 17006, "Bem Patrimonial inexistente").
                ASSIGN p-ok = NO.
                RETURN.
            END.
        END.
    END.
    ELSE DO:

        /* Retirado conforme Chamado: 141155
        IF  bem_pat.val_perc_bxa >= 100 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 17006, 
                       INPUT "Bem totalmente baixado n∆o pode ser informado !").
            ASSIGN p-ok = NO.
            RETURN.
        END.
        */

        IF  ttit-ped-fiscal.it-codigo:SCREEN-VALUE <> "9930050" THEN DO:

            IF int(fi-bem-pat:SCREEN-VALUE IN FRAME fpage0) <> 0 THEN DO:

                IF  ttped-fiscal.nat-oper <> 22
                AND ttped-fiscal.nat-oper <> 24 THEN DO:
                    FIND FIRST int_bem_pat_nf  NO-LOCK
                        WHERE int_bem_pat_nf.cod_cta_pat     = bem_pat.cod_cta_pat
                          AND int_bem_pat_nf.num_bem_pat     = bem_pat.num_bem_pat
                          AND int_bem_pat_nf.num_seq_bem_pat = bem_pat.num_seq_bem_pat NO-ERROR.
                    IF  AVAIL int_bem_pat_nf THEN DO:
                        FIND nota-fiscal NO-LOCK
                            WHERE nota-fiscal.cod-estabel = int_bem_pat_nf.cod-estabel
                              AND nota-fiscal.serie       = int_bem_pat_nf.serie
                              AND nota-fiscal.nr-nota-fis = int_bem_pat_nf.nr-nota-fis NO-ERROR.
                        IF  AVAIL nota-fiscal THEN DO:
                            FOR FIRST it-nota-fisc NO-LOCK
                                WHERE it-nota-fisc.cod-estabel =  nota-fiscal.cod-estabel
                                AND   it-nota-fisc.serie       =  nota-fiscal.serie      
                                AND   it-nota-fisc.nr-nota-fis =  nota-fiscal.nr-nota-fis
                                AND   it-nota-fisc.nr-seq-fat  =  int_bem_pat_nf.nr-seq-fat
                                AND   it-nota-fisc.it-codigo   =  int_bem_pat_nf.it-codigo:
                
                                run utp/ut-msgs.p (input "show", input 27100, "Atená∆o, Bem patrimonial j† vinculado a outra nota fiscal. Confirma ?. ~~" +
                                                  "Para confirmar esta situaá∆o, procure a Controladoria ou envie e-mail para grupo.contabil@intelbras.com.br." + CHR(10) + CHR(10) +
                                                  "Estab: " + int_bem_pat_nf.cod-estabel + CHR(10) +
                                                  "SÇrie: " + int_bem_pat_nf.serie       + CHR(10) +
                                                  "Nota: "  + int_bem_pat_nf.nr-nota-fis + CHR(10) +
                                                  "Seq: "   + string(int_bem_pat_nf.nr-seq-fat) + CHR(10) +
                                                  "Item: " + int_bem_pat_nf.it-codigo).
                                IF  RETURN-VALUE <> "YES" THEN DO:
                                    ASSIGN p-ok = NO.
                                    RETURN.
                                END.
                
                            END.
                        END.
                    END.
                END.
            END.
        END.

        IF  ttit-ped-fiscal.it-codigo:SCREEN-VALUE = "imobile" 
        OR  ttit-ped-fiscal.it-codigo:SCREEN-VALUE = "9890001" THEN DO:

            IF int(fi-bem-pat:SCREEN-VALUE IN FRAME fpage0) <> 0 THEN DO:
               IF  ttped-fiscal.nat-oper <> 22
               AND ttped-fiscal.nat-oper <> 24 THEN DO:
                   FIND FIRST saldo-terc
                       WHERE saldo-terc.cod-estabel  = ttPed-fiscal.cod-estabel
                       AND   saldo-terc.cod-emitente = ttped-fiscal.cod-emitente
                       AND   saldo-terc.it-codigo    = ttit-ped-fiscal.it-codigo:SCREEN-VALUE
                       AND   saldo-terc.quantidade   > 0 NO-LOCK NO-ERROR.
              
                   IF  AVAIL saldo-terc THEN DO:
                       RUN utp/ut-msgs.p (INPUT "show":U, 
                                          INPUT 27100, 
                                          INPUT "Emitente j† possui nota fiscal de bem patrimonial em seu nome. Confirma solicitaá∆o ?. ~~" +
                                          "Para confirmar esta situaá∆o, procure a Controladoria ou envie e-mail para grupo.contabil@intelbras.com.br.").
              
                       IF  RETURN-VALUE <> "YES" THEN DO:
                           ASSIGN p-ok = NO.
                           RETURN.
                       END.
                   END.
               END.
            END.
        END.
        ELSE DO:
            IF int(fi-bem-pat:SCREEN-VALUE IN FRAME fpage0) <> 0 THEN DO:
               IF   ttPed-fiscal.cod-estabel <> bem_pat.cod_estab THEN DO:
                   RUN utp/ut-msgs.p (INPUT "show":U, 
                              INPUT 17006, 
                              INPUT "Estabelecimento da solicitaá∆o difere do estabelecimento do Bem Patrimonial.").
                   ASSIGN p-ok = NO.
                   RETURN.
               END.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaWMS wMaintenanceNoNavigation 
PROCEDURE piValidaWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
            /* Validacao MFT x WMS  */
            FIND FIRST deposito 
                WHERE deposito.cod-depos    = ttit-ped-fiscal.cod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                  AND deposito.log-gera-wms = YES NO-LOCK NO-ERROR.
            IF AVAIL deposito THEN DO:

                RUN esp/wmp/eswmpapi003.p (INPUT  ttped-fiscal.cod-estabel,
                                           INPUT  ttit-ped-fiscal.cod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                           INPUT  ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                           INPUT  "",
                                           OUTPUT p-qtd-total,
                                           OUTPUT p-qtd-disp,
                                           OUTPUT p-qtd-bloq,
                                           OUTPUT TABLE tt-erro).

                FOR EACH tt-erro WHERE tt-erro.cd-erro = 56:
                    DELETE tt-erro.
                END. 

                IF p-qtd-disp < input frame {&frame-name} ttit-ped-fiscal.qtde THEN DO:

                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17006, 
                                       INPUT "Saldo indisponivel! ~~Item " + ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " nao possui saldo f°sico disponivel no deposito " + ttit-ped-fiscal.cod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "." +
                                             "Possivel causa: Bloqueio de localizacao Para maiores informacoes, entrar em contato com o responsavel pelo deposito.").
                    ASSIGN ttit-ped-fiscal.qtde:SCREEN-VALUE in frame {&frame-name} = ''.
                    ASSIGN l-ok = no.
                END. /* IF p-qtd-disp < input frame {&frame-name} ttit-ped-fiscal.qtde THEN DO: */
                ELSE DO:
                    FIND FIRST saldo-estoq NO-LOCK 
                         WHERE saldo-estoq.cod-estabel = ttped-fiscal.cod-estabel
                         AND   saldo-estoq.it-codigo   = ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                         AND   saldo-estoq.cod-depos   = ttit-ped-fiscal.cod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME}  
                         AND   saldo-estoq.cod-localiz = '' NO-ERROR.
                    IF AVAIL saldo-estoq THEN DO:

                        IF (saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped) - p-qtd-bloq < input frame {&frame-name} ttit-ped-fiscal.qtde THEN DO:
                            RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17006, 
                                               INPUT "Saldo indisponivel! ~~Item " + ttit-ped-fiscal.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " nao possui saldo f°sico disponivel no deposito " + ttit-ped-fiscal.cod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "." +
                                                     "Possivel causa: Bloqueio de localizacao Para maiores informacoes, entrar em contato com o responsavel pelo deposito.").
                            ASSIGN ttit-ped-fiscal.qtde:SCREEN-VALUE in frame {&frame-name} = ''.
                            ASSIGN l-ok = no.
                        END. /* IF p-qtd-disp - (saldo-estoq.qt-alocada  + saldo-estoq.qt-aloc-ped) < input frame {&frame-name} ttit-ped-fiscal.qtde THEN DO: */
                    END. /* IF AVAIL saldo-estoq THEN DO: */
                END. /* IF p-qtd-disp > input frame {&frame-name} ttit-ped-fiscal.qtde THEN DO: */

            END. /* IF AVAIL deposito THEN DO: */
            /* Fim Valid MFT x WMS  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

    ASSIGN ttIt-ped-fiscal.nr-pedido     = INPUT FRAME {&FRAME-NAME} ttPed-fiscal.nr-pedido.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

