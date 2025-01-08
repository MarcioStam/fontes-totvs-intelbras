/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i FT0518D 2.00.00.000}  /*** 010000 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ft0516d MFT}
&ENDIF


/****************************************************************************
**
**  PROGRAMA: ft0518D.P
**
**  OBJETIVO: Cria Item-Nota
**
****************************************************************************/

def input parameter r-it-nota   as rowid.
def input parameter r-cidade-zf as rowid.

def shared var i-codigo             as integer format "999".
def shared var de-conv              as decimal format ">>>>9.99".
def shared var de-conv-pis          as decimal format ">>>>9.99".
def shared var de-conv-cofins       as decimal format ">>>>9.99".
def shared var de-conv-total        as decimal format ">>>>9.99".
def shared var de-tot-icmssubs-obs  like it-nota-fisc.vl-icmsub-it.
def shared var de-tot-bicmssubs-obs like it-nota-fisc.vl-bsubs-it.
def shared var de-tot-icms-obs      like it-nota-fisc.vl-icms-it.
def shared var de-tot-ipi-dev-obs   like it-nota-fisc.vl-ipi-it.
def shared var de-tot-ipi-calc      like it-nota-fisc.vl-ipi-it.
def shared var de-tot-ipi-nota      like it-nota-fisc.vl-ipi-it.
def shared var r-item               as rowid.
def shared var r-natur-oper         as rowid.
def shared var r-nota-fiscal        as rowid.

def shared temp-table item-nota no-undo
    field registro     as rowid
    field it-codigo    like it-nota-fisc.it-codigo
    field aliquota-icm like it-nota-fisc.aliquota-icm
    field nr-seq-fat   like it-nota-fisc.nr-seq-fat
    field sit-tribut   as int format ">>>".

/* Definicao variaveis locais */
def var de-vl-bipi-it               like it-nota-fisc.vl-bipi-it.
def var de-vl-ipi-it                like it-nota-fisc.vl-ipi-it.
def var l-frete-bipi                as log.

create item-nota.

find first it-nota-fisc
     where rowid(it-nota-fisc) = r-it-nota no-lock no-error.

find first item
     where rowid(item) = r-item no-lock no-error.

assign item-nota.registro     = rowid(it-nota-fisc)
       item-nota.it-codigo    = it-nota-fisc.it-codigo
       item-nota.aliquota-icm = it-nota-fisc.aliquota-icm
       item-nota.nr-seq-fat   = it-nota-fisc.nr-seq-fat
       item-nota.sit-tribut   = int(string(item.codigo-orig) +
                                    string(i-codigo, "99")).

           /*------  ACUMULANDO VALORES PARA OBSERVACAO  ------*/

/* IPI SOBRE AS DESPESAS */

find first natur-oper
     where rowid(natur-oper) = r-natur-oper no-lock no-error.

if  r-cidade-zf <> ? then do:

    {ftp/ft0513.i1}  /* Determina valor do IPI */

    &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN

        ASSIGN de-tot-ipi-nota = de-tot-ipi-nota  + it-nota-fisc.vl-ipi-it
               de-tot-ipi-calc = de-tot-ipi-calc +
                                 if   it-nota-fisc.vl-despes-it > 0
                                 and  it-nota-fisc.vl-ipi-it    > 0
                                 then IF  natur-oper.log-deduz-desc-zfm-tot-nf THEN de-vl-ipi-it / de-conv-total
                                                                               ELSE de-vl-ipi-it / de-conv
                                 else
                                      if  it-nota-fisc.vl-despes-it > 0
                                      and it-nota-fisc.vl-ipi-it    > 0
                                      then de-vl-ipi-it
                                      else 0.
    &ELSE

        ASSIGN de-tot-ipi-nota = de-tot-ipi-nota  + it-nota-fisc.vl-ipi-it
               de-tot-ipi-calc = de-tot-ipi-calc +
                                 if   it-nota-fisc.vl-despes-it > 0
                                 and  it-nota-fisc.vl-ipi-it    > 0
                                 then IF  SUBSTRING(natur-oper.char-1,109,1) = "S" THEN de-vl-ipi-it / de-conv-total
                                                                                   ELSE de-vl-ipi-it / de-conv
                                 else
                                      if  it-nota-fisc.vl-despes-it > 0
                                      and it-nota-fisc.vl-ipi-it    > 0
                                      then de-vl-ipi-it
                                      else 0.

    &ENDIF

end.                                 

/* IPI REFERENTE A DEVOLUCAO */

find first nota-fiscal
     where rowid(nota-fiscal) = r-nota-fiscal no-lock no-error.

if  nota-fiscal.esp-docto = 20 then do:
    assign de-tot-ipi-dev-obs = de-tot-ipi-dev-obs + it-nota-fisc.vl-ipi-it.
end.

/* ICMS SUBSTITUTO */

assign de-tot-icmssubs-obs  = de-tot-icmssubs-obs  + it-nota-fisc.vl-icmsub-it
       de-tot-bicmssubs-obs = de-tot-bicmssubs-obs + it-nota-fisc.vl-bsubs-it.


/* TOTALIZACAO DO ICMS PARA O ESTADO DE SP - SUBST.TRIBUTARIA */

assign de-tot-icms-obs = de-tot-icms-obs + it-nota-fisc.vl-icms-it
       de-tot-icms-obs = de-tot-icms-obs + it-nota-fisc.vl-icmsub-it.


