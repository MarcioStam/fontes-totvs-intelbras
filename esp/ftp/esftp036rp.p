/*----------------------------------------------------------------------
**  Programa..: esp/ftp/esftp036rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Janeiro/2008 - Desenvolvimento
**  Descricao.: Relat¢rio de notas devolvidas - ConversÆo do ES0526
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esftp036 2.04.00.001}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}


FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio de Devolu‡äes"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESFTP036"
       c-versao       = "2.04"
       c-revisao      = "001".

{esp/ftp/esftp036tt.i}

DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-devolucoes
   FIELD cod-estabel    LIKE devol-cli.cod-estabel
   FIELD cod-emitente   LIKE emitente.cod-emitente
   FIELD nome-abrev     LIKE emitente.nome-abrev COLUMN-LABEL "Nome Abrev"
   FIELD dt-devol       LIKE devol-cli.dt-devol
   FIELD serie-docto    LIKE devol-cli.serie-docto
   FIELD nro-docto      LIKE devol-cli.nro-docto
   FIELD vl-total       LIKE devol-cli.vl-devol
   FIELD serie          LIKE devol-cli.serie
   FIELD nr-nota-fis    LIKE devol-cli.nr-nota-fis
   FIELD cod-gr-cob     LIKE int-emitente.cod-gr-cob COLUMN-LABEL "Gr Cob"
   INDEX ch-pri         AS PRIMARY UNIQUE cod-estabel serie-docto nro-docto serie nr-nota-fis
   INDEX ch-emit cod-emitente.

DEFINE TEMP-TABLE tt-detalhes
    FIELD cod-estabel          LIKE devol-cli.cod-estabel
    FIELD serie-docto          LIKE devol-cli.serie-docto
    FIELD nro-docto            LIKE devol-cli.nro-docto
    FIELD serie                LIKE devol-cli.serie
    FIELD nr-nota-fis          LIKE devol-cli.nr-nota-fis
    FIELD cod-emitente         LIKE emitente.cod-emitente
    FIELD dat_transacao        LIKE movto_tit_acr.dat_transacao
    FIELD tipo                 AS CHAR FORMAT "X(20)" COLUMN-LABEL "Tipo"
    FIELD cliente-titulo       AS CHAR FORMAT "X(36)" COLUMN-LABEL "Cliente/Titulo" 
    FIELD val_origin_tit_acr   LIKE tit_acr.val_origin_tit_acr COLUMN-LABEL "Vl Orig Tit"
    FIELD val_sdo_tit_acr      LIKE tit_acr.val_sdo_tit_acr
    FIELD val_movto_tit_acr    LIKE movto_tit_acr.val_movto_tit_acr
    FIELD num_id_movto_tit_acr LIKE movto_tit_acr.num_id_movto_tit_acr
    INDEX id cod-estabel serie-docto nro-docto serie nr-nota-fis dat_transacao.

DEFINE VARIABLE c-antecipacao AS CHARACTER FORMAT "X(132)" COLUMN-LABEL "Movimentos de Antecipacoes"   NO-UNDO.
DEFINE VARIABLE c-abatimento  AS CHARACTER FORMAT "X(132)" COLUMN-LABEL "Movimentos de Abatimentos"    NO-UNDO.

FORM HEADER
   "-- DEVOLU€OES -------------------------------------------------------------------------------------------- -- ABATIMENTOS ------------------------------------------------------------------------------------" SKIP
   "Est      C¢digo Nome Abrev   Dt Devol   Ser   Doc Ent               Vl Devolu‡Æo Ser   Nota Fis         Gr Tipo                 Data Trans Cliente/Titulo                         Saldo T¡tulo    Vl Movimento" SKIP
   "----- --------- ------------ ---------- ----- ---------------- ----------------- ----- ---------------- -- -------------------- ---------- ------------------------------------ -------------- ---------------" SKIP
    with stream-io width 255 no-labels no-box page-top frame f-cabec-devol.

DEFINE BUFFER b_an_tit_acr        FOR tit_acr.
DEFINE BUFFER b_an_movto_tit_acr  FOR movto_tit_acr.
DEFINE BUFFER b_ab_tit_acr        FOR tit_acr.
DEFINE BUFFER b_ab_movto_tit_acr  FOR movto_tit_acr.
DEFINE BUFFER b2_ab_tit_acr       FOR tit_acr.
DEFINE BUFFER b2_ab_movto_tit_acr FOR movto_tit_acr.
DEFINE BUFFER b_nc_tit_acr        FOR tit_acr.

/*---------------------------  Parƒmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
   {include/i-rpc255.i}
   {include/i-rpout.i}
   VIEW FRAME f-cabec-255.
   VIEW FRAME f-rodape-255.

   IF  tt-param.det-cta-receber THEN
       VIEW FRAME f-cabec-devol.

   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
   RUN piImprimeRelat.
   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.

PROCEDURE piImprimeRelat:

   FOR EACH devol-cli NO-LOCK
      WHERE devol-cli.cod-estabel  >= tt-param.cod-estabel-ini
        AND devol-cli.cod-estabel  <= tt-param.cod-estabel-fim
        AND devol-cli.cod-emitente >= tt-param.cod-emitente-ini
        AND devol-cli.cod-emitente <= tt-param.cod-emitente-fim
        AND devol-cli.dt-devol     >= tt-param.dt-devol-ini
        AND devol-cli.dt-devol     <= tt-param.dt-devol-fim
        AND devol-cli.nro-docto    >= tt-param.nro-docto-ini
        AND devol-cli.nro-docto    <= tt-param.nro-docto-fim
        AND devol-cli.nr-nota-fis  >= tt-param.nr-nota-fis-ini
        AND devol-cli.nr-nota-fis  <= tt-param.nr-nota-fis-fim
        /*AND (devol-cli.nat-operacao BEGINS "1201"
         OR  devol-cli.nat-operacao BEGINS "2201"
         OR  devol-cli.nat-operacao BEGINS "1202"
         OR  devol-cli.nat-operacao BEGINS "2202"
         OR  devol-cli.nat-operacao BEGINS "3201"
             
         OR  devol-cli.nat-operacao BEGINS "2410"
         OR  devol-cli.nat-operacao BEGINS "2411"
         OR  devol-cli.nat-operacao BEGINS "1410"
         OR  devol-cli.nat-operacao BEGINS "1411")*/,
      FIRST nota-fiscal OF devol-cli NO-LOCK,
      FIRST natur-oper NO-LOCK
      WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
        AND natur-oper.emite-dupli,
      FIRST emitente OF devol-cli NO-LOCK
          WHERE emitente.cgc >= tt-param.cgc-ini
            AND emitente.cgc <= tt-param.cgc-fim,
      FIRST int-emitente OF emitente NO-LOCK
      WHERE int-emitente.cod-gr-cob >= tt-param.cod-gr-cob-ini
        AND int-emitente.cod-gr-cob <= tt-param.cod-gr-cob-fim:

      RUN pi-acompanhar IN h-acomp (INPUT "Selecionando devolu‡Æo: " + devol-cli.nro-docto + "/" + devol-cli.serie-docto).

      /* Filtro naturezas devol */
      IF  NOT CAN-FIND(FIRST ext-natur-oper
                        WHERE ext-natur-oper.nat-operacao = devol-cli.nat-operacao
                        AND   ext-natur-oper.tipo         = 1 /* Devolu‡Æo */ ) THEN NEXT.

      FIND FIRST tt-devolucoes
          WHERE tt-devolucoes.cod-estabel = devol-cli.cod-estabel
          AND   tt-devolucoes.serie-docto = devol-cli.serie-docto
          AND   tt-devolucoes.nro-docto   = devol-cli.nro-docto
          AND   tt-devolucoes.serie       = devol-cli.serie
          AND   tt-devolucoes.nr-nota-fis = devol-cli.nr-nota-fis NO-ERROR.

      IF  NOT AVAILABLE (tt-devolucoes) THEN DO:
          CREATE tt-devolucoes.
          ASSIGN tt-devolucoes.cod-estabel  = devol-cli.cod-estabel
                 tt-devolucoes.serie-docto  = devol-cli.serie-docto
                 tt-devolucoes.nro-docto    = devol-cli.nro-docto
                 tt-devolucoes.dt-devol     = devol-cli.dt-devol
                 tt-devolucoes.cod-emitente = emitente.cod-emitente
                 tt-devolucoes.nome-abrev   = emitente.nome-abrev
                 tt-devolucoes.serie        = devol-cli.serie
                 tt-devolucoes.nr-nota-fis  = devol-cli.nr-nota-fis
                 tt-devolucoes.cod-gr-cob   = int-emitente.cod-gr-cob.

          IF  tt-param.det-cta-receber THEN 
              RUN pi-det-cta-receber.
      END.

      ASSIGN tt-devolucoes.vl-total = tt-devolucoes.vl-total + devol-cli.vl-devol.
   END.

   RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo...").
   
   IF  NOT tt-param.det-cta-receber THEN DO:
       FOR EACH tt-devolucoes NO-LOCK
          BREAK BY tt-devolucoes.dt-devol
                BY tt-devolucoes.cod-emitente
                BY tt-devolucoes.nro-docto:
    
          DISPLAY tt-devolucoes.cod-estabel
                  tt-devolucoes.cod-emitente
                  tt-devolucoes.nome-abrev
                  tt-devolucoes.dt-devol
                  tt-devolucoes.serie-docto
                  tt-devolucoes.nro-docto
                  tt-devolucoes.vl-total
                  (TOTAL BY tt-devolucoes.cod-emitente)
                  tt-devolucoes.serie
                  tt-devolucoes.nr-nota-fis
                  tt-devolucoes.cod-gr-cob
                  WITH STREAM-IO NO-BOX WIDTH 300 DOWN FRAME f-relat. 
       END.
   END.
   ELSE DO:
       FOR EACH tt-devolucoes:

           FIND FIRST tt-detalhes
               WHERE tt-detalhes.cod-estabel = tt-devolucoes.cod-estabel
               AND   tt-detalhes.serie-docto = tt-devolucoes.serie-docto
               AND   tt-detalhes.nro-docto   = tt-devolucoes.nro-docto
               AND   tt-detalhes.serie       = tt-devolucoes.serie
               AND   tt-detalhes.nr-nota-fis = tt-devolucoes.nr-nota-fis NO-LOCK NO-ERROR.

           IF  AVAIL tt-detalhes THEN DO:
    
               FOR EACH tt-detalhes
                   WHERE tt-detalhes.cod-estabel = tt-devolucoes.cod-estabel
                   AND   tt-detalhes.serie-docto = tt-devolucoes.serie-docto
                   AND   tt-detalhes.nro-docto   = tt-devolucoes.nro-docto
                   AND   tt-detalhes.serie       = tt-devolucoes.serie
                   AND   tt-detalhes.nr-nota-fis = tt-devolucoes.nr-nota-fis:
                   
                   DISPLAY tt-devolucoes.cod-estabel
                           tt-devolucoes.cod-emitente
                           tt-devolucoes.nome-abrev
                           tt-devolucoes.dt-devol
                           tt-devolucoes.serie-docto
                           tt-devolucoes.nro-docto
                           tt-devolucoes.vl-total
                           tt-devolucoes.serie
                           tt-devolucoes.nr-nota-fis
                           tt-devolucoes.cod-gr-cob
                           tt-detalhes.tipo
                           tt-detalhes.dat_transacao
                           tt-detalhes.cliente-titulo
                           tt-detalhes.val_sdo_tit_acr
                           tt-detalhes.val_movto_tit_acr
                           WITH STREAM-IO NO-BOX NO-LABEL WIDTH 300.
               END.
           END.
           ELSE DO:
               DISPLAY tt-devolucoes.cod-estabel
                       tt-devolucoes.cod-emitente
                       tt-devolucoes.nome-abrev
                       tt-devolucoes.dt-devol
                       tt-devolucoes.serie-docto
                       tt-devolucoes.nro-docto
                       tt-devolucoes.vl-total
                       tt-devolucoes.serie
                       tt-devolucoes.nr-nota-fis
                       tt-devolucoes.cod-gr-cob
                       WITH STREAM-IO NO-BOX NO-LABEL WIDTH 300.
           END.
       END.
   END.
END.


PROCEDURE pi-det-cta-receber:

    /* Busca antecipa‡äes */
    FOR EACH nota_devol_tit_acr
        WHERE nota_devol_tit_acr.cdn_cliente            = devol-cli.cod-emitente
        AND   nota_devol_tit_acr.cod_ser_nota_devol     = devol-cli.serie-docto
        AND   nota_devol_tit_acr.cod_nota_devol         = devol-cli.nro-docto
        AND   nota_devol_tit_acr.cod_natur_operac_devol = devol-cli.nat-operacao
        AND   nota_devol_tit_acr.cod_tit_acr            = devol-cli.nr-nota-fis NO-LOCK:
 
        /*
        FIND FIRST b_an_tit_acr
            WHERE b_an_tit_acr.cod_estab       = nota_devol_tit_acr.cod_estab
            and   b_an_tit_acr.cod_espec_docto = "AN"
            and   b_an_tit_acr.cod_ser_docto   = nota_devol_tit_acr.cod_ser_docto
            and   b_an_tit_acr.cod_tit_acr     = nota_devol_tit_acr.cod_tit_acr
            AND   b_an_tit_acr.cod_parcela     = nota_devol_tit_acr.cod_parcela NO-LOCK NO-ERROR.
        */

        FIND FIRST espec_docto
            WHERE espec_docto.cod_espec_docto = nota_devol_tit_acr.cod_espec_docto NO-LOCK NO-ERROR.

        IF  AVAIL espec_docto 
        AND espec_docto.ind_tip_espec_docto = "Antecipa‡Æo" THEN DO:
            FIND FIRST b_an_tit_acr
                WHERE b_an_tit_acr.cod_estab       = nota_devol_tit_acr.cod_estab
                and   b_an_tit_acr.cod_espec_docto = nota_devol_tit_acr.cod_espec_docto /*"AN"*/
                and   b_an_tit_acr.cod_ser_docto   = nota_devol_tit_acr.cod_ser_docto
                and   b_an_tit_acr.cod_tit_acr     = nota_devol_tit_acr.cod_tit_acr
                AND   b_an_tit_acr.cod_parcela     = nota_devol_tit_acr.cod_parcela NO-LOCK NO-ERROR.
        END.
        ELSE DO:
            IF  espec_docto.ind_tip_espec_docto = "Nota de Cr‚dito" THEN DO:
                FIND FIRST b_nc_tit_acr
                    WHERE b_nc_tit_acr.cod_estab       = nota_devol_tit_acr.cod_estab
                    and   b_nc_tit_acr.cod_espec_docto = nota_devol_tit_acr.cod_espec_docto
                    and   b_nc_tit_acr.cod_ser_docto   = nota_devol_tit_acr.cod_ser_docto
                    and   b_nc_tit_acr.cod_tit_acr     = nota_devol_tit_acr.cod_tit_acr
                    AND   b_nc_tit_acr.cod_parcela     = nota_devol_tit_acr.cod_parcela NO-LOCK NO-ERROR.
                
                IF  AVAIL b_nc_tit_acr THEN DO:
                    FIND FIRST relacto_tit_acr NO-LOCK
                        WHERE relacto_tit_acr.cod_estab      = b_nc_tit_acr.cod_estab
                        AND   relacto_tit_acr.num_id_tit_acr = b_nc_tit_acr.num_id_tit_acr NO-ERROR.

                    IF  AVAIL relacto_tit_acr THEN
                        find b_an_tit_acr no-lock
                             where b_an_tit_acr.cod_estab      = relacto_tit_acr.cod_estab_tit_acr_pai
                             and   b_an_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr_pai no-error.

                END.
            END.
        END.

        IF  AVAIL b_an_tit_acr THEN DO:

            FOR EACH b_an_movto_tit_acr OF b_an_tit_acr NO-LOCK 
                WHERE (b_an_movto_tit_acr.ind_trans_acr = "Liquida‡Æo"
                OR     b_an_movto_tit_acr.ind_trans_acr = "Liquida‡Æo Transf Estab"):
    
                IF  b_an_movto_tit_acr.ind_trans_acr = "Liquida‡Æo" THEN DO:
    
                    FOR EACH b_ab_movto_tit_acr NO-LOCK /* MOVIMENTOS DOS TITULOS QUE TIVERAM DESCONTOS */
                        WHERE b_ab_movto_tit_acr.cod_estab                   = b_an_movto_tit_acr.cod_estab_tit_acr_pai
                        AND   b_ab_movto_tit_acr.num_id_movto_tit_acr        = b_an_movto_tit_acr.num_id_movto_tit_acr_pai
                        AND   b_ab_movto_tit_acr.ind_trans_acr               = "Liquida‡Æo"
                        AND   b_ab_movto_tit_acr.log_liquidac_contra_antecip = YES:
            
                        FIND b_ab_tit_acr
                            WHERE b_ab_tit_acr.cod_estab      = b_ab_movto_tit_acr.cod_estab
                            AND   b_ab_tit_acr.num_id_tit_acr = b_ab_movto_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.
                        
                        IF  AVAIL b_ab_tit_acr THEN DO:     
                            FIND FIRST tt-detalhes 
                                WHERE tt-detalhes.num_id_movto_tit_acr = b_ab_movto_tit_acr.num_id_movto_tit_acr NO-LOCK NO-ERROR.
        
                            IF  NOT AVAIL tt-detalhes THEN DO:
                                CREATE tt-detalhes.
                                ASSIGN tt-detalhes.cod-estabel          = devol-cli.cod-estabel
                                       tt-detalhes.serie-docto          = devol-cli.serie-docto
                                       tt-detalhes.nro-docto            = devol-cli.nro-docto
                                       tt-detalhes.serie                = devol-cli.serie
                                       tt-detalhes.nr-nota-fis          = devol-cli.nr-nota-fis
                                       tt-detalhes.dat_transacao        = b_ab_movto_tit_acr.dat_transacao
                                       tt-detalhes.tipo                 = "Abatimento contra AN"
                                       tt-detalhes.cliente-titulo       = TRIM(STRING(b_ab_tit_acr.cdn_cliente)) + "/"
                                                                        + TRIM(b_ab_tit_acr.cod_estab) + "/" 
                                                                        + TRIM(b_ab_tit_acr.cod_espec_docto) + "/"
                                                                        + TRIM(b_ab_tit_acr.cod_ser_docto) + "/" 
                                                                        + TRIM(b_ab_tit_acr.cod_tit_acr) + "/"
                                                                        + TRIM(b_ab_tit_acr.cod_parcela)
                                       tt-detalhes.val_origin_tit_acr   = b_ab_tit_acr.val_origin_tit_acr
                                       tt-detalhes.val_sdo_tit_acr      = b_ab_tit_acr.val_sdo_tit_acr
                                       tt-detalhes.val_movto_tit_acr    = b_ab_movto_tit_acr.val_movto_tit_acr
                                       tt-detalhes.num_id_movto_tit_acr = b_ab_movto_tit_acr.num_id_movto_tit_acr.
    
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    FOR EACH movto_tit_acr NO-LOCK /* MOVIMENTOS DOS TITULOS QUE TIVERAM DESCONTOS */
                        WHERE movto_tit_acr.cod_estab_tit_acr_pai    = b_an_movto_tit_acr.cod_estab
                        AND   movto_tit_acr.num_id_movto_tit_acr_pai = b_an_movto_tit_acr.num_id_movto_tit_acr
                        AND   movto_tit_acr.ind_trans_acr            = "Transf Estabelecimento"
                        AND   movto_tit_acr.val_movto_tit_acr        > 0:
    
                        FIND FIRST b_ab_tit_acr
                            WHERE b_ab_tit_acr.cod_estab      = movto_tit_acr.cod_estab
                            AND   b_ab_tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.                          
    
                        IF  AVAIL b_ab_tit_acr THEN DO:
    
                            FOR EACH b_ab_movto_tit_acr NO-LOCK /* MOVIMENTOS DOS TITULOS QUE TIVERAM DESCONTOS */
                                WHERE b_ab_movto_tit_acr.cod_estab      = movto_tit_acr.cod_estab
                                AND   b_ab_movto_tit_acr.num_id_tit_acr = b_ab_tit_acr.num_id_tit_acr
                                AND   b_ab_movto_tit_acr.ind_trans_acr  = "Liquida‡Æo":
                    
                                FOR EACH b2_ab_movto_tit_acr NO-LOCK /* MOVIMENTOS DOS TITULOS QUE TIVERAM DESCONTOS */
                                    WHERE b2_ab_movto_tit_acr.cod_estab                   = b_ab_movto_tit_acr.cod_estab_tit_acr_pai
                                    AND   b2_ab_movto_tit_acr.num_id_movto_tit_acr        = b_ab_movto_tit_acr.num_id_movto_tit_acr_pai
                                    AND   b2_ab_movto_tit_acr.ind_trans_acr               = "Liquida‡Æo"
                                    AND   b2_ab_movto_tit_acr.log_liquidac_contra_antecip = YES:
    
                                    FIND b2_ab_tit_acr
                                        WHERE b2_ab_tit_acr.cod_estab      = b2_ab_movto_tit_acr.cod_estab
                                        AND   b2_ab_tit_acr.num_id_tit_acr = b2_ab_movto_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.
    
                                    IF  AVAIL b2_ab_tit_acr THEN DO:     
                                        FIND FIRST tt-detalhes 
                                            WHERE tt-detalhes.num_id_movto_tit_acr = b_ab_movto_tit_acr.num_id_movto_tit_acr NO-LOCK NO-ERROR.
                    
                                        IF  NOT AVAIL tt-detalhes THEN DO:
                                            CREATE tt-detalhes.
                                            ASSIGN tt-detalhes.cod-estabel          = devol-cli.cod-estabel
                                                   tt-detalhes.serie-docto          = devol-cli.serie-docto
                                                   tt-detalhes.nro-docto            = devol-cli.nro-docto
                                                   tt-detalhes.serie                = devol-cli.serie
                                                   tt-detalhes.nr-nota-fis          = devol-cli.nr-nota-fis
                                                   tt-detalhes.dat_transacao        = b2_ab_movto_tit_acr.dat_transacao
                                                   tt-detalhes.tipo                 = "Abatimento contra AN"
                                                   tt-detalhes.cliente-titulo       = TRIM(STRING(b2_ab_tit_acr.cdn_cliente)) + "/"
                                                                                    + TRIM(b2_ab_tit_acr.cod_estab) + "/" 
                                                                                    + TRIM(b2_ab_tit_acr.cod_espec_docto) + "/"
                                                                                    + TRIM(b2_ab_tit_acr.cod_ser_docto) + "/" 
                                                                                    + TRIM(b2_ab_tit_acr.cod_tit_acr) + "/"
                                                                                    + TRIM(b2_ab_tit_acr.cod_parcela)
                                                   tt-detalhes.val_origin_tit_acr   = b2_ab_tit_acr.val_origin_tit_acr
                                                   tt-detalhes.val_sdo_tit_acr      = b2_ab_tit_acr.val_sdo_tit_acr
                                                   tt-detalhes.val_movto_tit_acr    = b2_ab_movto_tit_acr.val_movto_tit_acr
                                                   tt-detalhes.num_id_movto_tit_acr = b2_ab_movto_tit_acr.num_id_movto_tit_acr.
                
                                        END.
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END. 

    /* Busca abatimentos na nota */
    FOR EACH nota_devol_tit_acr
        WHERE nota_devol_tit_acr.cdn_cliente            = devol-cli.cod-emitente
        AND   nota_devol_tit_acr.cod_ser_nota_devol     = devol-cli.serie-docto
        AND   nota_devol_tit_acr.cod_nota_devol         = devol-cli.nro-docto
        AND   nota_devol_tit_acr.cod_natur_operac_devol = devol-cli.nat-operacao 
        AND   nota_devol_tit_acr.cod_tit_acr            = devol-cli.nr-nota-fis NO-LOCK:
 
        FIND FIRST b_an_tit_acr
            WHERE b_an_tit_acr.cod_estab       = nota_devol_tit_acr.cod_estab
            and   b_an_tit_acr.cod_espec_docto = nota_devol_tit_acr.cod_espec_docto
            and   b_an_tit_acr.cod_ser_docto   = nota_devol_tit_acr.cod_ser_docto
            and   b_an_tit_acr.cod_tit_acr     = nota_devol_tit_acr.cod_tit_acr
            AND   b_an_tit_acr.cod_parcela     = nota_devol_tit_acr.cod_parcela NO-LOCK NO-ERROR.

        IF  AVAIL b_an_tit_acr THEN DO:
            for each relacto_tit_acr no-lock
                where relacto_tit_acr.cod_estab      = b_an_tit_acr.cod_estab
                and   relacto_tit_acr.num_id_tit_acr = b_an_tit_acr.num_id_tit_acr:
    
                find movto_tit_acr no-lock
                     where movto_tit_acr.cod_estab            = relacto_tit_acr.cod_estab_tit_acr_pai
                     and   movto_tit_acr.num_id_movto_tit_acr = relacto_tit_acr.num_id_movto_tit_acr_pai 
                     AND   movto_tit_acr.ind_trans_acr        = "Acerto Valor a Cr‚dito" no-error.
                
                if  avail movto_tit_acr then do:                
                    find tit_acr no-lock
                         where tit_acr.cod_estab      = movto_tit_acr.cod_estab
                           and tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr no-error.
    
                    IF  AVAIL tit_acr THEN DO:
                        FIND FIRST tt-detalhes 
                            WHERE tt-detalhes.num_id_movto_tit_acr = b_an_movto_tit_acr.num_id_movto_tit_acr NO-LOCK NO-ERROR.
    
                        IF  NOT AVAIL tt-detalhes THEN DO:
                            CREATE tt-detalhes.
                            ASSIGN tt-detalhes.cod-estabel          = devol-cli.cod-estabel
                                   tt-detalhes.serie-docto          = devol-cli.serie-docto
                                   tt-detalhes.nro-docto            = devol-cli.nro-docto
                                   tt-detalhes.serie                = devol-cli.serie
                                   tt-detalhes.nr-nota-fis          = devol-cli.nr-nota-fis
                                   tt-detalhes.dat_transacao        = movto_tit_acr.dat_transacao
                                   tt-detalhes.tipo                 = "Abatimento na Nota"
                                   tt-detalhes.cliente-titulo       = TRIM(STRING(tit_acr.cdn_cliente)) + "/"
                                                                    + TRIM(tit_acr.cod_estab)           + "/" 
                                                                    + TRIM(tit_acr.cod_espec_docto)     + "/"
                                                                    + TRIM(tit_acr.cod_ser_docto)       + "/" 
                                                                    + TRIM(tit_acr.cod_tit_acr)         + "/"
                                                                    + TRIM(tit_acr.cod_parcela)
                                   tt-detalhes.val_origin_tit_acr   = tit_acr.val_origin_tit_acr
                                   tt-detalhes.val_sdo_tit_acr      = tit_acr.val_sdo_tit_acr
                                   tt-detalhes.val_movto_tit_acr    = movto_tit_acr.val_movto_tit_acr
                                   tt-detalhes.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr.
                        END.
                    END.
                END.
            END.
        END.
    END. 

END PROCEDURE.


