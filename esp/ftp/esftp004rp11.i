
  IF tt-param.reimpressao = YES THEN DO:
     IF volume-nf.impresso = YES THEN DO: /* JA IMPRESSO */
         IF  NOT CAN-FIND(FIRST usuar_grp_usuar
              WHERE usuar_grp_usuar.cod_grp_usuar  >= "X03"
                AND  usuar_grp_usuar.cod_grp_usuar <= "X04"
                AND usuar_grp_usuar.cod_usuar     = tt-param.usuario)  THEN NEXT.

         /* CASO EXISTA NO GRUPO X04 ESTA AUTORIZADO A REIMPRIMIR */
     END.
     ELSE NEXT. /* AINDA NAO FOI IMPRESSA */
  END.
  ELSE DO:
      IF volume-nf.impresso = YES THEN NEXT. /* JA IMPRESSO */
  END.


