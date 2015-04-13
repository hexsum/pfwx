package Weixin::Client;
sub _is_need_login{
    my $self = shift;
    my $api = "https://wx.qq.com/";
    my $data = $self->http_get($api,); 
    return $data=~/\Q<div id="login_container" style="display:none;">\E/?0:1;
}
1;
