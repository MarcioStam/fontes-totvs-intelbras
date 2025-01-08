&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP020RP 2.04.00.001}

/* ***************************  Definitions  ************************** */
&global-define programa ESCCP020RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.

{esp/ccp/esccp020tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    
def var i-ind as int no-undo.

form
/*form-selecao-ini*/
    skip(1)
    "SELE€ÇO"         
    skip(1)
    /*form-selecao-usuario*/
    tt-param.cod-estabel COLON 40 LABEL "Estab" SKIP
    tt-param.item-ini colon 40 label "Item" 
    "<|   |>" at 75 tt-param.item-fim no-label skip
    tt-param.data-ini colon 40 label "Data" 
    "<|   |>" at 75 tt-param.data-fim no-label skip
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
/*form-parametro-fim*/
/*form-impressao-ini*/
    skip(1)
    "IMPRESSÇO"
    skip(1)
    c-destino           label "Destino" colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    label "Usu rio" colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

{include/i-rpvar.i}

find mgcad.empresa
    where empresa.ep-codigo = "1"
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Elimina‡Æo_de_Ordens_de_Compra * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{include/i-rpcab.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
find first tt-param no-error.
do on stop undo, leave:
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 
    
    run piReport (INPUT 1).
    run piReport (INPUT 3).
    run piReport (INPUT 5).

    if tt-param.imprime-par then do:
        page.
        disp tt-param.cod-estabel
             tt-param.item-ini 
             tt-param.data-ini 
             tt-param.item-fim 
             tt-param.data-fim 
             c-destino           
             tt-param.arquivo    
             tt-param.usuario 
             with frame f-impressao.   
    end.
    
    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "ok".
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReport Procedure 
PROCEDURE piReport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-situacao LIKE ordem-compra.situacao NO-UNDO.

    /* Eliminando OCïs */
    for each ordem-compra EXCLUSIVE-LOCK
       where ordem-compra.cod-estabel  = tt-param.cod-estabel
         AND ordem-compra.it-codigo   >= tt-param.item-ini
         AND ordem-compra.it-codigo   <= tt-param.item-fim
         AND ordem-compra.situacao     = p-situacao:
        
        FIND ITEM WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            disp "Item nÆo encontrado "
                 ordem-compra.numero-ordem
                 ordem-compra.it-codigo
                  with row 3 centered 12 down frame f-dados stream-io no-box.
            NEXT.
        END.

        IF ITEM.tipo-contr <> 2 THEN NEXT.

        run pi-acompanhar in h-acomp (input "Eliminando OC " + STRING(ordem-compra.numero-ordem)). 

        disp ordem-compra.numero-ordem
             ordem-compra.it-codigo
              with row 3 centered 12 down frame f-dados stream-io no-box.

        FOR each prazo-compra EXCLUSIVE-LOCK
           where prazo-compra.numero-ordem  = ordem-compra.numero-ordem
             and prazo-compra.data-entrega >= tt-param.data-ini
             and prazo-compra.data-entrega <= tt-param.data-fim:
            DELETE prazo-compra.
        END.

        for each cotacao-item
           where cotacao-item.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
            delete cotacao-item.
        end.

        delete ordem-compra.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

