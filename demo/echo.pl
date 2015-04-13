use lib "../lib";
use Weixin::Client;
my $w = Weixin::Client->new(debug=>0);
$w->load("ShowMsg");
$w->login();
$w->on_receive_message = sub{
    my $msg = shift ;
    #打印收到的消息
    $w->call("ShowMsg",$msg);
    #对收到的消息，以相同的内容回复
    $w->reply_msg($msg,$msg->{Content});
};
$w->on_send_message = sub {
    my ($msg,$is_success,$status) = @_;    
    #打印发送的消息
    $w->call("ShowMsg",$msg);
};
$w->run();
