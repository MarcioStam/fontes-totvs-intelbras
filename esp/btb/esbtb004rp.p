/*----------------------------------------------------------------------
**  Programa..: esp/btb/esbtb004rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Dezembro/2013 - Desenvolvimento
**  Descricao.: Integraá∆o AD
-----------------------------------------------------------------------*/

create widget-pool.

{include/i-prgvrs.i esbtb004 2.04.00.005}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find first param-global no-lock.
find first mgcad.empresa no-lock
   where empresa.ep-codigo = param-global.empresa-pri.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Integraá∆o AD"
       c-empresa      = if available empresa then empresa.razao-social else ''
       c-programa     = "ESBTB004"
       c-versao       = "2.04"
       c-revisao      = "005".

define variable h-acomp as handle no-undo.
define buffer busuar_grp_usuar for usuar_grp_usuar.
define buffer bimprsor_usuar for imprsor_usuar.

DEFINE VAR c-patrimonio AS CHAR NO-UNDO.

{esp/btb/esbtb004tt.i}
{utp/utapi019.i}
{include/i-freeac.i}
{esp/es0018.i}

/*---------------------------  ParÉmetros   ---------------------------*/
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
/* ***************************  Main Block  *************************** */
do on stop undo, leave:
   {include/i-rpcab.i}
   {include/i-rpout.i}
   view frame f-cabec.
   view frame f-rodape.
   run utp/ut-acomp.p persistent set h-acomp.
   run pi-inicializar in h-acomp (input "Integrando...").
   run piIntegra.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   return "OK".
end.

procedure piIntegra:
   define variable i-usuar_mestre as integer    no-undo.
   define variable c-changes      as character  no-undo.
   /** Desativa usu†rios **/
   run adQuery (no).

   for each tt-ad no-lock,
      first usuar_mestre exclusive-lock
         where usuar_mestre.cod_usuario    = tt-ad.sAMAccountName
           and usuar_mestre.dat_fim_valid >= today:
      run pi-acompanhar in h-acomp (input substitute("Desativando: &1", tt-ad.sAMAccountName)).
      assign usuar_mestre.dat_fim_valid = today - 1.
      put unformatted 'Desativado: ' tt-ad.sAMAccountName ' - ' tt-ad.displayName skip.

      run piInformaSupervisor.
   end.

   for each tt-ad no-lock,
      first usuar_mestre exclusive-lock
         where usuar_mestre.cod_usuario    = tt-ad.sAMAccountName
           and usuar_mestre.dat_fim_valid <= today - 7
           and can-find (first usuar_grp_usuar no-lock
                         where usuar_grp_usuar.cod_usuario = usuar_mestre.cod_usuario):
      run pi-acompanhar in h-acomp (input substitute("Limpando grupos: &1", tt-ad.sAMAccountName)).
      for each usuar_grp_usuar exclusive-lock
         where usuar_grp_usuar.cod_usuario = usuar_mestre.cod_usuario:
         delete usuar_grp_usuar.
      end.
      put unformatted 'Removidos os grupos: ' tt-ad.sAMAccountName ' - ' tt-ad.displayName skip.
   end.

   empty temp-table tt-ad.

   /** Cria usu†rios e atualiza informaá‰es **/
   run adQuery (yes).

   find last usuar_mestre no-lock use-index usrmstr_fwrk_id no-error.
   if available usuar_mestre then do:
      assign i-usuar_mestre = usuar_mestre.idi_dtsul.
      release usuar_mestre.
   end.
   
   for each tt-ad no-lock:
      assign c-changes = ''.

      find usuar_mestre no-lock
         where usuar_mestre.cod_usuario = tt-ad.sAMAccountName no-error.
      if available usuar_mestre then do:

         FIND FIRST estabelec NO-LOCK
              WHERE estabelec.cod-estabel = tt-ad.cod-estabel NO-ERROR.

         run pi-acompanhar in h-acomp (input substitute("Atualizando: &1", tt-ad.sAMAccountName)).

         if (usuar_mestre.nom_usuario <> tt-ad.displayName or usuar_mestre.cod_e_mail_local <> tt-ad.mail or usuar_mestre.dat_fim_valid <> 12/31/9999) then
            find current usuar_mestre exclusive-lock.

         if usuar_mestre.nom_usuario <> tt-ad.displayName then
            assign c-changes                = c-changes + substitute('~r~n~tnom_usuario: &1 (&2)', tt-ad.displayName, usuar_mestre.nom_usuario)
                   usuar_mestre.nom_usuario = tt-ad.displayName.

         if usuar_mestre.cod_e_mail_local <> tt-ad.mail then
            assign c-changes                     = c-changes + substitute('~r~n~tcod_e_mail_local: &1 (&2)', tt-ad.mail, usuar_mestre.cod_e_mail_local)
                   usuar_mestre.cod_e_mail_local = tt-ad.mail.

         if usuar_mestre.dat_fim_valid <> 12/31/9999 then
            assign c-changes                  = c-changes + substitute('~r~n~tdat_fim_valid: &1 (&2)', 12/31/9999, usuar_mestre.dat_fim_valid)
                   usuar_mestre.dat_fim_valid = 12/31/9999.

         if not can-find (first usuar_mestre_ext
                          where usuar_mestre_ext.cod_usuario  = usuar_mestre.cod_usuario
                            and usuar_mestre_ext.cod_domin_so = 'intelbras') then do:
            create usuar_mestre_ext.
            assign usuar_mestre_ext.cod_usuario  = usuar_mestre.cod_usuario
                   usuar_mestre_ext.cod_domin_so = 'intelbras'
                   usuar_mestre_ext.cod_usuar_so = tt-ad.sAMAccountName.
         end.

         find usuar_univ no-lock
            where usuar_univ.cod_usuario = usuar_mestre.cod_usuario
              and usuar_univ.cod_empresa = IF AVAIL estabelec THEN string(estabelec.ep-codigo) ELSE '1' no-error.

         if not available usuar_univ then do:
            create usuar_univ.
            assign usuar_univ.cod_usuario = usuar_mestre.cod_usuario
                   usuar_univ.cod_empresa = IF AVAIL estabelec THEN string(estabelec.ep-codigo) ELSE '1'.
         end.

         if (usuar_univ.cod_estab <> tt-ad.cod-estabel or usuar_univ.cod_unid_negoc <> tt-ad.cod_unid_negoc or
             usuar_univ.cod_plano_ccusto <> 'PADRAO' or usuar_univ.cod_ccusto <> tt-ad.cod_ccusto) then
            find current usuar_univ exclusive-lock.

         if usuar_univ.cod_estab <> tt-ad.cod-estabel THEN
            assign c-changes            = c-changes + substitute('~r~n~tcod_estab: &1 (&2)', tt-ad.cod-estabel, usuar_univ.cod_estab)
                   usuar_univ.cod_estab = tt-ad.cod-estabel.

         if usuar_univ.cod_unid_negoc <> tt-ad.cod_unid_negoc then
            assign c-changes                 = c-changes + substitute('~r~n~tcod_unid_negoc: &1 (&2)', tt-ad.cod_unid_negoc, usuar_univ.cod_unid_negoc)
                   usuar_univ.cod_unid_negoc = tt-ad.cod_unid_negoc.

         if usuar_univ.cod_plano_ccusto <> 'PADRAO' then
            assign c-changes                   = c-changes + substitute('~r~n~tcod_plano_ccusto: &1 (&2)', 'PADRAO', usuar_univ.cod_plano_ccusto)
                   usuar_univ.cod_plano_ccusto = 'PADRAO'.

         if usuar_univ.cod_ccusto <> tt-ad.cod_ccusto then
            assign c-changes             = c-changes + substitute('~r~n~tcod_ccusto: &1 (&2)', tt-ad.cod_ccusto, usuar_univ.cod_ccusto)
                   usuar_univ.cod_ccusto = tt-ad.cod_ccusto.

         find int_usuar_mestre no-lock
            where int_usuar_mestre.cod_usuario = usuar_mestre.cod_usuario no-error.

         if not available int_usuar_mestre then do:
            create int_usuar_mestre.
            assign int_usuar_mestre.cod_usuario = tt-ad.sAMAccountName.
         end.

         if (int_usuar_mestre.cpf <> tt-ad.employeeNumber or int_usuar_mestre.ramal <> tt-ad.telephoneNumber) then
            find current int_usuar_mestre exclusive-lock.

         if int_usuar_mestre.cpf <> tt-ad.employeeNumber then
            assign c-changes            = c-changes + substitute('~r~n~temployeeNumber: &1 (&2)', tt-ad.employeeNumber, int_usuar_mestre.cpf)
                   int_usuar_mestre.cpf = tt-ad.employeeNumber.

         if int_usuar_mestre.ramal <> tt-ad.telephoneNumber then
            assign c-changes              = c-changes + substitute('~r~n~ttelephoneNumber: &1 (&2)', tt-ad.telephoneNumber, int_usuar_mestre.ramal)
                   int_usuar_mestre.ramal = tt-ad.telephoneNumber.

         find usuar-mater no-lock
            where usuar-mater.cod-usuario = tt-ad.sAMAccountName no-error.

         if not available usuar-mater then do:
            /** Chamado 12011 **/
            create usuar-mater.
            assign usuar-mater.cod-usuario            = tt-ad.sAMAccountName
                   usuar-mater.usuar-solic            = yes
                   usuar-mater.usuar-requis           = yes
                   usuar-mater.log-1                  = yes
                   usuar-mater.log-2                  = yes
                   overlay(usuar-mater.char-1, 1, 1)  = 'N'
                   overlay(usuar-mater.char-1, 10, 1) = 'N'
                   overlay(usuar-mater.char-1, 15, 1) = 'N'.
         end.

         if usuar-mater.sc-codigo <> tt-ad.cod_ccusto or usuar-mater.cod-lotacao <> tt-ad.cod_ccusto then
            find current usuar-mater exclusive-lock.

         if usuar-mater.sc-codigo <> tt-ad.cod_ccusto then
            assign c-changes             = c-changes + substitute('~r~n~tsc-codigo: &1 (&2)', tt-ad.cod_ccusto, usuar-mater.sc-codigo)
                   usuar-mater.sc-codigo = tt-ad.cod_ccusto.

         if usuar-mater.cod-lotacao <> tt-ad.cod_ccusto then
            assign c-changes               = c-changes + substitute('~r~n~tcod-lotacao: &1 (&2)', tt-ad.cod_ccusto, usuar-mater.cod-lotacao)
                   usuar-mater.cod-lotacao = tt-ad.cod_ccusto.

         /** Chamado 65080 **/
         find requisitante no-lock
            where requisitante.nome-abrev = tt-ad.sAMAccountName no-error.

         if not available requisitante then do:
            create requisitante.
            assign requisitante.nome-abrev = tt-ad.sAMAccountName
                   requisitante.nome       = tt-ad.displayName
                   requisitante.e-mail     = tt-ad.mail.
         end.

         if requisitante.nome <> tt-ad.displayName or requisitante.sc-codigo <> tt-ad.cod_ccusto or requisitante.e-mail <> tt-ad.mail then
            find current requisitante exclusive-lock.

         if requisitante.nome <> tt-ad.displayName then
            assign c-changes              = c-changes + substitute('~r~n~tnome: &1 (&2)', tt-ad.displayName, requisitante.nome)
                   requisitante.nome = tt-ad.displayName.

         if requisitante.sc-codigo <> tt-ad.cod_ccusto then
            assign c-changes              = c-changes + substitute('~r~n~tsc-codigo: &1 (&2)', tt-ad.cod_ccusto, requisitante.sc-codigo)
                   requisitante.sc-codigo = tt-ad.cod_ccusto.

         if requisitante.e-mail <> tt-ad.mail then
            assign c-changes              = c-changes + substitute('~r~n~te-mail: &1 (&2)', tt-ad.mail, requisitante.e-mail)
                   requisitante.e-mail = tt-ad.mail.

         if c-changes <> '' then
            put unformatted 'Atualizado: ' tt-ad.sAMAccountName c-changes skip.
      end.
      else do:
         run pi-acompanhar in h-acomp (input substitute("Criando: &1", tt-ad.sAMAccountName)).

         assign i-usuar_mestre = i-usuar_mestre + 1.
         /** Cria usu†rio **/
         create usuar_mestre.
         assign usuar_mestre.cod_usuario          = tt-ad.sAMAccountName
                usuar_mestre.idi_dtsul            = i-usuar_mestre
                usuar_mestre.nom_usuario          = tt-ad.displayName
                usuar_mestre.cod_idiom_orig       = 'por'
                usuar_mestre.cod_e_mail_local     = tt-ad.mail
                usuar_mestre.nom_dir_spool        = '\\erpapp\spool' /*SESSION:TEMP-DIR*/
                usuar_mestre.nom_subdir_spool     = tt-ad.sAMAccountName
                usuar_mestre.nom_subdir_spool_rpw = tt-ad.sAMAccountName
                usuar_mestre.cod_dialet           = 'pt'
                usuar_mestre.ind_tip_usuar        = 'Comum'
                usuar_mestre.ind_tip_aces_usuar   = 'Externo'
                usuar_mestre.cod_senha            = base64-encode(sha1-digest(tt-ad.employeeNumber))
                usuar_mestre.cod_senha_framework  = base64-encode(sha1-digest(tt-ad.employeeNumber))
                usuar_mestre.dat_valid_senha      = today - 1
                usuar_mestre.dat_inic_valid       = today
                usuar_mestre.dat_fim_valid        = 12/31/9999
                usuar_mestre.num_dias_valid       = 60
                overlay(usuar_mestre.cod_livre_1, 1, 3) = 'UTB'.

         FIND FIRST estabelec NO-LOCK
              WHERE estabelec.cod-estabel = tt-ad.cod-estabel NO-ERROR.

         if not can-find (first usuar_mestre_ext
                          where usuar_mestre_ext.cod_domin_so = ''
                            and usuar_mestre_ext.cod_usuario  = tt-ad.sAMAccountName) then do:
            create usuar_mestre_ext.
            assign usuar_mestre_ext.cod_usuario  = usuar_mestre.cod_usuario
                   usuar_mestre_ext.cod_domin_so = ''
                   usuar_mestre_ext.cod_usuar_so = tt-ad.sAMAccountName.
         end.

         create usuar_mestre_ext.
         assign usuar_mestre_ext.cod_usuario  = usuar_mestre.cod_usuario
                usuar_mestre_ext.cod_domin_so = 'intelbras'
                usuar_mestre_ext.cod_usuar_so = tt-ad.sAMAccountName.

         if can-find (first int_usuar_mestre no-lock
                      where int_usuar_mestre.cod_usuario <> tt-ad.sAMAccountName
                        and int_usuar_mestre.cpf          = tt-ad.employeeNumber) then do:
            find first int_usuar_mestre no-lock
               where int_usuar_mestre.cod_usuario <> tt-ad.sAMAccountName
                 and int_usuar_mestre.cpf          = tt-ad.employeeNumber.

            for each usuar_grp_usuar no-lock
               where usuar_grp_usuar.cod_usuario = int_usuar_mestre.cod_usuario:

               create busuar_grp_usuar.
               assign busuar_grp_usuar.cod_usuario = tt-ad.sAMAccountName.
               buffer-copy usuar_grp_usuar except cod_usuario to busuar_grp_usuar.
            end.

            for each imprsor_usuar no-lock
               where imprsor_usuar.cod_usuario = int_usuar_mestre.cod_usuario:

               create bimprsor_usuar.
               assign bimprsor_usuar.cod_usuario = tt-ad.sAMAccountName.
               buffer-copy imprsor_usuar except cod_usuario to bimprsor_usuar.
            end.

            release int_usuar_mestre.
         end.

         IF NOT CAN-FIND(FIRST usuar_grp_usuar
                         WHERE usuar_grp_usuar.cod_grp_usuar = "*"
                           AND usuar_grp_usuar.cod_usuario = tt-ad.sAMAccountName) THEN DO:
             
             CREATE usuar_grp_usuar.
             ASSIGN usuar_grp_usuar.cod_grp_usuar = "*"
                    usuar_grp_usuar.cod_usuario   = tt-ad.sAMAccountName.

         END.

         create segur_empres_usuar.
         assign segur_empres_usuar.cod_usuario = tt-ad.sAMAccountName
                segur_empres_usuar.cod_empresa = IF AVAIL estabelec THEN string(estabelec.ep-codigo) ELSE '1'.

         create fnd_usuar_univ.
         assign fnd_usuar_univ.cod_usuario = tt-ad.sAMAccountName
                fnd_usuar_univ.cod_empresa = IF AVAIL estabelec THEN string(estabelec.ep-codigo) ELSE '1'.

         /* programa de cadastro: prgint/utb/utb100aa.r */
         create usuar_univ.
         assign usuar_univ.cod_usuario      = tt-ad.sAMAccountName
                usuar_univ.cod_empresa      = IF AVAIL estabelec THEN string(estabelec.ep-codigo) ELSE '1'
                usuar_univ.cod_estab        = tt-ad.cod-estabel
                usuar_univ.cod_unid_negoc   = tt-ad.cod_unid_negoc
                usuar_univ.cod_plano_ccusto = 'PADRAO'
                usuar_univ.cod_ccusto       = tt-ad.cod_ccusto.

         create int_usuar_mestre.
         assign int_usuar_mestre.cod_usuario = tt-ad.sAMAccountName
                int_usuar_mestre.cpf         = tt-ad.employeeNumber
                int_usuar_mestre.ramal       = tt-ad.telephoneNumber.

         /** Chamado 12011 **/
         create usuar-mater.
         assign usuar-mater.cod-usuario            = tt-ad.sAMAccountName
                usuar-mater.usuar-solic            = yes
                usuar-mater.usuar-requis           = yes
                usuar-mater.log-1                  = yes
                usuar-mater.log-2                  = yes
                usuar-mater.sc-codigo              = tt-ad.cod_ccusto
                usuar-mater.cod-lotacao            = tt-ad.cod_ccusto
                overlay(usuar-mater.char-1, 1, 1)  = 'N'
                overlay(usuar-mater.char-1, 10, 1) = 'N'
                overlay(usuar-mater.char-1, 15, 1) = 'N'.

         /** Chamado 65080 **/
         create requisitante.
         assign requisitante.nome-abrev = tt-ad.sAMAccountName
                requisitante.nome       = tt-ad.displayName
                requisitante.sc-codigo  = tt-ad.cod_ccusto
                requisitante.e-mail     = tt-ad.mail.

         /** TOTVS 12.1.11 **/
         create configur.
		 assign configur.idi_dtsul              = next-value(seq_configur, emsfnd)
                configur.idi_dtsul_usuar_mestre = i-usuar_mestre
                configur.nom_configur           = 'defaultFocus'
                configur.des_localiz_configur   = 'datasul.framework.index'
                configur.des_val_configur       = 'current_select_menu'.

         create configur.
		 assign configur.idi_dtsul              = next-value(seq_configur, emsfnd)
                configur.idi_dtsul_usuar_mestre = i-usuar_mestre
                configur.nom_configur           = 'blockUpdateByUser'
                configur.des_localiz_configur   = 'datasul.framework.index'
                configur.des_val_configur       = 'no'.

         put unformatted 'Criado: ' tt-ad.sAMAccountName ' - ' tt-ad.displayName skip.
      end.
   end.
end procedure.

procedure adQuery:
   define input parameter queryEnabled as logical no-undo.

   define variable adConn     as com-handle  no-undo.
   define variable adRS       as com-handle  no-undo.
   define variable adSysInfo  as com-handle  no-undo.
   define variable adRootDSE  as com-handle  no-undo.

   define variable adQuery    as character   no-undo.
   define variable numRecs    as integer     no-undo.
   define variable opts       as integer     no-undo.

   define variable i          as integer     no-undo.

   create "ADODB.Connection" adConn no-error.
   adConn:Provider = "ADsDSOObject".
   adConn:open = "ADSI Providers".

   create "ADODB.Recordset" adRS no-error.
   assign adQuery = "select displayName, samaccountname, employeeID from 'LDAP://intelbras.local'".
   adRS = adConn:execute(adQuery, output numRecs, opts) no-error.

   if valid-handle(adRS) then do:
      release object adRS.

      do i = 65 to 90:
         create '' adRootDSE connect to 'LDAP://RootDSE' no-error.
         adRS = adConn:execute('<LDAP://' + adRootDSE:get('defaultNamingContext') + '>;(&(employeeID>=' + string(tt-param.login-ini) + ')(employeeID<=' + string(tt-param.login-fim) + ')(' + (if not queryEnabled then '' else '!') + 'userAccountControl:1.2.840.113556.1.4.803:=2)(sAMAccountName=' + chr(i) + '*));displayName,userAccountControl,mail,employeeId,employeeNumber,employeeType,distinguishedName,PhysicalDeliveryOfficeName,telephoneNumber,samaccountname,manager;subtree',,) no-error.
         if valid-handle(adRS) then do:
            do while not adRS:eof:

               create tt-ad.
               assign tt-ad.sAMAccountName   = adRS:fields('samaccountname'):value
                      tt-ad.displayName      = adRS:fields('displayName'):value
                      tt-ad.manager          = adRS:fields('manager'):value
                      tt-ad.employeeId       = int(adRS:fields('employeeId'):value)
                      tt-ad.employeeNumber   = adRS:fields('employeeNumber'):value
                      tt-ad.departmentNumber = adRS:fields('employeeType'):value /** Campo multivalorado n∆o funciona no Progress **/
                      tt-ad.office           = adRS:fields('PhysicalDeliveryOfficeName'):value
                      tt-ad.mail             = adRS:fields('mail'):value
                      tt-ad.telephoneNumber  = adRS:fields('telephoneNumber'):value
                      tt-ad.accountDisabled  = queryEnabled.

               if tt-ad.telephoneNumber = ? then
                  assign tt-ad.telephoneNumber = ''.
               if tt-ad.mail = ? then
                  assign tt-ad.mail = ''.
               if tt-ad.employeeNumber = ? then
                  assign tt-ad.employeeNumber = ''.
               if tt-ad.manager = ? then
                  assign tt-ad.manager = ''.

               case tt-ad.office:
                  when "Matriz" then
                     assign tt-ad.cod-estabel = "101".
                  when "Renovigi Louveira" then
                     assign tt-ad.cod-estabel = "101".
                  when "Renovigi Chapeco" then
                     assign tt-ad.cod-estabel = "101".
                  when "Filial SC" then
                     assign tt-ad.cod-estabel = "104".
                  when "Filial MG" then
                     assign tt-ad.cod-estabel = "103".
                  when "Filial AM" then
                     assign tt-ad.cod-estabel = "105".
                  when "Filial PE" then
                     assign tt-ad.cod-estabel = "110".
                  when "Filial TB" then
                     assign tt-ad.cod-estabel = "111".
                  when "CD Sao Jose" then
                     assign tt-ad.cod-estabel = "104".
                  when "CD Manaus" then
                     assign tt-ad.cod-estabel = "105".
                  when "Decio" then
                     assign tt-ad.cod-estabel = "601".
                  when "Decio Filial" then
                     assign tt-ad.cod-estabel = "602".
               end case.

               if tt-ad.manager <> '' then
                  assign tt-ad.manager = entry(1, entry(2, tt-ad.manager, '='), ',').

               assign tt-ad.cod_unid_negoc = substring(tt-ad.departmentNumber, 1, 3)
                      tt-ad.cod_ccusto     = substring(tt-ad.departmentNumber, 4).

               run pi-acompanhar in h-acomp (input substitute("Lendo do ActiveDirectory: &1", tt-ad.sAMAccountName)).

               adRS:movenext.
            end.

            release object adRS.
         end.
      end.
   end.

   if valid-handle(adRS) then
      release object adRS.

   if valid-handle(adConn) then
      release object adConn.

end procedure.

procedure piInformaSupervisor:
   define variable conteudoMail as character no-undo.
   define variable destinoMail  as character no-undo.
   define variable temManager   as logical   no-undo init no.

   find emitente no-lock
      where emitente.cgc = tt-ad.employeeNumber no-error.

   if not available emitente then
      return.

   if not can-find (first saldo-terc no-lock
                    where saldo-terc.cod-emitente = emitente.cod-emitente
                      and saldo-terc.quantidade  <> 0) then
      return.

   EMPTY TEMP-TABLE tt-prog-ponto.
   RUN esp/es0018p.p (INPUT "esbtb004rp":U, 
                      INPUT 1, 
                      INPUT 0, 
                      INPUT "":U, 
                      OUTPUT TABLE tt-prog-ponto).

   ASSIGN destinoMail = "".
   FOR EACH tt-prog-ponto:
       ASSIGN destinoMail = IF destinoMail = "" THEN tt-prog-ponto.conteudo ELSE destinoMail + ";" + tt-prog-ponto.conteudo.
   END.

   /* Comentado para atender o chamado 124126 - Agora devem ser parametrizados no programa ES0018 os e-mails que ir∆o receber
      assign destinoMail = 'felipe.braun@intelbras.com.br;alexandro.fronza@intelbras.com.br;grupo.contabil@intelbras.com.br;valdirene.borges@intelbras.com.br'. */

   if tt-ad.manager <> '' then do:
      find usuar_mestre no-lock
         where usuar_mestre.cod_usuario = tt-ad.manager no-error.

      if available usuar_mestre and usuar_mestre.cod_e_mail_local <> '' then
         assign destinoMail = destinoMail + ';' + usuar_mestre.cod_e_mail_local
                temManager  = yes.
   end.


   assign conteudoMail = "<html>~n<head>~n<style><!--~* ~{ font-family: Calibri;~n font-size: 10pt;~n~}~n th, td ~{ border: 2px solid gray; ~}-->~n</style>~n</head>~n<body>~n"
          conteudoMail = conteudoMail + substitute("<p>Prezada Lideranáa,<br />~nInformamos o desligamento do colaborador <strong>&1</strong> - <strong>&2</strong> ", tt-ad.sAMAccountName, tt-ad.displayName)
          conteudoMail = conteudoMail + substitute(", que est† com os seguintes ativos em poder deste:")
          conteudoMail = conteudoMail + "<p><tabl" + "e>~n<thead>~n<tr><th>Estab</th><th>NF</th><th>Data</th><th>Valor</th><th>Narrativa</th><th>Patrimonio</th></tr>~n</thead>~n<tbody>".

   for each saldo-terc no-lock
      where saldo-terc.cod-emitente = emitente.cod-emitente
        and saldo-terc.quantidade  <> 0,
      first componente of saldo-terc no-lock:

       FIND FIRST ped-fiscal NO-LOCK
            WHERE ped-fiscal.nr-nota-fis = saldo-terc.nro-docto
              AND ped-fiscal.serie       = saldo-terc.serie
              AND ped-fiscal.cod-estabel = saldo-terc.cod-estabel NO-ERROR.
       IF AVAIL ped-fiscal THEN
           ASSIGN c-patrimonio = trim(SUBSTRING(ped-fiscal.observacao[4],12,15))
                  c-patrimonio = REPLACE(c-patrimonio,".","").
       ELSE
           ASSIGN c-patrimonio = "".

      assign conteudoMail = conteudoMail + substitute("<tr><td>&1</td><td>&2/&3</td><td>&4</td><td>R$ &5</td><td>&6</td><td>&7</td></tr>", saldo-terc.cod-estabel, saldo-terc.nro-docto, saldo-terc.serie-docto,
                                              string(saldo-terc.dt-retorno, '99/99/9999'), string(componente.preco-total[1], ">>>>>9.99"), componente.narrativa,c-patrimonio).
   end.

   assign conteudoMail = conteudoMail + "~n</tbody>~n</tabl" + "e></p>~n"
          conteudoMail = conteudoMail + "<p>Informamos que &eacute; imprescind&iacute;vel a devolu&ccedil;&atilde;o dos itens discriminados em at&eacute; 48h &uacute;teis ap&oacute;s o desligamento do colaborador. "
                                      + "Os equipamentos da lista devem ser entregues na TIC. Notebooks e celulares acompanhados da nota fiscal, e desktops ser&atilde;o "
                                      + "recolhidos para tratativas de seguran&ccedil;a e para disponibilizar para outro colaborador. Mais informa&ccedil;&otilde;es consultar o regulamento <strong>GTI-TIC-DP-0016</strong> no SE SUITE."
                                      + "</p>".
   if not temManager then
      assign conteudoMail = conteudoMail + "<p>Importante: a lideran&ccedil;a N&Atilde;O tem e-mail cadastrado, favor comunicar!</p>".

   assign conteudoMail = conteudoMail + "<p>Tecnologia da Informa&ccedil;&atilde;o e Comunica&ccedil;&atilde;o</p>"
          conteudoMail = conteudoMail + "~n</body>~n</html>".

   run enviaMail (input 'portal@intelbras.com.br', input destinoMail, input 'Desligamento de colaborador', input conteudoMail).
end procedure.

procedure enviaMail:
   define input parameter pRemetente      as character no-undo.
   define input parameter pDestinatario   as character no-undo.
   define input parameter pAssunto        as character no-undo.
   define input parameter pMensagem       as character no-undo.

   define variable h-utapi019 as handle      no-undo.

   empty temp-table tt-envio2.

   create tt-envio2.
   assign tt-envio2.versao-integracao  = 1
          tt-envio2.servidor           = param-global.serv-mail
          tt-envio2.porta              = param-global.porta-mail
          tt-envio2.exchange           = param-global.log-1
          tt-envio2.remetente          = pRemetente
          tt-envio2.destino            = pDestinatario
          tt-envio2.assunto            = pAssunto
          tt-envio2.mensagem           = pMensagem
          tt-envio2.arq-anexo          = ''
          tt-envio2.importancia        = 1
          tt-envio2.log-enviada        = no
          tt-envio2.log-lida           = no
          tt-envio2.acomp              = no
          tt-envio2.formato            = 'HTML'.

   run utp/utapi019.p persistent set h-utapi019.
   run pi-execute in h-utapi019 (input table tt-envio2, output table tt-erros).
   delete object h-utapi019.
end procedure.
