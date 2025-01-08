{include/i-prgvrs.i ESFTP003 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP003RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio de NFF cobradas em Duplicidade
**              ConversÆo do ES0874 (Claudiney)
**  VersÆo....: 001 15/11/2004 - Chaves
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp003tt.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
def temp-table tt-nota-fiscal
    field cod-estabel LIKE nota-fiscal.cod-estabel
    field serie       LIKE nota-fiscal.serie
    field nr-nota     LIKE nota-fiscal.nr-nota-fis
    field r-nota        as ROWID
    field duplicidade   as log
    index seq nr-nota.

/****************************  Variaveis    ****************************/
    def var de-valor           as dec format ">>,>>>,>>9.99".
    def var de-dif             as dec format "->,>>9.99".
    def var de-valor-comis     as dec format ">>,>>>,>>9.99".
    def var de-valor-calc      as dec format ">>,>>>,>>9.99".
    def var de-tot-nota        as dec format ">>,>>>,>>9.99".
    def var de-vl-temp         as dec.
    def var de-perc            as dec format ">9.99".
    def var da-data            as date.
    def var de-vl-frete        as dec.
/****************************  Frames       ****************************/
form nota-fiscal.nat-operac    column-label "Nat.Oper"
     nota-fiscal.nr-nota-fis   column-label "Nr. Nota"
     nota-fiscal.dt-emis-nota  column-label "Dt Fatur"
     emitente.cod-emite        column-label "Cliente"
     nota-fiscal.vl-tot-nota   column-label "Total Nota"
     /*
     conhecimento.nr-docto     column-label "Conhecimento"
     conhecimento.emissao      column-label "Dt Conhec"
     nota-fiscal.nome-transp   column-label "Fornec"
     conhecimento.valor-total  column-label "Vl Conhec" format ">>,>>>,>>9.99"*/
     de-valor                  column-label "Vl Calcul"
     de-dif                    column-label "Diferenca"
     with width 132 55 down frame f-imprime.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*
 * for each tt-raw-digita:
 *     create tt-digita.
 *     raw-transfer tt-raw-digita.raw-digita to tt-digita.
 * end. 
 */

def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       /*c-titulo-relat = "Relatorio de NFF cobradas em Duplicidade"*/
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP003"
       c-versao       = "2.04"
       c-revisao      = "001".
if tt-param.iTipo = 1 then 
     assign c-titulo-relat = "Relatorio de NFF sem conhecimento".
else assign c-titulo-relat = "Relatorio de NFF cobradas em Duplicidade".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelat:
    run pi-sem-conhecimento.

    /*
    if tt-param.iTipo = 1 then 
        run pi-sem-conhecimento.
    else run pi-duplicidade.*/
END PROCEDURE.

procedure pi-duplicidade.
        /*
        do da-data = tt-param.da-emis-ini to tt-param.da-emis-fim:
           RUN pi-acompanhar IN h-acomp (INPUT "Data.: " + string(da-data,"99/99/9999")).
           for each nota-fiscal no-lock use-index ch-distancia
               where nota-fiscal.dt-cancela = ?
                 and nota-fiscal.dt-emis-nota = da-data
                 and nota-fiscal.serie = "3"
                 and nota-fiscal.cidade-cif <> "",
               first transporte 
                     where transporte.nome-abrev = nota-fiscal.nome-transp:

               FIND FIRST tt-nota-fiscal 
                    WHERE tt-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                    AND   tt-nota-fiscal.serie       = nota-fiscal.serie 
                    AND   tt-nota-fiscal.nr-nota     = nota-fiscal.nr-nota-fis no-error.
               if not avail tt-nota-fiscal then do:     
                  create tt-nota-fiscal.
                  assign tt-nota-fiscal.nr-nota     = nota-fiscal.nr-nota-fis
                         tt-nota-fiscal.r-nota      = ROWID(nota-fiscal)
                         tt-nota-fiscal.duplicidade = no.
               end.
               else assign tt-nota-fiscal.duplicidade = yes.
           end.
        end.
        
        /*{esp/es0000.i}
        view frame f-cabec.
        view frame f-rodape.
        */
        for each tt-nota-fiscal 
            where tt-nota-fiscal.duplicidade:
            for each nota-fiscal no-lock 
                where ROWID(nota-fiscal) = tt-nota-fiscal.r-nota,
                first transporte 
                     where transporte.nome-abrev = nota-fiscal.nome-transp:
                
                find first conhecimento 
                     where conhecimento.cgc = nfs-conhecimento.cgc
                       and conhecimento.nr-docto = nfs-conhecimento.nr-docto
                     no-lock no-error.
                
                find first emitente no-lock 
                     where emitente.cod-emitente = nota-fiscal.cod-emitente
                     no-error.

                find first capital-frete no-lock 
                     where capital-frete.cod-transp = transporte.cod-transp
                       and capital-frete.uf         = emitente.estado
                       and capital-frete.nome     = emitente.cidade
                     no-error.
            
               find first tabela-frete no-lock
                    where tabela-frete.cod-transp = transporte.cod-transp
                      and tabela-frete.uf         = emitente.estado
                      and tabela-frete.dt-ini    <= nota-fiscal.dt-emis-nota
                      and tabela-frete.dt-fim    >= nota-fiscal.dt-emis-nota
                    no-error.
               assign de-valor = 0.
               if avail tabela-frete then do:
                  if avail capital-frete then do:
                     assign de-vl-temp = (nota-fiscal.vl-tot-nota *  
                                         (tabela-frete.perc-cap / 100))
                            de-perc    = tabela-frete.perc-cap.
                     if de-vl-temp < tabela-frete.min-cap then
                        assign de-valor = de-valor + (tabela-frete.min-cap /
                                          ((100 - tabela-frete.icms-cap) 
                                          / 100)).
                     else
                        assign de-valor = de-valor + (de-vl-temp /
                                          ((100 - tabela-frete.icms-cap) 
                                          / 100)).
                  end.
                  else do:
                     assign de-vl-temp = nota-fiscal.vl-tot-nota *
                                         (tabela-frete.perc-int / 100)
                            de-perc    = tabela-frete.perc-int. 
                     if de-vl-temp < tabela-frete.min-int then
                        assign de-valor = de-valor + (tabela-frete.min-int /
                                          ((100 - tabela-frete.icms-int) 
                                          / 100)).
                     else   
                        assign de-valor = de-valor + (de-vl-temp /
                                          ((100 - tabela-frete.icms-int) 
                                          / 100)).
                  end.
               end.
               else 
                  assign de-valor = 0.
               assign de-valor = de-valor + conhecimento.valor-pedagio +
                                 conhecimento.valor-suframa.

               assign de-dif = conhecimento.valor-total - de-valor.
               
               display nota-fiscal.nat-operac
                       nota-fiscal.nr-nota-fis
                       nota-fiscal.dt-emis-nota
                       emitente.cod-emite
                       nota-fiscal.vl-tot-nota
                       conhecimento.nr-docto
                       conhecimento.emissao
                       nota-fiscal.nome-transp
                       conhecimento.valor-total
                       de-valor
                       de-dif
                       with frame f-imprime.
                down with frame f-imprime.
            end.    
        end.
        */
end.

procedure pi-sem-conhecimento.
        do da-data = tt-param.da-emis-ini to tt-param.da-emis-fim:
           RUN pi-acompanhar IN h-acomp (INPUT "Data.: " + string(da-data,"99/99/9999")).
           /* TMS for each  nota-fiscal-tf no-lock 
               where nota-fiscal-tf.dt-cancela = ?
                 and nota-fiscal-tf.dt-emis-nota = da-data
                 and nota-fiscal-tf.serie = "3",
               first transporte 
               where transporte.nome-abrev = nota-fiscal-tf.nome-transp
                 and transporte.cod-transp <> 0  /* RETIRA */ 
                 and transporte.cod-transp <> 16 /* ELISOL */
                 and transporte.cod-transp <> 47 /* MALOTE */
                 and transporte.cod-transp <> 73 /* VASPEX */
                 and transporte.cod-transp <> 254: /* SEDEX */ 
               RUN pi-acompanhar IN h-acomp (INPUT "Data - Num.Nota.: " + string(da-data,"99/99/9999") + "-" + STRING(nota-fiscal-tf.nr-nota-fis)).
                     
               find first devol-cli use-index ch-nfs no-lock
                    where devol-cli.cod-estabel  = nota-fiscal-tf.cod-estabel
                    and   devol-cli.serie        = nota-fiscal-tf.serie
                    and   devol-cli.nr-nota-fis  = nota-fiscal-tf.nr-nota-fis
                    no-error.
               
               if avail devol-cli then do:
                  find first docum-est no-lock
                       where docum-est.cod-emitente = devol-cli.cod-emitente
                         and docum-est.nro-docto    = devol-cli.nro-docto
                         and docum-est.serie-docto  = devol-cli.serie-docto
                         and docum-est.nat-operacao = devol-cli.nat-operacao
                       no-error.
                  /* 500 = ENTREGA SUSPENSA 517 = TROCA DE NOTA FISCAL 
                  if avail docum-est and
                     (docum-est.u-dec-1 = 500 or docum-est.u-dec-1 = 517) then                      next.*/
                  FIND FIRST int-docum-est NO-LOCK
                       WHERE int-docum-est.serie-docto  = docum-est.serie-docto 
                       AND   int-docum-est.nro-docto    = docum-est.nro-docto   
                       AND   int-docum-est.cod-emitente = docum-est.cod-emitente
                       AND   int-docum-est.nat-operacao = docum-est.nat-operacao NO-ERROR.
                  IF AVAIL int-docum-est AND 
                     (int-docum-est.cod-msg-devolucao = 500  OR 
                      int-docum-est.cod-msg-devolucao = 517) THEN NEXT.
               end.
                                                  
               FIND FIRST tt-nota-fiscal 
                    WHERE tt-nota-fiscal.cod-estabel = nota-fiscal-tf.cod-estabel
                    AND   tt-nota-fiscal.serie       = nota-fiscal-tf.serie 
                    AND   tt-nota-fiscal.nr-nota     = nota-fiscal-tf.nr-nota-fis no-error.
               if NOT avail tt-nota-fiscal then do:     
                  create tt-nota-fiscal.
                  assign tt-nota-fiscal.cod-estabel = nota-fiscal-tf.cod-estabel
                         tt-nota-fiscal.serie       = nota-fiscal-tf.serie 
                         tt-nota-fiscal.nr-nota     = nota-fiscal-tf.nr-nota-fis 
                         tt-nota-fiscal.r-nota      = ROWID(nota-fiscal-tf).
               end.
           end.
        end.*/

        /*
        {esp/es0000.i}
        
        view frame f-cabec.
        view frame f-rodape.
        */
        IF NOT can-find(FIRST tt-nota-fiscal) THEN
            PUT "NÆo foram encontrados notas sem conhecimento para o per¡odo informado: " SKIP
                "Data Inicial.: " string(tt-param.da-emis-ini,"99/99/9999") FORMAT 'x(10)' "  "
                "Data Final.: " string(tt-param.da-emis-fim,"99/99/9999") FORMAT 'x(10)' SKIP.
        /* TMS for each tt-nota-fiscal,
            FIRST nota-fiscal-tf no-lock 
            WHERE ROWID(nota-fiscal-tf) = tt-nota-fiscal.r-nota,
            FIRST transporte 
            WHERE transporte.nome-abrev = nota-fiscal-tf.nome-transp
            by transporte.nome-abrev:

            FIND FIRST frete-nota-fis NO-LOCK
                 WHERE frete-nota-fis.cod-estabel = nota-fiscal-tf.cod-estabel
                 AND   frete-nota-fis.serie       = nota-fiscal-tf.serie
                 AND   frete-nota-fis.nr-nota-fis = nota-fiscal-tf.nr-nota-fis
                 AND   frete-nota-fis.int-1       = 1 NO-ERROR.
            IF  NOT AVAIL frete-nota-fis THEN NEXT.
            
            IF CAN-FIND(FIRST nota-conhec NO-LOCK
                        WHERE nota-conhec.cod-estabel-nf = frete-nota-fis.cod-estabel 
                        AND   nota-conhec.serie-nf       = frete-nota-fis.serie       
                        AND   nota-conhec.nr-nota-fis    = frete-nota-fis.nr-nota-fis 
                        AND   nota-conhec.nome-transp    = frete-nota-fis.nome-transp 
                        AND   nota-conhec.int-1          = frete-nota-fis.int-1       
                        AND   nota-conhec.int-2          = frete-nota-fis.sequencia) THEN
                NEXT.
            
            ASSIGN de-vl-frete = frete-nota-fis.vl-frete.
                
            /*
            run pi-calcula-frete (nota-fiscal-tf.nr-nota-fis,
                                  nota-fiscal-tf.estado,
                                  nota-fiscal-tf.cidade,
                                  avail transporte,
                                  0,
                                  nota-fiscal-tf.vl-tot-nota,
                                  nota-fiscal-tf.dt-emis-nota,
                                  output de-vl-frete).
            */
            DISPLAY nota-fiscal-tf.serie
                    nota-fiscal-tf.nr-nota-fis
                    nota-fiscal-tf.dt-emis-nota
                    nota-fiscal-tf.estado
                    nota-fiscal-tf.vl-nota 
                    nota-fiscal-tf.nome-transp
                    de-vl-frete LABEL "Vl Frete"
                    WITH DOWN STREAM-IO. */
        end.    
        
        /*output close.*/
end.

/********** PROCEDURES *********************************************/

/*
procedure pi-calcula-frete:
    def input  param i-nr-nota-fre    as integer no-undo.
    def input  param c-uf         as char    no-undo.
    def input  param c-cidade     as char    no-undo.
    def input  param l-existe-tra as logical no-undo.
    def input  param de-tot-item  as decimal no-undo.
    def input  param de-tot-nota  as decimal no-undo.
    def input  param da-dt-nota   as date    no-undo.
    def output param de-vl-frete  as decimal no-undo.
    
    def var de-vl-temp as decimal no-undo.

    find first tabela-frete no-lock
         where tabela-frete.cod-transp  = transporte.cod-transp
           and tabela-frete.uf          = c-uf
           and tabela-frete.dt-ini     <= da-dt-nota
           and tabela-frete.dt-fim     >= da-dt-nota no-error.
 
    if not avail tabela-frete then 
       find first tabela-frete no-lock
            where tabela-frete.uf          = c-uf
              and tabela-frete.dt-ini     <= da-dt-nota
              and tabela-frete.dt-fim     >= da-dt-nota no-error.

    find first capital-frete no-lock 
         where capital-frete.cod-transp = tabela-frete.cod-transp
           and capital-frete.uf         = c-uf
           and capital-frete.nome       = c-cidade no-error.

    if avail capital-frete and avail tabela-frete then do:
       assign de-vl-temp = (de-tot-nota * (tabela-frete.perc-cap / 100)).
       if de-tot-nota * (tabela-frete.perc-cap / 100) <
                                                tabela-frete.min-cap then do:
          assign de-vl-frete = (tabela-frete.min-cap /
                                     ((100 - tabela-frete.icms-cap) / 100)).
       end.
       else do:
          assign de-vl-frete = (de-vl-temp 
                                     / ((100 - tabela-frete.icms-cap) / 100)).
       end.
    end.
    else do:
       if avail tabela-frete then do:
          assign de-vl-temp = de-tot-nota * (tabela-frete.perc-int / 100).
                
          if de-tot-nota * (tabela-frete.perc-int / 100) <
                                           tabela-frete.min-int then do:
             assign de-vl-frete = (tabela-frete.min-int / 
                                       ((100 - tabela-frete.icms-int) / 100)).
          end.
          else do:   
             assign de-vl-frete = de-vl-temp / 
                                        ((100 - tabela-frete.icms-int) / 100).
          end.
       end.
       else 
           assign de-vl-frete = de-vl-frete + (de-tot-nota * 0.0162).
    end.
end.

*/
