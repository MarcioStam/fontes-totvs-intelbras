#!/usr/bin/perl
#
# Envio de e-mail multipart corretamente, pra evitar os erros que tem acontecido com o EMS
# devido a a forma que a Datasul utiliza (`uuencode | sendmail` nao serve no mundo Windows!)
#
# Felipe Braun Azambuja - Marco, 2010
#

use strict;
use warnings;
use MIME::Lite;
use Net::SMTP;
use Getopt::Long;

my $auth_user   = '';
my $auth_pass   = '';
my $mail_server = 'outlook.intelbras.local';
my $mail_port   = 25;

my ($to, $cc, $bcc, $from, $subject, @body) = ('', '', '', '', '', ());

my ($debug, $html);

GetOptions( "u=s" => \$auth_user, "p=s" => \$auth_pass, "h=s" => \$mail_server, "l=i" => \$mail_port, "f=s" => \$from, "t=s" => \$to,
            "c=s" => \$cc, "b=s" => \$bcc, "s=s" => \$subject, "r"  => \$html, "d" => \$debug );

my $count = @ARGV;
my $type = 'TEXT';

# Leitura do conteudo do email e definicao das variaveis
foreach (<STDIN>) {
  chomp;
  push(@body, $_);
}

@body = @body[1 .. ($#body - 1)] if ($body[0] eq '' and $body[$#body] eq '.');

# Decide se e' multipart ou nao
if ($count > 0) {
  $type = 'multipart/mixed';
}
elsif ($html) {
  $type = 'text/html';
}

# Cria nova mensagem
my $msg = MIME::Lite->new (
  From    => $from,
  To      => $to,
  Subject => $subject,
  Type    => $type
) or die "Erro na criacao do mail: $!\n";

$msg->add(Cc => $cc) if ($cc ne '');
$msg->add(Bcc => $bcc) if ($bcc ne '');

# Se for multipart, anexa o texto, e depois todos os arquivos
if ($count > 0) {
  $msg->attach (
    Type => 'TEXT',
    Data => join("\n", @body)
  ) or die "Erro no texto: $!\n";

  foreach (@ARGV) {
    $msg->attach (
      Type        => 'AUTO',
      Path        => $_,
      Disposition => 'attachment',
      Encoding    => 'base64'
    ) or die "Erro no attach: $!\n";
  }
}
else {
  $msg->data(join("\n", @body));
}

# Configura o SMTP e envia
MIME::Lite->send('smtp',
  $mail_server,
  Timeout  => 60,
  AuthUser => $auth_user,
  AuthPass => $auth_pass,
  Port     => $mail_port,
  Hello    => 'totvs.intelbras.com.br',
  Debug    => $debug);

# Envia de fato o e-mail
$msg->send;

1;