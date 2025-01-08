/*****************************************************************************
**     Programa.........: esp/acr/esacr003b.p
**     Descricao .......: Retorna e-mail do cliente
**     Versao...........: 1.00.000
**     Autor............: Medeiros - Gestech
**     Criado...........: 25/05/2005
**     Desc. Atualizaá∆o: Inclus∆o de possibilidades de e-mail nos contatos 
**                        do ems5, nos contatos do ems2 e no emitente
**     Autor............: Anderson Silvano - 03/06/05
*******************************************************************************/
DEF INPUT PARAM p_num_pessoa LIKE emscad.cliente.num_pessoa.
DEF OUTPUT PARAM p_e_mail AS CHAR.

IF  p_num_pessoa MODULO 2 = 0 THEN DO:
    FIND pessoa_fisic NO-LOCK
        WHERE pessoa_fisic.num_pessoa_fisic = p_num_pessoa NO-ERROR.
    IF AVAIL pessoa_fisic THEN
        ASSIGN p_e_mail = pessoa_fisic.cod_e_mail.

    IF p_e_mail = "" THEN 
        FOR FIRST emitente NO-LOCK
            WHERE emitente.cgc     = pessoa_fisic.cod_id_feder
            AND   emitente.e-mail <> "":
            ASSIGN p_e_mail = emitente.e-mail.
        END.
END.
ELSE DO:
    FOR FIRST pessoa_jurid NO-LOCK
        WHERE pessoa_jurid.num_pessoa_jurid = p_num_pessoa
        AND   pessoa_jurid.cod_e_mail_cobr <> "":
        ASSIGN p_e_mail = pessoa_jurid.cod_e_mail_cobr.
    END.
    
    IF p_e_mail = "" THEN
        FOR FIRST pessoa_jurid NO-LOCK
            WHERE pessoa_jurid.num_pessoa_jurid = p_num_pessoa
            AND   pessoa_jurid.cod_e_mail      <> "":
            ASSIGN p_e_mail = pessoa_jurid.cod_e_mail.
        END.
    IF p_e_mail = "" THEN
        FOR FIRST contato NO-LOCK
            WHERE contato.num_pessoa_jurid   = p_num_pessoa
            AND   contato.cod_e_mail_contat <> "":
            ASSIGN p_e_mail = contato.cod_e_mail_contat.
        END.
    IF p_e_mail = "" THEN 
        FOR FIRST emitente NO-LOCK
            WHERE emitente.cgc = pessoa_jurid.cod_id_feder,
            FIRST cont-emit NO-LOCK
            WHERE cont-emit.cod-emitente = emitente.cod-emitente
            AND   cont-emit.e-mail      <> "":
            ASSIGN p_e_mail = cont-emit.e-mail.
        END.
    IF p_e_mail = "" THEN 
        FOR FIRST emitente NO-LOCK
            WHERE emitente.cgc     = pessoa_jurid.cod_id_feder
            AND   emitente.e-mail <> "":
            ASSIGN p_e_mail = emitente.e-mail.
        END.
END.
