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
{include/i-prgvrs.i ESCEP031RP 2.04.00.001}

/* ***************************  Definitions  ************************** */
&global-define programa ESCEP031RP

{esp/cep/escep031tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    
def var c-destino                    as character format "x(15)":U.
def var c-obs-ini as char format "x(31)" no-undo. 
def var c-obs-fim as char format "x(31)" no-undo.

form
/*form-selecao-ini*/
    skip(1)
    "SELE€ÇO"         
    skip(1)
    /*form-selecao-usuario*/
    tt-param.tipo-ini colon 40 label "Tipo" 
    "<|   |>" at 75 tt-param.tipo-fim no-label skip
    tt-param.loc-ini colon 40 label "Localiza‡Æo" 
    "<|   |>" at 75 tt-param.loc-fim no-label skip
    tt-param.it-ini colon 40 label "Item" 
    "<|   |>" at 75 tt-param.it-fim no-label skip
    c-obs-ini colon 40 label "Obsoleto" 
    "<|   |>" at 75 c-obs-fim no-label skip
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
    "PAR¶METROS"
    skip(1)
    /*form-parametro-usuario*/
    tt-param.depos colon 40 label "Dep¢sito" skip
    tt-param.detalhado colon 40 label "Tipo" skip
    tt-param.saldo colon 40 label "Imprimir Local" skip
    tt-param.qtde colon 40 label "Imprimir" skip
    tt-param.dt-inv colon 40 label "Data Invent rio" skip
    skip(1)
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
    where empresa.ep-codigo = '1'
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio_de_Saldos_por_Localiza‡Æo * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}
       c-obs-ini     = string(tt-param.obs-ini) + " - " + {ininc/i17in172.i 04 tt-param.obs-ini}
       c-obs-fim     = string(tt-param.obs-fim) + " - " + {ininc/i17in172.i 04 tt-param.obs-fim}.

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
    
    run piReport in this-procedure.
    
    if tt-param.imprime-par then do:
        page.
        disp tt-param.tipo-ini 
             tt-param.loc-ini 
             tt-param.it-ini 
             c-obs-ini 
             tt-param.tipo-fim 
             tt-param.loc-fim 
             tt-param.it-fim 
             c-obs-fim 
             tt-param.depos 
             tt-param.detalhado 
             tt-param.saldo 
             tt-param.qtde 
             tt-param.dt-inv 
             c-destino           
             tt-param.arquivo    
             tt-param.usuario 
             with frame f-impressao.   
    end.
    
    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}
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
    def var l-tem-saldo as logi no-undo.
    
    for each local no-lock
       where local.cod-depos = tt-param.depos
         and local.localizacao >= tt-param.loc-ini
         and local.localizacao <= tt-param.loc-fim
         and local.cod-tipo    >= tt-param.tipo-ini
         and local.cod-tipo    <= tt-param.tipo-fim:
         
        run pi-acompanhar in h-acomp (input "Local: " + local.localizacao). 
       
        assign l-tem-saldo = no.
       
        for  each saldo-estoq  no-lock
         where saldo-estoq.cod-estabel = "101"
             and saldo-estoq.cod-depos   = tt-param.depos
             and saldo-estoq.cod-localiz = local.localizacao
             and saldo-estoq.qtidade-atu > 0:
            assign l-tem-saldo = yes.
        end.

        if tt-param.saldo and l-tem-saldo then 
           disp local.cod-depos column-label "Dep¢sito"
                local.localizacao column-label "Localiza‡Æo"
                with stream-io no-box.
             
        if not tt-param.saldo and not l-tem-saldo then
                disp local.cod-depos column-label "Dep¢sito"
                local.localizacao column-label "Localiza‡Æo"
                with stream-io no-box.
         
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

