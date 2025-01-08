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
{include/i-prgvrs.i ESCEP042RP 1.00.00.000}

/* ***************************  Definitions  ************************** */
&global-define programa ESCEP042RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.
def var c-itens-com-saldo            as char format "x(30)" no-undo.

{esp/cep/escep042tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    

form
/*form-selecao-ini*/
    skip(1)
    c-liter-sel         no-label
    skip(1)
    /*form-selecao-usuario*/
    tt-param.fm-codigo-ini format "x(8)" label "Fam¡lia" colon 40
    " <| |> " at 60
    tt-param.fm-codigo-fim format "x(8)" no-label skip
    tt-param.it-codigo-ini format "x(16)" label "Item" colon 40
    " <| |> " at 60
    tt-param.it-codigo-fim format "x(16)" no-label
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
    c-liter-par         no-label
    skip(1)
    /*form-parametro-usuario*/
    c-itens-com-saldo label "Itens com Saldo" colon 40 skip
    tt-param.cod-depos format "x(3)" label "Dep¢sito" colon 40 skip
    tt-param.cod-estabel label "Estabelecimento" colon 40
    skip(1)
/*form-parametro-fim*/
/*form-impressao-ini*/
    skip(1)
    c-liter-imp         no-label
    skip(1)
    c-destino           colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

form
    /*campos-do-relatorio*/
     with no-box width 132 down stream-io frame f-relat.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*inicio-traducao*/
/*traducao-default*/
{utp/ut-liter.i PAR¶METROS * r}
assign c-liter-par = return-value.
{utp/ut-liter.i SELE€ÇO * r}
assign c-liter-sel = return-value.
{utp/ut-liter.i IMPRESSÇO * r}
assign c-liter-imp = return-value.
{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-impressao = return-value.
{utp/ut-liter.i Usu rio * l}
assign tt-param.usuario:label in frame f-impressao = return-value.   
/*fim-traducao*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find mgcad.empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Divergˆncias_no_Saldo_de_Estoque * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}
       c-itens-com-saldo = entry(tt-param.ind-itens-com-saldo, "Errado,Correto em localiza‡Æo errada").

def temp-table tt-itens
    field it-codigo like item.it-codigo
    field tipo as int
    field localizacao like item.cod-localiz label "Localizacao"
    field saldo-local like saldo-estoq.qtidade-atu label "Saldo Local"
    field saldo-ae-local like saldo-estoq.qtidade-atu label "Saldo AE"
    field diferenca as dec label "Diferenca" format "->>>,>>>,>>9.9999"
    index codigo is primary it-codigo localizacao.
    
def buffer b-itens for tt-itens.

def var de-saldo-alm as dec label "Saldo ALM" format ">>>>,>>>,>>9.99" no-undo. 
def var de-saldo-rec as dec label "Saldo REC" format ">>>>,>>>,>>9.99" no-undo.
def var de-saldo-ae  as dec label "Saldo AE"  format ">>>>,>>>,>>9.99" no-undo.
def var de-saldo-total as dec no-undo.

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

do on stop undo, leave:
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 
    
    for each item no-lock
       where item.fm-codigo >= tt-param.fm-codigo-ini
          and item.fm-codigo <= tt-param.fm-codigo-fim
          and item.it-codigo >= tt-param.it-codigo-ini
          and item.it-codigo <= tt-param.it-codigo-fim
          and not item.it-codigo begins "203" 
          and not item.it-codigo begins "210":
          
       run pi-acompanhar in h-acomp (input "Item: " + item.it-codigo).

        for each saldo-estoq no-lock
           where saldo-estoq.cod-estabel = tt-param.cod-estabel
             and saldo-estoq.cod-depos   = tt-param.cod-depos
             and saldo-estoq.it-codigo   = item.it-codigo:

            create tt-itens.
            assign tt-itens.it-codigo = saldo-estoq.it-codigo
                   tt-itens.tipo      = 1
                   tt-itens.localizacao = saldo-estoq.cod-localiz
                   tt-itens.saldo-local = saldo-estoq.qtidade-atu.
        end.
                                                  
        for each ae-item  no-lock
           where ae-item.cod-estabel = tt-param.cod-estabel
             and ae-item.it-codigo = item.it-codigo
             and ae-item.situacao = no
             and ae-item.cod-depos = tt-param.cod-depos:

           run pi-acompanhar in h-acomp (input "Item: " + ae-item.it-codigo).

            find tt-itens
                 where tt-itens.it-codigo = ae-item.it-codigo
                   and tt-itens.localizacao = ae-item.localizacao
                   /* if tt-param.cod-depos = "alm" then
                                                 ae-item.localizacao
                                              else
                                                 "" */ no-error.
            if not avail tt-itens then do:
                create tt-itens.
                assign tt-itens.it-codigo = ae-item.it-codigo
                       tt-itens.tipo      = 1             
                       tt-itens.localizacao = ae-item.localizacao.
                       /* if tt-param.cod-depos = "alm" then
                                                 ae-item.localizacao
                                              else
                                                 "" no-error. */
            end.
            assign tt-itens.saldo-ae-local = tt-itens.saldo-ae-local + 
                   ae-item.quantidade.
        end.
    end.  
    assign de-saldo-total = 0.

    for each tt-itens break by tt-itens.it-codigo:
         assign tt-itens.diferenca = tt-itens.saldo-local - 
                                     tt-itens.saldo-ae-local.
                                     
         assign de-saldo-total = de-saldo-total + tt-itens.diferenca.
         
         if last-of(tt-itens.it-codigo) and de-saldo-total = 0 then do:
            for each b-itens where
                b-itens.it-codigo = tt-itens.it-codigo:
                assign b-itens.tipo = 2.
            end.
         end.
            
         if last-of(tt-itens.it-codigo) then
            assign de-saldo-total = 0.
    end.


    for each tt-itens where 
        tt-itens.diferenca <> 0 and
        tt-itens.tipo = tt-param.ind-itens-com-saldo
       break by tt-itens.it-codigo:
        
        view frame f-cabec.
        view frame f-rodape.
        find item where item.it-codigo = tt-itens.it-codigo.   
        disp item.it-codigo format "x(7)" label "Item"
             item.descricao-1 + 
             item.descricao-2 format "x(36)" label "Descri‡Æo"
             tt-itens.localizacao label "Loc F¡sica"
             tt-itens.saldo-local label "Saldo Local"
             tt-itens.saldo-ae-local label "Saldo AE"
             tt-itens.diferenca label "Diferen‡a"
             "Est. > AE" when tt-itens.saldo-local > tt-itens.saldo-ae-local
             "AE > Est." when tt-itens.saldo-local < tt-itens.saldo-ae-local
             skip with width 132 no-labels stream-io.
        if last-of(tt-itens.it-codigo) and tt-param.ind-itens-com-saldo = 2 then 
           put fill("-",130) format "x(130)".

        if tt-param.ind-itens-com-saldo = 1 then
           put fill("-",130) format "x(130)".
    end.     
    
    run pi-finalizar in h-acomp.
    
    page.
    
    disp c-liter-sel
         tt-param.cod-depos 
         tt-param.fm-codigo-ini 
         tt-param.fm-codigo-fim 
         tt-param.it-codigo-ini 
         tt-param.it-codigo-fim 
         c-liter-par         
         c-itens-com-saldo 
         tt-param.cod-estabel 
         c-liter-imp
         c-destino
         tt-param.arquivo   
         tt-param.usuario
         with frame f-impressao.
    
    {include/i-rpclo.i}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


