/***********************************************************************
**  Programa..: ESP\FTP\ESFTP013R1.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: Impressao Boleto BRADESCO - ES0658
**  VersÆo....: 001 27/12/2004 - Chaves
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp\ftp\esftp013tt.i}
/****************************  Temp-Tables  ****************************/
def temp-table tt-boleto
    field c-codesp        as char format "x(02)"
    field c-codserie      as char
    field c-documento     as char format "x(10)"
    field c-tipo          as char format "X(40)"
    field c-cpf           as char format "999999999999999"
    field c-sacado        as char format "x(30)"
    field c-end           as char
    field c-bairro        as char
    field c-cidade        as char
    field c-compl         as char
    field c-uf            as char
    field c-cep           as char
    field nat-operacao    like natur-oper.nat-operacao
    field i-carteira      as i  format "99"                       
    field d-valor         as de format ">>,>>>,>>9.99" decimals 3  
    field d-valor-doc     as de format ">,>>>,>>9.99"              
    field c-cod_espec_docto       as c  format "xx"
    field c-emissao       as c  format "99/99/9999"
    field c-vencimento    as c  format "99/99/9999"
    field d-juros         as de format ">>>,>>9.99"
    field d-desconto      as dec                     
    field c-process       as char format "99/99/9999"  
    field c-ficha         as char.

/****************************  Variaveis    ****************************/



/*def var tc-linha               as char format "x(69)" extent 9.
def var ti-linha               as int.
def var tc-nossonumero         as c    format "99999999999". 
def var tc-ficha               as c.
def var ti-linha-1             as i no-undo.
def var ti-coluna              as i no-undo.
def var tc-ntit_acr             as c format "x(16)" no-undo.
def var tc-posicao             as c no-undo.
def var ti-ixtab               as i no-undo.
def var ti-ixtab1              as i no-undo.
def var tc-dig-bin             as c format "x(5)" extent 10 init ["00110","10001","01001","11000","00101","10100","01100","00011","10010","01010"] no-undo.
def var tc-linha-bin           as c format "x(10)" no-undo.
def var tc-linha-bar           as c format "x(10)" no-undo.
def var tc-par-binar           as c forma "xx"     no-undo.
def var tc-barra-solida-fina   as c init "~033*c3A~033*c150B~033*c0P" no-undo.
def var tc-barra-solida-larga  as c init "~033*c9A~033*c150B~033*c0P" no-undo.
def var tc-barra-branca-fina   as c init "~033*c5H~033*c365V~033*c1P" no-undo.
def var tc-barra-branca-larga  as c init "~033*c15H~033*c365V~033*c1P"
    no-undo.
def var tl-imprimiu-fina       as l no-undo.
def var tc-linha-s80           as c format "x(20)" 
    init "~033*c5550H~033*c10V~033*c0P" no-undo.
def var tc-linha-f80           as c format "x(20)" 
    init "~033*c5550H~033*c5V~033*c0P"  no-undo.
def var tc-traco-fino          as c format "x(50)" 
    init "~033*c5H~033*c200V~033*c0P"   no-undo.
def var tc-traco-fino1         as c format "x(50)" 
    init "~033*c5H~033*c250V~033*c0P"   no-undo.
def var tc-fonte-10            as c format "x(50)" 
    init "~033(19U~033(s16901t0b0s10.0v1P" no-undo.    
def var tc-fonte-6             as c format "x(50)" 
    init "~033(19U~033(s1p6.0v0s0b16602T"  no-undo.    
def var tc-fonte-10exp         as c format "x(50)" 
    init "~033(19U~033(s0p12.0h0s0b4099T"  no-undo.

def var i-digito          as int.
def var i-mo-cod          like tit_acr.mo-codigo init 0.
*/
{esp\ftp\esftp013rtt.i "shared"}

/****************************  Frames       ****************************/
def input  parameter TABLE FOR tt-param.
def output parameter TABLE FOR tt-boleto.

/*
 * for each tt-raw-digita:
 *     create tt-digita.
 *     raw-transfer tt-raw-digita.raw-digita to tt-digita.
 * end. 
 */

/*FOR FIRST param-global NO-LOCK. END.*/
/*FOR FIRST emscad.empresa NO-LOCK
    WHERE empresa.cod_empresa = STRING(param-global.empresa-pri): END.*/
FIND FIRST tt-param NO-LOCK.
/* ***************************  Main Block  *************************** */
do on stop undo, leave:

   /*IF VALID-HANDLE(h-acomp) THEN
        run pi-acompanhar in h-acomp (input "Montando Relat¢rio...").*/
   run piMontaRelat.

   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE piMontaRelat:

        FIND estabelecimento NO-LOCK
             WHERE estabelecimento.cod_estab = tt-param.cod-estab NO-ERROR.    

        FIND FIRST emscad.portador NO-LOCK
             WHERE emscad.portador.cod_portador = tt-param.i-portador NO-ERROR.

        FOR EACH tt-boleto:
            DELETE tt-boleto.
        END.

        FOR EACH  tit_acr NO-LOCK
            WHERE tit_acr.cod_estab            = tt-param.cod-estab
              AND tit_acr.cod_tit_acr         >= tt-param.i-nr-titulo-ini
              AND tit_acr.cod_tit_acr         <= tt-param.i-nr-titulo-fim
              AND tit_acr.dat_emis_docto      >= tt-param.da-dt-ini
              AND tit_acr.dat_emis_docto      <= tt-param.da-dt-fim
              AND tit_acr.cod_espec_docto      = tt-param.c-esp
              AND tit_acr.log_sdo_tit_acr      = YES
              AND tit_acr.ind_tip_espec_docto  = "Normal"
              AND tit_acr.cod_indic_econ       = "Real":

            /*Mario F. Fleith Jr. - Para nÆo pegar t¡tulo renegociados*/
            FIND FIRST movto_tit_acr OF tit_acr NO-LOCK
                 WHERE movto_tit_acr.ind_trans_acr_abrev = 'IMPL' NO-ERROR.

            IF NOT AVAIL movto_tit_acr 
               THEN NEXT.

            FOR FIRST emscad.cliente NO-LOCK
                WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa
                  AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente:
            END.

            IF tit_acr.cod_cart_bcia = "60" 
               THEN NEXT.

            IF emscad.cliente.cdn_cliente = 6926          THEN DO:
                IF ((tit_acr.dat_vencto_tit_acr - tit_acr.dat_emis_docto) < 5
                OR (tit_acr.dat_vencto_tit_acr - tit_acr.dat_emis_docto)  > 35) 
                    THEN NEXT.
    
            END.
            ELSE DO:
                 FIND nota-fiscal NO-LOCK
                     WHERE nota-fiscal.cod-estabel = tit_acr.cod_estab
                       AND nota-fiscal.serie       = tit_acr.cod_ser_docto
                       AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr NO-ERROR.
                 IF AVAIL nota-fiscal 
                 THEN DO:
                      FIND int-cond-pagto NO-LOCK
                           WHERE int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-ERROR.
                      IF NOT AVAIL int-cond-pagto 
                         THEN NEXT.
                      IF  AVAIL int-cond-pagto
                      AND SUBSTRING(int-cond-pagto.char-1,1,1) <> "S" 
                          THEN NEXT.
                 END.
                 ELSE NEXT.
            END.
/*
                      IF  cliente.cod_grp_clien <> "08" 
                      AND ((tit_acr.dat_vencto_tit_acr - tit_acr.dat_emis_docto) < 5
                       OR (tit_acr.dat_vencto_tit_acr - tit_acr.dat_emis_docto)  > 25) 
                          THEN NEXT.
*/
     
            IF (tit_acr.cod_portador   = "999"  AND tit_acr.cod_cart_bcia = "00") OR 
               (tit_acr.cod_portador   = "237"  AND tit_acr.cod_cart_bcia = "11") THEN.
            ELSE NEXT.  

            FIND FIRST int_tit_acr 
                 WHERE int_tit_acr.cod_estab = tit_acr.cod_estab
                   AND int_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
            IF NOT AVAIL INT_tit_acr 
            THEN DO:
                 CREATE int_tit_acr.
                 ASSIGN int_tit_acr.cod_cart_bcia       = tit_acr.cod_cart_bcia 
                        int_tit_acr.cod_estab           = tit_acr.cod_estab     
                        int_tit_acr.cod_portador        = tit_acr.cod_portador  
                        int_tit_acr.num_id_tit_acr      = tit_acr.num_id_tit_acr
                        int_tit_acr.log_boleto_impresso = NO.
            END.
            
            IF     l-imp-reimp AND     int_tit_acr.log_boleto_impresso THEN NEXT.
            IF NOT l-imp-reimp AND NOT int_tit_acr.log_boleto_impresso THEN NEXT.
            
            CREATE tt-boleto.
            ASSIGN tt-boleto.c-codesp      = tit_acr.cod_espec_docto
                   tt-boleto.c-codserie    = tit_acr.cod_ser_docto
                   tt-boleto.c-documento   = STRING(tit_acr.cod_tit_acr, "9999999")
                                             +  "/" +  STRING(tit_acr.cod_parcela, "99").
            IF emscad.cliente.num_pessoa MOD 2 = 0
            THEN DO:
                 FIND pessoa_fisic NO-LOCK 
                    WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
                 IF AVAIL pessoa_fisic
                 THEN DO:
                      FIND emscad.pais NO-LOCK 
                         WHERE pais.cod_pais = pessoa_fisic.cod_pais NO-ERROR.
                      ASSIGN tt-boleto.c-tipo   = "CPF" /*if emitente.natureza = "f" then "CPF" else "CNPJ" */
                             tt-boleto.c-cpf    = STRING(pessoa_fisic.cod_id_feder, pais.cod_format_id_feder_fisic)
                             tt-boleto.c-sacado = pessoa_fisic.nom_pessoa
                             tt-boleto.c-end    = pessoa_fisic.nom_endereco
                             tt-boleto.c-bairro = pessoa_fisic.nom_bairro
                             tt-boleto.c-cidade = pessoa_fisic.nom_cidade
                             tt-boleto.c-uf     = pessoa_fisic.cod_unid_federac
                             tt-boleto.c-cep    = (IF pessoa_fisic.cod_cep <> '' THEN STRING(pessoa_fisic.cod_cep, emscad.pais.cod_format_cep) ELSE '').
                 END.
            END.
            ELSE DO:
                FIND pessoa_jurid NO-LOCK 
                    WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
                IF AVAIL pessoa_jurid
                THEN DO:
                     FIND emscad.pais NO-LOCK 
                         WHERE pais.cod_pais = pessoa_jurid.cod_pais NO-ERROR.
                     ASSIGN tt-boleto.c-tipo   = "CNPJ" /*if emitente.natureza = "f" then "CPF" else "CNPJ" */
                            tt-boleto.c-cpf    = STRING(pessoa_jurid.cod_id_feder, pais.cod_format_id_feder_jurid)
                            tt-boleto.c-sacado = pessoa_jurid.nom_pessoa. /*emitente.nome-emit*/
                    IF  pessoa_jurid.nom_ender_cobr = ""
                    THEN DO:
                         ASSIGN tt-boleto.c-end    = pessoa_jurid.nom_endereco
                                tt-boleto.c-bairro = pessoa_jurid.nom_bairro
                                tt-boleto.c-cidade = pessoa_jurid.nom_cidade
                                tt-boleto.c-uf     = pessoa_jurid.cod_unid_federac
                                tt-boleto.c-cep    = (IF pessoa_jurid.cod_cep <> '' THEN STRING(pessoa_jurid.cod_cep, emscad.pais.cod_format_cep) ELSE '').

                    END.
                    ELSE DO:
                         ASSIGN tt-boleto.c-end      = pessoa_jurid.nom_ender_cobr
                                tt-boleto.c-bairro   = pessoa_jurid.nom_bairro_cobr
                                tt-boleto.c-cidade   = pessoa_jurid.nom_cidad_cobr
                                tt-boleto.c-uf       = pessoa_jurid.cod_unid_federac_cobr
                                tt-boleto.c-cep      = (IF pessoa_jurid.cod_cep_cobr <> '' THEN STRING(pessoa_jurid.cod_cep_cobr, emscad.pais.cod_format_cep) ELSE '').
                    END.
                END.
            END /* else if  emscad.cliente.num_pessoa mod 2 = 0*/.
            FOR FIRST nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel = tit_acr.cod_estab
                  AND nota-fiscal.serie       = tit_acr.cod_ser_docto
                  AND nota-fiscal.nr-nota-fis = STRING(tit_acr.num_fatur_acr):
                ASSIGN tt-boleto.nat-operacao  = nota-fiscal.nat-operacao.
            END.
            ASSIGN /*------------- tit_acr -----------------------------*/
                   tt-boleto.i-carteira         = 09
                   tt-boleto.d-valor            = 0  
                   tt-boleto.d-valor-doc        = tit_acr.val_sdo_tit_acr
                   tt-boleto.d-juros            = (tit_acr.val_sdo_tit_acr * tit_acr.val_perc_juros_dia_atraso) / 100
                   tt-boleto.c-cod_espec_docto  = tit_acr.cod_espec_docto
                   tt-boleto.c-emissao          = STRING(tit_acr.dat_emis_docto,"99/99/9999")
                   tt-boleto.c-vencimento       = STRING(tit_acr.dat_vencto_tit_acr,"99/99/9999")
                   tt-boleto.d-desconto         = 0
                   tt-boleto.c-process          = STRING(TODAY,"99/99/9999").  

        END.
       
        ASSIGN ti-banco       = 237
               ti-carteira    = INT(tt-param.i-carteira)
               tc-bco-compens = "237-2"
               tc-nome-banco  = "BRADESCO"
               tc-nome-est    = estabelecimento.nom_pessoa.

        FIND portad_finalid_econ NO-LOCK
            WHERE portad_finalid_econ.cod_estab        = estabelecimento.cod_estab
              AND portad_finalid_econ.cod_portador     = "237"
              AND portad_finalid_econ.cod_cart_bcia    = "11"
              AND portad_finalid_econ.cod_finalid_econ = "Corrente" NO-ERROR.
        FIND cta_corren NO-LOCK
            WHERE cta_corren.cod_cta_corren = portad_finalid_econ.cod_cta_corren NO-ERROR.
        FIND agenc_bcia NO-LOCK
            WHERE agenc_bcia.cod_banco      = cta_corren.cod_banco
              AND agenc_bcia.cod_agenc_bcia = cta_corren.cod_agenc_bcia NO-ERROR.

        ASSIGN ti-ag-cedente  = INT(agenc_bcia.cod_agenc_bcia)
               i-dig-cart     = INT(agenc_bcia.cod_digito_agenc_bcia)
               ti-ccorrente   = INT(SUBSTR(cta_corren.cod_cta_corren,1,INDEX(cta_corren.cod_cta_corren,'-') - 1))
               ti-dac-agcc    = INT(cta_corren.cod_digito_cta_corren).

END PROCEDURE.

