/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI002 2.00.00.030}  /*** 010030 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi002 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1998)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*************************************************************************
**
**   Programa: bcapi002 - API de Impress∆o de coleta de dados
**
**   Parametros: tt-trans.nr-trans - Nr.Transaá∆o
**               tt-trans.conte£do - Campo RAW com a transaá∆o
**               tt-erro - Apos a execucao da API contera  os  possiveis
**                         erros de criacao de etiquetas
**
**   Versao de Integracao: 1 - Luciano (07/98)
**   Novembro/2000 - Alcides - Implementaá∆o da integraáao com Word
**   - Passa a tratar o destino de impress∆o na etiqueta, que pode ser
**              1-arquivo, 2-impressora-ems, 3-word
**   - ê poss°vel informar impressora-ems na etiqueta (alÇm do layout).
**   - Para manter compatibilidade com as etiquetas antigas s∆o usadas
**     as seguintes regras:
**      DestinoEtiqueta     Procedimento
**        arquivo           Assume o destino da transaá∆o
**        impressora-ems    Se informou impressora na etiqueta usa o destino
**                          da etiqueta. (nova etiqueta).
**                          Se n∆o informou impressora usa o destino da transaá∆o
**                          (etiqueta antiga).
**        word              Assume o destino da etiqueta.
**   - passa a receber da bcapi007 a relaá∆o dos arquivos gerados para chamar
**     o programa upc.
**
**************************************************************************/

/* VERSAO DE INTEGRACAO */
&SCOPED-DEFINE Versao-Integracao 1

{cdp/cd0666.i}   /* definicao da temp-table de tt-erros */
{bcp/bcapi002.i} /* Definicao da temp-table de tt-etiquetas */
{include/i-epc200.i bcapi002} /** Upc **/

def input        param i-nr-trans         like bc-trans.nr-trans.
def input        param ra-conteudo-trans  as   raw.
def input-output param table for tt-erro.

def temp-table tt-etiqueta-aux NO-UNDO like tt-etiqueta    .
def var l-erro              as logical initial no   no-undo.
def var i-aux               as integer initial  1   no-undo.
def var i-etq               as integer              no-undo.
def var i-aux1              as integer              no-undo.
def var i-seq               as integer initial 1    no-undo.
def var c-impres-trans      as char                 no-undo.
def var c-relacao-arquivos  as character            no-undo.
def var i-arq               as integer              no-undo.

/* Var para guardar o layout da etiqueta */
&IF "{&mgcld_version}" >= "2.04" &THEN
    DEFINE NEW GLOBAL SHARED VARIABLE i-cod-layout LIKE bc-etiqueta.cod-layout NO-UNDO. 
&endif
DEFINE TEMP-TABLE tt-etiqueta-layout NO-UNDO LIKE tt-etiqueta .

/* Variaveis para informaá‰es de tipo-destino da etiqueta */
{bcp/bc0103.i}

create tt-etiqueta. /* para ter um registro disponivel */

raw-transfer ra-conteudo-trans to tt-etiqueta.

assign tt-etiqueta.arquivo  = string(i-nr-trans) + ".ETQ"
       tt-etiqueta.nr-trans = i-nr-trans.

/*** Envia tt-etiqueta para ser gerado os tt-etiqueta-aux (fatorado) ***/
run bcp/bcapi008.p (input-output table tt-etiqueta,
                    input-output table tt-etiqueta-aux,
                    input-output table tt-erro).

find first tt-erro no-error.
if  available(tt-erro) then
    return "NOK".

/* Validaá∆o do tipo-destino para cada etiqueta ------------------------*/
/*------------------------------------------------------------------------
   Se destino = Impressora EMS 
      verifica a impressora/layout da etiqueta 
      Se etiqueta.impressora = "" usa a impressora da transaá∆o
   Se destino = msword
      verifica se est† no ambiente windows
------------------------------------------------------------------------*/
for each tt-etiqueta-aux break by tt-etiqueta-aux.tipo-etiq:
    if  first-of (tt-etiqueta-aux.tipo-etiq) then do:

        find first tipo-etiqueta
             where tipo-etiqueta.tipo-etiq = tt-etiqueta-aux.tipo-etiq
             no-lock no-error.

        /* A validaá∆o da existencia do tipo-etiqueta ser† feita no bcapi007.p */
        if  not avail tipo-etiqueta then
            next.

        /* fk: envia layout de impressao para etiquetas 1D */
        /*RUN pi-envia-layout-impressao IN THIS-PROCEDURE.*/


        /* bc0103.i ----------------------------------------------------*/
        run pi-obtem-campos-impressao (buffer tipo-etiqueta,
                                       output i-tipo-destino,
                                       output c-impres-ems, output c-layout-ems,
                                       output c-doc-msword, output c-imp-windows).

        /* Assume destino de geraá∆o da transaá∆o nestes casos ---------*/
        if  i-tipo-destino = 1 /* arquivo */
        or  (i-tipo-destino = 2 /* imp-ems */ and c-impres-ems = "":U) then do:
            find first bc-tipo-trans
                 where bc-tipo-trans.cd-trans = tt-etiqueta-aux.cd-trans
                 no-lock no-error.
            /* validaá∆o da existencia do bc-tipo-trans est† em bcapi007.p */
            if  avail bc-tipo-trans then
                c-impres-trans = trim(bc-tipo-trans.char-2).
            else
                c-impres-trans = "":U.
            /* verifica se impressora da transaá∆o + layout etiqueta est† ok */
            if  c-impres-trans <> "":U then do:
                find first impressora
                     where impressora.nom_impressora = c-impres-trans
                     no-lock no-error.
                if  not avail impressora
                then do:
                    {utp/ut-table.i mguni impressora 1}
                    run utp/ut-msgs.p ( input "msg",
                                        input 2,
                                        input return-value).
                    create  tt-erro.
                    assign  tt-erro.i-sequen = 1
                            tt-erro.cd-erro  = 2
                            tt-erro.mensagem = TRIM(return-value).
                    return "NOK".
                end.
                find first layout_impres
                     where layout_impres.nom_impressora     = impressora.nom_impressora
                       and layout_impres.cod_layout_impres  = c-layout-ems
                     no-lock no-error.
                if  not avail layout_impres
                then do:
                    run utp/ut-msgs.p ( input "msg":U,
                                        input 25878,
                                        input trim(c-layout-ems) + "~~":U + 
                                              impressora.nom_impressora + "~~":U +
                                              tt-etiqueta-aux.cd-trans + "~~":U +
                                              string(tt-etiqueta-aux.tipo-etiq)).
                    create  tt-erro.
                    assign  tt-erro.i-sequen = 1
                            tt-erro.cd-erro  = 25878
                            tt-erro.mensagem = TRIM(return-value).
                    return "NOK".
                end.
            end.
            next.
        end.
        /* Verifica ent∆o o destino de geraá∆o da etiqueta ----------------*/
        if  i-tipo-destino = 2 then do: /* impressora-ems */
            find first layout_impres
                 where layout_impres.nom_impressora     = c-impres-ems
                   and layout_impres.cod_layout_impres  = c-layout-ems
                 no-lock no-error.
            if  not avail layout_impres
            then do:
                run utp/ut-msgs.p ( input "msg",
                                    input 19097,
                                    input trim(c-layout-ems) + "~~" + c-impres-ems).
                create  tt-erro.
                assign  tt-erro.i-sequen = 1
                        tt-erro.cd-erro  = 19097
                        tt-erro.mensagem = TRIM(return-value).
                return "NOK".
            end.
            next.
        end.
        if  i-tipo-destino = 3 then do: /* impress∆o word */
            if  opsys <> "WIN32":U then do:
                run utp/ut-msgs.p ("msg":U, 25785, string(tt-etiqueta-aux.tipo-etiq) + "~~":U + opsys).
                create  tt-erro.
                assign  tt-erro.i-sequen = 1
                        tt-erro.cd-erro  = 25785
                        tt-erro.mensagem = TRIM(return-value).
                return "NOK".
            end.
            next.
        end.
    end.

end.

find first tt-etiqueta-aux no-lock no-error.
for  each tt-epc
    where tt-epc.cod-event = "Before-Print":
    delete tt-epc.
end.
create  tt-epc.
assign  tt-epc.cod-event     = "Before-Print"
        tt-epc.cod-parameter = "Item"
        tt-epc.val-parameter = tt-etiqueta-aux.it-codigo.
create  tt-epc.
assign  tt-epc.cod-event     = "Before-Print"
        tt-epc.cod-parameter = "CodigoTransacao"
        tt-epc.val-parameter = tt-etiqueta-aux.cd-trans.
create  tt-epc.
assign  tt-epc.cod-event     = "Before-Print"
        tt-epc.cod-parameter = "NumeroTransacao"
        tt-epc.val-parameter = string(tt-etiqueta-aux.nr-trans).
create  tt-epc.
assign  tt-epc.cod-event     = "Before-Print"
        tt-epc.cod-parameter = "TipoEtiqueta"
        tt-epc.val-parameter = string(tt-etiqueta-aux.tipo-etiq).

{include/i-epc201.i "Before-Print"}.

for  each tt-epc
    where tt-epc.cod-event = "Before-Print":
    delete tt-epc.
end.


/*** Envia tt-etiqueta-aux para impressao ***/
run bcp/bcapi007.p (input-output table tt-etiqueta-aux,
                    input-output table tt-erro,
                    output c-relacao-arquivos).

find first tt-erro no-error.
LOG-MANAGER:WRITE-MESSAGE("bcapi002 -5 available(tt-erro)=" + STRING(available(tt-erro))) NO-ERROR.


if  available(tt-erro) then
    return "NOK":U.

/* chamada do UPC passando de parametro cada arquivo gerado -----------*/
repeat i-arq = 1 to num-entries(c-relacao-arquivos):
    for  each tt-epc
        where tt-epc.cod-event = "Print":
        delete tt-epc.
    end.
    create tt-epc.
    assign tt-epc.cod-event     = "Print"
           tt-epc.cod-parameter = "file-name"
           tt-epc.val-parameter = entry(i-arq, c-relacao-arquivos).
    {include/i-epc201.i "Print"}.
end.

for  each tt-epc
    where tt-epc.cod-event = "Print":
    delete tt-epc.
end.

find first tt-etiqueta-aux no-lock no-error.
for  each tt-epc
    where tt-epc.cod-event = "After-Print":
    delete tt-epc.
end.
create  tt-epc.
assign  tt-epc.cod-event     = "After-Print"
        tt-epc.cod-parameter = "Item"
        tt-epc.val-parameter = tt-etiqueta-aux.it-codigo.
create  tt-epc.
assign  tt-epc.cod-event     = "After-Print"
        tt-epc.cod-parameter = "CodigoTransacao"
        tt-epc.val-parameter = tt-etiqueta-aux.cd-trans.
create  tt-epc.
assign  tt-epc.cod-event     = "After-Print"
        tt-epc.cod-parameter = "NumeroTransacao"
        tt-epc.val-parameter = string(tt-etiqueta-aux.nr-trans).
create  tt-epc.
assign  tt-epc.cod-event     = "After-Print"
        tt-epc.cod-parameter = "TipoEtiqueta"
        tt-epc.val-parameter = string(tt-etiqueta-aux.tipo-etiq).

{include/i-epc201.i "After-Print"}.

for  each tt-epc
    where tt-epc.cod-event = "After-Print":
    delete tt-epc.
end.

return "OK":U.


/* /* ********************************************************************************* */ */
/* PROCEDURE pi-envia-layout-impressao:                                                    */
/* /* Frank: Se for etiqueta 1D e tiver layout de impress∆o, envia antes*/                 */
/* /* ********************************************************************************* */ */
/*     /* Definicao variaveis */                                                           */
/*     DEFINE VARIABLE lReturnOK AS LOGICAL  INITIAL YES  NO-UNDO.                         */
/*                                                                                         */
/*     /* Somente executa se a versao do ems for maior que 204 */                          */
/*     &IF "{&mgcld_version}" >= "2.04" &THEN                                              */
/*                                                                                         */
/*         /* Verifica se n∆o foi enviado para a impressora o layout */                    */
/*         IF tipo-etiqueta.cod-layout <> i-cod-layout AND                                 */
/*            tipo-etiqueta.ind-dimensao = 1 THEN DO:                                      */
/*             /*  */                                                                      */
/*             ASSIGN i-cod-layout = tipo-etiqueta.cod-layout.                             */
/*                                                                                         */
/*             /* Gera o layout de etiqueta */                                             */
/*             CREATE tt-etiqueta-layout.                                                  */
/*             ASSIGN tt-etiqueta-layout.cod-versao-integracao = 1                         */
/*                    tt-etiqueta-layout.i-sequen              = 1                         */
/*                    tt-etiqueta-layout.cd-trans              = tt-etiqueta-aux.cd-trans  */
/*                    tt-etiqueta-layout.tipo-etiq             = tipo-etiqueta.cod-layout  */
/*                    tt-etiqueta-layout.usuario               = tt-etiqueta-aux.usuario   */
/*                    tt-etiqueta-layout.dt-impressao          = TODAY                     */
/*                    tt-etiqueta-layout.hora-impressao        = STRING(TIME,"HH:MM:SS")   */
/*                    tt-etiqueta-layout.qt-etiqueta           = 1.                        */
/*                                                                                         */
/*             /*** Envia o layout para impressao ***/                                     */
/*             run bcp/bcapi007.p (input-output table tt-etiqueta-layout,                  */
/*                                 input-output table tt-erro,                             */
/*                                 output c-relacao-arquivos).                             */
/*                                                                                         */
/*                                                                                         */
/*             /*  */                                                                      */
/*             find first tt-erro no-error.                                                */
/*             if  available(tt-erro) THEN ASSIGN lReturnOk = NO.                          */
/*         END.                                                                            */
/*                                                                                         */
/*     &endif                                                                              */
/*                                                                                         */
/*     /*  */                                                                              */
/*     IF lReturnOK = YES THEN RETURN 'OK'.                                                */
/*     ELSE RETURN 'NOK'.                                                                  */
/*                                                                                         */
/* END PROCEDURE.                                                                          */


/***** chamada upc antiga
else do:

    find first tt-etiqueta no-error.
    if avail tt-etiqueta then do:

       /*** Teste do tipo de transacao ***/
       find first bc-tipo-trans
            where bc-tipo-trans.cd-trans = tt-etiqueta.cd-trans no-lock no-error.

       if  not available(bc-tipo-trans) then do:
           {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
           run utp/ut-msgs.p (input "msg",
                              input 56,
                              input trim(return-value)).
           create tt-erro.
           assign tt-erro.i-sequen = tt-etiqueta.i-sequen
                  tt-erro.cd-erro  = 56
                  tt-erro.mensagem = return-value.
           {utp/ut-liter.i "Processo Geraá∆o Etiqueta" * L}
           assign tt-erro.mensagem =  tt-erro.mensagem 
                                    + " (" + return-value + ")".       
           return "NOK".
       end.

       /****** CHAMADA UPC ******/
       find param-bc no-lock no-error.

       for each tt-epc:
           delete tt-epc.
       end.

       create tt-epc.
       assign tt-epc.cod-event = "Print"
              tt-epc.cod-parameter = "file-name"
              tt-epc.val-parameter = (if avail param-bc 
                                     then param-bc.nome-dir-etiq
                                     else "")               
              tt-epc.val-parameter =  tt-epc.val-parameter
                                    + (if  bc-tipo-trans.char-1 <> "" 
                                       then( (if tt-epc.val-parameter <> "" 
                                              then "/"
                                              else "") 
                                            + trim(bc-tipo-trans.char-1) )
                                       else "")
                                    + (if tt-epc.val-parameter <> "" then "/"
                                       else  "") 
                                    + tt-etiqueta.arquivo
    
              tt-epc.val-parameter = (if  opsys = "unix" then 
                                          replace(tt-epc.val-parameter,"~\","/")
                                      else 
                                          replace(tt-epc.val-parameter,"/","~\")).                             

       {include/i-epc201.i "Print"}.                             
    end.

    return "OK".
end.
*/
