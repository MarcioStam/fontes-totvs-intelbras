&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP068A 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP068A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER c-procedimento AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.


DEFINE TEMP-TABLE tt-item-alocados NO-UNDO
    FIELD cod-estabel  AS CHARACTER
    FIELD it-codigo    LIKE item.it-codigo
    FIELD cod-depos    LIKE saldo-estoq.cod-depos
    FIELD cod-localiz  LIKE saldo-estoq.cod-localiz
    FIELD quantidade   AS DECIMAL
    FIELD lote         LIKE saldo-estoq.lote
    FIELD qt-aloc-ped  AS DECIMAL 
    INDEX ch-principal it-codigo cod-depos cod-localiz.

DEFINE BUFFER b-nota-fiscal FOR nota-fiscal.

DEF BUFFER b01-wt-fat-ser-lote FOR wt-fat-ser-lote.
DEF BUFFER b01-fat-ser-lote    FOR fat-ser-lote.
DEF BUFFER b01-saldo-estoq     FOR saldo-estoq.
DEF BUFFER b01-deposito        FOR deposito.


DEFINE VARIABLE l-depos-externo AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-2 RECT-1 c-cod-estabel ~
c-serie i-nr-nota-fis btOK btCancel text-1 text-2 
&Scoped-Define DISPLAYED-OBJECTS ed-info c-cod-estabel c-serie ~
i-nr-nota-fis c-item text-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-info AS CHARACTER 
     VIEW-AS EDITOR NO-BOX
     SIZE 71.86 BY 1.88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "x(5)" 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-nota-fis AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(30)":U INITIAL "Aloca‡Æo Nota Fiscal" 
      VIEW-AS TEXT 
     SIZE 15.14 BY .67 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(30)":U INITIAL "Aloca‡Æo Item" 
      VIEW-AS TEXT 
     SIZE 10.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.58.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.42.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     ed-info AT ROW 1.25 COL 10.29 NO-LABEL WIDGET-ID 20
     c-cod-estabel AT ROW 4.04 COL 13 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" WIDGET-ID 40
     c-serie AT ROW 5.04 COL 13 COLON-ALIGNED HELP
          "S‚rie da nota fiscal" WIDGET-ID 42
     i-nr-nota-fis AT ROW 6.04 COL 13 COLON-ALIGNED HELP
          "N£mero da nota fiscal" WIDGET-ID 44
     c-item AT ROW 8.13 COL 13 COLON-ALIGNED WIDGET-ID 6
     btOK AT ROW 9.71 COL 2
     btCancel AT ROW 9.71 COL 13
     text-1 AT ROW 3.25 COL 2.86 NO-LABEL WIDGET-ID 46
     text-2 AT ROW 7.42 COL 2.86 NO-LABEL WIDGET-ID 48
     rtToolBar AT ROW 9.46 COL 1
     RECT-2 AT ROW 7.88 COL 1 WIDGET-ID 34
     RECT-1 AT ROW 3.67 COL 1 WIDGET-ID 38
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.97
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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 9.96
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-item IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR ed-info IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-1 IN FRAME fPage0
   NO-DISPLAY ALIGN-L                                                   */
/* SETTINGS FOR FILL-IN text-2 IN FRAME fPage0
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
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
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    RUN pi-execute.
    IF  RETURN-VALUE = "OK" THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN ed-info = "***IMPORTANTE***" + CHR(10) +
                     "Este processo ir  buscar as notas pendentes de atualiza‡Æo de estoque, " +
                     "pedidos de nota extra pendentes, embarques pendentes, e atualizar " +
                     "a aloca‡Æo do item no estoque.".

    ASSIGN c-item = c-procedimento.

    ENABLE c-cod-estabel
           c-serie
           i-nr-nota-fis
           c-item
        WITH FRAME fPage0.

    DISP text-1
         text-2
         ed-info
         c-item
        WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-alocacao-item wWindow 
PROCEDURE pi-alocacao-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-item-alocados.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Alocando item...").

    ASSIGN c-arquivo = "c:\temp\fat-ser-lote_todos" + c-item + ".txt".
    
    OUTPUT TO VALUE(c-arquivo).
    FOR EACH  item NO-LOCK
        WHERE item.it-codigo   = c-item
        AND   item.baixa-estoq = YES:
    
        RUN pi-acompanhar in h-acomp (input "Item " + item.it-codigo ).
        
        PUT "" skip
            "Item " item.it-codigo SKIP
            "" SKIP.
    
        FOR EACH saldo-estoq NO-LOCK //EXCLUSIVE-LOCK
            WHERE saldo-estoq.it-codigo = item.it-codigo:

            ASSIGN l-depos-externo = NO.
           /* RUN pi-depos-externo (INPUT saldo-estoq.cod-depos,
                                  OUTPUT l-depos-externo).*/

            IF l-depos-externo THEN NEXT.

            FIND b01-saldo-estoq WHERE ROWID(b01-saldo-estoq) = rowid(saldo-estoq) EXCLUSIVE-LOCK NO-ERROR. 
    
            IF AVAIL b01-saldo-estoq THEN
               ASSIGN b01-saldo-estoq.qt-alocada = 0.
        END.
    
        FOR EACH it-pre-fat NO-LOCK
            WHERE it-pre-fat.it-codigo = item.it-codigo,
            FIRST pre-fatur OF it-pre-fat NO-LOCK
            WHERE pre-fatur.cod-sit-pre = 1,
            EACH it-dep-fat NO-LOCK
            WHERE it-dep-fat.cdd-embarq   = it-pre-fat.cdd-embarq  
              AND it-dep-fat.nr-resumo     = it-pre-fat.nr-resumo    
              AND it-dep-fat.nome-abrev    = it-pre-fat.nome-abrev   
              AND it-dep-fat.nr-pedcli     = it-pre-fat.nr-pedcli    
              AND it-dep-fat.cod-estabel   = pre-fatur.cod-estabel  
              AND it-dep-fat.nr-sequencia  = it-pre-fat.nr-sequencia 
              AND it-dep-fat.it-codigo     = it-pre-fat.it-codigo    
              AND it-dep-fat.cod-refer     = it-pre-fat.cod-refer    
              AND it-dep-fat.nr-entrega    = it-pre-fat.nr-entrega:
    
            RUN pi-acompanhar in h-acomp (input "Pre-fatur " + item.it-codigo ).

            ASSIGN l-depos-externo = NO.
          /*  RUN pi-depos-externo (INPUT it-dep-fat.cod-depos,
                                  OUTPUT l-depos-externo).*/

            IF l-depos-externo THEN NEXT.

            PUT "Embarque " it-pre-fat.cdd-embarq 
                " Pedido " it-pre-fat.nr-pedcli
                " Deposito " it-dep-fat.cod-depos
                " Localizacao " it-dep-fat.cod-localiz
                "qtde Alocada " it-pre-fat.qt-alocada SKIP. 
    
            RUN pi-atualiza-temp-table (INPUT pre-fatur.cod-estabel,
                                        INPUT it-pre-fat.it-codigo,
                                        INPUT it-dep-fat.cod-depos,
                                        INPUT it-dep-fat.cod-localiz,
                                        INPUT it-dep-fat.qt-alocada,
                                        INPUT it-dep-fat.nr-serlote,
                                        INPUT 1).
        END.
    
    
        FOR EACH wt-fat-ser-lote NO-LOCK //EXCLUSIVE-LOCK
            WHERE wt-fat-ser-lote.it-codigo = item.it-codigo,
              FIRST wt-docto OF wt-fat-ser-lote NO-LOCK
            WHERE wt-docto.nr-pedcli = ""
            AND wt-docto.num-romaneio = 0:
    
            RUN pi-acompanhar in h-acomp (input "wt-fat-ser-lote " + item.it-codigo ).

            ASSIGN l-depos-externo = NO.
           /* RUN pi-depos-externo (INPUT wt-fat-ser-lote.cod-depos,
                                  OUTPUT l-depos-externo).*/

            IF l-depos-externo THEN NEXT.
    
            PUT  "FAT-SER-LOTE Nota Fiscal " wt-fat-ser-lote.seq-wt-docto
                                " Deposito " wt-fat-ser-lote.cod-depos
                                " Quantidade " wt-fat-ser-lote.quantidade[1] SKIP.

            FIND b01-wt-fat-ser-lote WHERE rowid(b01-wt-fat-ser-lote) = rowid(wt-fat-ser-lote) EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL b01-wt-fat-ser-lote THEN
               ASSIGN b01-wt-fat-ser-lote.log-1 = YES.

            RUN pi-atualiza-temp-table (INPUT wt-docto.cod-estabel,
                                        INPUT wt-fat-ser-lote.it-codigo,
                                        INPUT wt-fat-ser-lote.cod-depos,
                                        INPUT wt-fat-ser-lote.cod-localiz,
                                        INPUT wt-fat-ser-lote.quantidade[1],
                                        INPUT wt-fat-ser-lote.lote,
                                        INPUT 1).
        END.
    
        FOR EACH fat-ser-lote NO-LOCK //EXCLUSIVE-LOCK
                WHERE fat-ser-lote.it-codigo = item.it-codigo,
                FIRST nota-fiscal OF fat-ser-lote NO-LOCK
                WHERE nota-fiscal.dt-confirma = ?
                AND nota-fiscal.dt-cancel = ?:
    
            RUN pi-acompanhar in h-acomp (input "fat-ser-lote " + item.it-codigo ).

            ASSIGN l-depos-externo = NO.
         /*   RUN pi-depos-externo (INPUT fat-ser-lote.cod-depos,
                                  OUTPUT l-depos-externo).*/

            IF l-depos-externo THEN NEXT.
    
            PUT  "FAT-SER-LOTE Nota Fiscal " fat-ser-lote.nr-nota-fis
                              " Dt Emissao " nota-fiscal.dt-emis-nota
                                " Deposito " fat-ser-lote.cod-depos
                                  " Pedido " nota-fiscal.nr-pedcli     FORMAT "x(7)"
                                " qt Baixa " fat-ser-lote.qt-baixada[1] SKIP.

            FIND b01-fat-ser-lote WHERE rowid(b01-fat-ser-lote) = rowid(fat-ser-lote) EXCLUSIVE-LOCK NO-ERROR.
                
            IF AVAIL b01-fat-ser-lote THEN
               ASSIGN b01-fat-ser-lote.log-1 = YES.

            RUN pi-atualiza-temp-table (INPUT nota-fiscal.cod-estabel,
                                        INPUT fat-ser-lote.it-codigo,
                                        INPUT fat-ser-lote.cod-depos,
                                        INPUT fat-ser-lote.cod-localiz,
                                        INPUT fat-ser-lote.qt-baixada[1],
                                        INPUT fat-ser-lote.nr-serlote,
                                        INPUT 1).
        END.
                                                                              
        FOR EACH mgesp.it-ped-fiscal NO-LOCK 
            WHERE it-ped-fiscal.it-codigo = item.it-codigo:
    
            RUN pi-acompanhar in h-acomp (input "it-ped-fiscal " + item.it-codigo ).
            FIND mgesp.ped-fiscal
                WHERE ped-fiscal.nr-pedido = it-ped-fiscal.nr-pedido
                EXCLUSIVE-LOCK NO-ERROR.


            ASSIGN l-depos-externo = NO.
           /* RUN pi-depos-externo (INPUT it-ped-fiscal.cod-depos,
                                  OUTPUT l-depos-externo).*/

            IF l-depos-externo THEN NEXT.

            
    
            RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                        INPUT it-ped-fiscal.it-codigo,
                                        INPUT it-ped-fiscal.cod-depos,
                                        INPUT it-ped-fiscal.cod-localiz,
                                        INPUT 0,
                                        INPUT "",
                                        INPUT 1).
    
            IF ped-fiscal.situacao < 5  THEN DO:
                put "IT-PED-FISCAL " it-ped-fiscal.nr-pedido 
                    "sequencia " it-ped-fiscal.seq
                    " Data Emissao " ped-fiscal.dt-emissao 
                    " Deposito " it-ped-fiscal.cod-depos
                    " Quandidade  " it-ped-fiscal.qtde SKIP.

                IF  item.tipo-con-est = 3 THEN DO:
                    FOR EACH int-saldo-aloc-lote NO-LOCK //EXCLUSIVE-LOCK
                       WHERE int-saldo-aloc-lote.nr-pedido = it-ped-fiscal.nr-pedido
                         AND int-saldo-aloc-lote.it-codigo = it-ped-fiscal.it-codigo
                         AND int-saldo-aloc-lote.seq       = it-ped-fiscal.seq:
            
                        RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                                    INPUT it-ped-fiscal.it-codigo,
                                                    INPUT it-ped-fiscal.cod-depos,
                                                    INPUT it-ped-fiscal.cod-localiz,
                                                    INPUT int-saldo-aloc-lote.qtidade-atu,
                                                    INPUT int-saldo-aloc-lote.lote,
                                                    INPUT 1).
                    END.
                END.
                ELSE DO:
                    RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                                INPUT it-ped-fiscal.it-codigo,
                                                INPUT it-ped-fiscal.cod-depos,
                                                INPUT it-ped-fiscal.cod-localiz,
                                                INPUT it-ped-fiscal.qtde,
                                                INPUT "",
                                                INPUT 1).
                END.
    
            END.
    
        END.
        /* Ajustando qt-aloc-ped*/
        FOR EACH saldo-estoq NO-LOCK
            WHERE saldo-estoq.it-codigo = item.it-codigo:

           FOR EACH ped-item 
              WHERE ped-item.it-codigo = ITEM.it-codigo
                AND ped-item.cod-sit-item < 3 
                AND ped-item.qt-log-aloc > 0 NO-LOCK,

               EACH ped-ent OF ped-item NO-LOCK
               WHERE ped-ent.cod-sit-ent < 3
                 AND ped-item.qt-log-aloca > 0:

               FIND FIRST ped-saldo
                    WHERE ped-saldo.nome-abrev  = ped-ent.nome-abrev                   
                      AND ped-saldo.nr-pedcli   = ped-ent.nr-pedcli                   
                      AND ped-saldo.nr-seq-item = ped-ent.nr-sequencia                
                      AND ped-saldo.it-codigo   = ped-ent.it-codigo                   
                      AND ped-saldo.cod-refer   = ped-ent.cod-refer                   
                      AND ped-saldo.nr-entrega  = ped-ent.nr-entrega 
                      AND ped-saldo.cod-depos   = saldo-estoq.cod-depos
                      AND ped-saldo.cod-estabel = saldo-estoq.cod-estabel NO-LOCK NO-ERROR.


                RUN pi-acompanhar in h-acomp (input "Atualizando Quantidade pedidos  " + saldo-estoq.it-codigo ).
                IF AVAIL ped-saldo THEN DO:
                    RUN pi-atualiza-temp-table (INPUT ped-saldo.cod-estabel,
                                                INPUT ped-saldo.it-codigo,
                                                INPUT ped-saldo.cod-depos,
                                                INPUT saldo-estoq.cod-localiz,
                                                INPUT ped-ent.qt-log-aloca,
                                                INPUT saldo-estoq.lote,
                                                INPUT 2).

                    
                END.
                ELSE DO:
                    RUN pi-atualiza-temp-table (INPUT saldo-estoq.cod-estabel,
                                                INPUT saldo-estoq.it-codigo,
                                                INPUT saldo-estoq.cod-depos,
                                                INPUT saldo-estoq.cod-localiz,
                                                INPUT 0,
                                                INPUT saldo-estoq.lote,
                                                INPUT 2).   
              
                    
                    
                    
                END.
           END.
        END.
    END.
    
    
    FOR EACH tt-item-alocados:
        for each saldo-estoq
            where saldo-estoq.it-codigo   = tt-item-alocados.it-codigo
              and saldo-estoq.cod-estabel = tt-item-alocados.cod-estabel
              and saldo-estoq.cod-depos   = tt-item-alocados.cod-depos
              and saldo-estoq.cod-local   = tt-item-alocados.cod-localiz
              AND saldo-estoq.lote        = tt-item-alocados.lote NO-LOCK /*EXCLUSIVE-LOCK*/ :

            ASSIGN l-depos-externo = NO.
          /*  RUN pi-depos-externo (INPUT saldo-estoq.cod-depos,
                                  OUTPUT l-depos-externo).*/

            IF l-depos-externo THEN NEXT.   

    
            RUN pi-acompanhar in h-acomp (input "Atualizando Quantidade Alocada  " + saldo-estoq.it-codigo ).
    
            put tt-item-alocados.it-codigo " " tt-item-alocados.cod-estabel " " tt-item-alocados.cod-depos " " tt-item-alocados.cod-localiz
                " " tt-item-alocados.quantidade 
                " SALDO-ESTOQ " saldo-estoq.qtidade-atu  saldo-estoq.qt-aloc-ped saldo-estoq.qt-alocada 
                tt-item-alocados.quantidade SKIP.

            FIND b01-saldo-estoq WHERE ROWID(b01-saldo-estoq) = rowid(saldo-estoq) EXCLUSIVE-LOCK NO-ERROR. 
    
            IF AVAIL b01-saldo-estoq THEN
               ASSIGN b01-saldo-estoq.qt-alocada = tt-item-alocados.quantidade
                      b01-saldo-estoq.qt-aloc-ped = tt-item-alocados.qt-aloc-ped.
 
        END.
    END.

    RUN pi-finalizar in h-acomp.
    ASSIGN h-acomp = ?.

    OUTPUT CLOSE.
    OS-COMMAND NO-WAIT NOTEPAD VALUE(c-arquivo).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-alocacao-nota wWindow 
PROCEDURE pi-alocacao-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-item-alocados.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Alocando nota...").

    ASSIGN c-arquivo = "c:\temp\fat-ser-lote_nota_" + STRING(i-nr-nota-fis) + ".txt".
    PUT "Antes Leitura "  c-cod-estabel          " "        
                          c-serie                " "       
                          STRING(i-nr-nota-fis,"9999999") SKIP.


    OUTPUT TO VALUE(c-arquivo).
    FOR EACH  b-nota-fiscal NO-LOCK
        WHERE b-nota-fiscal.cod-estabel = c-cod-estabel
        AND   b-nota-fiscal.serie       = c-serie
        AND   b-nota-fiscal.nr-nota-fis = STRING(i-nr-nota-fis,"9999999"),
        EACH  it-nota-fisc OF b-nota-fiscal NO-LOCK,
        EACH  item NO-LOCK
        WHERE item.it-codigo = it-nota-fisc.it-codigo
        AND   item.baixa-estoq = YES:
    
        RUN pi-acompanhar IN h-acomp (INPUT "Item " + item.it-codigo ).
        
        PUT ""                     SKIP
            "Item " item.it-codigo SKIP
            ""                     SKIP.

        ASSIGN l-depos-externo = NO.

      /*  FOR FIRST fat-ser-lote OF b-nota-fiscal NO-LOCK:
            RUN pi-depos-externo (INPUT fat-ser-lote.cod-depos,
                                  OUTPUT l-depos-externo).
        END.     */    

        IF l-depos-externo THEN DO: 
           MESSAGE 'NF alocada em Deposito Externo'
               VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

           NEXT.
        END.
    
        FOR EACH  saldo-estoq NO-LOCK //EXCLUSIVE-LOCK
            WHERE saldo-estoq.it-codigo = item.it-codigo:

            FIND b01-saldo-estoq WHERE ROWID(b01-saldo-estoq) = rowid(saldo-estoq) EXCLUSIVE-LOCK NO-ERROR. 

            IF AVAIL b01-saldo-estoq THEN
               ASSIGN b01-saldo-estoq.qt-alocada = 0.
        END.
    
        FOR EACH  it-pre-fat NO-LOCK
            WHERE it-pre-fat.it-codigo = item.it-codigo,
            FIRST pre-fatur OF it-pre-fat NO-LOCK
            WHERE pre-fatur.cod-sit-pre = 1,
            EACH  it-dep-fat NO-LOCK
            WHERE it-dep-fat.nr-embarque   = it-pre-fat.nr-embarque  
              AND it-dep-fat.nr-resumo     = it-pre-fat.nr-resumo    
              AND it-dep-fat.nome-abrev    = it-pre-fat.nome-abrev   
              AND it-dep-fat.nr-pedcli     = it-pre-fat.nr-pedcli    
              AND it-dep-fat.cod-estabel   = pre-fatur.cod-estabel  
              AND it-dep-fat.nr-sequencia  = it-pre-fat.nr-sequencia 
              AND it-dep-fat.it-codigo     = it-pre-fat.it-codigo    
              AND it-dep-fat.cod-refer     = it-pre-fat.cod-refer    
              AND it-dep-fat.nr-entrega    = it-pre-fat.nr-entrega:

            RUN pi-acompanhar in h-acomp (input "Pre-fatur " + item.it-codigo ).
    
            PUT "Embarque " it-pre-fat.nr-embarque 
                " Pedido " it-pre-fat.nr-pedcli
                " Deposito " it-dep-fat.cod-depos
                " Localizacao " it-dep-fat.cod-localiz
                "qtde Alocada " it-pre-fat.qt-alocada SKIP. 
    
            RUN pi-atualiza-temp-table (INPUT pre-fatur.cod-estabel,
                                        INPUT it-pre-fat.it-codigo,
                                        INPUT it-dep-fat.cod-depos,
                                        INPUT it-dep-fat.cod-localiz,
                                        INPUT it-dep-fat.qt-alocada,
                                        INPUT it-dep-fat.nr-serlote,
                                        INPUT 1).
        END.
    
    
        FOR EACH  wt-fat-ser-lote no-lock //EXCLUSIVE-LOCK
            WHERE wt-fat-ser-lote.it-codigo = item.it-codigo,
            FIRST wt-docto OF wt-fat-ser-lote NO-LOCK
            WHERE wt-docto.nr-pedcli = "":

            RUN pi-acompanhar IN h-acomp (INPUT "wt-fat-ser-lote " + item.it-codigo ).
    
            PUT  "FAT-SER-LOTE Nota Fiscal " wt-fat-ser-lote.seq-wt-docto
                 " Deposito " wt-fat-ser-lote.cod-depos
                 " Quantidade " wt-fat-ser-lote.quantidade[1] SKIP.

            FIND b01-wt-fat-ser-lote WHERE rowid(b01-wt-fat-ser-lote) = rowid(wt-fat-ser-lote) EXCLUSIVE-LOCK NO-ERROR.
                
            IF AVAIL b01-wt-fat-ser-lote THEN
               ASSIGN b01-wt-fat-ser-lote.log-1 = YES.

            RUN pi-atualiza-temp-table (INPUT wt-docto.cod-estabel,
                                        INPUT wt-fat-ser-lote.it-codigo,
                                        INPUT wt-fat-ser-lote.cod-depos,
                                        INPUT wt-fat-ser-lote.cod-localiz,
                                        INPUT wt-fat-ser-lote.quantidade[1],
                                        INPUT wt-fat-ser-lote.lote,
                                        INPUT 1).
        END.

        FOR EACH  fat-ser-lote  //EXCLUSIVE-LOCK
            WHERE fat-ser-lote.it-codigo  = item.it-codigo
              AND fat-ser-lote.nr-seq-fat = it-nota-fisc.nr-seq-fat,
            FIRST nota-fiscal OF fat-ser-lote 
            WHERE nota-fiscal.dt-confirma = ?
            AND   nota-fiscal.dt-cancel   = ? NO-LOCK:
    
            RUN pi-acompanhar IN h-acomp (INPUT "fat-ser-lote " + item.it-codigo ).
    
            PUT  "FAT-SER-LOTE Nota Fiscal " fat-ser-lote.nr-nota-fis
                              " Dt Emissao " b-nota-fiscal.dt-emis-nota
                                " Deposito " fat-ser-lote.cod-depos
                                  " Pedido " b-nota-fiscal.nr-pedcli     FORMAT "x(7)"
                                " qt Baixa " fat-ser-lote.qt-baixada[1] SKIP.

            FIND b01-fat-ser-lote WHERE rowid(b01-fat-ser-lote) = rowid(fat-ser-lote) EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL b01-fat-ser-lote THEN
               ASSIGN b01-fat-ser-lote.log-1 = YES.

            RUN pi-atualiza-temp-table (INPUT b-nota-fiscal.cod-estabel,
                                        INPUT fat-ser-lote.it-codigo,
                                        INPUT fat-ser-lote.cod-depos,
                                        INPUT fat-ser-lote.cod-localiz,
                                        INPUT fat-ser-lote.qt-baixada[1],
                                        INPUT fat-ser-lote.nr-serlote,
                                        INPUT 1).
        END.
                                                                              
        FOR EACH  mgesp.it-ped-fiscal NO-LOCK
            WHERE it-ped-fiscal.it-codigo = item.it-codigo:

            RUN pi-acompanhar IN h-acomp (INPUT "it-ped-fiscal " + item.it-codigo ).

            FIND FIRST mgesp.ped-fiscal EXCLUSIVE-LOCK
                WHERE  ped-fiscal.nr-pedido = it-ped-fiscal.nr-pedido NO-ERROR.
    
            RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                        INPUT it-ped-fiscal.it-codigo,
                                        INPUT it-ped-fiscal.cod-depos,
                                        INPUT it-ped-fiscal.cod-localiz,
                                        INPUT 0,
                                        INPUT "",
                                        INPUT 1).
    
            IF  ped-fiscal.situacao   < 3 AND
                ped-fiscal.dt-emissao >= 03/01/2010  THEN DO:

                PUT "IT-PED-FISCAL " it-ped-fiscal.nr-pedido 
                    " Data Emissao " ped-fiscal.dt-emissao 
                    " Deposito " it-ped-fiscal.cod-depos
                    " Quandidade  " it-ped-fiscal.qtde SKIP.

                /*Aloca‡Æo por lote*/
                IF  item.tipo-con-est = 3 THEN DO:
                    FOR EACH int-saldo-aloc-lote NO-LOCK //EXCLUSIVE-LOCK
                       WHERE int-saldo-aloc-lote.nr-pedido = it-ped-fiscal.nr-pedido
                         AND int-saldo-aloc-lote.it-codigo = it-ped-fiscal.it-codigo
                         AND int-saldo-aloc-lote.seq       = it-ped-fiscal.seq:
        
                        RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                                    INPUT it-ped-fiscal.it-codigo,
                                                    INPUT it-ped-fiscal.cod-depos,
                                                    INPUT it-ped-fiscal.cod-localiz,
                                                    INPUT int-saldo-aloc-lote.qtidade-atu,
                                                    INPUT int-saldo-aloc-lote.lote,
                                                    INPUT 1).
                    END.
                END.
                ELSE DO:
                    RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                                    INPUT it-ped-fiscal.it-codigo,
                                                    INPUT it-ped-fiscal.cod-depos,
                                                    INPUT it-ped-fiscal.cod-localiz,
                                                    INPUT it-ped-fiscal.qtde,
                                                    INPUT "",
                                                    INPUT 1).
                END.
            END.
            ELSE DO:
                IF  ped-fiscal.situacao  <> 4 AND 
                    ped-fiscal.situacao  <> 5 and
                    ped-fiscal.dt-emissao < 03/01/2010  THEN DO:
                    ASSIGN ped-fiscal.situacao = 5.

                    PUT "it-ped-fiscal " it-ped-fiscal.nr-pedido " Situacao alterada para bloqueado" SKIP.

                    RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                                INPUT it-ped-fiscal.it-codigo,
                                                INPUT it-ped-fiscal.cod-depos,
                                                INPUT it-ped-fiscal.cod-localiz,
                                                INPUT 0,
                                                INPUT "",
                                                INPUT 1).
                END.
            END.
        END.
    END.
    
    
    FOR EACH tt-item-alocados:
        FOR EACH  saldo-estoq  NO-LOCK //EXCLUSIVE-LOCK
            WHERE saldo-estoq.it-codigo   = tt-item-alocados.it-codigo
              AND saldo-estoq.cod-estabel = tt-item-alocados.cod-estabel
              AND saldo-estoq.cod-depos   = tt-item-alocados.cod-depos
              AND saldo-estoq.cod-local   = tt-item-alocados.cod-localiz
              AND saldo-estoq.lote        = tt-item-alocados.lote:
    
            RUN pi-acompanhar IN h-acomp (INPUT "Atualizando Quantidade Alocada  " + saldo-estoq.it-codigo ).
          
            ASSIGN l-depos-externo = NO.
           /* RUN pi-depos-externo (INPUT saldo-estoq.cod-depos,
                                  OUTPUT l-depos-externo).*/

            IF l-depos-externo THEN NEXT.
    
            PUT tt-item-alocados.it-codigo " " tt-item-alocados.cod-estabel " " tt-item-alocados.cod-depos " " tt-item-alocados.cod-localiz
                " " tt-item-alocados.quantidade 
                " SALDO-ESTOQ " saldo-estoq.qtidade-atu  saldo-estoq.qt-aloc-ped saldo-estoq.qt-alocada 
                tt-item-alocados.quantidade SKIP.

            FIND b01-saldo-estoq WHERE ROWID(b01-saldo-estoq) = rowid(saldo-estoq) EXCLUSIVE-LOCK NO-ERROR. 
    
            IF AVAIL b01-saldo-estoq THEN
               ASSIGN b01-saldo-estoq.qt-alocada = tt-item-alocados.quantidade.
        END.
    END.
    OUTPUT CLOSE.

    RUN pi-finalizar in h-acomp.
    ASSIGN h-acomp = ?.

    OS-COMMAND NO-WAIT NOTEPAD VALUE(c-arquivo).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-temp-table wWindow 
PROCEDURE pi-atualiza-temp-table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER c-cod-estabel AS CHARACTER                   NO-UNDO.
    DEFINE INPUT PARAMETER c-it-codigo   LIKE it-ped-fiscal.it-codigo   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-depos   LIKE it-ped-fiscal.cod-depos   NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-localiz LIKE it-ped-fiscal.cod-localiz NO-UNDO.
    DEFINE INPUT PARAMETER de-qtde       LIKE it-ped-fiscal.qtde        NO-UNDO.
    DEFINE INPUT PARAMETER p-lote        LIKE int-saldo-aloc-lote.lote  NO-UNDO.
    DEFINE INPUT PARAMETER p-tipo        AS INT                         NO-UNDO. //p-tipo = 1 qt-aloc, p-tipo = 2 qt-aloc-ped.
    
    FIND FIRST tt-item-alocados EXCLUSIVE-LOCK
        WHERE  tt-item-alocados.cod-estabel = c-cod-estabel
          AND  tt-item-alocados.it-codigo   = c-it-codigo
          AND  tt-item-alocados.cod-depos   = c-cod-depos
          AND  tt-item-alocados.cod-localiz = c-cod-localiz 
          AND  tt-item-alocados.lote        = p-lote NO-ERROR.
    IF  NOT AVAIL tt-item-alocados THEN DO:
        CREATE tt-item-alocados.
        ASSIGN tt-item-alocados.cod-estabel = c-cod-estabel
               tt-item-alocados.it-codigo   = c-it-codigo
               tt-item-alocados.cod-depos   = c-cod-depos
               tt-item-alocados.cod-localiz = c-cod-localiz
               tt-item-alocados.lote        = p-lote.
    END.
    
    IF p-tipo = 1 THEN
        ASSIGN tt-item-alocados.quantidade  = tt-item-alocados.quantidade + de-qtde.
    ELSE         
        ASSIGN tt-item-alocados.qt-aloc-ped = tt-item-alocados.qt-aloc-ped + de-qtde.
        
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-depos-externo wWindow 
PROCEDURE pi-depos-externo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM  p-depos         AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-depos-externo AS LOG  NO-UNDO.

ASSIGN p-depos-externo = NO.

FIND FIRST b01-deposito WHERE b01-deposito.cod-depos = p-depos NO-LOCK NO-ERROR. 

IF AVAIL b01-deposito THEN DO:
    //DEPOSITO EXTERNO
   IF b01-deposito.ind-tipo-dep = 2 THEN 
      ASSIGN p-depos-externo = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-execute wWindow 
PROCEDURE pi-execute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fPage0 c-cod-estabel
           INPUT FRAME fPage0 c-serie
           INPUT FRAME fPage0 i-nr-nota-fis
           INPUT FRAME fPage0 c-item.

    IF  c-cod-estabel <> "" AND
        c-serie       <> "" AND
        i-nr-nota-fis <> 0  THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 27100,
                           INPUT "A corre‡Æo da aloca‡Æo ser  feita para a nota fiscal " + STRING(i-nr-nota-fis) + ". Confima?").
        IF  RETURN-VALUE = "YES" THEN
            RUN pi-alocacao-nota.
    END.

    IF  c-item <> "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 27100,
                           INPUT 'A corre‡Æo da aloca‡Æo ser  feita para o item "' + c-item + '". Confirma?').
        IF  RETURN-VALUE = "YES" THEN
            RUN pi-alocacao-item.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

