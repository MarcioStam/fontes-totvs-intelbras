/***********************************************************************
**  Programa..: UPC\CC0105-UPC.P
**  Autor.....: Clayton antunes
**  Data......: Agosto/2006 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 14/08/2006
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-objeto-aux AS WIDGET-HANDLE NO-UNDO.
DEF VAR colhdl AS HANDLE NO-UNDO.

DEF VAR hquery AS HANDLE NO-UNDO.
DEF VAR hbuffer AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-browser AS HANDLE NO-UNDO.
DEF VAR adcol AS LOG.


DEF VAR hativo AS HANDLE NO-UNDO.
DEF VAR hcot-aut AS HANDLE NO-UNDO.




/* MESSAGE "event" p-ind-event SKIP
        "obj type" p-ind-object SKIP
        "obj" c-objeto SKIP
        "table" p-cod-table skip
        "row-table" STRING(p-row-table) VIEW-AS ALERT-BOX. 

*/

If  p-ind-event = "Before-display" THEN DO:
    ASSIGN h-browser = p-wgh-frame:FIRST-CHILD.
    do  while valid-handle(h-browser):
         IF  h-browser:TYPE <> "field-group" and
             h-browser:TYPE <> "frame" THEN DO:
                h-browser = h-browser:NEXT-SIBLING.
         END.
         ELSE DO:
             IF h-browser:TYPE = "FRAME" THEN DO:
                 ASSIGN h-objeto-aux = h-browser:FIRST-CHILD.
                 do  while valid-handle(h-objeto-aux):
                      IF  h-objeto-aux:TYPE <> "field-group" and
                          h-objeto-aux:TYPE <> "frame" THEN DO:

                          IF  h-objeto-aux:NAME = "BRSON1" THEN DO:
                              ASSIGN h-browser = h-objeto-aux:HANDLE.
                             ASSIGN
                             hquery = h-browser:QUERY
                             hbuffer = hquery:GET-BUFFER-HANDLE(1).
                           
                             
                             adcol = h-browser:ADD-COLUMNS-FROM ("tt-item-fornec", 
                                                                  

                                                                  
"aval-insp[1],aval-insp[2],aval-insp[3],aval-insp[4],
 aval-insp[5],aval-insp[6],aval-insp[7],aval-insp[8],
 aval-insp[9],aval-insp[10],aval-insp[11],aval-insp[12],aval-insp[13],aval-insp[14],aval-insp[15],aval-insp[16],                                                                  
 aval-insp[17],aval-insp[18],aval-insp[19],aval-insp[20],aval-insp[21],aval-insp[22],aval-insp[23],aval-insp[24],                                                                                                                                    
                                                                  
                                                                  ,cd-referencia,char-1,char-2,check-sum,
classe-repro,cod-cond-pag,cod-emitente,cod-mensagem,
conceito,concentracao,contr-forn,criticidade,data-1,
data-2,dec-1,dec-2,fator-conver,hora-fim,hora-ini,
horiz-fixo,ind-pont,int-1,int-2,it-codigo,item-do-forn,
log-1,log-2,lote-minimo,lote-mul-for,narrativa,niv-inspecao,
niv-qua-ac,num-casa-dec,numero-nota,observacao,ped-fornec,
perc-compra,perc-dev-forn,perc-pont-forn,qt-max-ordem,
reaj-tabela,rendimento,serie-nota,tempo-ressup,tp-inspecao,
ult-ficha[1],ult-ficha[2],ult-ficha[3],ult-ficha[4],ult-ficha[5],ult-ficha[6],ult-ficha[7],ult-ficha[8],
ult-ficha[9],ult-ficha[10],ult-ficha[11],ult-ficha[12],ult-ficha[13],ult-ficha[14],ult-ficha[15],ult-ficha[16],
ult-ficha[17],ult-ficha[18],ult-ficha[19],ult-ficha[20],ult-ficha[21],ult-ficha[22],ult-ficha[23],ult-ficha[24],r-rowid,
                                                                  
                                                                  ,unid-med-for,usa-contrato") .
                             

                                
                            ASSIGN hativo = h-browser:GET-BROWSE-COLUMN(18)
                                   hcot-aut = h-browser:GET-BROWSE-COLUMN(17).

                            ON ROW-DISPLAY OF h-browser PERSISTENT RUN upc\cc0105-upca.p (INPUT hativo, INPUT hcot-aut).
                                
                            LEAVE.
                          END.
                              h-objeto-aux = h-objeto-aux:NEXT-SIBLING.
                      END.
                      ELSE DO:
                            h-objeto-aux = h-objeto-aux:FIRST-CHILD.
                      END.
                 END.
                 h-browser = h-browser:NEXT-SIBLING.
             END.
             ELSE 
                 h-browser = h-browser:FIRST-CHILD.
         END.
    END.


END.

IF   p-ind-event = "after-open-query" THEN DO:
     IF  VALID-HANDLE(h-browser) THEN DO:
     END.
END.

RETURN "ok":U.

