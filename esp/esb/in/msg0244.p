CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/*DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.
DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.*/

DEFINE VARIABLE raw-param AS RAW     NO-UNDO.
DEFINE VARIABLE i-cont    AS INTEGER NO-UNDO.

/*ASSIGN iXML = "<?xml version='1.0' encoding='ISO-8859-1' ?>
<MENSAGEM>
  <CABECALHO>
    <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor>
    <NumeroOperacao>305481-1022555-SERIAL:false-MAC:true</NumeroOperacao>
    <CodigoMensagem>MSG0244</CodigoMensagem>
    <LoginUsuario>sensus.marcelo</LoginUsuario>
  </CABECALHO>
  <CONTEUDO>
    <MSG0244>
      <NumeroPedidoCompra>305481</NumeroPedidoCompra>
      <CadastrarSerialNumbers>false</CadastrarSerialNumbers>
      <ItensConsulta>
        <CodigoProduto>1022555</CodigoProduto>
      </ItensConsulta>
      <CadastrarMacAddresses>true</CadastrarMacAddresses>
    </MSG0244>
  </CONTEUDO>
</MENSAGEM>".*/


{esp/esb/in/msg0244.i}
{esapi/esapi023.i}     /*ttItem*/
{cdp/cd0666.i}         /*tt-erro*/
{btb/btb912zb.i}       /* Inicio criar pedido execucao */
{esp/es0018.i}

/*Retorna ambiente atual*/
FUNCTION fnRetornaRPW RETURN CHARACTER():
    DEFINE VARIABLE c-ambiente AS CHARACTER NO-UNDO.
    DEFINE VARIABLE p-rpw      AS CHARACTER NO-UNDO.

    RUN esp/es0018p.p (INPUT  "ambiente":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST tt-prog-ponto NO-ERROR.
    
    IF  AVAILABLE tt-prog-ponto THEN
        ASSIGN c-ambiente = tt-prog-ponto.conteudo.
    
    
    RUN esp/es0018p.p (INPUT  "MSG0244":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR EACH tt-prog-ponto:
        IF ENTRY(1, tt-prog-ponto.conteudo, ";") = c-ambiente THEN
            ASSIGN p-rpw =  ENTRY(2, tt-prog-ponto.conteudo, ";").
    END.

    RETURN p-rpw.
END FUNCTION.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0244, ItensConsulta
    DATA-RELATION FOR conteudo, MSG0244       RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR MSG0244,  ItensConsulta RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0244R1,resultado
   DATA-RELATION FOR conteudor, MSG0244R1  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0244R1, resultado  RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0244R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0244 NO-ERROR.

CREATE conteudor.
CREATE MSG0244R1.
CREATE resultado.

CREATE tt-param.
ASSIGN tt-param.usuario      = c-seg-usuario
       tt-param.destino      = 2
       tt-param.data-exec    = TODAY
       tt-param.hora-exec    = TIME
       tt-param.ind-execucao = 2
       tt-param.num-pedido   = MSG0244.NumeroPedidoCompra
       tt-param.gera-ns      = MSG0244.CadastrarSerialNumbers
       tt-param.gera-mac     = MSG0244.CadastrarMacAddress.

/*FOR EACH ItensConsulta:
    CREATE tt-raw-digita.
    RAW-TRANSFER ItensConsulta TO tt-raw-digita.raw-digita.
END.*/

CREATE tt_param_segur.
ASSIGN tt_param_segur.tta_num_vers_integr_api      = 3
       tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
       tt_param_segur.tta_cod_empres_usuar         = STRING(i-ep-codigo-usuario)
       tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
       tt_param_segur.tta_cod_idiom_usuar          = "POR":U
       tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
       tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
       tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
       tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

CREATE tt_ped_exec.
ASSIGN tt_ped_exec.tta_num_seq                = 1
       tt_ped_exec.tta_cod_usuario            = v_cod_usuar_corren
       tt_ped_exec.tta_cod_prog_dtsul         = "esesb020rp" 
       tt_ped_exec.tta_cod_prog_dtsul_rp      = "esp/esb/esesb020rp.p"
       tt_ped_exec.tta_cod_release_prog_dtsul = "2.00.00.000"
       tt_ped_exec.tta_dat_exec_ped_exec      = TODAY
       tt_ped_exec.tta_hra_exec_ped_exec      = REPLACE(STRING(TIME,"HH:MM:SS"), ":", "")
       tt_ped_exec.tta_cod_servid_exec        = fnRetornaRPW()
       tt_ped_exec.tta_cdn_estil_dwb          = 97.

CREATE tt_ped_exec_param.
ASSIGN tt_ped_exec_param.tta_num_seq         = 1
       tt_ped_exec_param.tta_cod_dwb_file    = "esp/esesb020rp.p"
       tt_ped_exec_param.tta_cod_dwb_output  = 'Arquivo'
       tt_ped_exec_param.tta_nom_dwb_printer = "esesb020rp.tmp".

RAW-TRANSFER tt-param TO tt_ped_exec_param.tta_raw_param_ped_exec.

ASSIGN i-cont = 0.
FOR EACH ItensConsulta NO-LOCK:
    ASSIGN i-cont = i-cont + 1.
    CREATE tt_ped_exec_param_aux.
    ASSIGN tt_ped_exec_param_aux.tta_num_dwb_order      = i-cont
           tt_ped_exec_param_aux.tta_num_seq            = 1.

    RAW-TRANSFER ItensConsulta TO tt_ped_exec_param_aux.tta_raw_param_ped_exec.
END.

RUN btb/btb912zb.p (INPUT-OUTPUT TABLE tt_param_segur,
                    INPUT-OUTPUT TABLE tt_ped_exec,
                    INPUT TABLE        tt_ped_exec_param,
                    INPUT TABLE        tt_ped_exec_param_aux,
                    INPUT TABLE        tt_ped_exec_sel).

/* Mensagem nÆo trata resultado */
ASSIGN resultado.sucesso = YES.
       
FIND FIRST tt_ped_exec NO-ERROR.
IF AVAIL tt_ped_exec THEN
    ASSIGN resultado.Mensagem = STRING(tt_ped_exec.tta_num_ped_exec).

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/*DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-gugui" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").*/
