/*****************************************************************************
** Programa..............: esp/es5800a.w
** Autor.................: Andrey M Oliveira
** Criado em.............: 25/01/24
** Objetivo..............: Detalhamento projetos Suframa.
*****************************************************************************/

DEFINE TEMP-TABLE tt-item-proj-suframa NO-UNDO LIKE item-proj-suframa.

/*
DEF TEMP-TABLE tt_item NO-UNDO LIKE item
    FIELD situacao     AS CHAR FORMAT "x(20)"
    FIELD nve          AS CHAR FORMAT "x(200)"
    FIELD ex-tarifario LIKE int-item.ex-tarifario
    FIELD part-number  LIKE item-fabric.it-fabric
    FIELD fabricante   LIKE fabricante.nome-abrev
    FIELD cod-ean13    LIKE item-mat.cod-ean
    FIELD destaque     LIKE int-item.destaque
    FIELD ex-ipi       LIKE int-item.exipi
    FIELD antidumping  LIKE int-item.log-antidumping
    FIELD log-gatt     LIKE int-item.log-gatt
    FIELD perc-gatt    LIKE int-item.perc-gatt
    FIELD seq-suframa  LIKE int-item.seq-suframa
    FIELD aliq-ii      AS DEC.
*/

DEF TEMP-TABLE tt_item NO-UNDO /*LIKE item*/
    FIELD it-codigo        LIKE item.it-codigo                                          
    FIELD desc-item        LIKE item.desc-item                                          
    FIELD desc-inter       LIKE item.desc-inter                                         
    FIELD fm-codigo        LIKE item.fm-codigo                                          
    FIELD peso-liquido     LIKE item.peso-liquido                                       
    FIELD peso-bruto       LIKE item.peso-bruto                                         
    FIELD comprim          LIKE item.comprim                                            
    FIELD largura          LIKE item.largura                                            
    FIELD altura           LIKE item.altura                                             
    FIELD cod-estabel      LIKE item.cod-estabel                                        
    FIELD cod-unid-negoc   LIKE item.cod-unid-negoc                                     
    FIELD un               LIKE item.un                                                 
    FIELD fm-cod-com       LIKE item.fm-cod-com                                         
    FIELD class-fiscal     LIKE item.class-fiscal                                       
    FIELD log-necessita-li LIKE item.log-necessita-li                                   
    FIELD narrativa        AS CHAR
    FIELD codigo-orig      LIKE item.codigo-orig                                        
    FIELD ind-item-fat     LIKE item.ind-item-fat                                       
    FIELD situacao         AS CHAR FORMAT "x(20)"
    FIELD nve              AS CHAR FORMAT "x(200)"
    FIELD ex-tarifario     LIKE int-item.ex-tarifario
    FIELD part-number      LIKE item-fabric.it-fabric
    FIELD fabricante       LIKE fabricante.nome-abrev
    FIELD cod-ean13        LIKE item-mat.cod-ean
    FIELD destaque         LIKE int-item.destaque
    FIELD ex-ipi           LIKE int-item.exipi
    FIELD antidumping      LIKE int-item.log-antidumping
    FIELD log-gatt         LIKE int-item.log-gatt
    FIELD perc-gatt        LIKE int-item.perc-gatt
    FIELD seq-suframa      LIKE int-item.seq-suframa
    FIELD aliq-ii          AS DEC
    FIELD aliquota-ipi     AS DEC
    FIELD tipo-contr       LIKE item.tipo-contr
    FIELD criticidade      LIKE item.criticidade
    FIELD char-2           LIKE item.char-2
    FIELD ge-codigo        LIKE item.ge-codigo
    FIELD nr-projeto       LIKE item-proj-suframa.nr-projeto
    FIELD controlado       LIKE item-proj-suframa.controlado.

DEF INPUT PARAM v_it_codigo LIKE tt_item.it-codigo NO-UNDO.
DEF INPUT PARAM TABLE FOR tt_item.

DEF RECT rt_001 SIZE 1 BY 1 EDGE-PIXELS 2.
DEF RECT rt_002 SIZE 1 BY 1 EDGE-PIXELS 2.

DEF BUTTON bt_ok LABEL "&OK":U TOOLTIP "OK":U SIZE 1 BY 1 AUTO-GO.

DEFINE QUERY qr_item-proj-suframa FOR tt-item-proj-suframa SCROLLING.

DEFINE BROWSE br_proj_suframa QUERY qr_item-proj-suframa 
    DISPLAY tt-item-proj-suframa.it-codigo  WIDTH-CHARS 10.00 COLUMN-LABEL "Item":U
            tt-item-proj-suframa.nr-projeto WIDTH-CHARS 10.00 COLUMN-LABEL "Nr Projeto":U
            tt-item-proj-suframa.controlado WIDTH-CHARS 5.00 COLUMN-LABEL "Controlado":U
    WITH NO-BOX SEPARATORS SINGLE SIZE 63.57 BY 06.58 FONT 1 BGCOLOR 15 FIT-LAST-COLUMN. 

DEFINE FRAME fPage0
    rt_001              AT ROW 01.20 COL 02.00
    tt_item.seq-suframa AT ROW 01.55 COL 05.00
    br_proj_suframa     AT ROW 02.90 COL 02.00
    rt_002              AT ROW 09.75 COL 02.00 BGCOLOR 7 
    bt_ok               AT ROW 09.95 COL 02.80 font ? help "OK":U
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D
         SIZE-CHAR 67.00 BY 11.83
         VIEW-AS DIALOG-BOX
         FONT 1 FGCOLOR ? BGCOLOR 8
         TITLE "Projetos Suframa".

ENABLE ALL WITH FRAME fPage0.

ASSIGN bt_ok:WIDTH-CHARS             IN FRAME fPage0 = 10.00
       bt_ok:HEIGHT-CHARS            IN FRAME fPage0 = 01.00
       rt_001:WIDTH-CHARS            IN FRAME fPage0 = 63.57
       rt_001:HEIGHT-CHARS           IN FRAME fPage0 = 01.42
       rt_002:WIDTH-CHARS            IN FRAME fPage0 = 63.57
       rt_002:HEIGHT-CHARS           IN FRAME fPage0 = 01.42
       tt_item.seq-suframa:SENSITIVE IN FRAME fPage0 = NO.

bem_nf_block:
DO  ON ENDKEY UNDO bem_nf_block, LEAVE bem_nf_block:
    VIEW FRAME fPage0.

    RUN pi_monta_temptable.

    OPEN QUERY qr_item-proj-suframa FOR EACH tt-item-proj-suframa NO-LOCK.
    
    WAIT-FOR GO OF FRAME fPage0.
END.

HIDE FRAME fPage0.

RETURN "OK".

PROCEDURE pi_monta_temptable:

    FIND FIRST tt_item 
        WHERE tt_item.it-codigo = v_it_codigo NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL tt_item THEN DO:
        MESSAGE "Item n∆o Localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "OK".
    END.
    
    ASSIGN tt_item.seq-suframa:SCREEN-VALUE  IN FRAME fPage0 = string(tt_item.seq-suframa).

    EMPTY TEMP-TABLE tt-item-proj-suframa NO-ERROR.
    
    FOR EACH item-proj-suframa
        WHERE item-proj-suframa.it-codigo = tt_item.it-codigo NO-LOCK:

        CREATE tt-item-proj-suframa.
        BUFFER-COPY item-proj-suframa to tt-item-proj-suframa no-error.
    END.

END PROCEDURE.

