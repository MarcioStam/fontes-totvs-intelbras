/********************************************************************************
 ** UPC........: wsc079.p - UPC WRITE usuario-scm
 ** Data.......: 21/03/2016
 ** Objetivo...: Gera tarefas para o usu rio que est  sendo incluido
 *******************************************************************************/
DEFINE PARAMETER BUFFER b-usuario-scm      FOR usuario-scm.
DEFINE PARAMETER BUFFER b-old-usuario-scm  FOR usuario-scm.

IF NEW b-usuario-scm THEN DO:
    FOR EACH wm-tarefa
        WHERE NOT CAN-FIND (FIRST wm-usuario-tarefa
                            WHERE wm-usuario-tarefa.cod-usuario = b-usuario-scm.usuario
                            AND   wm-usuario-tarefa.cod-tarefa  = wm-tarefa.cod-tarefa) NO-LOCK:

        CREATE wm-usuario-tarefa.
        ASSIGN wm-usuario-tarefa.cod-usuario = b-usuario-scm.usuario
               wm-usuario-tarefa.cod-tarefa  = wm-tarefa.cod-tarefa.
    END.
END.
