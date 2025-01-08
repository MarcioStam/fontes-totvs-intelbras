/*****************************************************************************
**
**   Programa:  es0589.p
**
**   Funcao:  importar/exportar dados do b2b compras
**
**   Data:  05/03/2001
**
**   Autor:  Flavio Schoenell - INTELBRAS S/A.
**
******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i es0589 1.00.00.000}
{esp/es0009.i}

    /**** includes utilizadas para a api ******/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def stream a.
def VAR c-transacao-global as char no-undo.
/*DEF VAR c-programa AS CHAR INIT "es0589".*/

/* {esp/es0008.i} /* busca conta e centro de custo por programa */ */

DEF stream b.
DEF stream d.
DEF STREAM z.

def var c-it-codigo      like item.it-codigo.
def var c-dep-almoxar    like item-uni-estab.deposito-pad.
def var c-erro           as char.
def var c-linha          as char .
def var c-lin-rat        as char.
def var l-erro           as logical.
DEF VAR l-tem-oc         AS LOG NO-UNDO.
def var i-num-pedido     as int.
def var i-mes            as int format "99".
def var c-sdcv           as char.
DEFINE VAR cRemetente    AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CDestino      AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CAssunto      AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CDescEmail    AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CArqEmail     AS CHAR FORMAT 'x(60)' NO-UNDO.
def var c-dir            as char.
DEF VAR c-valor-arq      AS CHAR.
DEF VAR cArqDest         AS CHAR.
DEF VAR cArqVolta        AS CHAR.
DEF VAR c-rat            AS CHAR.
DEF VAR c-move           AS CHAR.
def var a                as char.
DEF VAR c-ct-codigo      AS CHAR FORMAT "X(8)".
DEF VAR c-sc-codigo      AS CHAR FORMAT "X(8)".
def var h-boin274        as handle no-undo.
def var h-boin356        as handle no-undo.
def var h-boin082        as handle no-undo.
def var h-boin295        as handle no-undo.
def var h-acomp        as handle  no-undo.
DEFINE VARIABLE iLockAgain AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-cessao-credito AS LOGICAL     NO-UNDO.
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i}
{esp/es0018.i}
/* {cdp/cd0666.i} */
def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

&GLOBAL-DEFINE ROW-NUM-DEFINED YES

DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr

FIELD r-rowid AS ROWID

&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN

FIELD RowNum AS INTEGER INIT 1

INDEX iSeq AS PRIMARY RowNum

&ENDIF.

def temp-table tt-versao-integr no-undo
       field cod-versao-integracao as integer format "999"
       field ind-origem-msg            as integer format  "99".

def temp-table tt-erros-geral no-undo
       field identif-msg                     as char     format "x(60)"
       field num-sequencia-erro    as integer  format "999"
       field cod-erro                        as integer  format "99999"   
       field des-erro                          as char      format "x(60)"
       field cod-maq-origem           as integer format "999"
       field num-processo              as integer  format "999999999".

def temp-table tt-ordem-compra no-undo like ordem-compra
    FIELD r-rowid AS ROWID.

def temp-table tt-prazo-compra no-undo like prazo-compra
    FIELD r-rowid AS ROWID.

def temp-table tt-cotacao-item no-undo like cotacao-item
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE rowerrors NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
        FIELD errordescription AS CHAR FORMAT "x(150)"
        FIELD errorparameters  AS CHAR
        FIELD errortype        AS CHAR
        FIELD errorhelp        AS CHAR FORMAT "x(150)"
        FIELD errorsubtype     AS CHAR.

def temp-table tt-for
    field cod-emitente like emitente.cod-emitente
    field l-erro as logical.
    
def temp-table tt-ped
    field cgc like emitente.cgc
    field numero-ordem like ordem-compra.numero-ordem
    field sdcv as char format "x(20)"
    field cod-emitente like emitente.cod-emitente
    field l-erro as logical
    field c-erro as char format "x(40)"
    field l-aprovada as logical
    field num-pedido like pedido-compr.num-pedido
    index codigo is primary cod-emitente.

def var i-nr-ordem like ordem-compra.numero-ordem.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

find first param-global no-lock no-error.
find first empresa no-lock
   where empresa.ep-codigo = param-global.empresa-pri no-error.

{include/i-rpvar.i}
{include/i-rpcab.i}
{include/i-rpout.i}

assign c-dir = "/usr3/b2b/b2b_mag/compras/".

/* assign c-dir = "\\intel200\b2b\b2b_mag\compras\".  */

assign c-valor-arq = c-dir + "*.NOC"
        cArqDest    = session:temp-directory + "ocs.txt".   
/*        cArqDest    = "\\intel200\spool\ocs.txt".  */

unix silent ls value(c-valor-arq) > value(cArqDest) 2>/dev/null.

/*  DOS SILENT DIR /B VALUE(c-valor-arq) > VALUE(cArqDest). */

input stream a from VALUE(cArqDest) NO-ECHO.

/* input stream a from \\intel200\spool\ocs.txt NO-ECHO. */

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Integraá∆o Pedidos SDCV").

FIND FIRST param-compra NO-LOCK NO-ERROR.

repeat:
    
    for each tt-ped:
        delete tt-ped.
    end.
    for each tt-for:
        delete tt-for.
    end.

    import stream a unformatted a.
    
    /* Ç utilizado para testar no windows ****/
    /* ASSIGN a = "\\intel200\b2b\b2b_mag\compras\" + a.  */

    input stream b from value(a).

    repeat:

        import stream b unformatted c-linha.
        FOR EACH tt-ordem-compra:
            DELETE tt-ordem-compra.
        END.

        FOR EACH tt-prazo-compra:
            DELETE tt-prazo-compra.
        END.

        FOR EACH tt-cotacao-item:
            DELETE tt-cotacao-item.
        END.

        FOR EACH tt-pedido-compr:
            DELETE tt-pedido-compr.
        END.

        assign c-erro = "0"
               l-erro = NO.

        find emitente where 
             emitente.cod-emitente = int(entry(1,c-linha,";"))
             no-lock no-error.
         
        IF NOT AVAIL emitente THEN DO:
           ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(for)"
                  cDescEmail = "Fornecedor " + entry(1,c-linha,";") + " n∆o cadastrado. SDCV: " + string(entry(3,c-linha,";"),"X(8)").
                  c-erro = "1".
           
           RUN piEnviaEmail(INPUT cRemetente, 
                            INPUT cDestino,
                            INPUT cAssunto,
                            INPUT cDescEmail,
                            INPUT cArqEmail).
           LEAVE.
        END.

        ASSIGN l-cessao-credito = NO.

        FIND FIRST int-cond-pagto 
             WHERE int-cond-pagto.cod-cond-pag = emitente.cod-cond-pag NO-LOCK NO-ERROR.
        
        IF AVAIL int-cond-pagto THEN DO:
            ASSIGN l-cessao-credito = IF SUBSTRING(int-cond-pagto.char-1,3,1) = "S" THEN YES ELSE NO.
        END.
        
        if emitente.natureza = 3 and emitente.cgc = ? then DO:
            ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(for2)"
                   cDescEmail = "Fornecedor " + STRING(emitente.cod-emitente) + " sem CGC informado. SDCV: " + string(entry(3,c-linha,";"),"X(8)") 
                   c-erro = "6".
            RUN piEnviaEmail(INPUT cRemetente, 
                             INPUT cDestino,
                             INPUT cAssunto,
                             INPUT cDescEmail,
                             INPUT cArqEmail).
            LEAVE.
        END.

        if entry(7,c-linha,";") BEGINS "11910015" THEN
            ASSIGN c-ct-codigo = "11910015"
                   c-sc-codigo = "00100000".
        ELSE IF entry(7,c-linha,";") BEGINS "11930055" THEN
            ASSIGN c-ct-codigo = "11930055"
                   c-sc-codigo = "00100000".
        ELSE 
            ASSIGN c-ct-codigo = entry(7,c-linha,";")
                   c-sc-codigo = "00" + entry(6,c-linha,";").  

        find conta-contab
             where conta-contab.ct-codigo = c-ct-codigo
               and conta-contab.sc-codigo = c-sc-codigo
               and conta-contab.ep-codigo = empresa.ep-codigo
             no-lock no-error.
        if not avail conta-contab then do:
            ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(cc)"
                   cDescEmail = "Conta contabil " + c-ct-codigo + "." + c-sc-codigo + " n∆o cadastrada. SDCV: "  + string(entry(3,c-linha,";"),"X(8)") 
                   c-erro = "2".
            RUN piEnviaEmail(INPUT cRemetente, 
                             INPUT cDestino,
                             INPUT cAssunto,
                             INPUT cDescEmail,
                             INPUT "").
            LEAVE.
        end.

        find comprador 
             where comprador.cod-comprado = entry(10,c-linha,";") 
             no-lock no-error.
    
        run pi-acompanhar in h-acomp (input "Lendo SDCV: " + string(entry(3,c-linha,";"))).

        if not avail comprador then DO:
            ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(Comp)"
                   cDescEmail = "Comprador " + entry(10,c-linha,";") + " n∆o cadastrado. SDCV: "  + string(entry(3,c-linha,";"),"X(8)") 
                   c-erro = "3".
            RUN piEnviaEmail(INPUT cRemetente, 
                             INPUT cDestino,
                             INPUT cAssunto,
                             INPUT cDescEmail,
                             INPUT cArqEmail).
            LEAVE.
        END.
    
        find cond-pagto 
             where cond-pagto.cod-cond-pag = int(entry(12,c-linha,";")) 
                   no-lock no-error.
        if not avail cond-pagto THEN DO:
            ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(cond)"
                   cDescEmail = "Condicao de pagamento " + entry(12,c-linha,";") + " n∆o cadastrada. SDCV: "  + string(entry(3,c-linha,";"),"X(8)")  
                   c-erro = "4".
            RUN piEnviaEmail(INPUT cRemetente, 
                             INPUT cDestino,
                             INPUT cAssunto,
                             INPUT cDescEmail,
                             INPUT cArqEmail).
            LEAVE.
        END.

        if dec(entry(18,c-linha,";")) <= 0 THEN DO:
            ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(preco)"
                   cDescEmail = "Preáo zero.  SDCV: "  + string(entry(3,c-linha,";"),"X(8)")  
                   c-erro = "8".
            RUN piEnviaEmail(INPUT cRemetente, 
                             INPUT cDestino,
                             INPUT cAssunto,
                             INPUT cDescEmail,
                             INPUT cArqEmail).
            LEAVE.
        END.

        ASSIGN l-tem-oc = NO
               i-nr-ordem = 0.

        if entry(8,c-linha,";") =  "" then do:
           find first ordem-compra 
                WHERE ordem-compra.cod-emitente = emitente.cod-emitente
                  AND ordem-compra.narrativa BEGINS "SDCV: " + entry(3,c-linha,";") 
                no-lock no-error.
           if avail ordem-compra then DO:
              IF ordem-compra.num-pedido = 0 THEN DO:
                  ASSIGN i-nr-ordem = ordem-compra.numero-ordem
                         l-tem-oc   = YES.

/*                 create tt-ped.
                 assign tt-ped.cgc          = emitente.cgc
                        tt-ped.numero-ordem = ordem-compra.numero-ordem
                        tt-ped.cod-emitente = int(entry(1,c-linha,";")) 
                        tt-ped.l-erro       = NO
                        tt-ped.c-erro       = "0"
                        tt-ped.l-aprovada   = YES
                        tt-ped.sdcv         = entry(3,c-linha,";")
                        l-tem-oc            = YES. */
              END.
              ELSE DO:
                  ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(SDCV)"
                         cAssunto   = "SDCV: " + string(entry(3,c-linha,";"),"X(8)") + 
                                      " ja integrada anteriormente na ordem de compra " +
                                      string(ordem-compra.numero-ordem) + " Pedido: " +
                                      STRING(ordem-compra.num-pedido)
                         c-erro = "5".  /* erro de integraá∆o anterior */
                  
                  RUN piEnviaEmail(INPUT cRemetente, 
                                   INPUT cDestino,
                                   INPUT cAssunto,
                                   INPUT cDescEmail,
                                   INPUT "").
                  RUN pi-trata-erro5.
                  LEAVE.
              END.
           END.
        end.

        if entry(8,c-linha,";") = "" AND NOT l-tem-oc then do:
            ASSIGN l-erro = NO
                   iLockAgain = 0.
            FIND FIRST param-compra EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

            DO WHILE LOCKED param-compra:
                IF LOCKED param-compra THEN DO:
                    PAUSE 5 NO-MESSAGE.  /* Esperar 30 segundos antes de tentar novamente */
                    FIND CURRENT param-compra EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
                END.

                IF (NOT LOCKED param-compra AND NOT AVAILABLE param-compra)
                OR (AVAILABLE  param-compra AND NOT LOCKED param-compra)
                OR (iLockAgain >= 5) THEN LEAVE.

                ASSIGN iLockAgain = iLockAgain + 1.
            END.

            IF NOT AVAILABLE param-compra THEN DO:
                IF LOCKED param-compra THEN DO:
                    /*--- Erro 4: Registro da tabela XXXXXXXX esta bloqueado por outro usuario ---*/
                    ASSIGN cAssunto   = "Registro da tabela ParÉmetros de Compras est† bloqueado por outro usu†rio"
                           cDescEmail = "Registro da tabela ParÉmetros de Compras est† bloqueado por outro usu†rio"  
                           c-erro = "4"
                           l-erro = YES.
                    RUN piEnviaEmail(INPUT cRemetente, 
                                     INPUT cDestino,
                                     INPUT cAssunto,
                                     INPUT cDescEmail,
                                     INPUT cArqEmail).
                END.
                ELSE DO:
                    /*--- Erro 3: Tabela {&TableLabel} nao disponivel ---*/
                    ASSIGN cAssunto   = "Tabela ParÉmetros de Compras n∆o dispon°vel"
                           cDescEmail = "Tabela ParÉmetros de Compras n∆o dispon°vel"  
                           c-erro = "3"
                           l-erro = YES.
                    RUN piEnviaEmail(INPUT cRemetente, 
                                     INPUT cDestino,
                                     INPUT cAssunto,
                                     INPUT cDescEmail,
                                     INPUT cArqEmail).
                END.    
            END.
            ELSE IF CURRENT-CHANGED param-compra THEN DO:
                /*--- Erro 12: Registro corrente ja foi alterado por outro usuario ---*/
                ASSIGN cAssunto   = "Registro corrente foi alterado por outro usu†rio"
                       cDescEmail = "Registro corrente foi alterado por outro usu†rio"  
                       c-erro = "12"
                       l-erro = YES.
                RUN piEnviaEmail(INPUT cRemetente, 
                                 INPUT cDestino,
                                 INPUT cAssunto,
                                 INPUT cDescEmail,
                                 INPUT cArqEmail).
            END.        

            IF NOT l-erro THEN DO:
                IF AVAIL param-compra THEN DO:
                    DO WHILE NOT l-tem-oc:
                        assign i-nr-ordem = param-compra.prox-ord-aut  * 100
                               param-compra.prox-ord-aut = param-compra.prox-ord-aut + 1.

                        FIND ordem-compra WHERE
                             ordem-compra.numero-ordem = i-nr-ordem NO-LOCK NO-ERROR.
                        IF NOT AVAIL ordem-compra THEN
                            ASSIGN l-tem-oc = YES.
                    END.
                END.
            END.
            ELSE DO:
                IF l-erro THEN
                    LEAVE.
            END.

           FIND CURRENT param-compra no-lock NO-ERROR.
                      
           ASSIGN c-it-codigo = if entry(7,c-linha,";") BEGINS "11910015" then
                                   "INVESTI"
                                ELSE
                                   "".
           FIND FIRST item NO-LOCK
                WHERE item.it-codigo = c-it-codigo NO-ERROR.

           ASSIGN c-dep-almoxar = "".

           IF AVAIL item THEN DO:
              FIND FIRST item-uni-estab NO-LOCK
                  WHERE item-uni-estab.it-codigo   = item.it-codigo
                    AND item-uni-estab.cod-estabel = entry(23,c-linha,";") NO-ERROR.
              IF AVAIL item-uni-estab THEN
                 ASSIGN c-dep-almoxar = item-uni-estab.deposito-pad.
           END.

            create tt-ordem-compra.
            assign tt-ordem-compra.numero-ordem = i-nr-ordem
                   tt-ordem-compra.ep-codigo    = empresa.ep-codigo
                   tt-ordem-compra.it-codigo    = c-it-codigo
                   tt-ordem-compra.origem       = 1
                   tt-ordem-compra.data-emissao = today
                   tt-ordem-compra.cod-comprado = entry(10,c-linha,";")
                   tt-ordem-compra.requisitante = entry(9,c-linha,";")
                   tt-ordem-compra.ct-codigo    = c-ct-codigo
                   tt-ordem-compra.sc-codigo    = c-sc-codigo
                   tt-ordem-compra.conta-contab = c-ct-codigo + c-sc-codigo
                   tt-ordem-compra.cod-estabel  = entry(23,c-linha,";")
                   tt-ordem-compra.narrativa    = "SDCV: " + string(entry(3,c-linha,";"),"X(8)") + entry(4,c-linha,";") 
                   tt-ordem-compra.situacao     = 2 /* COTADA */
                   tt-ordem-compra.tp-despesa   = 1 /* TIPO DE RECEITA E DESPESA 1 = MERCADO NACIONAL */

                   /* Adicionado conforme combinado com Waldemar e Osnir, em 18.07.2007 */
                   tt-ordem-compra.dep-almoxar  = c-dep-almoxar
                   tt-ordem-compra.cod-unid-negoc = IF AVAIL item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "ADM".
            
            /* seleciona tipo de despesa do cadastro da conta */

            FIND int-conta-contab NO-LOCK
                 WHERE int-conta-contab.ct-codigo = c-ct-codigo           
                   AND int-conta-contab.sc-codigo = c-sc-codigo NO-ERROR.
            IF AVAIL int-conta-contab THEN
                ASSIGN tt-ordem-compra.tp-despesa = int-conta-contab.tp-codigo.


            create tt-prazo-compra.
            ASSIGN tt-prazo-compra.numero-ordem = i-nr-ordem
                   tt-prazo-compra.parcela      = 1
                   tt-prazo-compra.situacao     = 2 /* COTADA */
                   tt-prazo-compra.it-codigo    = c-it-codigo
                   tt-prazo-compra.un           = "pc"
                   tt-prazo-compra.quantid-orig = dec(entry(5,c-linha,";"))
                   tt-prazo-compra.quantidade   = dec(entry(5,c-linha,";"))
                   tt-prazo-compra.quant-saldo  = dec(entry(5,c-linha,";"))
                   tt-prazo-compra.qtd-do-forn  = dec(entry(5,c-linha,";"))
                   tt-prazo-compra.qtd-sal-forn = dec(entry(5,c-linha,";"))
                   tt-prazo-compra.data-orig    = date(entry(19,c-linha,";"))
                   tt-prazo-compra.data-entrega = date(entry(11,c-linha,";")).

             
            create tt-cotacao-item.
            assign tt-cotacao-item.numero-ordem  = i-nr-ordem
                   tt-cotacao-item.it-codigo     = c-it-codigo
                   tt-cotacao-item.cod-emitente  = int(entry(1,c-linha,";"))
                   tt-cotacao-item.data-cotacao  = date(entry(19,c-linha,";"))
                   tt-cotacao-item.un            = "pc"
                   tt-cotacao-item.preco-unit    = dec(entry(18,c-linha,";")) +
                                                   if entry(17,c-linha,";") <> "1" then 
                                                      dec(entry(18,c-linha,";")) * dec(entry(16,c-linha,";")) / 100 
                                                   else 
                                                      0
                   tt-cotacao-item.pre-unit-for  = dec(entry(18,c-linha,";")) +
                                                   if entry(17,c-linha,";") <> "1" then 
                                                      dec(entry(18,c-linha,";")) * dec(entry(16,c-linha,";")) / 100 
                                                   else 
                                                      0
                   tt-cotacao-item.preco-fornec  = dec(entry(18,c-linha,";")) 
                   tt-cotacao-item.mo-codigo     = 0
                   tt-cotacao-item.codigo-ipi    = if entry(17,c-linha,";") = "1" then 
                                                      yes 
                                                   else 
                                                      no
                   tt-cotacao-item.aliquota-ipi  = dec(entry(16,c-linha,";"))
                   tt-cotacao-item.aliquota-iss  = 0 
                   tt-cotacao-item.codigo-icm    = 1
                   tt-cotacao-item.aliquota-icm  = dec(entry(15,c-linha,";"))
                   tt-cotacao-item.frete         = if entry(14,c-linha,";") = "1" then 
                                                      YES 
                                                   else 
                                                      NO
                   tt-cotacao-item.valor-frete   = dec(entry(13,c-linha,";"))
                   tt-cotacao-item.cod-cond-pag  = IF l-cessao-credito THEN emitente.cod-cond-pag ELSE int(entry(12,c-linha,";")).  

            ASSIGN tt-cotacao-item.prazo-entreg  = date(entry(11,c-linha,";")) - date(entry(19,c-linha,";"))
                   tt-cotacao-item.contato       = entry(2,c-linha,";")
                   tt-cotacao-item.cod-comprado  = entry(10,c-linha,";")
                   tt-cotacao-item.cot-aprovada  = yes
                   tt-cotacao-item.aprovador     = entry(10,c-linha,";")
                   tt-cotacao-item.usuario       = entry(10,c-linha,";")
                   tt-cotacao-item.data-atualiz  = today
                   tt-cotacao-item.hora-atualiz  = string(time,"HH:MM:SS")
                   tt-cotacao-item.motivo-apr    = "SDCv"
                   tt-cotacao-item.dias-validade = 999.

            assign i-mes = int(entry(21,c-linha,";")).
       
            assign tt-ordem-compra.preco-orig    = tt-cotacao-item.preco-fornec
                   tt-ordem-compra.preco-unit    = tt-cotacao-item.preco-unit
                   tt-ordem-compra.pre-unit-for  = tt-cotacao-item.pre-unit-for
                   tt-ordem-compra.preco-fornec  = tt-cotacao-item.preco-fornec
                   tt-ordem-compra.mo-codigo     = 0
                   tt-ordem-compra.codigo-ipi    = tt-cotacao-item.codigo-ipi
                   tt-ordem-compra.aliquota-ipi  = tt-cotacao-item.aliquota-ipi
                   tt-ordem-compra.codigo-icm    = tt-cotacao-item.codigo-icm
                   tt-ordem-compra.aliquota-icm  = tt-cotacao-item.aliquota-icm
                   tt-ordem-compra.aliquota-iss  = tt-cotacao-item.aliquota-iss
                   tt-ordem-compra.frete         = tt-cotacao-item.frete
                   tt-ordem-compra.valor-frete   = tt-cotacao-item.valor-frete
                   tt-ordem-compra.cod-cond-pag  = tt-cotacao-item.cod-cond-pag
                   tt-ordem-compra.prazo-entreg  = tt-cotacao-item.prazo-entreg
                   tt-ordem-compra.contato       = tt-cotacao-item.contato.
            
            RUN pi-executar-bos (OUTPUT l-erro).

            IF l-erro THEN DO:
               NEXT.
            END.

            IF tt-ordem-compra.it-codigo <> "investi"  AND
               c-ct-codigo               <> "11910015" AND
               c-ct-codigo               <> "11930055" THEN
                RUN pi-grava-matriz-rat.

            /* Eliminar unid-neg-ordem para ordens que tiverem a unidade de neg¢cio informada na OC*/
            FIND ordem-compra WHERE
                 ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK NO-ERROR.
            IF AVAIL ordem-compra THEN DO:
                IF ordem-compra.cod-unid-negoc <> "" THEN DO:
                    FOR EACH unid-neg-ordem
                       WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
                        DELETE unid-neg-ordem.
                    END.
                END.
            END.
               
        end. 
        else do:
           IF i-nr-ordem = 0 THEN
               assign i-nr-ordem = int(entry(8,c-linha,";")).

           if i-nr-ordem <> 0 then do:
              find ordem-compra
                   where ordem-compra.numero-ordem = i-nr-ordem no-error.
              if not avail ordem-compra then DO:
                  ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(OC)"
                         cDescEmail = "Ordem de compra " + entry(8,c-linha,";") + " enviada do B2B n∆o cadastrada no EMS " 
                         c-erro = "7".
                  RUN piEnviaEmail(INPUT cRemetente, 
                                   INPUT cDestino,
                                   INPUT cAssunto,
                                   INPUT cDescEmail,
                                   INPUT cArqEmail).
                  LEAVE.
              END.
           end.          
        END.
        find tt-for where tt-for.cod-emitente = int(entry(1,c-linha,";")) no-error.
        if not avail tt-for then do:
           create tt-for.
           assign tt-for.cod-emitente = int(entry(1,c-linha,";")) 
                  tt-for.l-erro       = l-erro.
        end.
    
        if l-erro then assign tt-for.l-erro = l-erro.

        create tt-ped.
        assign tt-ped.cgc          = emitente.cgc
               tt-ped.numero-ordem = i-nr-ordem
               tt-ped.cod-emitente = int(entry(1,c-linha,";")) 
               tt-ped.l-erro       = l-erro
               tt-ped.c-erro       = c-erro
               tt-ped.l-aprovada   = if l-erro then no else yes
               tt-ped.sdcv         = entry(3,c-linha,";").
    END.
    
    input stream b close.

    IF l-erro OR c-erro <> "0" THEN NEXT.
        
    assign c-move = c-dir + "salva".
    
    OS-RENAME VALUE(A) VALUE(C-MOVE).
    
    for each tt-for
        where tt-for.l-erro = no:

        ASSIGN i-num-pedido = 0.

        for each tt-ped 
            where tt-ped.cod-emitente = tt-for.cod-emitente
            break by tt-ped.cod-emitente:

            if FIRST-OF(tt-ped.cod-emitente) then do:
       
               FOR EACH tt-pedido-compr:
                   DELETE tt-pedido-compr.
               END.

               create tt-pedido-compr.
               ASSIGN tt-pedido-compr.natureza        = 1 
                      tt-pedido-compr.data-pedido     = TODAY
                      tt-pedido-compr.situacao        = 1 
                      tt-pedido-compr.cod-emitente    = int(entry(1,c-linha,";")) 
                      tt-pedido-compr.end-entrega     = entry(23,c-linha,";") 
                      tt-pedido-compr.end-cobranca    = entry(23,c-linha,";")
                      tt-pedido-compr.frete           = 2 /* a pagar */
                      tt-pedido-compr.cod-transp      = int(entry(20,c-linha,";"))
                      tt-pedido-compr.via-transp      = 1
                      tt-pedido-compr.cod-cond-pag    = IF l-cessao-credito THEN emitente.cod-cond-pag ELSE int(entry(12,c-linha,";"))
                      tt-pedido-compr.responsavel     = entry(10,c-linha,";")
                      tt-pedido-compr.cod-mensagem    = 1
                      tt-pedido-compr.impr-pedido     = yes.                       
               
               
               RUN pi-grava-pedido(OUTPUT l-erro).

            end.
            IF l-erro THEN
               NEXT.
    
            assign tt-ped.num-pedido = i-num-pedido.

            find ordem-compra
                 where ordem-compra.numero-ordem = tt-ped.numero-ordem no-error.
           
            if not avail ordem-compra then do:
               ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(oc2)"
                      cDescEmail = "Ordem de compra " + entry(8,c-linha,";") + " SUMIU " 
                      c-erro = "7".
               RUN piEnviaEmail(INPUT cRemetente, 
                                INPUT cDestino,
                                INPUT cAssunto,
                                INPUT cDescEmail,
                                INPUT cArqEmail).
            end.
            else do:
               assign ordem-compra.num-pedido = tt-ped.num-pedido
                      ordem-compra.data-pedido = today
                      ordem-compra.cod-emitente = tt-ped.cod-emitente
                      ordem-compra.situacao = 2.
               for each prazo-compra
                   where prazo-compra.numero-ordem = tt-ped.numero-ordem:
                   assign prazo-compra.situacao = 2.
               end.
            end.    
        end.
    end. 

    assign cArqVolta = "/usr3/b2b/mag_b2b/compras/" +
                   substring(string(today),1,2) +
                   substring(string(today),4,2) +
                   substring(string(time,"HH:MM:SS"),1,2) +
                   substring(string(time,"HH:MM:SS"),4,2) +
                   substring(string(time,"HH:MM:SS"),7,2) +
                   string(random(2,99),"99") +
                   ".norc".
       


    /* assign cArqVolta = "\\intel200\b2b\mag_b2b\compras\" +
                   substring(string(today),1,2) +
                   substring(string(today),4,2) +
                   substring(string(time,"HH:MM:SS"),1,2) +
                   substring(string(time,"HH:MM:SS"),4,2) +
                   substring(string(time,"HH:MM:SS"),7,2) +
                   string(random(2,99),"99") +
                   ".norc".
       */
    output stream z to value(cArqVolta). 
    
    for each tt-ped:

        put stream z tt-ped.numero-ordem ";"
            tt-ped.sdcv ";"
            tt-ped.num-pedido ";"
            tt-ped.l-aprovada ";"
            tt-ped.cgc ";"
            tt-ped.c-erro
            skip.
    end.

    output stream z close.

    assign c-move = "/usr3/b2b/mag_b2b/compras/salva/".  
  
    /* ASSIGN c-move = "\\intel200\b2b\mag_b2b\compras\salva\".  */
                    
    OS-COPY VALUE(cArqVolta) VALUE(c-move).       

end.

input stream a close.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

PROCEDURE pi-trata-erro5.
    assign c-move = c-dir + "salva".
    
    OS-RENAME VALUE(A) VALUE(C-MOVE).
/*
    IF OS-ERROR = 10 THEN /* Arquivo ja existe */
        OS-DELETE VALUE(A).
*/
  
    assign cArqVolta = "/usr3/b2b/mag_b2b/compras/" +
                    substring(string(today),1,2) +
                    substring(string(today),4,2) +
                    substring(string(time,"HH:MM:SS"),1,2) +
                    substring(string(time,"HH:MM:SS"),4,2) +
                    substring(string(time,"HH:MM:SS"),7,2) +
                    string(random(2,99),"99") +
                    ".norc".
      
    /* assign cArqVolta = "\\intel200\b2b\mag_b2b\compras\" +
                    substring(string(today),1,2) +
                    substring(string(today),4,2) +
                    substring(string(time,"HH:MM:SS"),1,2) +
                    substring(string(time,"HH:MM:SS"),4,2) +
                    substring(string(time,"HH:MM:SS"),7,2) +
                    string(random(2,99),"99") +
                    ".norc".
     */  
     output stream z to value(cArqVolta). 

     put stream z ordem-compra.numero-ordem ";"
         entry(3,c-linha,";") ";"
         ordem-compra.num-pedido ";"
         "yes" ";"
         emitente.cgc ";"
         "0"
         skip.

     output stream z close.

     assign c-move = "/usr3/b2b/mag_b2b/compras/salva/".  
   
     /* ASSIGN c-move = "\\intel200\b2b\mag_b2b\compras\salva\".  */

     OS-COPY VALUE(cArqVolta) VALUE(c-move).
END PROCEDURE.

PROCEDURE pi-grava-matriz-rat.

   assign c-sdcv = entry(1,entry(3,c-linha,";"),"/") +
                   entry(2,entry(3,c-linha,";"),"/").
                  
   assign c-rat = c-dir + c-sdcv + ".NRAT".
                 
   IF SEARCH(c-rat) = ? THEN
      LEAVE.

   input stream d from value(c-rat).

   repeat: 
        import stream d unformatted c-lin-rat.
        
        find first matriz-rat-ordem where
             matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem and
             matriz-rat-ordem.conta-contabil = entry(1,c-lin-rat,";") + "00" + entry(2,c-lin-rat,";")  
            NO-ERROR.
        if not avail matriz-rat-ordem then do:
           create matriz-rat-ordem.
           assign matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem
                  matriz-rat-ordem.conta-contabil = entry(1,c-lin-rat,";") + "00" + entry(2,c-lin-rat,";")
                  matriz-rat-ordem.ct-codigo    = entry(1,c-lin-rat,";")
                  matriz-rat-ordem.sc-codigo    = "00" + entry(2,c-lin-rat,";").
        end.
        assign matriz-rat-ordem.perc = dec(entry(4,c-lin-rat,";")).
   end.
   
   input stream d close.
    
   assign c-move = c-dir + "salva".

   OS-RENAME VALUE(c-rat) VALUE(c-move).
                                                    
end.


PROCEDURE piEnviaEmail:

    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEF VAR c-arq-tmp AS CHAR NO-UNDO.
    DEF VAR icont AS INT. 

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

    IF pDescEmail = "" OR pDescEmail = ? THEN
        ASSIGN pDescEmail = pAssunto.

    ASSIGN pRemetente = "b2b@intelbras.com.br"
           pDestino   = "".

    FOR EACH tt-prog-ponto:
        DELETE tt-prog-ponto.
    END.

    RUN esp/es0018p.p (INPUT "es0589",
                       INPUT 1, 
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).
    for each tt-prog-ponto:
        ASSIGN pDestino = pDestino + tt-prog-ponto.conteudo + ";".
    END.

    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = pRemetente
           tt-mail.Destinatario  = pdestino
           tt-mail.Assunto       = pAssunto
           tt-mail.Arquivo       = IF pArquivo <> "" then
                                      SEARCH(pArquivo) 
                                   ELSE
                                       "" 
           tt-mail.Mensagem      = pDescEmail.

       RUN utp/utapi019.p PERSISTENT SET h-utapi019.

       FOR EACH tt-mail:

           FOR EACH tt-envio2.   DELETE tt-envio2.   END.
           FOR EACH tt-mensagem. DELETE tt-mensagem. END.

           CREATE tt-envio2.
           ASSIGN tt-envio2.versao-integracao = 1
                  tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                  tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                  tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
                  tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
                  tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
                  tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Tempor†rio */
                  tt-envio2.formato           = "TEXTO".

           CREATE tt-mensagem.
           ASSIGN tt-mensagem.seq-mensagem = 1
                  tt-mensagem.mensagem     = tt-mail.Mensagem. /* Mensagem           */
                   /*"<h1><center>message body 1</pre>"*/

       /*    PUT 'TST 1 ' SKIP.*/
           RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                          INPUT  TABLE tt-mensagem,
                                          OUTPUT TABLE tt-erros).

       /*    PUT 'TST 2 ' SKIP.*/
/*           ASSIGN tt-mail.lEnviado = CAN-FIND(FIRST tt-erros). */
           FIND FIRST tt-erros NO-LOCK NO-ERROR.
           IF AVAIL tt-erros THEN DO:
               ASSIGN c-arq-tmp = session:TEMP-DIRECTORY + "erros-comerc.LOG".

              OUTPUT TO value(c-arq-tmp).

               FOR EACH tt-erros:
                   DISP tt-erros.cod-erro
                        tt-erros.desc-erro FORMAT "x(90)"
                        tt-erros.desc-arq  FORMAT "x(60)" WITH STREAM-IO WIDTH 200.
               END.
               OUTPUT CLOSE.
           END.
       END.
       DELETE PROCEDURE h-utapi019.
END PROCEDURE.

PROCEDURE pi-executar-bos.
    DEFINE OUTPUT PARAM l-erro         AS LOG NO-UNDO.
    
    bloco:
    DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                    ON ENDKEY UNDO bloco, LEAVE bloco:
        
        run inbo/boin274.p persistent set h-boin274.
        run openQueryStatic in h-boin274(input "Main":U).
        run emptyRowErrors in h-boin274.
        run setRecord       in h-boin274(input table tt-ordem-compra).
        RUN createRecord   in h-boin274.
        run getRowErrors   in h-boin274(output table RowErrors).
    
        for each RowErrors:
            ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(ORDEM-COMPRA)"
                   cDescEmail = RowErrors.ERRORDescription 
                   l-erro = YES.
            RUN piEnviaEmail(INPUT cRemetente, 
                             INPUT cDestino,
                             INPUT cAssunto,
                             INPUT cDescEmail,
                             INPUT cArqEmail).
        END.
/*        
        if valid-handle(h-boin274) and h-boin274:file-name = "inbo/boin274.p" and h-boin274:type = "procedure" then
           run destroyBO in h-boin274.*/
        if valid-handle(h-boin274) then do:
           delete procedure h-boin274.
           assign h-boin274 = ?.
        end.

        IF l-erro  THEN
           UNDO bloco, LEAVE bloco.

        run inbo/boin082.p persistent set h-boin082.
        run openQueryStatic in h-boin082(input "Main":U).
        run emptyRowErrors in h-boin082.
        run setRecord       in h-boin082(input table tt-cotacao-item).
        RUN createRecord   in h-boin082.
        run getRowErrors   in h-boin082(output table RowErrors).
    
        for each RowErrors:
            ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(COTACAO-ITEM)"
                   cDescEmail = RowErrors.ERRORDescription 
                   l-erro = YES.
            RUN piEnviaEmail(INPUT cRemetente, 
                             INPUT cDestino,
                             INPUT cAssunto,
                             INPUT cDescEmail,
                             INPUT cArqEmail).
        END.
/*        
        if valid-handle(h-boin082) and h-boin082:file-name = "inbo/boin082.p" and h-boin082:type = "procedure" then
           run destroyBO in h-boin082.*/
        if valid-handle(h-boin082) then do:
           delete procedure h-boin082.
           assign h-boin082 = ?.
        end.
        
        IF l-erro  THEN
           UNDO bloco, LEAVE bloco.

        run inbo/boin356.p persistent set h-boin356.
        run openQueryStatic in h-boin356(input "Main":U).
        run emptyRowErrors in h-boin356.
        run setRecord       in h-boin356(input table tt-prazo-compra).
        RUN createRecord   in h-boin356.
        run getRowErrors   in h-boin356(output table RowErrors).
    
        for each RowErrors:
            ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(PRAZO-COMPRA)"
                   cDescEmail = RowErrors.ERRORDescription 
                   l-erro = YES.
            RUN piEnviaEmail(INPUT cRemetente, 
                             INPUT cDestino,
                             INPUT cAssunto,
                             INPUT cDescEmail,
                             INPUT cArqEmail).
        END.
/*        
        if valid-handle(h-boin356) and h-boin356:file-name = "inbo/boin356.p" and h-boin356:type = "procedure" then
           run destroyBO in h-boin356.*/
        if valid-handle(h-boin356) then do:
           delete procedure h-boin356.
           assign h-boin356 = ?.
        end.
    
        IF l-erro  THEN
           UNDO bloco, LEAVE bloco.

        END.
    END.

PROCEDURE pi-grava-pedido.
    DEFINE OUTPUT PARAM l-erro         AS LOG NO-UNDO.

    bloco:
    DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                    ON ENDKEY UNDO bloco, LEAVE bloco:

        run inbo/boin295.p persistent set h-boin295.
        run openQueryStatic in h-boin295(input "Main":U).
        run emptyRowErrors in h-boin295.
        
        RUN geraNumeroPedidoCompra IN h-boin295 (output i-num-pedido).

        ASSIGN tt-pedido-compr.num-pedido = i-num-pedido.
        
        run setRecord       in h-boin295(input table tt-pedido-compr).
        RUN createRecord   in h-boin295.
        run getRowErrors   in h-boin295(output table RowErrors).

        for each RowErrors:
            ASSIGN cAssunto   = "Problema de integraá∆o entre B2B e EMS(PEDIDO-COMPR)"
                   cDescEmail = RowErrors.ERRORDescription 
                   l-erro = YES.
            RUN piEnviaEmail(INPUT cRemetente, 
                             INPUT cDestino,
                             INPUT cAssunto,
                             INPUT cDescEmail,
                             INPUT cArqEmail).
        END.

        delete procedure h-boin295.
        ASSIGN h-boin295 = ?.

        IF l-erro  THEN
           UNDO bloco, LEAVE bloco.
    END.
END.
    /* es0589.p   */

