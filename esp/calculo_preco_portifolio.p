DEFINE BUFFER b-unid-feder FOR unid-feder.


DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.
DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd AS INTEGER.


def input param p_cod-estabel  like ped-venda.cod-estabel.
def input param p_cod-emitente like ped-venda.cod-emitente.
def input param p_cod-entrega  like ped-venda.cod-entrega.
def input param p_tabela       like preco-item.nr-tabpre.


DEFINE VARIABLE l-return                AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-boes505               AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-nat-oper              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-consumidor-final      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-bodi317im1br          AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-aliquota-ipi         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-preco                AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-icms            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-iss             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-descto-zf            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-desc-pis-zfm         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-desc-cofins-zfm      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-per-des-icms         AS DECIMAL     NO-UNDO.

def var i-cont as int.
def var i-arred as int.
def var i-round as int.

def temp-table tt-item NO-UNDO XML-NODE-NAME 'ProdutoItem'
    field it-codigo            like ped-item.it-codigo
    field quant-min            like ped-item.qt-pedida
    field nat-operacao         like ped-item.nat-operacao
    field preco-unit           like ped-item.vl-preuni
    field vl-icms              as decimal
    field perc-icms            as decimal
    field vl-ipi               as decimal
    field perc-ipi             as decimal
    field vl-pis               as decimal
    field vl-cofins            as decimal
    field vl-icmsst            as decimal
    field preco-total          as decimal.
    

def input-output parameter table for tt-item.
    
    
find first emitente
     where emitente.cod-emitente = p_cod-emitente 
           no-lock no-error.
  
           
       

if avail emitente then do:
   IF  emitente.natureza <> 3             and 
       emitente.contrib-icms = NO         and 
      (emitente.ins-estadual = ""         or 
       emitente.ins-estadual = "ISENTO"   or
       emitente.ins-estadual = "ISENTA")  THEN
       ASSIGN l-consumidor-final = YES.

    RUN esbo/boes505.p PERSISTENT SET h-boes505.
    RUN defineNatOperacao IN h-boes505 (INPUT p_cod-estabel,
                                        INPUT emitente.cod-emitente,
                                        INPUT p_cod-entrega,
                                        INPUT "",
                                        INPUT l-consumidor-final,
                                        OUTPUT c-nat-oper,
                                        OUTPUT l-return).
    DELETE PROCEDURE h-boes505.
   
    for each preco-item 
        where preco-item.nr-tabpre = p_tabela 
         /* and dt-inival >= today */ no-lock,
       first item where 
            item.it-codigo = preco-item.it-codigo no-lock :
            
       if avail item then do:
          RUN esbo/boes505.p PERSISTENT SET h-boes505.
          RUN defineNatOperacao IN h-boes505 (INPUT p_cod-estabel,
                                              INPUT emitente.cod-emitente,
                                              INPUT p_cod-entrega,
                                              INPUT preco-item.it-codigo,
                                              INPUT l-consumidor-final,
                                              OUTPUT c-nat-oper,
                                              OUTPUT l-return).
          DELETE PROCEDURE h-boes505.
   
          /* busca aliquota de ICMS do item */
 
          ASSIGN g-cod-emitente-bodi317im1br = emitente.cod-emitente.
          ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.

          FOR FIRST estabelec FIELDS (pais estado)
              WHERE estabelec.cod-estabel = p_cod-estabel NO-LOCK USE-INDEX codigo: END.
          FOR FIRST loc-entr NO-LOCK
              WHERE loc-entr.nome-abrev  = emitente.nome-abrev
                AND loc-entr.cod-entrega = "Padrao": END.
            

          assign de-perc-icms = 0.
          IF emitente.contrib-icm = YES THEN DO:
             FOR FIRST inf-compl  /* conteudo do cd0908 */
                 WHERE inf-compl.cdn-identif = 5
                   AND inf-compl.cod-indice = item.it-codigo + chr(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
                assign de-perc-icms = inf-compl.val-campo.
             END.
          END.
          IF de-perc-icms = 0 THEN DO:
                RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.

             RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                       INPUT  emitente.natureza,
                                                       INPUT  estabelec.estado,
                                                       INPUT  estabelec.pais,
                                                       INPUT  loc-entr.estado,
                                                       INPUT  item.it-codigo,
                                                       INPUT  c-nat-oper,
                                                       OUTPUT de-perc-icms, 
                                                       OUTPUT l-return).
             DELETE PROCEDURE h-bodi317im1br.

             FIND natur-oper NO-LOCK
                  WHERE natur-oper.nat-operacao = c-nat-oper NO-ERROR.
      
             IF  AVAIL natur-oper            AND 
                 ITEM.cd-trib-icm = 4        AND 
                 natur-oper.cd-trib-icm = 4  AND 
                 de-perc-icms > 0            AND 
                 natur-oper.perc-red-icm > 0 THEN 
              ASSIGN de-perc-icms = de-perc-icms - (de-perc-icms * natur-oper.perc-red-icm / 100).
          end. 
        
          ASSIGN g-cod-emitente-bodi317im1br = 0.
          ASSIGN g-codigo-orig-bodi317sd     = 0.
   

          FIND natur-oper
               WHERE natur-oper.nat-operacao = c-nat-oper NO-LOCK NO-ERROR.
   
          FIND cidade-zf WHERE
               cidade-zf.cidade = loc-entr.cidade AND
               cidade-zf.estado = loc-entr.estado NO-LOCK NO-ERROR.
   
          IF NOT AVAIL cidade-zf and avail natur-oper THEN 
             IF (ITEM.cd-trib-icm <> 1  AND 
                 ITEM.cd-trib-icm <> 4) or
                (natur-oper.cd-trib-icm <> 1 AND
                 natur-oper.cd-trib-icm <> 4) THEN /* quando ‚ isento */
                 ASSIGN de-perc-icms = 0.
   
          IF  de-perc-icms <> 0 THEN
              ASSIGN de-preco = preco-item.preco-venda / ((100 - de-perc-icms) / 100) .
          ELSE
              ASSIGN de-preco = preco-item.preco-venda.

         /***** Desconto ICMS ****/

          IF  AVAIL natur-oper THEN    
              ASSIGN de-descto-zf = DEC(SUBSTR(natur-oper.char-2,66,5)).
    
          ASSIGN de-desc-pis-zfm    = 0
                 de-desc-cofins-zfm = 0.
    
          IF  AVAIL natur-oper THEN
              IF  natur-oper.log-deduz-desc-zfm-tot-nf  = YES THEN
                  ASSIGN de-desc-pis-zfm    = natur-oper.val-perc-desc-pis-zfm    
                         de-desc-cofins-zfm = natur-oper.val-perc-desc-cofins-zfm.
    
          IF  loc-entr.estado <> estabelec.estado AND
              emitente.contrib-icms = YES THEN DO:
              FOR FIRST b-unid-feder FIELDS(est-exc perc-exc desc-icms) WHERE
                        b-unid-feder.pais   = estabelec.pais AND
                        b-unid-feder.estado = estabelec.estado NO-LOCK:
    
              ASSIGN de-per-des-icms = 0.
    
              DO  i-cont = 1 TO 12:
                  IF  b-unid-feder.est-exc[i-cont] = loc-entr.estado THEN DO:
                      ASSIGN de-per-des-icms = b-unid-feder.perc-exc[i-cont + 13].
                      LEAVE.
                  END.
              END.
    
              ASSIGN de-per-des-icms = IF  de-per-des-icms <> 0 THEN
                                           de-per-des-icms
                                       ELSE 
                                           IF  b-unid-feder.desc-icms <> 0 THEN
                                               b-unid-feder.desc-icms ELSE
                                               if avail natur-oper then natur-oper.per-des-icms else 0.
             END.
          END.
       END.
       ELSE 
           ASSIGN de-per-des-icms = if avail natur-oper then natur-oper.per-des-icms else 0.
    

       ASSIGN de-preco = IF  i-arred = 1 
                         THEN TRUNCATE(de-preco * (1 - (de-per-des-icms / 100)), i-round)
                         ELSE ROUND(de-preco * (1 - (de-per-des-icms / 100)), i-round).

       ASSIGN de-preco = IF  AVAIL cidade-zf AND AVAIL natur-oper THEN                                                               
                           IF  i-arred = 1                                                                                         
                              THEN TRUNCATE(de-preco  * (1 - ((de-descto-zf + de-desc-pis-zfm + de-desc-cofins-zfm) / 100)), i-round) 
                              ELSE ROUND(de-preco  * (1 - ((de-descto-zf + de-desc-pis-zfm + de-desc-cofins-zfm) / 100)), i-round)    
                           ELSE de-preco.                                                                                              


       if l-return then do:
          create tt-item.
          assign tt-item.it-codigo  = preco-item.it-codigo
                 tt-item.preco-unit = preco-item.preco-venda
                 tt-item.nat-operacao = c-nat-oper
                 tt-item.perc-icms    = de-perc-icms
                 tt-item.perc-ipi     = item.aliquota-ipi
                 tt-item.quant-min    = preco-item.quant-min.
                 tt-item.preco-total  = de-preco.
       end.
        
    end. /* for each */
end.           
     
