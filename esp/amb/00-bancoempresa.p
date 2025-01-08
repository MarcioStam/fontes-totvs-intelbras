DEFINE INPUT PARAMETER c-ambiente AS CHARACTER NO-UNDO.

for each bco_empres exclusive-lock:

    IF c-ambiente = "HOMOLOGACAO"      THEN ASSIGN bco_empres.cod_param_conex = REPLACE(bco_empres.cod_param_conex, '-S 20', '-S 30')
                                                   bco_empres.cod_livre_1     = '/opt/oedb/homologacao'.

    IF c-ambiente = "DESENVOLVIMENTO" THEN ASSIGN bco_empres.cod_param_conex = REPLACE(bco_empres.cod_param_conex, '-S 20', '-S 35')    
                                                  bco_empres.cod_livre_1     = '/opt/oedb/desenvolvimento'.                             
    
END.

RETURN 'ok'.
