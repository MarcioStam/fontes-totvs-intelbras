{esp/es0018.i}

/* Relaá∆o de pessoas / matriz */
def temp-table tt_pessoa_jurid_matriz     no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_cdn_fornecedor_matriz        as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field nom_abrev_matriz                 as character format "x(15)" label "Nome" column-label "Nome".


/* Temp-table para envio de e-mail */                 
def temp-table tt_mail_fax no-undo
    field ttv_nom_servid            as character format "x(30)"
    field ttv_num_porta_servid      as integer   format ">>>>9"
    field ttv_log_exchange          as logical   format "Sim/N∆o" initial no
    field ttv_nom_from              as character format "x(50)"
    field ttv_nom_to                as character format "x(50)" label "To"
    field ttv_nom_cc                as character format "x(50)" label "Cc"
    field ttv_nom_subject           as character format "x(30)"
    field ttv_nom_message           as character format "x(50)"
    field ttv_nom_attachfile        as character format "x(30)"
    field ttv_num_imptcia           as integer   format "9"
    field ttv_log_envda             as logical   format "Sim/N∆o" initial no
    field ttv_log_lida              as logical   format "Sim/N∆o" initial no
    field ttv_cod_format_mail       as character format "x(8)"    initial "TEXTO".

def temp-table tt_erros_mail_fax no-undo
    field ttv_cod_erro          as character format "x(10)"
    field ttv_des_erro          as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_arquivo       as character format "x(255)".
/* Temp-table para envio de e-mail */

def new global shared temp-table tt_paint_row_tit_ap no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_num_color                    as integer format ">>>>,>>9"
    field ttv_num_color_1                  as integer format ">>>>,>>9"
    index tt_index_unique                 
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.

def temp-table tt_permuta no-undo
    field cod_estab_apb                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field cdn_fornecedor_apb               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field nom_abrev_apb                    as character format "x(15)" label "Nome" column-label "Nome"
    field cod_espec_docto_apb              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field cod_ser_docto_apb                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field cod_tit_apb                      as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field cod_parcela_apb                  as character format "x(02)" label "Parcela" column-label "Parc"
    field dat_vencto_apb                   as date label "Vencto" column-label "Vencto"
    field val_sdo_apb                      as dec label "Saldo" column-label "Saldo"
    field cod_estab_acr                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field cdn_cliente_acr                  as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field nom_abrev_acr                    as character format "x(15)" label "Nome" column-label "Nome"
    field cod_espec_docto_acr              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field cod_ser_docto_acr                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field cod_tit_acr                      as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field cod_parcela_acr                  as character format "x(02)" label "Parcela" column-label "Parc"
    field dat_vencto_acr                   as date label "Vencto" column-label "Vencto"
    field val_sdo_acr                      as dec label "Saldo" column-label "Saldo"
    field cdn_matriz                       as integer format ">>>,>>>,>>9" label "Matriz" column-label "Matriz"
    field nom_abrev_matriz                 as character format "x(15)" label "Nome" column-label "Nome"
    field cdn_tip                          as integer format "9" label "Tipo" column-label "Tipo"
    field ind_impto_apb                    as character format "x(03)" label "Impto" column-label "Impto"
    index tt_index                 
          cdn_matriz                   ascending
          cdn_tip                      ascending.

DEF BUTTON bt_ok
    LABEL "OK"
    TOOLTIP "OK"
    SIZE 1 BY 1
    AUTO-GO.

DEF BUTTON bt_can
    LABEL "Cancela"
    TOOLTIP "Cancela"
    SIZE 1 BY 1
    AUTO-ENDKEY.

DEFINE VARIABLE v_des_email_para  AS CHARACTER FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE v_des_email_copia AS CHARACTER FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE c_dt_arq          AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c_remetente       AS CHARACTER                NO-UNDO INIT "intelbras@intelbras.com.br".
DEFINE VARIABLE c_tam_tab         AS CHARACTER                NO-UNDO INIT "900".
DEFINE VARIABLE c-arquivo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-titulo          AS CHARACTER   NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEF STREAM s_permuta.

DEFINE BUFFER btt_permuta FOR tt_permuta.

DEF FRAME f_permuta
    v_des_email_para
         AT ROW 1.42 COL 03.70 LABEL "Para"
         VIEW-AS FILL-IN 
         SIZE-CHARS 51.14 BY .88 
         FGCOLOR ? BGCOLOR 15 FONT 2
    v_des_email_copia
         AT ROW 2.42 COL 03.00 LABEL "Copia"
         VIEW-AS FILL-IN 
         SIZE-CHARS 51.14 BY .88 
         FGCOLOR ? BGCOLOR 15 FONT 2 
    bt_ok
         AT ROW 03.63 COL 02 FONT ?
         HELP "OK"
    bt_can
         AT ROW 03.63 COL 13 FONT ?
         HELP "Cancela"    
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D 
         SIZE-CHAR 60 BY 05 DEFAULT-BUTTON bt_ok
         VIEW-AS DIALOG-BOX 
         FONT 1 FGCOLOR ? BGCOLOR 8
         TITLE "E-mail Permuta".

ASSIGN bt_can:WIDTH-CHARS   IN FRAME f_permuta = 10.00
       bt_can:HEIGHT-CHARS  IN FRAME f_permuta = 01.00
       bt_ok:WIDTH-CHARS    IN FRAME f_permuta = 10.00
       bt_ok:HEIGHT-CHARS   IN FRAME f_permuta = 01.00.



DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE:

    FOR FIRST usuar_mestre FIELDS (cod_e_mail_local)
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
        ASSIGN c_remetente       = usuar_mestre.cod_e_mail_local
               v_des_email_copia = c_remetente.
    END.

    RUN esp/es0018p.r (INPUT "permuta",
                       INPUT 1,
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST tt-prog-ponto NO-LOCK.
        
    ASSIGN v_des_email_para  = ENTRY(1,tt-prog-ponto.conteudo,";")
           v_des_email_copia = ENTRY(2,tt-prog-ponto.conteudo,";").

    VIEW FRAME f_permuta.

    DISPLAY v_des_email_para
            v_des_email_copia
            bt_can
            bt_ok
            WITH FRAME f_permuta.

    ENABLE ALL WITH FRAME f_permuta.

    WAIT-FOR GO OF FRAME f_permuta.

    ASSIGN v_des_email_para v_des_email_copia.

    RUN pi_envia_email.

END.

HIDE FRAME f_permuta NO-PAUSE.


PROCEDURE pi_envia_email:

    ASSIGN c_dt_arq  = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99").

    RUN pi_cria_tabela.

    /* ** Limpar registros sem permuta ***/
    FOR EACH tt_permuta
        WHERE tt_permuta.cdn_tip = 1:
        IF NOT CAN-FIND(FIRST btt_permuta NO-LOCK
                        WHERE btt_permuta.cdn_matriz = tt_permuta.cdn_matriz
                          AND btt_permuta.cdn_tip    = 2)
           THEN DELETE tt_permuta.
    END.

    IF NOT CAN-FIND(FIRST tt_permuta) 
    THEN DO:
         MESSAGE "N∆o foram encontrados t°tulos para Permuta. Atená∆o, e-mail n∆o enviado!"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN "NOK".
    END.

    FOR EACH tt_permuta
        BREAK BY tt_permuta.cdn_matriz
              BY tt_permuta.cdn_tip:

        IF FIRST-OF(tt_permuta.cdn_matriz) 
        THEN DO:
             ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "permuta" + STRING(tt_permuta.cdn_matriz) + c_dt_arq + ".html".
             OUTPUT STREAM s_permuta TO VALUE(c-arquivo)
                    CONVERT TARGET SESSION:CHARSET.
             RUN pi-html-inicio("Permuta").
        END.

        IF FIRST-OF(tt_permuta.cdn_tip) 
        THEN DO:
             IF tt_permuta.cdn_tip = 1 
             THEN DO:
                  RUN pi-abre-tabela ("fornecedor").
             END.
             ELSE DO:
                  RUN pi-abre-tabela ("cliente").
             END.
        END.

        RUN pi-imprime(tt_permuta.cdn_tip).
         
        IF LAST-OF(tt_permuta.cdn_tip) 
        THEN DO:
             IF tt_permuta.cdn_tip = 1 
             THEN DO:
                  /*finaliza fornecedor*/
                  PUT STREAM s_permuta UNFORMATTED "</TABLE>" SKIP.
             END.
             ELSE DO:
                  /*finaliza cliente*/
                  PUT STREAM s_permuta UNFORMATTED "</TABLE>" SKIP.
             END.
        END.   

        IF LAST-OF(tt_permuta.cdn_matriz) 
        THEN DO:
             RUN pi-fecha-arquivo(v_des_email_para + "," + v_des_email_copia).
        END.   

    END.
    
END.

PROCEDURE pi_cria_tabela:

      DEF BUFFER b_pessoa_jurid FOR pessoa_jurid.
      DEF BUFFER b_fornecedor   FOR emscad.fornecedor.

      FOR EACH tt_paint_row_tit_ap:

/*           IF tt_paint_row_tit_ap.ttv_num_color_1 = 0 */
/*              THEN NEXT.                              */

          FIND emscad.fornecedor NO-LOCK
              WHERE emscad.fornecedor.cod_empresa = v_cod_empres_usuar
                AND emscad.fornecedor.cdn_fornec  = tt_paint_row_tit_ap.tta_cdn_fornecedor NO-ERROR.
          IF NOT AVAIL emscad.fornecedor 
             THEN NEXT.

          FIND tit_ap NO-LOCK
              WHERE tit_ap.cod_estab   = tt_paint_row_tit_ap.tta_cod_estab      
                AND tit_ap.cdn_fornec  = tt_paint_row_tit_ap.tta_cdn_fornecedor 
                AND tit_ap.cod_espec   = tt_paint_row_tit_ap.tta_cod_espec_docto            
                AND tit_ap.cod_ser     = tt_paint_row_tit_ap.tta_cod_ser_docto  
                AND tit_ap.cod_tit_ap  = tt_paint_row_tit_ap.tta_cod_tit_ap     
                AND tit_ap.cod_parcela = tt_paint_row_tit_ap.tta_cod_parcela NO-ERROR.
          IF NOT AVAIL tit_ap            
             THEN NEXT.

          /* ** Cria os t°tulos do APB, alimentando a Matriz ***/
          CREATE tt_permuta.
          ASSIGN tt_permuta.cod_estab_apb        = tt_paint_row_tit_ap.tta_cod_estab
                 tt_permuta.cdn_fornecedor_apb   = tt_paint_row_tit_ap.tta_cdn_fornecedor
                 tt_permuta.nom_abrev_apb        = emscad.fornecedor.nom_abrev
                 tt_permuta.cod_espec_docto_apb  = tt_paint_row_tit_ap.tta_cod_espec_docto
                 tt_permuta.cod_ser_docto_apb    = tt_paint_row_tit_ap.tta_cod_ser_docto  
                 tt_permuta.cod_tit_apb          = tt_paint_row_tit_ap.tta_cod_tit_ap     
                 tt_permuta.cod_parcela_apb      = tt_paint_row_tit_ap.tta_cod_parcela    
                 tt_permuta.dat_vencto_apb       = tit_ap.dat_vencto
                 tt_permuta.val_sdo_apb          = tit_ap.val_sdo_tit_ap
                 tt_permuta.cdn_tip              = 1.

          IF CAN-FIND (FIRST compl_retenc_impto_pagto NO-LOCK 
                       WHERE compl_retenc_impto_pagto.cod_estab     = tit_ap.cod_estab
                         AND compl_retenc_impto_pagto.num_id_tit_ap = tit_ap.num_id_tit_ap) 
             THEN ASSIGN tt_permuta.ind_impto_apb = " X ".
             ELSE ASSIGN tt_permuta.ind_impto_apb = "&nbsp;".

          FIND FIRST tt_pessoa_jurid_matriz
               WHERE tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa NO-ERROR.
          IF AVAIL tt_pessoa_jurid_matriz 
          THEN DO:
               ASSIGN tt_permuta.cdn_matriz       = tt_pessoa_jurid_matriz.tta_cdn_fornecedor_matriz
                      tt_permuta.nom_abrev_matriz = tt_pessoa_jurid_matriz.nom_abrev_matriz.
               NEXT.
          END.

          /* --- Fornecedor Pessoa F°sica ---*/
          IF emscad.fornecedor.num_pessoa MOD 2 = 0
          THEN DO:
               CREATE tt_pessoa_jurid_matriz.
               ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid        = emscad.fornecedor.num_pessoa
                      tt_pessoa_jurid_matriz.tta_cdn_fornecedor_matriz   = emscad.fornecedor.cdn_fornec
                      tt_pessoa_jurid_matriz.nom_abrev_matriz            = emscad.fornecedor.nom_abrev.
               ASSIGN tt_permuta.cdn_matriz       = emscad.fornecedor.cdn_fornec
                      tt_permuta.nom_abrev_matriz = emscad.fornecedor.nom_abrev.
          END.
          ELSE DO:
               /* --- Fornecedor Pessoa Jur°dica ---*/
               FIND pessoa_jurid NO-LOCK 
                    WHERE pessoa_jurid.num_pessoa_jurid = emscad.fornecedor.num_pessoa NO-ERROR.
               IF AVAIL pessoa_jurid
               THEN DO:

                    IF pessoa_jurid.num_pessoa_jurid_matriz = 0
                    THEN DO:
                         CREATE tt_pessoa_jurid_matriz.
                         ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid        = emscad.fornecedor.num_pessoa
                                tt_pessoa_jurid_matriz.tta_cdn_fornecedor_matriz   = emscad.fornecedor.cdn_fornec
                                tt_pessoa_jurid_matriz.nom_abrev_matriz            = emscad.fornecedor.nom_abrev.
                         ASSIGN tt_permuta.cdn_matriz       = emscad.fornecedor.cdn_fornec
                                tt_permuta.nom_abrev_matriz = emscad.fornecedor.nom_abrev.
                         NEXT.
                    END.

                    FIND FIRST b_fornecedor NO-LOCK
                         WHERE b_fornecedor.num_pessoa = pessoa_jurid.num_pessoa_jurid_matriz NO-ERROR.
                    IF NOT AVAIL b_fornecedor 
                    THEN DO:
                         /* ** Caso n∆o haja fornecedor para a matriz, considera o pr¢prio fornecedor ***/
                         ASSIGN tt_permuta.cdn_matriz       = emscad.fornecedor.cdn_fornec
                                tt_permuta.nom_abrev_matriz = emscad.fornecedor.nom_abrev.
                    END.
                    ELSE DO:
                         ASSIGN tt_permuta.cdn_matriz       = b_fornecedor.cdn_fornec
                                tt_permuta.nom_abrev_matriz = b_fornecedor.nom_abrev.
                    END.

                    FOR EACH b_pessoa_jurid NO-LOCK 
                        WHERE b_pessoa_jurid.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz USE-INDEX pssjrda_matriz:
                        FIND FIRST tt_pessoa_jurid_matriz NO-LOCK 
                             WHERE tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = b_pessoa_jurid.num_pessoa_jurid NO-ERROR.
                        IF NOT AVAIL tt_pessoa_jurid_matriz
                        THEN DO:
                             CREATE tt_pessoa_jurid_matriz.
                             ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid      = b_pessoa_jurid.num_pessoa_jurid
                                    tt_pessoa_jurid_matriz.tta_cdn_fornecedor_matriz = tt_permuta.cdn_matriz      
                                    tt_pessoa_jurid_matriz.nom_abrev_matriz          = tt_permuta.nom_abrev_matriz.
                        END.
                    END.

               END.
          END.
      END.

      blk_estab:
      FOR EACH estabelecimento
          WHERE estabelecimento.cod_empresa = v_cod_empres_usuar NO-LOCK:
          IF estabelecimento.cod_estab = '201' 
             THEN NEXT.
          /* ** Se alterar esta regra se seleá∆o do tit_acr, alterar tambem o programa apb711zd_epc ***/
          FOR EACH tt_pessoa_jurid_matriz,
              EACH tit_acr NO-LOCK
              WHERE tit_acr.cod_estab            = estabelecimento.cod_estab
                AND tit_acr.ind_tip_espec_docto  = "Normal"
                AND tit_acr.num_pessoa           = tt_pessoa_jurid_matriz.tta_num_pessoa_jurid
                AND tit_acr.log_sdo_tit_acr      = YES
                AND tit_acr.log_tit_acr_estordo  = NO
                AND tit_acr.dat_vencto_tit_acr   < (TODAY - 1)
                AND tit_acr.cod_portador        <> '9905'
                AND tit_acr.cod_portador        <> '9907'
                AND tit_acr.cod_portador        <> '9908'
                AND tit_acr.cod_portador        <> '9943'
                AND tit_acr.cod_portador        <> '9954'
                AND tit_acr.cod_portador        <> '9996'
                USE-INDEX titacr_espec_pessoa_emis:

              FIND emscad.cliente NO-LOCK
                  WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                    AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
              IF NOT AVAIL tit_acr 
                 THEN NEXT.

              IF  tit_acr.dat_vencto_tit_acr = (TODAY - 2) THEN DO:
                  IF  WEEKDAY(tit_acr.dat_vencto_tit_acr) = 7 THEN
                      NEXT.
              END.

              /* ** Cria os t°tulos do ACR, alimentando a Matriz ***/
              CREATE tt_permuta.
              ASSIGN tt_permuta.cod_estab_acr       = tit_acr.cod_estab
                     tt_permuta.cdn_cliente_acr     = tit_acr.cdn_cliente
                     tt_permuta.nom_abrev_acr       = emscad.cliente.nom_abrev
                     tt_permuta.cod_espec_docto_acr = tit_acr.cod_espec_docto
                     tt_permuta.cod_ser_docto_acr   = tit_acr.cod_ser_docto  
                     tt_permuta.cod_tit_acr         = tit_acr.cod_tit_acr
                     tt_permuta.cod_parcela_acr     = tit_acr.cod_parcela    
                     tt_permuta.dat_vencto_acr      = tit_acr.dat_vencto_tit_acr
                     tt_permuta.val_sdo_acr         = tit_acr.val_sdo_tit_acr
                     tt_permuta.cdn_tip             = 2
                     tt_permuta.cdn_matriz          = tt_pessoa_jurid_matriz.tta_cdn_fornecedor_matriz
                     tt_permuta.nom_abrev_matriz    = tt_pessoa_jurid_matriz.nom_abrev_matriz
                     tt_permuta.ind_impto_apb       = "&nbsp;".

          END.
      END.
   
      /*se algum campo FOR igual a "" ent∆o "&nbsp;"*/

END PROCEDURE.


PROCEDURE pi-abre-tabela :

   def input parameter c-destino         as char    no-undo.
   
   IF c-destino = "fornecedor" 
   THEN DO:
        ASSIGN c-titulo = "T°tulos em aberto no Contas a Pagar para a Matriz: (" + STRING(tt_permuta.cdn_matriz) + ") - " + tt_permuta.nom_abrev_matriz + "<BR>". 
   END.
   ELSE DO: /*Cliente*/
        ASSIGN c-titulo = "T°tulos em aberto no Contas a Receber para a Matriz: (" + STRING(tt_permuta.cdn_matriz) + ") - " + tt_permuta.nom_abrev_matriz + "<BR>". 
   END. 

   PUT STREAM s_permuta UNFORMATTED "<H4>" c-titulo  "</H4>" SKIP.
   PUT STREAM s_permuta UNFORMATTED "<TABLE BORDER ALIGN = CENTER BGCOLOR = #FFFFFF WIDTH= " c_tam_tab " >" SKIP.
   PUT STREAM s_permuta UNFORMATTED "<TR>" SKIP.
        
   RUN pi-html-cab-tab("Estab", c-destino).
   RUN pi-html-cab-tab("Codigo", c-destino).
   RUN pi-html-cab-tab("Nome Abrev", c-destino).
   RUN pi-html-cab-tab("Esp", c-destino).
   RUN pi-html-cab-tab("Ser", c-destino).
   RUN pi-html-cab-tab("Titulo", c-destino).
   RUN pi-html-cab-tab("Par", c-destino).
   RUN pi-html-cab-tab("Dt Vecto", c-destino).
   RUN pi-html-cab-tab("Impto", c-destino).
   RUN pi-html-cab-tab("Vl Saldo", c-destino).
   RUN pi-html-cab-tab("Vl Juros", c-destino).
   RUN pi-html-cab-tab("Vl Permuta", c-destino).
   RUN pi-html-cab-tab("Obs", c-destino).

   PUT STREAM s_permuta UNFORMATTED "</TR>" SKIP.

END PROCEDURE.

PROCEDURE pi-fecha-arquivo:

   def input parameter c-mail as char no-undo.

   def var c-texto-html as char format "x(76)" extent 40.

   PUT STREAM s_permuta UNFORMATTED SKIP 
       "</FONT>" SKIP 
       "</BODY>" SKIP  
       "</HTML>".
   OUTPUT STREAM s_permuta CLOSE.
   
        
   IF c-mail <> "" THEN DO:
       assign c-texto-html[1]  = "Segue arquivo contendo Permutas. "
              c-titulo         = "Relatorio de Permutas - Matriz: (" + STRING(tt_permuta.cdn_matriz) + ") - " + tt_permuta.nom_abrev_matriz.

       IF R-INDEX(c-arquivo, ".htm") = 0
       AND R-INDEX(c-arquivo, ".html") = 0 THEN DO:
           OS-COPY VALUE(c-arquivo) VALUE(c-arquivo + ".html").
           c-arquivo = c-arquivo + ".html".
       END.
    
        RUN enviaMail (INPUT c_remetente,
                       INPUT c-mail,
                       INPUT trim(c-titulo),
                       INPUT c-texto-html[1] + "~n" + c-texto-html[2],
                       INPUT c-arquivo).
   END.
END PROCEDURE.

PROCEDURE pi-htm-conspan-tab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter c-con as char.
   def input parameter c-alin as char    no-undo.
   def input parameter i-span as integer no-undo.
   def input parameter c-destino as char no-undo.
            
   def var c-linha as char no-undo.
               
   assign c-linha = "<TD ALIGN="  
                  + chr(34) 
                  + trim(c-alin)  
                  + chr(34)
                  + " ROWSPAN=" 
                  + trim(string(i-span,">>>9")) + ">"  
                  + trim(c-con)   + "</TD>".
                                    
   put stream s_permuta unformatted c-linha  skip.

END PROCEDURE.

PROCEDURE pi-html-cab-tab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter c-cab as char.
    def input param c-destino as char no-undo.
    
    put stream s_permuta unformatted "<TH>" c-cab "</TH>" skip. 

END PROCEDURE.

PROCEDURE pi-html-con-tab :

    def input parameter c-con as char.
    def input parameter c-alin as char.
    
    put stream s_permuta unformatted "<TD ALIGN=" '"' + c-alin + '"' ">" c-con  "</TD>"  skip. 

END PROCEDURE.

PROCEDURE pi-html-inicio :
    
     def input parameter c-titulo as char.
    
     put stream s_permuta unformatted "<HTML>" skip
         "<HEAD>" skip
         "<SCRIPT>" skip
         "function popWindow(mypage,myname,w,h,scroll,resize,status)" 
         chr(123) skip
         "var win2= null;" skip
         "var winl = (screen.width-w)/2;" skip
         "var wint = (screen.height-h)/2;" skip
         "var settings  =" chr(39) 
         "height=" chr(39) "+h+" chr(39) "," chr(39) ";" skip
         "settings +=" chr(39) "width=" chr(39) "+w+" chr(39) "," chr(39) ";" skip
         "settings +=" chr(39) "top=" chr(39) "+wint+" chr(39) "," chr(39) ";"
         skip
         "settings +=" chr(39) "left=" chr(39) "+winl+" chr(39) "," chr(39) ";"
         skip
         "settings +=" chr(39) "scrollbars=" chr(39) "+scroll+" chr(39) "," 
         chr(39) ";" skip
         "settings +=" chr(39) "resizable=" chr(39) "+resize+" chr(39) "," 
         chr(39)  ";" skip
         "settings +=" chr(39) "status=" chr(39) "+status;" skip
         "//mypage+=" chr(39) "?id=" chr(39) "+id+" chr(39) "&" chr(39) "+" 
         chr(39) "txt=" chr(39) "+txtPath+" chr(39) "&" chr(39) "+" chr(39) 
         "img=" chr(39) "+img~Path;" skip
         "win2=window.open(mypage,myname,settings);" skip
         "if(parseInt(navigator.appVersion) >= 4)" skip
         "  win2.window.focus();"       skip
         chr(125) skip
                                      
         "</SCRIPT>" skip
      
         "<TITLE>" c-titulo "</TITLE>" skip
         "<style type=" '"text/css"' ">" skip
         "th " chr(123) "font-family = Arial; font-size = 10; font_style = bold" 
         chr(125)  skip
         "td " chr(123) "font-family = Arial; font-size = 10" chr(125) skip
         "</style> "
         "</HEAD>" skip
         "<BODY BGCOLOR=#FFFFFF>" skip
         "<FONT SIZE =" '"1"' " FACE=" '"' "Arial" '"' ">" skip .

END PROCEDURE.

PROCEDURE pi-imprime :
  
   DEFINE INPUT PARAM pTip AS INT NO-UNDO.

   PUT STREAM s_permuta UNFORMATTED "<TR>" SKIP.

   IF pTip = 1 
   THEN DO:
        RUN pi-html-con-tab(tt_permuta.cod_estab_apb, "center").
        RUN pi-html-con-tab(tt_permuta.cdn_fornecedor_apb, "rigth").
        RUN pi-html-con-tab(tt_permuta.nom_abrev_apb, "center").
        RUN pi-html-con-tab(tt_permuta.cod_espec_docto_apb, "center").
        RUN pi-html-con-tab(tt_permuta.cod_ser_docto_apb, "center").
        RUN pi-html-con-tab(tt_permuta.cod_tit_apb, "center").
        RUN pi-html-con-tab(tt_permuta.cod_parcela_apb, "center").
        RUN pi-html-con-tab(STRING(tt_permuta.dat_vencto_apb,"99/99/9999"), "center").
        RUN pi-html-con-tab(tt_permuta.ind_impto_apb, "center").
        RUN pi-html-con-tab(STRING(tt_permuta.val_sdo_apb,"->>>,>>>,>>9.99"), "right").
   END.
   ELSE DO:
        RUN pi-html-con-tab(tt_permuta.cod_estab_acr, "center").
        RUN pi-html-con-tab(tt_permuta.cdn_cliente_acr, "rigth").
        RUN pi-html-con-tab(tt_permuta.nom_abrev_acr, "center").
        RUN pi-html-con-tab(tt_permuta.cod_espec_docto_acr, "center").
        RUN pi-html-con-tab(tt_permuta.cod_ser_docto_acr, "center").
        RUN pi-html-con-tab(tt_permuta.cod_tit_acr, "center").
        RUN pi-html-con-tab(tt_permuta.cod_parcela_acr, "center").
        RUN pi-html-con-tab(STRING(tt_permuta.dat_vencto_acr,"99/99/9999"), "center").
        RUN pi-html-con-tab(tt_permuta.ind_impto_apb, "center").
        RUN pi-html-con-tab(STRING(tt_permuta.val_sdo_acr,"->>>,>>>,>>9.99"), "right").
   END.

   RUN pi-html-con-tab("&nbsp;", "right").
   RUN pi-html-con-tab("&nbsp;", "right").
   RUN pi-html-con-tab("&nbsp;", "right").

   PUT STREAM s_permuta UNFORMATTED "</TR>" SKIP.

END PROCEDURE.

PROCEDURE enviaMail :

    DEFINE INPUT  PARAM pRemetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEF VAR i AS INTEGER NO-UNDO.

    FOR EACH tt_mail_fax:
        DELETE tt_mail_fax.
    END.
    FOR EACH tt_erros_mail_fax:
        DELETE tt_erros_mail_fax.
    END.

    CREATE tt_mail_fax.
    ASSIGN tt_mail_fax.ttv_nom_from         = pRemetente
           tt_mail_fax.ttv_nom_to           = pDestino
           tt_mail_fax.ttv_nom_subject      = pAssunto
           tt_mail_fax.ttv_nom_message      = pDescEmail
           tt_mail_fax.ttv_nom_attachfile   = pArquivo   
           tt_mail_fax.ttv_num_imptcia      = 2
           tt_mail_fax.ttv_cod_format_mail  = "texto".

    run prgtec\btb\btb916za.py (input "1",
                                input  table tt_mail_fax,
                                output table tt_erros_mail_fax).

    /* Erro da API de envio de email ser∆o enviados para um arquivo no diret¢rio tempor†rio */
    IF  CAN-FIND(tt_erros_mail_fax) 
    THEN DO:
         FIND FIRST tt_erros_mail_fax NO-LOCK NO-ERROR.
         IF AVAIL tt_erros_mail_fax THEN
             MESSAGE "Erro: "       tt_erros_mail_fax.ttv_cod_erro SKIP
                     "Desc Erro: "  tt_erros_mail_fax.ttv_des_erro SKIP
                     "Desc Arq: "   tt_erros_mail_fax.ttv_des_arquivo                          
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END PROCEDURE.
