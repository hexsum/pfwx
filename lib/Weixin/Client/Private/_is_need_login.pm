package Weixin::Client;
sub _is_need_login{
    my $self = shift;
    my $api = "https://wx.qq.com/";
    my $data = $self->http_get($api,); 
    return $data=~/window\.MMCgi\s*=\s*{\s*isLogin\s*:\s*(!!"1")\s*}/s?0:1;
}
1;
