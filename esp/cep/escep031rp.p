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
def var i-nr-ae      like ae-item.nr-ae format ">>>>>>9" extent 7 no-undo.
def var i-quantidade like ae-item.quantidade extent 7 format ">>>>>" no-undo.
def var i-sequencia  like ae-item.sequencia format ">>9" extent 7 no-undo.
def var i-ind as int no-undo.

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
    def var l-primeiro as logi no-undo.
        
    if tt-param.saldo then do:
        for each local no-lock
            where local.cod-estabel = tt-param.cod-estabel
              and local.cod-depos = tt-param.depos
              and local.localizacao >= tt-param.loc-ini
              and local.localizacao <= tt-param.loc-fim
              and local.cod-tipo    >= tt-param.tipo-ini
              and local.cod-tipo    <= tt-param.tipo-fim,
            each saldo-estoq  no-lock
                where saldo-estoq.cod-estabel = tt-param.cod-estabel
                  and saldo-estoq.cod-depos   = tt-param.depos
                  and saldo-estoq.cod-localiz = local.localizacao
                  and saldo-estoq.qtidade-atu > 0,
            each item no-lock
                where item.it-codigo = saldo-estoq.it-codigo
                      and item.cod-obsoleto >= tt-param.obs-ini 
                      and item.cod-obsoleto <= tt-param.obs-fim
                      and item.it-codigo >= tt-param.it-ini
                      and item.it-codigo <= tt-param.it-fim
                break by local.cod-estabel
                      by local.cod-depos
                      by local.localizacao
                      by saldo-estoq.it-codigo:
             
            run pi-acompanhar in h-acomp (input "Item: " + item.it-codigo).
            
            if dt-inv <> ? then do:
               find first inventario no-lock where
                    inventario.dt-saldo = dt-inv and
                    inventario.cod-estabel = tt-param.cod-estabel and
                    inventario.cod-depos = tt-param.depos and
                    inventario.cod-localiz = local.localizacao and
                    inventario.it-codigo = item.it-codigo no-error.
               if not avail inventario then next.  
            end.
      
            if first-of(local.cod-depos) then 
                disp local.cod-depos column-label "Dep¢sito" with stream-io no-box.
            
            if first-of(local.localizacao) then 
                disp local.localizacao column-label "Localiza‡Æo" with stream-io no-box.
      
            
            disp item.it-codigo
                 item.descricao-1 + item.descricao-2 format "x(36)" label
                      "Descri‡Æo"
                 {ininc/i17in172.i 04 item.cod-obsoleto} format "x(31)" column-label "Situa‡Æo"
                 saldo-estoq.qtidade-atu when tt-param.qtde with width 132 stream-io no-box.
            
            if tt-param.detalhado then do:
                assign i-ind = 0.
                assign l-primeiro = yes.
                
                for each ae-item no-lock
                    where ae-item.cod-estabel = tt-param.cod-estabel
                      and ae-item.it-codigo   = item.it-codigo
                      and ae-item.localizacao = local.localizacao
                      and ae-item.situacao    = no
                       by ae-item.data
                       by ae-item.nr-ae
                       by ae-item.sequencia:
            
                    if l-primeiro = yes then put skip(1).
                        
                    assign l-primeiro = no.
                    assign i-ind = i-ind + 1.
                    assign i-nr-ae[i-ind] = ae-item.nr-ae
                           i-sequencia[i-ind] = ae-item.sequencia
                           i-quantidade[i-ind] = if tt-param.qtde then
                                                    ae-item.quantidade
                                                 else 
                                                    0.
            
                    if i-ind = 7 then do:
                        run put-ae.
                    end.
                end. 
                if i-ind > 0 then do:
                    run put-ae.
                end.
            end.
            
        end.   
    end.
    ELSE DO:
        for each local no-lock
            where local.cod-estabel = tt-param.cod-estabel
              and local.cod-depos = tt-param.depos
              and local.localizacao >= tt-param.loc-ini
              and local.localizacao <= tt-param.loc-fim
              and local.cod-tipo    >= tt-param.tipo-ini
              and local.cod-tipo    <= tt-param.tipo-fim:
            
            IF CAN-FIND (FIRST saldo-estoq  no-lock
                where saldo-estoq.cod-estabel = local.cod-estabel
                  and saldo-estoq.cod-depos   = local.cod-depos
                  and saldo-estoq.cod-localiz = local.localizacao
                  AND saldo-estoq.qtidade-atu > 0) THEN NEXT.
            
            disp local.cod-depos column-label "Dep¢sito"
                 local.localizacao column-label "Localiza‡Æo" 
                 with stream-io no-box.
            
        END.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-put-ae) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE put-ae Procedure 
PROCEDURE put-ae :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    put  i-nr-ae[1] " "
         i-sequencia[1] " "
         i-quantidade[1] " |"
    
         i-nr-ae[2] " "
         i-sequencia[2] " "
         i-quantidade[2] " |"
    
         i-nr-ae[3] " "
         i-sequencia[3] " "
         i-quantidade[3] " |"
         
         i-nr-ae[4] " "
         i-sequencia[4] " "
         i-quantidade[4] " |"
    
         i-nr-ae[5] " "
         i-sequencia[5] " "
         i-quantidade[5] " |"
    
         i-nr-ae[6] " "
         i-sequencia[6] " "
         i-quantidade[6] " |"
    
         i-nr-ae[7] " "
         i-sequencia[7] " "
         i-quantidade[7] skip(1).
    
    assign i-ind = 0
           i-nr-ae = 0
           i-sequencia = 0
           i-quantidade = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

