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

{include/i-prgvrs.i ESIMP005RP 1.00.00.000}

/* ***************************  Definitions  ************************** */
&global-define programa ESIMP005RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.
def var c-tipo                       as char format "x(30)" no-undo.
DEF VAR c-periodo                    AS CHAR NO-UNDO.
DEF VAR de-desp-total                AS DEC FORMAT ">,>>>,>>>,>>9.99" NO-UNDO.
{esp/imp/esimp005tt.i}
{esp/es0018.i}

DEFINE TEMP-TABLE tt-excessao-nat NO-UNDO
    FIELD nat-operacao AS CHARACTER
    INDEX chave nat-operacao.

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    

DEFINE BUFFER bf-docum-est      FOR docum-est.
DEFINE BUFFER bf-item-doc-est   FOR item-doc-est.

form
/*form-selecao-ini*/
    skip(1)
    c-liter-sel         no-label
    skip(1)
    /*form-selecao-usuario*/
    tt-param.data-fi-ini format "99/99/9999" label "Data FI" colon 40
    " <| |> " at 60
    tt-param.data-fi-fim format "99/99/9999" no-label 
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
    c-liter-par         no-label
    skip(1)
    /*form-parametro-usuario*/
    tt-param.log-estrutura format "Sim/N∆o" label "Por Estrutura?" colon 40 skip
    c-tipo colon 40 label "Relat¢rio" skip
    tt-param.log-excel format "Sim/N∆o" label "Arquivo para Excel?" colon 40 skip
    tt-param.cotacao format ">>>9.99999" colon 40 label "Cotaá∆o" skip
    tt-param.pis format "9.99" colon 40 label "PIS" skip
    tt-param.cofins format "9.99" colon 40 label "COFINS" skip
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
{utp/ut-liter.i PAR∂METROS * r}
assign c-liter-par = return-value.
{utp/ut-liter.i SELEÄ«O * r}
assign c-liter-sel = return-value.
{utp/ut-liter.i IMPRESS«O * r}
assign c-liter-imp = return-value.
{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-impressao = return-value.
{utp/ut-liter.i Usu†rio * l}
assign tt-param.usuario:label in frame f-impressao = return-value.   
/*fim-traducao*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec°ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio_de_Preáo_FOB/CIF_p/_Produto * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}
       c-tipo         = entry(tt-param.ind-tipo, "Anal°tico,SintÇtico").

{include/tt-edit.i}
{include/pi-edit.i}

def var i-num-casa-dec   as int no-undo.
def var de-fator-conver  as dec no-undo.
def var i-cont           as int no-undo.
def var de-preco-fob     as dec no-undo.
def var de-fi            as dec format ">>>9.99999" NO-UNDO.
DEF VAR de-fi-total      AS DEC format ">>>9.99999" NO-UNDO.
def var de-qtde          as dec no-undo.
def var c-nome-abrev     like emitente.nome-abrev no-undo.
def var l-nacional       as log no-undo.
def var de-nacional      as dec format ">>,>>>,>>9.9999" no-undo.
def var de-importado     as dec format ">>,>>>,>>9.9999" no-undo.
def var de-fob-US$-nac   as dec format ">>>,>>9.99999" no-undo.
def var de-cif-us$-nac   as dec format ">>>,>>9.99999" no-undo.
def var de-cif-r$-nac    as dec format ">>>,>>9.99999" no-undo.
def var de-fob-US$-imp   as dec format ">>>9.99999" no-undo.
def var de-cif-us$-imp   as dec format ">>>9.99999" no-undo.
def var de-cif-r$-imp    as dec format ">>>9.99999" no-undo.
def var de-fob-US$-tot   as dec format ">>>9.99999" no-undo.
def var de-cif-us$-tot   as dec format ">>>9.99999" no-undo.
def var de-cif-r$-tot    as dec format ">>>9.99999" no-undo.
def var c-descricao      as char format "X(36)" no-undo.
def var de-preco         as dec no-undo.
def var de-tmp           as dec no-undo.
def var de-val-unit      as dec format ">>9.9999" no-undo.
def var de-val-mat       as dec format ">>>>9.9999" no-undo.
def var de-val-mob       as dec format ">>>>9.9999" no-undo.
def var de-val-ggf       as dec format ">>>>9.9999" no-undo.
def var de-fob-US$-nac-geral as dec format ">>>,>>9.99999" no-undo.
def var de-cif-us$-nac-geral as dec format ">>>,>>9.99999" no-undo.
def var de-cif-r$-nac-geral as dec format ">>>,>>9.99999" no-undo.
def var de-val-unit-geral as dec format ">>>>9.9999" no-undo.
def var de-val-mat-geral as dec format ">>>>9.9999" no-undo.
DEF VAR de-val-nc LIKE item-doc-est.preco-unit[1] NO-UNDO.


form item.it-codigo format "X(08)" label "       Produto"
     c-descricao format "X(36)" no-label skip(1)
     tt-param.cotacao format ">>>9.99999" label "       Dolar Digitado" skip(1)
     "    FOB US$" at 28
     "    CIF US$" at 43
     "     CIF R$" at 58 skip
     " Valor Nacional " 
     de-fob-us$-nac at 30 
     de-cif-us$-nac at 45
     de-cif-r$-nac  at 60 skip
     "Valor Importado " 
     de-fob-us$-imp at 30
     de-cif-us$-imp at 45
     de-cif-r$-imp  at 60 skip(1)
     "    VALOR TOTAL " 
     de-fob-us$-tot format ">>>>>9.99999" at 30
     de-cif-us$-tot format ">>>>>9.99999" at 45
     de-cif-r$-tot  format ">>>>>9.99999" at 60 skip(1)
     "Obs: partindo de FOB"
     with frame f-sintetico row 5 centered side-label no-labels
          title "Total SintÇtico" stream-io.
          
def temp-table tt-est no-undo
    field it-codigo    like estrutura.it-codigo
    field descricao    as char format "x(36)" label "Descriá∆o"
    field qtde         as dec format ">>>9.99999"
    index tt-est is primary unique it-codigo.
    
def temp-table tt-imp no-undo
    field nac-imp        as log
    FIELD existe-uma-imp AS LOG
    field it-codigo     as char format "X(07)"     label "Item"
    field descricao     as char format "X(35)"     label "Descriá∆o"
    field class-fiscal  like item.class-fiscal
    field qtde          as dec format ">>>>>9.99999" label "Qtde"
    field de-preco-fob  as dec format ">>>9.99999" label "Custo FOB"
    field de-fi         as dec format ">>>9.99999"   label "FI"
    FIELD de-fi-total     AS DEC FORMAT ">>>9.99999"   LABEL "Èltimo FI"
    field de-fob-us$    as dec format ">>>>9.99999"  label "FOB US$"
    field de-cif-us$    as dec format ">>>>9.99999"  label "CIF US$"
    field de-cif-r$     as dec format ">>>>9.99999"  label "CIF R$"
    field val-unit-mat  as dec format ">>>>9.9999" label "MÇdio"
    field preco-ul-ent  as dec format ">>9.9999"   label "Ult Entrada"
    field un            as char format "X(02)"     label "Un"
    field nome-abrev  as char format "X(12)"       label "Fornecedor"
    FIELD periodo-fixo LIKE ITEM.periodo-fixo
    FIELD res-for-comp LIKE ITEM.res-for-comp
    FIELD horiz-fixo   LIKE ITEM.horiz-fixo
    FIELD horiz-lib    LIKE ITEM.horiz-fixo
    FIELD tp-despesa   LIKE ITEM.tp-desp-padrao
    FIELD deposito-alm LIKE ITEM.deposito-pad
    FIELD numero        AS INTEGER
    index tt-imp is primary nac-imp it-codigo
    INDEX chave2 it-codigo.
              
def buffer b-estrutura for estrutura.

ASSIGN c-periodo = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99").

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
         HEIGHT             = 11.71
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
    if not tt-param.log-excel then do:
        view frame f-cabec.
        view frame f-rodape.    
    end.    
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 
    
    if tt-param.log-excel then do:
       put space(50) "   V A L O R E S    F  O  B "
           space(10) " V A L O R E S    C  I  F  (U S $) "
           space(10) " V A L O R E S    C  I  F  (R $) " skip
           "C¢digo  Descriá∆o                            "
           "     Nacional  Importado      Total " 
           "         Nacional  Importado      Total "
           "             Nacional  Importado      Total " skip. 
    end.
  
    if tt-param.log-estrutura then do:
       for each tt-digita:
       
           run pi-acompanhar in h-acomp (input "Item: " + tt-digita.it-codigo).

           for each tt-est:
               delete tt-est.
           end.
    
           for each tt-imp:
               delete tt-imp.
           end.
    
           for each estrutura no-lock where
               estrutura.it-codigo = tt-digita.it-codigo and
               estrutura.data-inicio <= today and
               estrutura.data-termino >= today,
               first item no-lock where
                     item.it-codigo = estrutura.es-codigo:
               if not estrutura.fantasma and item.compr-fabric = 1 
                   then do:
                   
                  find first tt-est where
                       tt-est.it-codigo = estrutura.es-codigo no-error.
                  if not avail tt-est then do:
                     create tt-est.
                     assign tt-est.it-codigo = estrutura.es-codigo
                            tt-est.descricao = item.descricao-1 +
                                               item.descricao-2.
                  end.
                  assign tt-est.qtde = tt-est.qtde + estrutura.quant-usada.
               end.
               run pi-ler(estrutura.es-codigo, estrutura.quant-usada).
           end.

           find first tt-est no-error.
           if not avail tt-est then next.

           if tt-param.log-excel then
              run pi-excel.
           else
              run pi-normal.
       end.
    end.
    else do:
       run pi-faz-sem-estrutura.
    end.
  
    run pi-finalizar in h-acomp.
    
    hide frame f-sintetico.

    if not tt-param.log-excel then do:
        page.
        
        disp c-liter-sel
             tt-param.log-estrutura 
             tt-param.log-excel 
             tt-param.cotacao
             tt-param.pis 
             tt-param.cofins 
             tt-param.data-fi-ini 
             tt-param.data-fi-fim 
             c-liter-par         
             c-tipo
             tt-param.cod-estabel 
             c-liter-imp
             c-destino
             tt-param.arquivo   
             tt-param.usuario
             with frame f-impressao.
    end.
    
    {include/i-rpclo.i}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-excel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-excel Procedure 
PROCEDURE pi-excel PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   assign de-nacional = 0
          de-importado = 0.

   EMPTY TEMP-TABLE tt-excessao-nat.

    RUN esp/es0018p.p (INPUT "escsp007rp",
                       INPUT 1,
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        CREATE tt-excessao-nat.
        ASSIGN tt-excessao-nat.nat-operacao = tt-prog-ponto.conteudo.
    END.
               
   run pi-mostra.
 
   find first item no-lock where
        item.it-codigo = tt-digita.it-codigo no-error.
   run pi-print-editor (item.desc-item, 36).
        
   assign c-descricao = substring(item.desc-item,1,36).
   put item.it-codigo format "X(7)" " "
       c-descricao "    ".

   assign de-fob-us$-nac = 0
          de-cif-us$-nac = 0
          de-cif-r$-nac  = 0
          de-fob-us$-imp = 0
          de-cif-us$-imp = 0
          de-cif-r$-imp  = 0.
                   
   run pi-acompanhar in h-acomp (input "Imprimindo item : " + tt-digita.it-codigo).

   for each tt-imp:
       if tt-imp.nac-imp then
          assign de-fob-us$-nac = de-fob-us$-nac + tt-imp.de-fob-us$
                 de-cif-us$-nac = de-cif-us$-nac + tt-imp.de-cif-us$
                 de-cif-r$-nac = de-cif-r$-nac + tt-imp.de-cif-r$.
       else
          assign de-fob-us$-imp = de-fob-us$-imp + tt-imp.de-fob-us$
                 de-cif-us$-imp = de-cif-us$-imp + tt-imp.de-cif-us$
                 de-cif-r$-imp  = de-cif-r$-imp  + tt-imp.de-cif-r$.
   end.

   assign de-fob-us$-tot = de-fob-us$-imp + de-fob-us$-nac
          de-cif-us$-tot = de-cif-us$-imp + de-cif-us$-nac
          de-cif-r$-tot  = de-cif-r$-imp  + de-cif-r$-nac.

   put de-fob-us$-nac " "
       de-fob-us$-imp " "
       de-fob-us$-tot "        "
       
       de-cif-us$-nac " "
       de-cif-us$-imp " "
       de-cif-us$-tot "            "
        
       de-cif-r$-nac " "
       de-cif-r$-imp " "
       de-cif-r$-tot " " skip.

   page.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-faz-sem-estrutura) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-faz-sem-estrutura Procedure 
PROCEDURE pi-faz-sem-estrutura PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   for each tt-est:
       delete tt-est.
   end.
        
   for each tt-imp:
       delete tt-imp.
   end.
        
   assign de-nacional = 0
          de-importado = 0.
               
   for each item no-lock 
       where item.it-codigo <= "1999999":
       find first tt-est 
            where tt-est.it-codigo = item.it-codigo no-error.
       if not avail tt-est then do:
          create tt-est.
          assign tt-est.it-codigo = item.it-codigo.
       end.
       assign tt-est.qtde = 1.
   end.
        
   for each item no-lock 
       where item.it-codigo >= "5000000"
         AND ITEM.it-codigo <= "6999999":
       find first tt-est 
            where tt-est.it-codigo = item.it-codigo no-error.
       if not avail tt-est then do:
          create tt-est.
          assign tt-est.it-codigo = item.it-codigo.
       end.
       assign tt-est.qtde = 1.
   end.

   EMPTY TEMP-TABLE tt-excessao-nat.

   RUN esp/es0018p.p (INPUT "escsp007rp",
                       INPUT 1,
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        CREATE tt-excessao-nat.
        ASSIGN tt-excessao-nat.nat-operacao = tt-prog-ponto.conteudo.
    END.

   for each tt-est:
       run pi-acompanhar in h-acomp (input "Item: " + tt-est.it-codigo).

       run pi-mostra-sem-estrutura.
   end.
 
   if tt-param.ind-tipo = 1 then do:
      for each tt-imp break by tt-imp.nac-imp:
          disp tt-imp.it-codigo label "Item"
               tt-imp.descricao label "Descriá∆o"
               tt-imp.un label "Un"
               tt-imp.class-fiscal
               tt-imp.de-preco-fob label "Custo FOB"
               tt-imp.de-fi  label "FI"
               tt-imp.de-fi-total LABEL "FI Total"
               tt-imp.de-cif-r$
                              label "CIF R$" format ">>>9.99999"
               tt-imp.val-unit-mat label "MÇdio"
               with width 400 no-labels stream-io. 
      end.
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-ler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ler Procedure 
PROCEDURE pi-ler PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter c-it-codigo like estrutura.es-codigo no-undo.
   define input parameter de-qtde     like estrutura.quant-usada no-undo.
        

   run pi-acompanhar in h-acomp (input "Lendo estrutura : " + c-it-codigo).

   for each b-estrutura no-lock where
       b-estrutura.it-codigo = c-it-codigo and
       b-estrutura.data-inicio <= today and
       b-estrutura.data-termino >= today,
       first item no-lock where
             item.it-codigo = b-estrutura.es-codigo:

       if not b-estrutura.fantasma and item.compr-fabric = 1
           then do:
           
          find first tt-est where
               tt-est.it-codigo = b-estrutura.es-codigo no-error.
          if not avail tt-est then do:
            assign c-descricao = substring(item.desc-item,1,36).
            run pi-print-editor (item.desc-item, 36).
             create tt-est.
             assign tt-est.it-codigo = b-estrutura.es-codigo
                    tt-est.descricao = c-descricao.
          end.
          assign tt-est.qtde = tt-est.qtde + 
                               (b-estrutura.quant-usada * de-qtde).
       end. 

       run pi-ler(b-estrutura.es-codigo, b-estrutura.quant-usada * de-qtde).
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mostra) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra Procedure 
PROCEDURE pi-mostra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign de-preco-fob = 0
           de-fi  = 0
           de-fi-total = 0
           de-preco = 0
           de-qtde  = 0.
    
/*     for each fator-internacao no-lock                                                                                           */
/*         where fator-internacao.it-codigo = tt-est.it-codigo                                                                     */
/*           and fator-internacao.data >= tt-param.data-fi-ini                                                                     */
/*           and fator-internacao.data <= tt-param.data-fi-fim                                                                     */
/*           and fator-internacao.fi-geral <> ?,                                                                                   */
/*         FIRST embarque-imp                                                                                                      */
/*         WHERE embarque-imp.cod-estabel = tt-param.cod-estabel                                                                   */
/*           AND embarque-imp.embarque    = fator-internacao.embarque:                                                             */
/*         if fator-internacao.fi-geral <> 0 then do:                                                                              */
/*               find prazo-compra no-lock                                                                                         */
/*              where prazo-compra.numero-ordem = fator-internacao.numero-ordem                                                    */
/*                and prazo-compra.parcela      = fator-internacao.parcela                    no-error.                            */
/*                                                                                                                                 */
/*            if avail prazo-compra then                                                                                           */
/*            assign de-fi = de-fi + ( fator-internacao.fi-geral *                                     prazo-compra.quantid-orig ) */
/*                   de-qtde = de-qtde + prazo-compra.quantid-orig.                                                                */
/*                                                                                                                                 */
/*            ASSIGN de-fi-total = fator-internacao.fi-geral.                                                                        */
/*                                                                                                                                 */
/*         end.                                                                                                                    */
/*     END.                                                                                                                        */


    FOR EACH tt-est:
        assign c-nome-abrev = ""
               de-preco-fob = 0.

        run pi-acompanhar in h-acomp (input "Imprimindo item : " + tt-est.it-codigo).

        FIND ITEM WHERE
             ITEM.it-codigo = tt-est.it-codigo NO-LOCK NO-ERROR.

        for each item-tab no-lock 
            where item-tab.it-codigo = tt-est.it-codigo 
              and item-tab.situacao = 1,
            first tb-pr-cc no-lock 
            where tb-pr-cc.cod-emitente = item-tab.cod-emitente
              and tb-pr-cc.cod-cond-pag = item-tab.cod-cond-pag
               and tb-pr-cc.nr-tab = item-tab.nr-tab
               and tb-pr-cc.situacao = 1
               and tb-pr-cc.dt-inicio <= today 
               and tb-pr-cc.dt-termino >= today,
            first emitente no-lock 
              where emitente.nome-abrev = item-tab.nome-abrev,
            first item-fornec-estab no-lock
                  where item-fornec-estab.cod-estabel = tt-param.cod-estabel
                    AND item-fornec-estab.it-codigo = item-tab.it-codigo
                    and item-fornec-estab.cod-emitente = emitente.cod-emitente 
                    and item-fornec-estab.ativo:

            assign i-num-casa-dec = 1.

            do i-cont = 1 to item-fornec-estab.num-casa-dec:
               assign i-num-casa-dec = i-num-casa-dec * 10.
            end.

            assign de-fator-conver = item-fornec-estab.fator-conver /
                                     i-num-casa-dec.    

            ASSIGN de-preco-fob = item-tab.pr-item.

            IF tb-pr-cc.mo-codigo > 1 THEN DO: /* se for diferende de dolar e real encontramos primeiro o valor em real */
                FIND FIRST cotacao
                     WHERE cotacao.mo-codigo = tb-pr-cc.mo-codigo
                       AND cotacao.ano-periodo = c-periodo NO-LOCK NO-ERROR.
                IF AVAIL cotacao THEN
                    ASSIGN de-preco-fob = item-tab.pr-item * cotacao.cota-media.
            END.

            if tb-pr-cc.mo-codigo <> 1 THEN  /* se o valor da tabela de preáo n∆o for em real ent∆o temos que encontrar o valor em real */
               assign de-preco-fob = de-preco-fob / tt-param.cotacao.

            assign de-preco-fob = de-preco-fob * de-fator-conver.

            if tb-pr-cc.valor-taxa <> 0 then
               assign de-preco-fob = de-preco-fob + (de-preco-fob * 
                                     (tb-pr-cc.valor-taxa / 100)).

            assign de-tmp = de-preco-fob.

            if emitente.natureza <> 3 and item-tab.aliquota-icm <> 0 then 
               assign de-preco-fob = de-preco-fob *
                                     ((100 - item-tab.aliquota-icm) / 100). 

            if emitente.natureza <> 3 then
               assign de-preco-fob = de-preco-fob - 
                                     (de-tmp * ((tt-param.pis + tt-param.cofins ) / 100)).

            assign c-nome-abrev = emitente.nome-abrev.

            if emitente.natureza = 3 then do:
               assign l-nacional = no.
               leave.
            end.
        end.

        assign de-val-unit = 0
               de-val-mat  = 0
               de-val-mob  = 0
               de-val-ggf  = 0.

        find item-estab no-lock
            where item-estab.cod-estabel = tt-param.cod-estabel
              and item-estab.it-codigo   = item.it-codigo no-error.

        if avail item-estab then 
           assign de-val-unit = item-estab.val-unit-mat-m[1]
                              + item-estab.val-unit-mob-m[1]
                              + item-estab.val-unit-ggf-m[1]
                  de-val-mat = item-estab.val-unit-mat-m[1]
                  de-val-mob = item-estab.val-unit-mob-m[1]
                  de-val-ggf = item-estab.val-unit-ggf-m[1].

        FIND item-uni-estab WHERE
             item-uni-estab.it-codigo   = item.it-codigo AND
             item-uni-estab.cod-estabel = tt-param.cod-estabel NO-LOCK NO-ERROR.

    /*xxxxxxxxxxxxxxxxx*/    
        create tt-imp.
        assign tt-imp.nac-imp      = if l-nacional then
                                        yes
                                     else
                                        no
               tt-imp.it-codigo    = tt-est.it-codigo
               tt-imp.descricao    = tt-est.descricao
               tt-imp.qtde         = tt-est.qtde 
               tt-imp.de-preco-fob = de-preco-fob 
               tt-imp.de-fob-us$   = tt-est.qtde * de-preco-fob
               tt-imp.val-unit-mat = de-val-unit
               tt-imp.de-fi        = 1
               tt-imp.de-fi-total  = 1
               tt-imp.nome-abrev   = c-nome-abrev
               tt-imp.class-fiscal = item.class-fiscal
               tt-imp.un           = item.un
               tt-imp.numero       = 0. 

        IF AVAIL item-uni-estab THEN
            ASSIGN tt-imp.preco-ul-ent = item-uni-estab.preco-ul-ent
                   tt-imp.periodo-fixo = item-uni-estab.periodo-fixo
                   tt-imp.res-for-comp = item-uni-estab.res-for-comp
                   tt-imp.horiz-fixo   = item-uni-estab.horiz-fixo
                   tt-imp.horiz-lib    = int(substring(item-uni-estab.char-1,129,3))
                   tt-imp.tp-despesa   = item-uni-estab.tp-desp-padrao 
                   tt-imp.deposito-alm = item-uni-estab.deposito-pad.
        ELSE
            ASSIGN tt-imp.preco-ul-ent = item.preco-ul-ent
                   tt-imp.periodo-fixo = ITEM.periodo-fixo
                   tt-imp.res-for-comp = ITEM.res-for-comp
                   tt-imp.horiz-fixo   = ITEM.horiz-fixo
                   tt-imp.horiz-lib    = int(substring(item.char-1,129,3))
                   tt-imp.tp-despesa   = ITEM.tp-desp-padrao 
                   tt-imp.deposito-alm = ITEM.deposito-pad.
    END.

    for each docum-est use-index est-origem no-lock  
       where docum-est.cod-estabel = tt-param.cod-estabel
         and docum-est.dt-trans   >= tt-param.data-fi-ini
         and docum-est.dt-trans   <= tt-param.data-fi-fim,
       FIRST natur-oper NO-LOCK
       WHERE natur-oper.nat-operacao = docum-est.nat-operacao,
        each item-doc-est of docum-est NO-LOCK
        WHERE item-doc-est.it-codigo <> "",
        FIRST tt-est NO-LOCK
        WHERE tt-est.it-codigo = item-doc-est.it-codigo:

        FIND item no-lock
             WHERE item.it-codigo = item-doc-est.it-codigo NO-ERROR.

        IF NOT AVAIL ITEM THEN NEXT.

        IF NOT (ITEM.ge-codigo < 19 OR ITEM.ge-codigo = 45) THEN NEXT.

        IF NOT CAN-FIND(FIRST tt-excessao-nat 
                        WHERE tt-excessao-nat.nat-operacao = natur-oper.nat-operacao) THEN DO:
            IF NOT natur-oper.emite-duplic OR natur-oper.tipo-compra <> 1 THEN NEXT.
        END.

        ASSIGN de-desp-total = 0
               de-fi         = 0
               de-fi-total     = 0
               de-val-nc     = 0.

        IF SUBSTRING(docum-est.nat-operacao,1,1) = "3" THEN DO:

            FOR EACH item-doc-est-cex OF item-doc-est NO-LOCK:

                FOR FIRST desp-imp NO-LOCK
                    WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp
                      AND desp-imp.gera-custo:

                    ASSIGN de-desp-total = de-desp-total + item-doc-est-cex.val-desp.
                END.
            END.

            ASSIGN de-fi =  (item-doc-est.preco-total[1] + de-desp-total) / item-doc-est.preco-total[1].

             FOR EACH rat-docum NO-LOCK USE-INDEX nf-docto
                WHERE rat-docum.nf-serie  = docum-est.serie-docto
                  AND rat-docum.nf-nro      = docum-est.nro-docto
                  AND rat-docum.nf-emitente = docum-est.cod-emitente
                  AND rat-docum.nf-nat-oper = docum-est.nat-oper:

                FIND FIRST bf-docum-est USE-INDEX documento 
                     WHERE bf-docum-est.serie-docto = rat-docum.serie-docto 
                       AND bf-docum-est.nro-docto   = rat-docum.nro-docto   
                       AND bf-docum-est.cod-emitente = rat-docum.cod-emitente 
                       AND bf-docum-est.nat-operacao = rat-docum.nat-operacao NO-LOCK NO-ERROR.

                IF AVAIL bf-docum-est THEN DO:

                    FOR EACH bf-item-doc-est OF bf-docum-est
                       WHERE bf-item-doc-est.it-codigo = item-doc-est.it-codigo:

                        ASSIGN de-val-nc = de-val-nc + bf-item-doc-est.preco-total[1].
                    END.
                END.
                ASSIGN de-fi-total = (item-doc-est.preco-total[1] + de-desp-total + de-val-nc) / item-doc-est.preco-total[1].
            END.
        END.
        
        run pi-acompanhar in h-acomp (input "Imprimindo item : " + tt-est.it-codigo).

        if de-fi = ? or de-fi = 0 then assign de-fi = 1.
        IF de-fi-total = ? OR de-fi-total = 0 THEN ASSIGN de-fi-total = 1.

        FIND FIRST tt-imp WHERE
            tt-imp.it-codigo = tt-est.it-codigo NO-LOCK NO-ERROR.

        IF SUBSTRING(docum-est.nat-operacao,1,1) = "3" THEN DO:
            IF tt-imp.numero = 0 THEN
                ASSIGN tt-imp.de-fi        = de-fi
                       tt-imp.de-fi-total  = de-fi-total.
            ELSE
                ASSIGN tt-imp.de-fi        = (tt-imp.de-fi       + de-fi)
                       tt-imp.de-fi-total  = (tt-imp.de-fi-total   + de-fi-total).

            ASSIGN tt-imp.numero = tt-imp.numero + 1.
        END.

        /******* O 1.015 ABAIXO Ç O FRETE  *******/

        if l-nacional then
           assign tt-imp.de-cif-us$ = (de-preco-fob * tt-est.qtde) * 1.015.
        else
           assign tt-imp.de-cif-us$ = (de-preco-fob * tt-est.qtde) * tt-imp.de-fi.

        assign tt-imp.de-cif-r$ = tt-imp.de-cif-us$ * tt-param.cotacao.
    END.

    FOR EACH tt-imp:
        IF tt-imp.numero > 0 THEN
            ASSIGN tt-imp.de-fi = tt-imp.de-fi / tt-imp.numero
                   tt-imp.de-fi-total = tt-imp.de-fi-total / tt-imp.numero.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mostra-sem-estrutura) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-sem-estrutura Procedure 
PROCEDURE pi-mostra-sem-estrutura PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign de-preco-fob = 0
           de-fi        = 0
           de-fi-total  = 0
           de-preco     = 0
           de-qtde      = 0.

    FOR FIRST ITEM fields(ge-codigo it-codigo descricao-1 descricao-2 preco-ul-ent un class-fiscal periodo-fixo res-for-comp horiz-fixo char-1 tp-desp-padrao deposito-pad) NO-LOCK
        USE-INDEX codigo
        WHERE ITEM.it-codigo = tt-est.it-codigo:
    END.

    IF NOT (ITEM.ge-codigo < 19 OR ITEM.ge-codigo = 45) THEN RETURN.

    FOR EACH item-doc-est NO-LOCK USE-INDEX ITEM
        WHERE item-doc-est.it-codigo = ITEM.it-codigo:

        IF item-doc-est.data < tt-param.data-fi-ini OR
           item-doc-est.data > tt-param.data-fi-fim THEN
            NEXT.
        
        FOR FIRST docum-est NO-LOCK USE-INDEX documento
            WHERE docum-est.serie-docto  = item-doc-est.serie-docto
            AND   docum-est.nro-docto    = item-doc-est.nro-docto
            AND   docum-est.cod-emitente = item-doc-est.cod-emitente
            AND   docum-est.nat-operacao = item-doc-est.nat-operacao:

            IF docum-est.cod-estabel <> tt-param.cod-estabel THEN
                NEXT.
    
            FOR FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = docum-est.nat-operacao:
        
                FOR FIRST emitente NO-LOCK USE-INDEX codigo
                    WHERE emitente.cod-emitente = docum-est.cod-emitente:
                
                    IF NOT CAN-FIND(FIRST tt-excessao-nat  
                                    WHERE tt-excessao-nat.nat-operacao = natur-oper.nat-operacao) THEN DO:
            
                        IF NOT natur-oper.emite-duplic OR natur-oper.tipo-compra <> 1 THEN NEXT.
            
                    END.
            
                    ASSIGN de-desp-total = 0
                           de-fi         = 0
                           de-fi-total   = 0.
            
                    FOR EACH item-doc-est-cex NO-LOCK USE-INDEX codigo
                        WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                        AND   item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                        AND   item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                        AND   item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao:
            
                        FOR FIRST desp-imp NO-LOCK
                            WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp:
            
                            IF desp-imp.gera-custo THEN
                                ASSIGN de-desp-total = de-desp-total + item-doc-est-cex.val-desp.
            
                        END.
            
                    END.
            
                    ASSIGN de-fi = de-fi + ((item-doc-est.preco-total[1] + de-desp-total) / item-doc-est.quantidade / item-doc-est.preco-unit[1]).
            
                    FOR EACH rat-docum USE-INDEX nf-docto
                       WHERE rat-docum.nf-serie     = docum-est.serie-docto
                         AND rat-docum.nf-nro       = docum-est.nro-docto
                         AND rat-docum.nf-emitente  = docum-est.cod-emitente
                         AND rat-docum.nf-nat-oper  = docum-est.nat-operacao NO-LOCK:
            
                        FOR FIRST bf-docum-est USE-INDEX documento
                             WHERE bf-docum-est.serie-docto  = rat-docum.serie-docto 
                               AND bf-docum-est.nro-docto    = rat-docum.nro-docto   
                               AND bf-docum-est.cod-emitente = rat-docum.cod-emitente 
                               AND bf-docum-est.nat-operacao = rat-docum.nat-operacao NO-LOCK:
            
                            FOR EACH bf-item-doc-est NO-LOCK USE-INDEX documento
                                WHERE bf-item-doc-est.serie-docto  = bf-docum-est.serie-docto
                                AND   bf-item-doc-est.nro-docto    = bf-docum-est.nro-docto
                                AND   bf-item-doc-est.cod-emitente = bf-docum-est.cod-emitente
                                AND   bf-item-doc-est.nat-operacao = bf-docum-est.nat-operacao
                                /*AND   bf-item-doc-est.it-codigo    = item-doc-est.it-codigo*/:
            
                                IF bf-item-doc-est.it-codigo <> item-doc-est.it-codigo THEN
                                    NEXT.
                        
                                ASSIGN de-fi-total = de-fi-total + (bf-item-doc-est.preco-total[1] / item-doc-est.quantidade).
                            END.
                        END.
                    END.

                END.  /* FOR FIRST emitente */

            END.   /* FOR FIRST natur-oper */

        END.  /* FOR FIRST docum-est */

    END. /* FOR EACH item-doc-est */

    if de-fi = ? then
       assign de-fi = 0.

    if de-fi-total = ? then
       assign de-fi-total = 0.

    ASSIGN de-fi-total = de-fi-total + de-fi.

    assign c-nome-abrev = ""
           l-nacional = yes.

    for each item-tab no-lock USE-INDEX item-tab
        WHERE item-tab.it-codigo = tt-est.it-codigo:

        IF item-tab.situacao <> 1 THEN
            NEXT.

        FOR first tb-pr-cc no-lock USE-INDEX ch-codigo
            WHERE tb-pr-cc.cod-emitente  = item-tab.cod-emitente
            AND   tb-pr-cc.cdn-fabrican  = item-tab.cdn-fabrican
            AND   tb-pr-cc.cod-cond-pag  = item-tab.cod-cond-pag
            AND   tb-pr-cc.nr-tab        = item-tab.nr-tab
            AND   tb-pr-cc.dt-inicio     = item-tab.dt-inicio:

            IF tb-pr-cc.situacao   <> 1 OR
               tb-pr-cc.dt-inicio   > TODAY OR
               tb-pr-cc.dt-termino  < TODAY THEN
                NEXT.
    
            FOR first emitente no-lock USE-INDEX nome
                where emitente.nome-abrev = item-tab.nome-abrev,
        
            first item-fornec-estab NO-LOCK USE-INDEX item-emit-est
                where item-fornec-estab.it-codigo    = item-tab.it-codigo
                and   item-fornec-estab.cod-emitente = emitente.cod-emitente 
                AND   item-fornec-estab.cod-estabel  = tt-param.cod-estabel:

                IF NOT item-fornec-estab.ativo THEN
                    NEXT.
        
                assign i-num-casa-dec = 1.
                
                do i-cont = 1 to item-fornec-estab.num-casa-dec:
                   assign i-num-casa-dec = i-num-casa-dec * 10.
                end.
                            
                assign de-fator-conver = item-fornec-estab.fator-conver /
                                         i-num-casa-dec.    
        
                ASSIGN de-preco-fob = item-tab.pr-item.
        
                IF tb-pr-cc.mo-codigo > 1 THEN DO: /* se for diferende de dolar e real encontramos primeiro o valor em real */

                    FOR FIRST cotacao
                        WHERE cotacao.mo-codigo   = tb-pr-cc.mo-codigo
                        AND   cotacao.ano-periodo = c-periodo NO-LOCK:
        
                        ASSIGN de-preco-fob = item-tab.pr-item * cotacao.cota-media.
        
                    END.
                END.
        
                if tb-pr-cc.mo-codigo <> 1 THEN  /* se o valor da tabela de preáo n∆o for em real ent∆o temos que encontrar o valor em real */
                   assign de-preco-fob = de-preco-fob / tt-param.cotacao.
        
                assign de-preco-fob = de-preco-fob * de-fator-conver.
                
                assign de-tmp = de-preco-fob.
                
                if emitente.natureza <> 3 and item-tab.aliquota-icm <> 0 then 
                   assign de-preco-fob = de-preco-fob *
                                         ((100 - item-tab.aliquota-icm) / 100). 
            
                if emitente.natureza <> 3 then
                   assign de-preco-fob = de-preco-fob - 
                                         (de-tmp * ((tt-param.pis + tt-param.cofins ) / 100)).
        
                if tb-pr-cc.valor-taxa <> 0 then
                   assign de-preco-fob = de-preco-fob + (de-preco-fob * 
                                         (tb-pr-cc.valor-taxa / 100)).
                
                assign c-nome-abrev = emitente.nome-abrev.
                
                if emitente.natureza = 3 and de-fi <> 0 then do:
                   assign de-preco-fob = de-preco-fob - 
                                         (de-tmp * ((tt-param.pis + tt-param.cofins ) / 100)).
                   assign l-nacional = no.
                   leave.
                end.
            end.

        END.  /* FOR FIRST tb-pr-cc */

    END.  /* FOR EACH item-tab */

    assign de-val-unit = 0
           de-val-mat  = 0
           de-val-mob  = 0
           de-val-ggf  = 0.
    
    find item-estab no-lock
        where item-estab.cod-estabel = tt-param.cod-estabel 
          and item-estab.it-codigo = item.it-codigo no-error.

    if avail item-estab then 
       assign de-val-unit = item-estab.val-unit-mat-m[1]
                          + item-estab.val-unit-mob-m[1]
                          + item-estab.val-unit-ggf-m[1]
              de-val-mat = item-estab.val-unit-mat-m[1]
              de-val-mob = item-estab.val-unit-mob-m[1]
              de-val-ggf = item-estab.val-unit-ggf-m[1]  .
    
    create tt-imp.
    assign tt-imp.nac-imp      = if l-nacional then
                                    yes
                                 else
                                    no
           tt-imp.it-codigo    = tt-est.it-codigo
           tt-imp.descricao    = item.descricao-1 + item.descricao-2
           tt-imp.qtde         = tt-est.qtde 
           tt-imp.de-preco-fob = de-preco-fob 
           tt-imp.de-fi        = if l-nacional then 1 else de-fi
           tt-imp.de-fi-total    = IF l-nacional THEN 1 ELSE de-fi-total
           tt-imp.de-fob-us$   = tt-est.qtde * de-preco-fob
           tt-imp.val-unit-mat = de-val-unit
           tt-imp.preco-ul-ent = item.preco-ul-ent
           tt-imp.un           = item.un
           tt-imp.class-fiscal = item.class-fiscal
           tt-imp.nome-abrev   = c-nome-abrev
           tt-imp.periodo-fixo = ITEM.periodo-fixo
           tt-imp.res-for-comp = ITEM.res-for-comp
           tt-imp.horiz-fixo   = ITEM.horiz-fixo
           tt-imp.horiz-lib    = int(substring(item.char-1,129,3))
           tt-imp.tp-despesa   = ITEM.tp-desp-padrao
           tt-imp.deposito-alm = ITEM.deposito-pad.
           
        /******* O 1.015 ABAIXO E O FRETE  *******/

    if l-nacional then
       assign tt-imp.de-cif-us$ = (de-preco-fob) * 1.015.
    else
       assign tt-imp.de-cif-us$ = (de-preco-fob) * (1 + de-fi).

    assign tt-imp.de-cif-r$ = tt-imp.de-cif-us$ * tt-param.cotacao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-normal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-normal Procedure 
PROCEDURE pi-normal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   if tt-param.ind-tipo = 1 then do:
                  
      view frame f-cabec.
      view frame f-rodape.

      find first item no-lock where
           item.it-codigo = tt-digita.it-codigo no-error.
           
      run pi-print-editor (item.desc-item, 36).
             
      assign c-descricao = substring(item.desc-item,1,36).
       
      put "Cotaá∆o: " tt-param.cotacao format ">>>9.99999" skip
          "   Item: " item.it-codigo format "X(07)" 
          " - " c-descricao format "X(36)"
          skip(1).
   end.
        
   assign de-nacional = 0
          de-importado = 0.

   EMPTY TEMP-TABLE tt-excessao-nat.

    RUN esp/es0018p.p (INPUT "escsp007rp",
                       INPUT 1,
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        CREATE tt-excessao-nat.
        ASSIGN tt-excessao-nat.nat-operacao = tt-prog-ponto.conteudo.
    END.

   run pi-mostra.
 
   if tt-param.ind-tipo = 1 then do:   
      for each tt-imp break by tt-imp.nac-imp:
          if first-of(tt-imp.nac-imp) then
             assign de-fob-US$-nac = 0
                    de-cif-us$-nac = 0
                    de-cif-r$-nac  = 0
                    de-val-unit    = 0
                    de-val-mat     = 0.

          assign de-fob-US$-nac = de-fob-US$-nac + tt-imp.de-fob-us$
                 de-cif-us$-nac = de-cif-us$-nac + tt-imp.de-cif-us$
                 de-cif-r$-nac  = de-cif-r$-nac  + tt-imp.de-cif-r$
                 de-val-unit    = de-val-unit    + (tt-imp.preco-ul-ent * tt-imp.qtde)
                 de-val-mat     = de-val-mat     + (tt-imp.val-unit-mat * tt-imp.qtde).
                                 
          disp tt-imp.it-codigo label "Item"
               tt-imp.descricao label "Descriá∆o"
               tt-imp.qtde label "Qtde"
               tt-imp.un label "Un"
               tt-imp.class-fiscal label "Class fiscal"
               tt-imp.de-preco-fob label "Custo FOB"
               tt-imp.de-fi  label "FI"
               tt-imp.de-fi-total LABEL "FI Total"
               tt-imp.de-fob-us$
                              label "FOB US$" format ">>>>>9.99999"
               tt-imp.de-cif-us$ 
                              label "CIF US$" format ">>>>>9.99999"
               tt-imp.de-cif-r$
                              label "CIF R$" format ">>>>>9.99999"
               tt-imp.val-unit-mat label "MÇdio"
               tt-imp.preco-ul-ent label "Ult Entrada"
               tt-imp.nome-abrev label "Fornecedor"
               tt-imp.periodo-fixo LABEL "Per Fixo"
               tt-imp.res-for-comp LABEL "Res Forn"
               tt-imp.horiz-fixo   LABEL "Horiz Fixo"
               tt-imp.horiz-lib    LABEL "Horiz Lib"
               tt-imp.tp-despesa   LABEL "Tp Despesa"
               tt-imp.deposito-alm LABEL "Deposito"
                       with width 400 no-labels stream-io. 
                       
          if last-of(tt-imp.nac-imp) then do:
             put  skip
                   "--------------------------------------------------------------" at 106 skip
                   "SUB-TOTAL " at 99
                  de-fob-us$-nac to 118
                  de-cif-us$-nac to 131
                  de-cif-r$-nac to 144
                  de-val-mat to 155
                  de-val-unit to 167 skip(2).
                  
             assign de-fob-US$-nac-geral = de-fob-US$-nac-geral + de-fob-US$-nac
                    de-cif-us$-nac-geral = de-cif-us$-nac-geral + de-cif-us$-nac
                    de-cif-r$-nac-geral  = de-cif-r$-nac-geral + de-cif-r$-nac
                    de-val-unit-geral    = de-val-unit-geral + de-val-unit
                    de-val-mat-geral     = de-val-mat-geral + de-val-mat.                  
          end.
          
          if last(tt-imp.nac-imp) then
             put  "--------------------------------------------------------------" at 106 skip
                  "TOTAL " at 99
                  de-fob-us$-nac-geral to 118
                  de-cif-us$-nac-geral to 131
                  de-cif-r$-nac-geral to 144
                  de-val-mat-geral to 155
                  de-val-unit-geral to 167 skip(2).
          
      end.
   end.
   else do:
      find first item no-lock where
           item.it-codigo = tt-digita.it-codigo no-error.
      run pi-print-editor (item.desc-item, 36).
             
      assign c-descricao = substring(item.desc-item,1,36).
      disp item.it-codigo
           c-descricao
           tt-param.cotacao
           with frame f-sintetico.

      assign de-fob-us$-nac = 0
             de-cif-us$-nac = 0
             de-cif-r$-nac  = 0.
                   
      for each tt-imp where tt-imp.nac-imp:
          assign de-fob-us$-nac = de-fob-us$-nac + tt-imp.de-fob-us$
                 de-cif-us$-nac = de-cif-us$-nac + tt-imp.de-cif-us$
                 de-cif-r$-nac = de-cif-r$-nac + tt-imp.de-cif-r$.
      end.

      disp de-fob-us$-nac
           de-cif-us$-nac
           de-cif-r$-nac
           with frame f-sintetico.

      assign de-fob-us$-imp = 0
             de-cif-us$-imp = 0
             de-cif-r$-imp  = 0.
                  
      for each tt-imp where NOT tt-imp.nac-imp:
          assign de-fob-us$-imp = de-fob-us$-imp + tt-imp.de-fob-us$
                 de-cif-us$-imp = de-cif-us$-imp + tt-imp.de-cif-us$
                 de-cif-r$-imp  = de-cif-r$-imp  + tt-imp.de-cif-r$.
      end.

      assign de-fob-us$-tot = de-fob-us$-imp + de-fob-us$-nac
             de-cif-us$-tot = de-cif-us$-imp + de-cif-us$-nac
             de-cif-r$-tot  = de-cif-r$-imp  + de-cif-r$-nac.
                  
      disp de-fob-us$-imp 
           de-cif-us$-imp
           de-cif-r$-imp
           de-fob-us$-tot
           de-cif-us$-tot
           de-cif-r$-tot
           with frame f-sintetico.
   end.
   page.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

