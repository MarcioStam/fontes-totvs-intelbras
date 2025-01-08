/***********************************************************************
**  Programa..: UPC\DP0301-UPC.P
**  Autor.....: Clayton Antunes
**  Data......: DEZEMBRO/2006 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 13/12/2006
**                  Desenvolvimento Programa
**              002 20/09/2021 - Nicolas Martinez
**                  Importador de Estrutura DP
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
{utp\ut-glob.i}


DEF NEW GLOBAL SHARED VAR gr-proces-item     AS ROWID         NO-UNDO.

DEF VAR c-objeto  AS CHAR            NO-UNDO.

DEF VAR h-object  AS HANDLE          NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").    

/*
MESSAGE 'p-ind-event  ' p-ind-event  SKIP
        'p-ind-object ' p-ind-object SKIP
        'p-cod-table  ' p-cod-table  SKIP
        'p-row-table  ' string(p-row-table) SKIP
        'c-objeto     ' c-objeto
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */


if  p-ind-event  = "enable"
and p-ind-object = "container"
and c-objeto     = "dp0301.w"
then do:
    def var bt-narrativa   as widget-handle    no-undo.
    DEF VAR bt-cria-estr   AS widget-handle    no-undo.

    create button bt-narrativa
    assign frame     = p-wgh-frame
           width     = 4.00
           height    = 1.25
           row       = 1.13
           col       = 64.00
           font      = 4
           tooltip   = "Narrativa"
           visible   = YES
           sensitive = yes
           triggers:
                on CHOOSE persistent run upc/dp0301-upcv.w.
           end.

    if bt-narrativa:load-image-up ("image~\im-cldwn") then.
    bt-narrativa:move-to-top(). 

    create button bt-cria-estr
    assign frame     = p-wgh-frame
           width     = 4.00
           height    = 1.25
           row       = 1.13
           col       = 68.00
           font      = 4
           tooltip   = "Importa estrutura"
           visible   = YES
           sensitive = yes
           triggers:
                on CHOOSE persistent run upc/dp0301-upcw.w.
           end.

    if bt-cria-estr:load-image-up ("image~\im-negoc") then.
    bt-cria-estr:move-to-top().  

end.

IF  p-ind-event  = "DISPLAY"
AND c-objeto     = "v01mf613.w" THEN 
    ASSIGN gr-proces-item = p-row-table.



    

    


    
