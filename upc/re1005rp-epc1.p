/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/

DEFINE INPUT PARAM p-rowid AS ROWID NO-UNDO.

DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
DEFINE BUTTON    btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.
DEFINE BUTTON    btimpressora AUTO-GO LABEL "Impressora" SIZE 10 BY 1 BGCOLOR 8.

DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 8.3 BGCOLOR 8.
DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.5 BGCOLOR 7.
DEFINE VARIABLE clocalizacao1 AS CHAR FORMAT "x(30)" LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 25 BY .88 NO-UNDO.
DEFINE VARIABLE clocalizacao2 AS CHAR FORMAT "x(30)" LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 25 BY .88 NO-UNDO.
DEFINE VARIABLE clocalizacao3 AS CHAR FORMAT "x(30)" LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 25 BY .88 NO-UNDO.
DEFINE VARIABLE clocalizacao4 AS CHAR FORMAT "x(30)" LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 25 BY .88 NO-UNDO.
DEFINE VARIABLE clocalizacao5 AS CHAR FORMAT "x(30)" LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 25 BY .88 NO-UNDO.
DEFINE VARIABLE cestrado1      LIKE ae-entrada.estrado[1]  FORMAT "x(3)"   LABEL "Volumes"       VIEW-AS FILL-IN  SIZE 05 BY .88 NO-UNDO.
DEFINE VARIABLE croteiro AS LOGICAL LABEL "Imprimir Roteiro" VIEW-AS TOGGLE-BOX SIZE 15 BY .88 NO-UNDO INITIAL YES.

{esp/cqp/escqp003tt.i}
FIND FIRST docum-est
     WHERE ROWID(docum-est) = p-rowid NO-LOCK NO-ERROR.
IF NOT AVAIL docum-est THEN RETURN "OK".

    DEFINE FRAME fDadosAdicionais
           cestrado1      AT ROW 01.17 COL 18 COLON-ALIGN 
           /* cmaterial   AT ROW 02.17 COL 18 COLON-ALIGN 
              csolicitante   AT ROW 03.17 COL 18 COLON-ALIGN */
           clocalizacao1  AT ROW 02.17 COL 18 COLON-ALIGN 
           clocalizacao2  AT ROW 03.17 COL 18 COLON-ALIGN 
           clocalizacao3  AT ROW 04.17 COL 18 COLON-ALIGN 
           clocalizacao4  AT ROW 05.17 COL 18 COLON-ALIGN 
           clocalizacao5  AT ROW 06.17 COL 18 COLON-ALIGN 
           croteiro       AT ROW 08.17 COL 18 COLON-ALIGN 
           rtGoToFields   AT ROW 01    COL 1
           btGoToOK       AT ROW 09.7  COL 2.14
           btGoToCancel   AT ROW 09.7  COL 13.14
           rtGoToButton   AT ROW 09.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Roteiro de inspeá∆o" FONT 1
             DEFAULT-BUTTON btGoToOK.
 
    ON  "CHOOSE":U OF btGoToOK IN FRAME fDadosAdicionais DO:
        SESSION:SET-WAIT-STATE("general":U).
        SESSION:SET-WAIT-STATE("":U).
        ASSIGN cestrado1 
               /* cmaterial     
                  csolicitante */
               croteiro
               clocalizacao1 
               clocalizacao2 
               clocalizacao3 
               clocalizacao4 
               clocalizacao5.
        APPLY "GO":U TO FRAME fDadosAdicionais.
        
        FIND FIRST ae-entrada 
             WHERE ae-entrada.cod-estabel  = docum-est.cod-estabel 
               AND ae-entrada.nro-docto    = int(docum-est.nro-docto) 
               AND ae-entrada.cod-emitente = docum-est.cod-emitente  EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ae-entrada THEN
            ASSIGN ae-entrada.estrado[1]      = cestrado1:SCREEN-VALUE IN FRAME fDadosAdicionais
                   /* ae-entrada.material        = cmaterial    
                      ae-entrada.solicitante     = csolicitante */
                   ae-entrada.localizacao[1]  = clocalizacao1:SCREEN-VALUE IN FRAME fDadosAdicionais
                   ae-entrada.localizacao[2]  = clocalizacao2:SCREEN-VALUE IN FRAME fDadosAdicionais
                   ae-entrada.localizacao[3]  = clocalizacao3:SCREEN-VALUE IN FRAME fDadosAdicionais
                   ae-entrada.localizacao[4]  = clocalizacao4:SCREEN-VALUE IN FRAME fDadosAdicionais
                   ae-entrada.localizacao[5]  = clocalizacao5:SCREEN-VALUE IN FRAME fDadosAdicionais.

        IF croteiro = YES THEN DO: 
            DEF VAR cfile AS CHAR.
            CREATE tt-param.
            ASSIGN tt-param.usuario         = docum-est.usuario
                   tt-param.cod-estabel     = docum-est.cod-estabel
                   tt-param.destino         = 1
                   /*tt-param.arquivo         = "Win-Laser:Padr∆o_132_R" */
                   tt-param.data-exec       = TODAY
                   tt-param.hora-exec       = TIME
                   tt-param.cod-emitente    = docum-est.cod-emitente
                   tt-param.serie-docto     = docum-est.serie-docto
                   tt-param.nro-docto       = docum-est.nro-docto
                   tt-param.nat-operacao    = docum-est.nat-operacao
                   tt-param.urgencia        = NO
                   tt-param.imprime-param   = NO
                   tt-param.volume          = dec(cestrado1:SCREEN-VALUE IN FRAME fDadosAdicionais) 
                   tt-param.localizacao1    = clocalizacao1:SCREEN-VALUE IN FRAME fDadosAdicionais 
                   tt-param.localizacao2    = clocalizacao2:SCREEN-VALUE IN FRAME fDadosAdicionais 
                   tt-param.localizacao3    = clocalizacao3:SCREEN-VALUE IN FRAME fDadosAdicionais 
                   tt-param.localizacao4    = clocalizacao4:SCREEN-VALUE IN FRAME fDadosAdicionais 
                   tt-param.localizacao5    = clocalizacao5:SCREEN-VALUE IN FRAME fDadosAdicionais.                 

            IF tt-param.destino = 1 THEN 
               assign tt-param.arquivo = "REC-Laser:Padr∆o_132_R_Duplex":U.

            DEF VAR t-raw AS RAW.

            RAW-TRANSFER tt-param TO t-raw.

            /*:T Executar do programa RP.P que ir† criar o relat¢rio */
            /* {report/rpexb.i} */

            /* Substitui a include acima */
            FIND imprsor_usuar                                    WHERE
                 imprsor_usuar.nom_impressora = "REC-Laser"       AND
                 imprsor_usuar.cod_usuario    = docum-est.usuario NO-ERROR.
            IF NOT AVAIL imprsor_usuar THEN
               MESSAGE "N∆o encontrou impressora"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

            FIND layout_impres WHERE
                 layout_impres.nom_impressora = imprsor_usuar.nom_impressora AND
                 layout_impres.cod_layout     = "Padr∆o_132_R_Duplex" NO-ERROR.
            IF NOT AVAIL layout_impres THEN
               MESSAGE "N∆o encontrou layout"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.    
            /* Fim da include */

            SESSION:SET-WAIT-STATE("GENERAL":U).
                
            /* {report/rprun.i esp/cqp/escqp003rp.p} */            
            RUN esp/cqp/escqp003rp.p (INPUT t-raw,
                                      INPUT TABLE tt-raw-digita).   

            {report/rpexc.i}
            
            SESSION:SET-WAIT-STATE("":U).
            
            {report/rptrm.i}
            
        END.
    END.


    ON  "CHOOSE":U OF btGoToCancel IN FRAME fDadosAdicionais DO:
        APPLY "GO":U TO FRAME fDadosAdicionais.
    END.


    ENABLE cestrado1     
           /*cmaterial     
             csolicitante  */
           clocalizacao1 
           clocalizacao2 
           clocalizacao3 
           clocalizacao4 
           clocalizacao5 
           croteiro 
           btGoToOK 
           btGoToCancel
           WITH FRAME fDadosAdicionais.
    
    WAIT-FOR "GO":U OF FRAME fDadosAdicionais.
