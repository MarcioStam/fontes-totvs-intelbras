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
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP043RP 1.00.00.000}

/* ***************************  Definitions  ************************** */
&global-define programa ESCEP043RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.
def var c-obsoleto-ini               as char format "x(30)" no-undo.
def var c-obsoleto-fim               as char format "x(30)" no-undo.
def var c-tipo                       as char format "x(30)" no-undo.
def var c-imprimir                   as char format "x(30)" no-undo.
def var c-imprime-local              as char format "x(30)" no-undo.
DEFINE VARIABLE l-achou-baixa        AS LOGICAL     NO-UNDO.
{esp/cep/escep043tt.i}

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
    tt-param.cod-tipo-ini format ">>9" label "C¢digo Tipo" colon 40
    " <| |> " at 60
    tt-param.cod-tipo-fim format ">>9" no-label skip
    tt-param.cod-localiz-ini format "x(10)" label "Localiza‡Æo" colon 40
    " <| |> " at 60
    tt-param.cod-localiz-fim format "x(10)" no-label skip
    tt-param.it-codigo-ini format "x(16)" label "Item" colon 40 
    " <| |> " at 60
    tt-param.it-codigo-fim format "x(16)" no-label skip
    c-obsoleto-ini label "Obsoleto" colon 40
    " <| |> " at 60
    c-obsoleto-fim no-label 
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
    c-liter-par         no-label
    skip(1)
    /*form-parametro-usuario*/
    tt-param.cod-depos format "x(3)" label "Dep¢sito" colon 40 skip
    tt-param.cod-estabel label "Estabelecimento" colon 40 skip
    c-tipo colon 40 label "Tipo" skip
    c-imprimir colon 40 label "Imprimir" skip
    c-imprime-local colon 40 label "Imprimir Local"
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

find empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio_de_Saldos_por_Localiza‡Æo * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}
       c-obsoleto-ini = {ininc/i17in172.i 04 tt-param.cod-obsoleto-ini}
       c-obsoleto-fim = {ininc/i17in172.i 04 tt-param.cod-obsoleto-fim}
       c-tipo         = entry(tt-param.ind-tipo, "Resumido,Detalhado")
       c-imprimir     = entry(tt-param.ind-imprimir, "Sem Quantidade,Com Quantidade")
       c-imprime-local = entry(tt-param.ind-imprime-local, "Dispon¡vel,Ocupada").

def var i-ind as int no-undo.
def var l-primeiro as logical no-undo.
def var i-nr-ae      like ae-item.nr-ae format ">>>>>>9" extent 7 no-undo.
def var i-sequencia  like ae-item.sequencia format ">>9" extent 7 no-undo.
def var i-quantidade like ae-item.quantidade extent 7 format ">>>>>" no-undo.
def var l-tem-saldo as logical no-undo.

{include/tt-edit.i}
{include/pi-edit.i}

def temp-table tt-relat no-undo
    field localizacao  like local.localizacao
    field it-codigo    like item.it-codigo
    field cod-depos    like local.cod-depos
    field desc-item    like tt-editor.conteudo
    field cod-obsoleto like item.cod-obsoleto
    field qtidade-atu  like saldo-estoq.qtidade-atu
    index relat cod-depos localizacao it-codigo.

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
   Other Settings: CODE-ONLY
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
    
    if tt-param.ind-disponibilidade = 1 then do:
        for each local no-lock use-index codigo
           where local.cod-estabel = tt-param.cod-estabel
             and local.cod-depos = tt-param.cod-depos
             and local.localizacao >= tt-param.cod-localiz-ini
             and local.localizacao <= tt-param.cod-localiz-fim
             and local.cod-tipo    >= tt-param.cod-tipo-ini
             and local.cod-tipo    <= tt-param.cod-tipo-fim,
            each saldo-estoq  no-lock
           where saldo-estoq.cod-estabel = tt-param.cod-estabel
             and saldo-estoq.cod-depos   = local.cod-depos
             and saldo-estoq.cod-localiz = local.localizacao
             and saldo-estoq.it-codigo   >= tt-param.it-codigo-ini
             and saldo-estoq.it-codigo   <= tt-param.it-codigo-fim,
            each item no-lock
           where item.it-codigo = saldo-estoq.it-codigo
             and item.cod-obsoleto >= tt-param.cod-obsoleto-ini 
             and item.cod-obsoleto <= tt-param.cod-obsoleto-fim:

           run pi-acompanhar in h-acomp (input "Local: " + local.localizacao).

            if tt-param.dt-saldo <> ? then do:
               find first inventario no-lock where
                    inventario.dt-saldo = tt-param.dt-saldo and
                    inventario.cod-estabel = tt-param.cod-estabel and
                    inventario.cod-depos = tt-param.cod-depos and
                    inventario.cod-localiz = local.localizacao and
                    inventario.it-codigo = item.it-codigo no-error.
               if not avail inventario then next.  
            end.
            
            run pi-print-editor (item.desc-item, 36).
            create tt-relat.
            assign tt-relat.localizacao  = local.localizacao
                   tt-relat.it-codigo    = item.it-codigo
                   tt-relat.cod-depos    = local.cod-depos
                   tt-relat.desc-item    = tt-editor.conteudo
                   tt-relat.cod-obsoleto = item.cod-obsoleto
                   tt-relat.qtidade-atu  = saldo-estoq.qtidade-atu.
                   
        end.
        
        for each tt-relat
            break by tt-relat.cod-depos
                  by tt-relat.localizacao
                  by tt-relat.it-codigo:           
          
           run pi-acompanhar in h-acomp (input "Local: " + tt-relat.localizacao).

           if first-of(tt-relat.cod-depos) then 
                disp tt-relat.cod-depos with stream-io.
            
           if first-of(tt-relat.localizacao) then 
                disp tt-relat.localizacao with stream-io.

           if tt-param.ind-imprime-local = 2 then do:    

            disp tt-relat.it-codigo
                 tt-relat.desc-item format "x(36)" label
                      "Descri‡Æo"
                 tt-relat.cod-obsoleto 
                 tt-relat.qtidade-atu when tt-param.ind-imprimir = 2 with width 132 with stream-io.
                 
            if tt-param.ind-tipo = 2 then do:
                assign i-ind = 0.
                assign l-primeiro = yes.
                for each ae-item no-lock
                   where ae-item.cod-estabel = tt-param.cod-estabel
                     and ae-item.it-codigo   = tt-relat.it-codigo
                     and ae-item.localizacao = tt-relat.localizacao
                     and ae-item.situacao    = no
                      by ae-item.data
                      by ae-item.nr-ae
                      by ae-item.sequencia:

                    if l-primeiro = yes then put skip(1).
                    
                    assign l-primeiro = no.
                    assign i-ind = i-ind + 1.
                    assign i-nr-ae[i-ind] = ae-item.nr-ae
                           i-sequencia[i-ind] = ae-item.sequencia
                           i-quantidade[i-ind] = if tt-param.ind-imprimir = 2 then
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

    end.    
    else do:
        for each local NO-LOCK USE-INDEX dep-local
           where local.cod-estabel  = tt-param.cod-estabel
             and local.cod-depos    = tt-param.cod-depos
             and local.localizacao >= tt-param.cod-localiz-ini
             and local.localizacao <= tt-param.cod-localiz-fim
             and local.cod-tipo    >= tt-param.cod-tipo-ini
             and local.cod-tipo    <= tt-param.cod-tipo-fim:
  
            run pi-acompanhar in h-acomp (input "Local: " + local.localizacao).

            /*
            ASSIGN l-achou-baixa = NO.

            FOR EACH ae-item NO-LOCK USE-INDEX deposito
                WHERE ae-item.cod-estabel = local.cod-estabel
                AND   ae-item.cod-depos   = local.cod-depos
                AND   ae-item.localizacao = local.localizacao,

            FIRST ae-baixa NO-LOCK
                WHERE ae-baixa.nr-ae = ae-item.nr-ae
                AND   ae-baixa.sequencia = ae-item.sequencia:

                ASSIGN l-achou-baixa = YES.
                LEAVE.

            END.

            IF l-achou-baixa  THEN NEXT.
            */

            assign l-tem-saldo = no.
  
            for  FIRST saldo-estoq  NO-LOCK USE-INDEX dep-estabel
                where saldo-estoq.cod-depos   = tt-param.cod-depos
                AND   saldo-estoq.cod-estabel = tt-param.cod-estabel
                and   saldo-estoq.cod-localiz = local.localizacao
                and   saldo-estoq.qtidade-atu > 0:

                assign l-tem-saldo = yes.

            end.
  
            if tt-param.ind-imprime-local = 2 and l-tem-saldo then
               disp local.cod-depos local.localizacao with stream-io.
  
            if tt-param.ind-imprime-local = 1 and not l-tem-saldo then
                    disp local.cod-depos local.localizacao with stream-io.
  
        end.
    
    end.
    
    run pi-finalizar in h-acomp.
    
    page.
    
    disp c-liter-sel
         tt-param.cod-depos 
         tt-param.cod-tipo-ini 
         tt-param.cod-tipo-fim
         tt-param.cod-localiz-ini 
         tt-param.cod-localiz-fim 
         tt-param.it-codigo-ini 
         tt-param.it-codigo-fim 
         c-obsoleto-ini 
         c-obsoleto-fim 
         c-liter-par         
         c-tipo
         c-imprimir
         c-imprime-local 
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


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-put-ae) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE put-ae Procedure 
PROCEDURE put-ae PRIVATE :
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

