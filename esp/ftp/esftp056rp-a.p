DEF INPUT  PARAM p_cod_estab  AS CHAR.
DEF INPUT  PARAM p_cdn_repres AS INT.
DEF OUTPUT PARAM p_e_mail     AS CHAR.

FIND estabelecimento NO-LOCK
    WHERE estabelecimento.cod_estab = p_cod_estab NO-ERROR.
IF NOT AVAIL estabelecimento
THEN DO:
     ASSIGN p_e_mail = "Estabelecimento Nao Localizado " + p_cod_estab.
     RETURN.
END.

FIND representante NO-LOCK
    WHERE representante.cod_empresa = estabelecimento.cod_empresa
      AND representante.cdn_repres  = p_cdn_repres NO-ERROR.
IF AVAIL representante 
THEN DO:
     IF representante.num_pessoa MODULO 2 = 0 
     THEN DO:
          FIND pessoa_fisic NO-LOCK
              WHERE pessoa_fisic.num_pessoa_fisic = representante.num_pessoa NO-ERROR.
          IF AVAIL pessoa_fisic 
             THEN ASSIGN p_e_mail = pessoa_fisic.cod_e_mail.
      END.
      ELSE DO:
           FIND pessoa_jurid NO-LOCK
               WHERE pessoa_jurid.num_pessoa_jurid = representante.num_pessoa NO-ERROR.
           IF AVAIL pessoa_jurid 
              THEN ASSIGN p_e_mail = pessoa_jurid.cod_e_mail.
      END.
END.
IF p_e_mail = "" 
   THEN ASSIGN p_e_mail = "e-mail Nao Localizado " + STRING(p_cdn_repres).
