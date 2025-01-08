/*****************************************************************************
** Programa..............: esp/essco003.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 10/08/2009
*****************************************************************************/

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def temp-table ttBankStmntImportExecParamDTO no-undo
    field validateDate                 as LOG
    field validateReference            as LOG
    field cashClosingUnit              as CHAR 
    field validateEndBalance           as LOG.

def temp-table ttBankStmntImportFileParamDTO no-undo
    field importFileName               as CHAR
    field bankStatementLayout          as CHAR
    field setType                      as INT
    field chkAccount                   as CHAR
    field startChkAccount              as CHAR
    field endChkAccount                as CHAR
    field directoryTransfer            as CHAR
    field transferFile                 as LOG
    field bank                         as CHAR.

def temp-table tt_row_errors no-undo
    field ttv_num_seq_erro                 as integer format ">>>>,>>9" initial 0
    field ttv_num_erro                     as integer format ">>>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_param                    as character format "x(50)" label "Param" column-label "Param"
    field ttv_des_type                     as character format "x(10)"
    field ttv_des_help                     as character format "x(40)" label "Ajuda" column-label "Ajuda"
    field ttv_des_sub_type                 as character format "x(40)"
    index tt_indice_errors                
          ttv_num_seq_erro                 ascending.

DEF TEMP-TABLE tt_aux
    FIELD id    AS INT
    FIELD linha AS CHAR FORMAT "x(4000)"
    INDEX id_id IS PRIMARY
          id.

{esp/es0018.i}

def input parameter raw-param  as raw no-undo.
def input parameter table     for tt-raw-digita.

DEFINE VARIABLE v_cod_dir     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_b2c AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_cmg AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_log AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_bkp AS CHARACTER   NO-UNDO.

DEFINE VARIABLE v_cod_aux     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_arq     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_linha   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_aux     AS DATE        NO-UNDO.
DEFINE VARIABLE v_dat_cred    AS DATE        NO-UNDO.
DEFINE VARIABLE v_cod_arq_log AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_aux         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cont        AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_log_linha AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_tid_visa  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE v_log_lote_valido AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_cod_parc_hiper  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE v_hdl_api_integr_cmg AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEF STREAM s_1.
DEF STREAM s_2.
DEF STREAM s_import.
DEF STREAM s_export.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "FINANC":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:

    ASSIGN c-dir-saida = replace(tt-prog-ponto.conteudo, "/", "~\").

    IF SUBSTRING(c-dir-saida, LENGTH(c-dir-saida), 1) <> "~\" THEN
        ASSIGN c-dir-saida = c-dir-saida + "~\".

END.

FILE-INFO:FILE-NAME = "Y:\inbox\".
IF FILE-INFO:FILE-TYPE <> ?
   THEN ASSIGN v_cod_dir     = "y:\inbox\"
               v_cod_dir_b2c = "y:\inbox\b2c\"
               v_cod_dir_cmg = "y:\inbox\cmg\"
               v_cod_dir_log = "y:\inbox\cmg\log\"
               v_cod_dir_bkp = "y:\inbox\cmg\bkp\".
   ELSE ASSIGN v_cod_dir     = c-dir-saida + "skyline~\inbox~\"            /* ** local onde a Nexxera disponibiliza todos os arquivos   ***/
               v_cod_dir_b2c = c-dir-saida + "skyline~\inbox~\b2c~\"       /* ** arquivos importados do b2c                             ***/
               v_cod_dir_cmg = c-dir-saida + "skyline~\inbox~\cmg~\"       /* ** transferir arquivos homologados e que ser∆o importados ***/
               v_cod_dir_log = c-dir-saida + "skyline~\inbox~\cmg~\log~\"  /* ** criar log do resultado da importaá∆o                   ***/
               v_cod_dir_bkp = c-dir-saida + "skyline~\inbox~\cmg~\bkp~\". /* ** transfere arquivos homologados originais, sem alteraá∆o. Ex: 237 ***/.

/* ** Tratamento Extrato ***/
ASSIGN v_cod_arq_log = v_cod_dir_log + "EXT" + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99") + STRING(TIME) + ".LOG".

OUTPUT STREAM s_2 TO VALUE(v_cod_arq_log) CONVERT TARGET 'iso8859-1' APPEND.

INPUT STREAM s_1 FROM OS-DIR (v_cod_dir).

REPEAT:

     IMPORT STREAM s_1 v_cod_aux.

     IF v_cod_aux = "." 
     OR v_cod_aux = ".." 
     OR SEARCH(v_cod_dir + v_cod_aux) = ?
        THEN NEXT.

     ASSIGN v_cod_arq = "".

/* *** Posiá∆o de extratos homologados atÇ 11/10/2023 ***
Cta Corren	Banco
350032-2      001
6024277-01	  041
6859335-01    041
68593351-6	  041
016647-2	  237
67464-8	      237
05555-6	      341
07732-5	      341
19894-3	      341
32852-6    	  341
56036-5       341
70176901	  356
723998-1	  356
8594-45	      399
234-95	      399
279803-5	  409
109956-7	  409
273518-5	  409
013217-9	  422
Homologado em 12/11/2009
13000002-5    033
13000065-7    033
*********************************************************/

     /* ** Extratos Homologados ***/
     IF  NOT v_cod_aux BEGINS ("EXT001") /* ** 3500322                                       ***/
     AND NOT v_cod_aux BEGINS ("EXT041") /* ** 602427701 / 685933501 / 685933516             ***/
     AND NOT v_cod_aux BEGINS ("EXT237") /* ** 166472 / 674648                               ***/
     AND NOT v_cod_aux BEGINS ("EXT356") /* ** 7017690 / 7239981                             ***/
     AND NOT v_cod_aux BEGINS ("EXT399") /* ** 23495 / 859445                                ***/
     AND NOT v_cod_aux BEGINS ("EXT409") /* ** 2798035 / 2735185 / 1099567                   ***/
     AND NOT v_cod_aux BEGINS ("EXT422") /* ** 132179                                        ***/
     AND NOT v_cod_aux BEGINS ("EXT341") /* ** 0555562 / 1989432 / 3285262 / 0773252 / 56036 ***/
     AND NOT v_cod_aux BEGINS ("EXT246") /* ** 220176411                                     ***/
     AND NOT v_cod_aux BEGINS ("EXT033") /* ** 130000025 / 130000657                         ***/
     AND NOT v_cod_aux BEGINS ("EXT104") /* ** 62711                                         ***/
     AND NOT v_cod_aux BEGINS ("EXT320") /* ** 141002610 / 421002628                         ***/
     AND NOT v_cod_aux BEGINS ("EXT745") /* ** 141002610 / 421002628                         ***/
     AND NOT v_cod_aux BEGINS ("EXT355") /* ** 0000014713-5                                  ***/
     AND NOT v_cod_aux BEGINS ("EXT208") /* ** 005754783                                     ***/
     AND NOT v_cod_aux BEGINS ("EXT224") /* ** 670482-1                                      ***/
     AND NOT v_cod_aux BEGINS ("EXT748") /* ** 07714-0                                       ***/
         THEN NEXT.

     ASSIGN v_cod_arq = v_cod_dir + v_cod_aux.

     IF  v_cod_aux BEGINS ("EXT104") THEN DO:
          /* ** Salva copia do arquivo original e altera linha de detalhe, corrigindo a conta corrente ***/
          OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).

          EMPTY TEMP-TABLE tt_aux.

          INPUT STREAM s_import FROM VALUE(v_cod_arq).
          REPEAT:

              ASSIGN v_cont = v_cont + 1.

              IMPORT STREAM s_import UNFORMATTED v_aux.

              CREATE tt_aux.
              ASSIGN tt_aux.id    = v_cont
                     tt_aux.linha = v_aux.

              IF SUBSTRING(v_aux, 61, 11) = "30000006271"
                 THEN ASSIGN SUBSTRING(tt_aux.linha, 61, 11) = "00000006271".

              IF SUBSTRING(v_aux, 61, 11) = "30008001453"
                 THEN ASSIGN SUBSTRING(tt_aux.linha, 61, 11) = "00008001453".
          END.

          OUTPUT STREAM s_import CLOSE.

          OUTPUT STREAM s_export TO VALUE (v_cod_arq).
          FOR EACH tt_aux:
              PUT STREAM s_export UNFORMATTED tt_aux.linha SKIP.
          END.
          OUTPUT STREAM s_export CLOSE.

     END.

     IF  v_cod_aux BEGINS ("EXT033") THEN DO:
          /* ** Salva copia do arquivo original e altera linha de detalhe, corrigindo a conta corrente do Santander Matriz ***/
          OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).

          EMPTY TEMP-TABLE tt_aux.

          INPUT STREAM s_import FROM VALUE(v_cod_arq).
          REPEAT:

              ASSIGN v_cont = v_cont + 1.

              IMPORT STREAM s_import UNFORMATTED v_aux.

              CREATE tt_aux.
              ASSIGN tt_aux.id    = v_cont
                     tt_aux.linha = v_aux.

              IF SUBSTRING(v_aux, 19, 14) = "82901000000127"
                 THEN ASSIGN SUBSTRING(tt_aux.linha, 61, 11) = "00130000025".

          END.

          OUTPUT STREAM s_import CLOSE.

          OUTPUT STREAM s_export TO VALUE (v_cod_arq).
          FOR EACH tt_aux:
              PUT STREAM s_export UNFORMATTED tt_aux.linha SKIP.
          END.
          OUTPUT STREAM s_export CLOSE.

     END.
     
     IF  v_cod_aux BEGINS ("EXT237") THEN DO:
          /* ** Salva copia do arquivo original e altera linha de total para o banco Bradesco ***/
          OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).

          EMPTY TEMP-TABLE tt_aux.

          INPUT STREAM s_import FROM VALUE(v_cod_arq).
          REPEAT:

              ASSIGN v_cont = v_cont + 1.

              IMPORT STREAM s_import UNFORMATTED v_aux.

              CREATE tt_aux.
              ASSIGN tt_aux.id    = v_cont
                     tt_aux.linha = v_aux.

              IF  SUBSTRING(v_aux, 61, 11) = "0000130402P" THEN 
                  ASSIGN SUBSTRING(tt_aux.linha, 61, 11) = "00001304020".

              IF SUBSTRING(tt_aux.linha, 8, 1) = "5" THEN DO:
                   ASSIGN SUBSTRING(tt_aux.linha, 151, 18) = SUBSTRING(tt_aux.linha, 223, 18)
                          SUBSTRING(tt_aux.linha, 169, 01) = SUBSTRING(tt_aux.linha, 222, 01).
              END.

          END.
          OUTPUT STREAM s_import CLOSE.

          OUTPUT STREAM s_export TO VALUE (v_cod_arq).
          FOR EACH tt_aux:
              PUT STREAM s_export UNFORMATTED tt_aux.linha SKIP.
          END.
          OUTPUT STREAM s_export CLOSE.

     END.

     IF  v_cod_aux BEGINS ("EXT399") THEN DO:
          /* ** Salva copia do arquivo original e desconsidera as linhas tipo 1 e 5 duplicadas  ***/
          OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).

          ASSIGN v_log_linha = NO.

          EMPTY TEMP-TABLE tt_aux.

          INPUT STREAM s_import FROM VALUE(v_cod_arq).
          REPEAT:

              ASSIGN v_cont = v_cont + 1.

              IMPORT STREAM s_import UNFORMATTED v_aux.

              IF  v_log_linha = YES 
              AND (SUBSTRING(v_aux, 8, 1) = "1" OR
                   SUBSTRING(v_aux, 8, 1) = "5")
                  THEN NEXT.

              IF SUBSTRING(v_aux, 8, 1) = "5" 
                 THEN ASSIGN v_log_linha = YES.

              CREATE tt_aux.
              ASSIGN tt_aux.id    = v_cont
                     tt_aux.linha = v_aux.

          END.
          OUTPUT STREAM s_import CLOSE.

          OUTPUT STREAM s_export TO VALUE (v_cod_arq).
          FOR EACH tt_aux:
              PUT STREAM s_export UNFORMATTED tt_aux.linha SKIP.
          END.
          OUTPUT STREAM s_export CLOSE.

     END.

     /* *** Retirado registro de saldo inicial duplicado no arquivo ***/
     IF  v_cod_aux BEGINS ("EXT341") THEN DO:

          /* ** Salva copia do arquivo original e desconsidera a linha tipo 1 duplicada  ***/
          OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).

          ASSIGN v_log_linha = NO.

          EMPTY TEMP-TABLE tt_aux.

          INPUT STREAM s_import FROM VALUE(v_cod_arq).
          REPEAT:

              ASSIGN v_cont = v_cont + 1.

              IMPORT STREAM s_import UNFORMATTED v_aux.

              /* ** Tratamento extrato Maxcom, que vem somente com uma conta, n∆o deve eliminar registro do arquivo ***/
              IF  SUBSTRING(v_aux, 68, 4) = "2122" THEN 
                  ASSIGN v_log_linha = YES.
              
              CREATE tt_aux.
              ASSIGN tt_aux.id    = v_cont
                     tt_aux.linha = v_aux.

              IF  SUBSTRING(v_aux, 61, 10) = "0000056036" THEN
                  ASSIGN SUBSTRING(tt_aux.linha, 61, 12) = "56036     5 ".
          END.
          OUTPUT STREAM s_import CLOSE.

          OUTPUT STREAM s_export TO VALUE (v_cod_arq).
          FOR EACH tt_aux:
              PUT STREAM s_export UNFORMATTED tt_aux.linha SKIP.
          END.
          OUTPUT STREAM s_export CLOSE.
     END.

     /* *** Banco Otimo ***/
     IF  v_cod_aux BEGINS ("EXT355") THEN DO:
         /* ** Salva copia do arquivo original ***/
         OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).

         EMPTY TEMP-TABLE tt_aux.

         INPUT STREAM s_import FROM VALUE(v_cod_arq).
         REPEAT:

             ASSIGN v_cont = v_cont + 1.

             IMPORT STREAM s_import UNFORMATTED v_aux.

             CREATE tt_aux.
             ASSIGN tt_aux.id    = v_cont
                    tt_aux.linha = v_aux.

         END.

         OUTPUT STREAM s_import CLOSE.

         OUTPUT STREAM s_export TO VALUE (v_cod_arq).
         FOR EACH tt_aux:
             PUT STREAM s_export UNFORMATTED tt_aux.linha SKIP.
         END.
         OUTPUT STREAM s_export CLOSE.
     END. /* Banco Otimo */

     /* *** BTG ***/
     IF  v_cod_aux BEGINS ("EXT208") THEN DO:
         /* ** Salva copia do arquivo original ***/
         OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).

         EMPTY TEMP-TABLE tt_aux.

         INPUT STREAM s_import FROM VALUE(v_cod_arq).
         REPEAT:

             ASSIGN v_cont = v_cont + 1.

             IMPORT STREAM s_import UNFORMATTED v_aux.

             CREATE tt_aux.
             ASSIGN tt_aux.id    = v_cont
                    tt_aux.linha = v_aux.

             IF  SUBSTRING(v_aux, 61, 11) = "00005754783" THEN 
                 ASSIGN SUBSTRING(tt_aux.linha, 61, 11) = "005754783  ".
         END.

         OUTPUT STREAM s_import CLOSE.

         OUTPUT STREAM s_export TO VALUE (v_cod_arq).
         FOR EACH tt_aux:
             PUT STREAM s_export UNFORMATTED tt_aux.linha SKIP.
         END.
         OUTPUT STREAM s_export CLOSE.
     END. /* BTG */

     /* *** Banco Fibra ***/
     IF  v_cod_aux BEGINS ("EXT224") THEN DO:
         /* ** Salva copia do arquivo original ***/
         OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).

         EMPTY TEMP-TABLE tt_aux.

         INPUT STREAM s_import FROM VALUE(v_cod_arq).
         REPEAT:

             ASSIGN v_cont = v_cont + 1.

             IMPORT STREAM s_import UNFORMATTED v_aux.

             CREATE tt_aux.
             ASSIGN tt_aux.id    = v_cont
                    tt_aux.linha = v_aux.

             IF SUBSTRING(v_aux, 61, 11) = "00006704821"
                THEN ASSIGN SUBSTRING(tt_aux.linha, 61, 10) = "670482    ".
         END.

         OUTPUT STREAM s_import CLOSE.

         OUTPUT STREAM s_export TO VALUE (v_cod_arq).
         FOR EACH tt_aux:
             PUT STREAM s_export UNFORMATTED tt_aux.linha SKIP.
         END.
         OUTPUT STREAM s_export CLOSE.
     END. /* Banco Fibra */

     /* *** SICREDI ***/
     IF  v_cod_aux BEGINS ("EXT748") THEN DO:
         /* ** Salva copia do arquivo original ***/
         OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).

         EMPTY TEMP-TABLE tt_aux.

         INPUT STREAM s_import FROM VALUE(v_cod_arq).
         REPEAT:

             ASSIGN v_cont = v_cont + 1.

             IMPORT STREAM s_import UNFORMATTED v_aux.

             CREATE tt_aux.
             ASSIGN tt_aux.id    = v_cont
                    tt_aux.linha = v_aux.

             IF SUBSTRING(v_aux, 61, 10) = "0000007714"
                THEN ASSIGN SUBSTRING(tt_aux.linha, 61, 10) = "07714     ".
         END.

         OUTPUT STREAM s_import CLOSE.

         OUTPUT STREAM s_export TO VALUE (v_cod_arq).
         FOR EACH tt_aux:
             PUT STREAM s_export UNFORMATTED tt_aux.linha SKIP.
         END.
         OUTPUT STREAM s_export CLOSE.
     END. /* SICREDI */

     EMPTY TEMP-TABLE ttBankStmntImportExecParamDTO.
     EMPTY TEMP-TABLE ttBankStmntImportFileParamDTO.
     EMPTY TEMP-TABLE tt_row_errors.

     CREATE ttBankStmntImportExecParamDTO.
     ASSIGN ttBankStmntImportExecParamDTO.validateDate       = NO
            ttBankStmntImportExecParamDTO.validateReference  = NO
            ttBankStmntImportExecParamDTO.cashClosingUnit    = ""
            ttBankStmntImportExecParamDTO.validateEndBalance = YES.
     
     CREATE ttBankStmntImportFileParamDTO.
     ASSIGN ttBankStmntImportFileParamDTO.importFileName      = v_cod_arq
            ttBankStmntImportFileParamDTO.bankStatementLayout = "NEXXERA"
            ttBankStmntImportFileParamDTO.setType             = 2
            ttBankStmntImportFileParamDTO.chkAccount          = ""
            ttBankStmntImportFileParamDTO.startChkAccount     = ""
            ttBankStmntImportFileParamDTO.endChkAccount       = "ZZZZZZZZZZZZZZZZZZZZZ"
            ttBankStmntImportFileParamDTO.directoryTransfer   = v_cod_dir_cmg
            ttBankStmntImportFileParamDTO.transferFile        = YES
            ttBankStmntImportFileParamDTO.bank                = SUBSTRING(v_cod_aux, 4, 3).
    
     /* ** Instancia a cada extrato ***/
     RUN prgfin/cmg/cmg909za.py PERSISTENT SET v_hdl_api_integr_cmg.
     RUN pi_main_import_bank_statement IN v_hdl_api_integr_cmg (INPUT TABLE ttBankStmntImportExecParamDTO,
                                                                INPUT TABLE ttBankStmntImportFileParamDTO,
                                                                OUTPUT TABLE tt_row_errors).
     DELETE PROCEDURE v_hdl_api_integr_cmg.
     
     IF NOT CAN-FIND (FIRST tt_row_errors) 
     THEN DO:
          /* ** Transfere arquivos para pasta de j† importados ***
          OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_cmg).
          OS-DELETE VALUE(v_cod_arq). */
          PUT STREAM s_2 UNFORMATTED SKIP(1) "Extrato Importado OK: " v_cod_arq SKIP.
     END.
     ELSE DO:
          PUT STREAM s_2 UNFORMATTED SKIP(1) "Erro na importaá∆o do Extrato: " v_cod_aux   SKIP.
          /** * Mostra Erros da tt_row_errors ***/
          FOR EACH tt_row_errors:
              PUT STREAM s_2 UNFORMATTED "          Seq: "       tt_row_errors.ttv_num_seq_erro  SKIP
                                         "          Erro: "      tt_row_errors.ttv_num_erro      SKIP
                                         "          Descriá∆o: " tt_row_errors.ttv_des_erro      SKIP
                                         "          Ajuda: "     tt_row_errors.ttv_des_help      SKIP.
          END.

     END.

END.

INPUT STREAM s_1 CLOSE.

OUTPUT STREAM s_2 CLOSE.

/* ** Tratamento B2C ***/
INPUT STREAM s_1 FROM OS-DIR (v_cod_dir).
REPEAT:

    IMPORT STREAM s_1 v_cod_aux.

    IF v_cod_aux = "." 
    OR v_cod_aux = ".." 
    OR SEARCH(v_cod_dir + v_cod_aux) = ?
       THEN NEXT.

    ASSIGN v_cod_arq = "".

    IF v_cod_aux BEGINS ("COB237") 
    OR v_cod_aux BEGINS ("VISA") 
    OR v_cod_aux BEGINS ("EEFI") 
    OR v_cod_aux BEGINS ("EEVC") 
    OR v_cod_aux BEGINS ("EEVD")
    OR v_cod_aux BEGINS ("HCARD")
/* ** OR v_cod_aux BEGINS ("?????") debito direto ***/
    THEN DO:
         ASSIGN v_cod_arq = v_cod_dir + v_cod_aux.
    END.

    IF v_cod_arq <> "" 
    THEN DO:

         FIND FIRST int_concil_b2 NO-LOCK
              WHERE int_concil_b2.nom_arq_orig = v_cod_aux NO-ERROR.
         IF AVAIL int_concil_b2
         OR v_cod_aux BEGINS ("EEVD")
         THEN DO:
              /* ** Transfere arquivos para pasta de j† importados ***/
              OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_b2c).
              OS-DELETE VALUE(v_cod_arq).
              NEXT.
         END.

         INPUT STREAM s_2 FROM VALUE(v_cod_arq). 

         blk_import:
         REPEAT:
             IMPORT STREAM s_2 UNFORMATTED v_cod_linha.

             /* ** DEBITO DIRETO BRADESCO ***
             IF v_cod_aux BEGINS ("?????")
             THEN DO:

                  /* *** Se ja importou o pedido, NEXT - gravar pedido NO cod_tit_acr_bco ***/
                  FIND int_concil_b2 NO-LOCK 
                      WHERE int_concil_b2.cod_adm_bco     = "DEBITO DIRETO"
                        AND int_concil_b2.cod_rv          = ""
                        AND int_concil_b2.cod_tit_acr_bco = TRIM(SUBSTRING(v_cod_linha, 2, 27))
                        AND int_concil_b2.cod_reg         = "10" NO-ERROR.
                  IF AVAIL int_concil_b2 
                     THEN NEXT.
               
                  CREATE int_concil_b2.
                  ASSIGN int_concil_b2.cod_adm_bco       = "DEBITO DIRETO"
                         int_concil_b2.cod_tip_arq       = "C"
                         int_concil_b2.cod_reg           = "10"
                         int_concil_b2.des_reg           = "DETALHE DEBITO DIRETO"
                         int_concil_b2.dat_emis_arq      = TODAY
                         int_concil_b2.dat_credito       = DATE(SUBSTRING(v_cod_linha, 41, 6))
                         int_concil_b2.cod_tit_acr_bco   = TRIM(SUBSTRING(v_cod_linha, 2, 27))
                         int_concil_b2.nom_arq_orig      = v_cod_aux
                         int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 30, 10)) / 100)
                         int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 30, 10)) / 100).

             END. ***/

             /* ** BOLETO BRADESCO***/
             IF v_cod_aux BEGINS ("COB237")
             THEN DO:

                  IF SUBSTRING(v_cod_linha, 1, 2) = "02"
                  THEN DO: 
                       ASSIGN v_dat_aux = DATE(SUBSTRING(v_cod_linha, 95, 6)).
                       NEXT.
                  END.

                  IF SUBSTRING(v_cod_linha, 1, 2) <> "10"
                     THEN NEXT.

                  IF SUBSTRING(v_cod_linha, 296, 6) = "000000" 
                     THEN NEXT.

                  CREATE int_concil_b2.
                  ASSIGN int_concil_b2.cod_adm_bco       = "BOLETO"
                         int_concil_b2.cod_tip_arq       = "C"
                         int_concil_b2.cod_reg           = "10"
                         int_concil_b2.des_reg           = "DETALHE BOLETO"
                         int_concil_b2.dat_emis_arq      = v_dat_aux
                         int_concil_b2.dat_credito       = DATE(SUBSTRING(v_cod_linha, 296, 6))
                         int_concil_b2.cod_tit_acr_bco   = SUBSTRING(v_cod_linha, 71, 12)
                         int_concil_b2.nom_arq_orig      = v_cod_aux
                         int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 153, 13)) / 100)
                         int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 153, 13)) / 100).

             END.

             /* ** VISANET ***/
             IF v_cod_aux BEGINS ("VISA")
             THEN DO:

                  IF  SUBSTRING(v_cod_linha, 1, 1)  = "0"
                  AND SUBSTRING(v_cod_linha, 53, 1) = "D"
                     THEN LEAVE blk_import.

                  IF SUBSTRING(v_cod_linha, 1, 1)  = "0"
                     THEN ASSIGN v_dat_aux = DATE(SUBSTRING(v_cod_linha, 18, 2) + SUBSTRING(v_cod_linha, 16, 2) + SUBSTRING(v_cod_linha, 12, 4)) /* ** AAAAMMDD ***/.

                  /* ** Data de corte 12/05/2009, arquivo de venda (D) sem CV e arquivo de repasse (C) com CV ***/
                  IF v_dat_aux < 05/12/2009 
                     THEN LEAVE blk_import.

                  IF  SUBSTRING(v_cod_linha, 1, 1) <> "1"
                  AND SUBSTRING(v_cod_linha, 1, 1) <> "2"
                      THEN NEXT.

                  IF SUBSTRING(v_cod_linha, 1, 1) = "1" 
                  THEN DO:
                       CREATE int_concil_b2.
                       ASSIGN int_concil_b2.cod_adm_bco       = "VISANET"
                              int_concil_b2.cod_tip_arq       = "C"
                              int_concil_b2.cod_reg           = "1"
                              int_concil_b2.des_reg           = "RESUMO DE VENDA"
                              int_concil_b2.dat_emis_arq      = v_dat_aux
                              int_concil_b2.dat_credito       = DATE(SUBSTRING(v_cod_linha, 49, 2) + SUBSTRING(v_cod_linha, 47, 2) + SUBSTRING(v_cod_linha, 45, 2))  /* ** AAMMDD ***/
                              int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 12, 7)
                              int_concil_b2.nom_arq_orig      = v_cod_aux
                              int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 57, 14)) / 100)
                              int_concil_b2.val_desc_tx_adm   = (DEC(SUBSTRING(v_cod_linha, 71, 14)) / 100)
                              int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 99, 14)) / 100)
                              int_concil_b2.cod_ocor          = SUBSTRING(v_cod_linha, 37, 2)
                              v_dat_cred                      = int_concil_b2.dat_credito.
                       IF int_concil_b2.cod_ocor = '07'
                          THEN ASSIGN int_concil_b2.des_ocor  = "Ajuste DB/CR".
                       IF int_concil_b2.cod_ocor = '12'
                          THEN ASSIGN int_concil_b2.des_ocor  = "Aluguel de POS".
                       IF int_concil_b2.cod_ocor = '14'
                          THEN ASSIGN int_concil_b2.des_ocor  = "Liquidaá∆o".
                  END.
                  
                  IF SUBSTRING(v_cod_linha, 1, 1) = "2" 
                  THEN DO:

                       /* ** Alteraá∆o de TEF para e-commerce, n∆o retorna mais o NSU, somente o TID ***/
                       ASSIGN v_tid_visa = TRIM(SUBSTRING(v_cod_linha, 100, 40)).
                       IF v_tid_visa = "" 
                          THEN ASSIGN v_tid_visa = SUBSTRING(v_cod_linha, 140, 6).

                       CREATE int_concil_b2.
                       ASSIGN int_concil_b2.cod_adm_bco       = "VISANET"
                              int_concil_b2.cod_tip_arq       = "C"
                              int_concil_b2.cod_reg           = "2"
                              int_concil_b2.des_reg           = "DETALHE RESUMO DE VENDA"
                              int_concil_b2.dat_emis_arq      = v_dat_aux
                              int_concil_b2.dat_credito       = v_dat_cred
                              int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 12, 7)
                              int_concil_b2.nom_arq_orig      = v_cod_aux
                              int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 46, 14)) / 100)
                              int_concil_b2.cod_cart_cred     = SUBSTRING(v_cod_linha, 19, 19)
                              int_concil_b2.cod_ocor          = SUBSTRING(v_cod_linha, 37, 2)
                              int_concil_b2.cod_cv_nsu        = v_tid_visa /* SUBSTRING(v_cod_linha, 140, 6) */
                              int_concil_b2.cod_autoriz       = SUBSTRING(v_cod_linha,  94, 6)
                              int_concil_b2.cod_parcela       = STRING(SUBSTRING(v_cod_linha, 60, 4), "99/99")
                              int_concil_b2.cod_tid           = SUBSTRING(v_cod_linha, 100, 40)
                              int_concil_b2.des_ocor          = SUBSTRING(v_cod_linha, 64, 30).
                       IF int_concil_b2.cod_parcela = "00/00" 
                          THEN ASSIGN int_concil_b2.cod_parcela = "01/01".
                  END.

             END.

             /* ** REDECARD ***/
             IF v_cod_aux BEGINS ("EEFI") 
             OR v_cod_aux BEGINS ("EEVC") 
             THEN DO:

                  /* ** DETALHAMENTO VENDA CRêDITO ***/
                  IF v_cod_aux BEGINS ("EEVC")  
                  THEN DO:

                       IF SUBSTRING(v_cod_linha, 1, 3) = "002"
                          THEN ASSIGN v_dat_aux = DATE(SUBSTRING(v_cod_linha, 4, 8)).

                       IF SUBSTRING(v_cod_linha, 1, 3) = "006"
                       THEN DO:
                            CREATE int_concil_b2.
                            ASSIGN int_concil_b2.cod_adm_bco       = "REDECARD"
                                   int_concil_b2.cod_tip_arq       = "D"
                                   int_concil_b2.cod_reg           = "006"
                                   int_concil_b2.des_reg           = "VENDA ∑ VISTA"
                                   int_concil_b2.dat_emis_arq      = v_dat_aux
                                   int_concil_b2.dat_credito       = DATE(SUBSTRING(v_cod_linha, 129, 8))
                                   int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 13, 9)
                                   int_concil_b2.nom_arq_orig      = v_cod_aux
                                   int_concil_b2.dat_rv_cv_nsu     = DATE(SUBSTRING(v_cod_linha, 41, 8))
                                   int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 54, 15)) / 100)
                                   int_concil_b2.val_desc_tx_adm   = (DEC(SUBSTRING(v_cod_linha, 99, 15)) / 100)
                                   int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 114, 15)) / 100)
                                   v_dat_cred                  = int_concil_b2.dat_credito.
                       END.

                       IF SUBSTRING(v_cod_linha, 1, 3) = "008"
                       THEN DO:
                            CREATE int_concil_b2.
                            ASSIGN int_concil_b2.cod_adm_bco       = "REDECARD"
                                   int_concil_b2.cod_tip_arq       = "D"
                                   int_concil_b2.cod_reg           = "008"
                                   int_concil_b2.des_reg           = "DETALHE VENDA ∑ VISTA"
                                   int_concil_b2.dat_emis_arq      = v_dat_aux
                                   int_concil_b2.dat_credito       = v_dat_cred
                                   int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 13, 9)
                                   int_concil_b2.nom_arq_orig      = v_cod_aux
                                   int_concil_b2.dat_rv_cv_nsu     = DATE(SUBSTRING(v_cod_linha, 22, 8))
                                   int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 38, 15)) / 100)
                                   int_concil_b2.val_desc_tx_adm   = (DEC(SUBSTRING(v_cod_linha, 112, 15)) / 100)
                                   int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 204, 15)) / 100)
                                   int_concil_b2.cod_cart_cred     = SUBSTRING(v_cod_linha, 68, 16)
                                   int_concil_b2.cod_ocor          = SUBSTRING(v_cod_linha, 84, 3)
                                   int_concil_b2.cod_cv_nsu        = SUBSTRING(v_cod_linha, 87, 12)
                                   int_concil_b2.cod_autoriz       = SUBSTRING(v_cod_linha, 127, 6).
                       END.

                       IF SUBSTRING(v_cod_linha, 1, 3) = "012"
                       THEN DO:
                            CREATE int_concil_b2.
                            ASSIGN int_concil_b2.cod_adm_bco       = "REDECARD"
                                   int_concil_b2.cod_tip_arq       = "D"
                                   int_concil_b2.cod_reg           = "012"
                                   int_concil_b2.des_reg           = "VENDA PARCELADA - DETALHE VENDA"
                                   int_concil_b2.dat_emis_arq      = v_dat_aux
                                   int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 13, 9)
                                   int_concil_b2.nom_arq_orig      = v_cod_aux
                                   int_concil_b2.dat_rv_cv_nsu     = DATE(SUBSTRING(v_cod_linha, 22, 8))
                                   int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 38, 15)) / 100)
                                   int_concil_b2.val_desc_tx_adm   = (DEC(SUBSTRING(v_cod_linha, 114, 15)) / 100)
                                   int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 206, 15)) / 100)
                                   int_concil_b2.cod_cart_cred     = SUBSTRING(v_cod_linha, 68, 16)
                                   int_concil_b2.cod_ocor          = SUBSTRING(v_cod_linha, 84, 3)
                                   int_concil_b2.cod_cv_nsu        = SUBSTRING(v_cod_linha, 89, 12)
                                   int_concil_b2.cod_autoriz       = SUBSTRING(v_cod_linha, 129, 6)
                                   int_concil_b2.cod_parcela       = SUBSTRING(v_cod_linha, 87, 2).
                       END.

                       IF SUBSTRING(v_cod_linha, 1, 3) = "014"
                       THEN DO:
                            CREATE int_concil_b2.
                            ASSIGN int_concil_b2.cod_adm_bco       = "REDECARD"
                                   int_concil_b2.cod_tip_arq       = "D"
                                   int_concil_b2.cod_reg           = "014"
                                   int_concil_b2.des_reg           = "VENDA PARCELADA - DETALHE REPASSE"
                                   int_concil_b2.dat_emis_arq      = v_dat_aux
                                   int_concil_b2.dat_credito       = DATE(SUBSTRING(v_cod_linha, 85, 8))
                                   int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 13, 9)
                                   int_concil_b2.nom_arq_orig      = v_cod_aux
                                   int_concil_b2.dat_rv_cv_nsu     = DATE(SUBSTRING(v_cod_linha, 22, 8))
                                   int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 40, 15)) / 100)
                                   int_concil_b2.val_desc_tx_adm   = (DEC(SUBSTRING(v_cod_linha, 55, 15)) / 100)
                                   int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 70, 15)) / 100)
                                   int_concil_b2.cod_parcela       = SUBSTRING(v_cod_linha, 38, 2).
                       END.

                  END.

                  /* ** DETALHAMENTO MOVIMENTO FINANCEIRO ***/
                  IF v_cod_aux BEGINS ("EEFI")  
                  THEN DO:

                       IF SUBSTRING(v_cod_linha, 1, 3) = "030"
                          THEN ASSIGN v_dat_aux = DATE(SUBSTRING(v_cod_linha, 4, 8)).
  
                       IF SUBSTRING(v_cod_linha, 1, 3) = "034"
                       THEN DO:
                            CREATE int_concil_b2.
                            ASSIGN int_concil_b2.cod_adm_bco     = "REDECARD"
                                   int_concil_b2.cod_tip_arq     = "C"
                                   int_concil_b2.cod_reg         = "034"
                                   int_concil_b2.des_reg         = "CRêDITOS"
                                   int_concil_b2.dat_emis_arq    = v_dat_aux
                                   int_concil_b2.dat_credito     = DATE(SUBSTRING(v_cod_linha, 24, 8))
                                   int_concil_b2.cod_rv          = SUBSTRING(v_cod_linha, 76, 9)
                                   int_concil_b2.nom_arq_orig    = v_cod_aux
                                   int_concil_b2.dat_rv_cv_nsu   = DATE(SUBSTRING(v_cod_linha, 85, 8))
                                   int_concil_b2.val_bruto       = (DEC(SUBSTRING(v_cod_linha, 95, 15)) / 100)
                                   int_concil_b2.val_desc_tx_adm = (DEC(SUBSTRING(v_cod_linha, 110, 15)) / 100)
                                   int_concil_b2.val_liquido     = (DEC(SUBSTRING(v_cod_linha, 32, 15)) / 100)
                                   int_concil_b2.cod_parcela     = SUBSTRING(v_cod_linha, 125, 5)
                                   int_concil_b2.cod_ocor        = SUBSTRING(v_cod_linha, 130, 2).
                       END.
                  
                       IF SUBSTRING(v_cod_linha, 1, 3) = "035"
                       THEN DO:
                            CREATE int_concil_b2.
                            ASSIGN int_concil_b2.cod_adm_bco       = "REDECARD"
                                   int_concil_b2.cod_tip_arq       = "C"
                                   int_concil_b2.cod_reg           = "035"
                                   int_concil_b2.des_reg           = "AJUSTES"
                                   int_concil_b2.dat_emis_arq      = v_dat_aux
                                   int_concil_b2.dat_credito       = DATE(SUBSTRING(v_cod_linha, 171, 8))
                                   int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 13, 9)
                                   int_concil_b2.nom_arq_orig      = v_cod_aux
                                   int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 30, 15)) / 100)
                                   int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 30, 15)) / 100)
                                   int_concil_b2.cod_cart_cred     = SUBSTRING(v_cod_linha, 76, 16)
                                   int_concil_b2.cod_ocor          = SUBSTRING(v_cod_linha, 46, 2)
                                   int_concil_b2.des_ocor          = SUBSTRING(v_cod_linha, 48, 28)
                                   int_concil_b2.cod_cv_nsu        = SUBSTRING(v_cod_linha, 239, 12)
                                   int_concil_b2.cod_autoriz       = SUBSTRING(v_cod_linha, 251, 6).
                       END.
                    
                  END.

             END.

             /* ** HIPERCARD ***/
             IF v_cod_aux BEGINS ("HCARD")
             THEN DO:

                  /*
                  IF  SUBSTRING(v_cod_linha, 1, 1)  = "0"
                  AND SUBSTRING(v_cod_linha, 53, 1) = "D"
                     THEN LEAVE blk_import.
                     */

                 /* ** Identificaá∆o Arquivo ***
                 0 => Header de Arquivo
                 1 => Capa de Lote
                 2 => Movimentos de Venda
                 3 => Previs‰es de Pagamento
                 4 => Desagendamento de Parcelas
                 5 => Ajustes
                 7 => Tarifas
                 9 = > Trailer do Arquivo ***/

                  IF SUBSTRING(v_cod_linha, 1, 1)  = "0"
                     THEN ASSIGN v_dat_aux = DATE(SUBSTRING(v_cod_linha, 18, 2) + SUBSTRING(v_cod_linha, 16, 2) + SUBSTRING(v_cod_linha, 12, 4)) /* ** AAAAMMDD ***/.

                  IF SUBSTRING(v_cod_linha, 1, 1) = "0" /* ** Header do Arquivo  ***/
                  OR SUBSTRING(v_cod_linha, 1, 1) = "9" /* ** Trailer do Arquivo ***/
                     THEN NEXT.

                  /* ** Tratamento para ignorar lotes que n∆o sejam de PAG, AJU ou TAR ***/
                  IF SUBSTRING(v_cod_linha,  1, 1) = "1" 
                     THEN ASSIGN v_log_lote_valido = NO.

                  IF   SUBSTRING(v_cod_linha,  1, 1) = "1" 
                  AND (SUBSTRING(v_cod_linha, 27, 3) = "PAG" OR 
                       SUBSTRING(v_cod_linha, 27, 3) = "AJU" OR 
                       SUBSTRING(v_cod_linha, 27, 3) = "TAR") 
                      THEN ASSIGN v_log_lote_valido = YES.

                  IF NOT v_log_lote_valido 
                     THEN NEXT.
                  /* ** Fim tratamento ignorar lotes ***/

                  IF SUBSTRING(v_cod_linha, 1, 1) = "1" 
                  THEN DO:
                       CREATE int_concil_b2.
                       ASSIGN int_concil_b2.cod_adm_bco       = "HIPERCARD"
                              int_concil_b2.cod_tip_arq       = "C"
                              int_concil_b2.cod_reg           = "1"
                              int_concil_b2.des_reg           = "RESUMO DE VENDA"
                              int_concil_b2.dat_emis_arq      = v_dat_aux
                              int_concil_b2.dat_credito       = DATE(SUBSTRING(v_cod_linha, 60, 2) + SUBSTRING(v_cod_linha, 58, 2) + SUBSTRING(v_cod_linha, 54, 4))  /* ** AAAAMMDD ***/
                              int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 15, 7)
                              int_concil_b2.nom_arq_orig      = v_cod_aux
                              int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 062, 14)) / 100)
                              int_concil_b2.val_desc_tx_adm   = (DEC(SUBSTRING(v_cod_linha, 109, 14)) / 100)
                              int_concil_b2.val_liquido       = ((DEC(SUBSTRING(v_cod_linha, 062, 14)) / 100) - /* ** + Valor Bruto              ***/
                                                                 (DEC(SUBSTRING(v_cod_linha, 076, 14)) / 100) - /* ** - Valor Rejeitado          ***/
                                                                 (DEC(SUBSTRING(v_cod_linha, 109, 14)) / 100))  /* ** - Valor Taxa Administraá∆o ***/ 
                              int_concil_b2.cod_ocor          = SUBSTRING(v_cod_linha, 27, 3)
                              v_dat_cred                      = int_concil_b2.dat_credito
                              v_cod_parc_hiper                = SUBSTRING(v_cod_linha, 22, 5).
                       IF int_concil_b2.cod_ocor = 'PRE'
                          THEN ASSIGN int_concil_b2.des_ocor  = "Vendas/Prev.Pagamento".
                       IF int_concil_b2.cod_ocor = 'DES'
                          THEN ASSIGN int_concil_b2.des_ocor  = "Desagendamento Parcelas".
                       IF int_concil_b2.cod_ocor = 'PAG'
                          THEN ASSIGN int_concil_b2.des_ocor  = "Pagamento".
                       IF int_concil_b2.cod_ocor = 'AJU'
                          THEN ASSIGN int_concil_b2.des_ocor  = "Ajuste(CR/DB)".
                       IF int_concil_b2.cod_ocor = 'ANT'
                          THEN ASSIGN int_concil_b2.des_ocor  = "Pagamento Antecipado".
                       IF int_concil_b2.cod_ocor = 'TAR'
                          THEN ASSIGN int_concil_b2.des_ocor  = "Tarifas".
                  END.
                  
                  /* ** Tratamento para PAG ***/
                  IF SUBSTRING(v_cod_linha, 1, 1) = "2" 
                  THEN DO:

                       CREATE int_concil_b2.
                       ASSIGN int_concil_b2.cod_adm_bco       = "HIPERCARD"
                              int_concil_b2.cod_tip_arq       = "C"
                              int_concil_b2.cod_reg           = "2"
                              int_concil_b2.des_reg           = "DETALHE RESUMO DE VENDA - PAGAMENTO"
                              int_concil_b2.dat_emis_arq      = v_dat_aux
                              int_concil_b2.dat_credito       = v_dat_cred
                              int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 15, 7)
                              int_concil_b2.nom_arq_orig      = v_cod_aux
                              int_concil_b2.cod_cart_cred     = SUBSTRING(v_cod_linha,  22, 19)
                              int_concil_b2.cod_autoriz       = SUBSTRING(v_cod_linha, 121, 6)
                              int_concil_b2.cod_cv_nsu        = SUBSTRING(v_cod_linha, 127, 6)
                              int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 157, 14)) / 100)
                              int_concil_b2.cod_ocor          = SUBSTRING(v_cod_linha, 185, 3)
                              int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 188, 14)) / 100)
                              int_concil_b2.cod_parcela       = v_cod_parc_hiper.
                       IF int_concil_b2.cod_parcela = "00/00" 
                          THEN ASSIGN int_concil_b2.cod_parcela = "01/01".

                  END.

                  /* ** Tratamento para AJU ***/
                  IF SUBSTRING(v_cod_linha, 1, 1) = "5" 
                  THEN DO:

                       CREATE int_concil_b2.
                       ASSIGN int_concil_b2.cod_adm_bco       = "HIPERCARD"
                              int_concil_b2.cod_tip_arq       = "C"
                              int_concil_b2.cod_reg           = "5"
                              int_concil_b2.des_reg           = "DETALHE RESUMO DE VENDA - AJUSTE"
                              int_concil_b2.dat_emis_arq      = v_dat_aux
                              int_concil_b2.dat_credito       = v_dat_cred
                              int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 15, 7)
                              int_concil_b2.nom_arq_orig      = v_cod_aux
                              int_concil_b2.cod_cart_cred     = SUBSTRING(v_cod_linha, 22, 19)
                              int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 65, 14)) / 100)
                              int_concil_b2.val_liquido       = (DEC(SUBSTRING(v_cod_linha, 79, 14)) / 100)
                              int_concil_b2.cod_parcela       = STRING(SUBSTRING(v_cod_linha, 73, 4), "99/99")
                              int_concil_b2.cod_cv_nsu        = SUBSTRING(v_cod_linha, 97, 6)
                              int_concil_b2.cod_ocor          = SUBSTRING(v_cod_linha, 103, 3)
                              int_concil_b2.des_ocor          = SUBSTRING(v_cod_linha, 106, 60).
                       IF int_concil_b2.cod_parcela = "00/00" 
                          THEN ASSIGN int_concil_b2.cod_parcela = "01/01".

                  END.
             
                  /* ** Tratamento para TAR ***/
                  IF SUBSTRING(v_cod_linha, 1, 1) = "7" 
                  THEN DO:

                       CREATE int_concil_b2.
                       ASSIGN int_concil_b2.cod_adm_bco       = "HIPERCARD"
                              int_concil_b2.cod_tip_arq       = "C"
                              int_concil_b2.cod_reg           = "7"
                              int_concil_b2.des_reg           = "DETALHE RESUMO DE VENDA - TARIFA"
                              int_concil_b2.dat_emis_arq      = v_dat_aux
                              int_concil_b2.dat_credito       = v_dat_cred
                              int_concil_b2.cod_rv            = SUBSTRING(v_cod_linha, 15, 7)
                              int_concil_b2.nom_arq_orig      = v_cod_aux
                              int_concil_b2.val_bruto         = (DEC(SUBSTRING(v_cod_linha, 36, 11)) / 100)
                              int_concil_b2.cod_ocor          = SUBSTRING(v_cod_linha, 47, 3).

                  END.

                  
             END.

         END.
         INPUT STREAM s_2 CLOSE.

         /* ** Transfere arquivos para pasta de j† importados ***/
         OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_b2c).
         OS-DELETE VALUE(v_cod_arq).
         
    END.

END.

INPUT STREAM s_1 CLOSE.
