package Weixin::Client;
sub _synccheck{
    my $self = shift;
    return if $self->{_sync_running} ;
    my $api = "https://webpush.weixin.qq.com/cgi-bin/mmwebwx-bin/synccheck";
    $self->{_synccheck_running} = 1;
    my $callback = sub {
        my $response = shift;
        #window.synccheck={retcode:"0",selector:"0"}    
        $self->{_synccheck_running} = 0;
        my($retcode,$selector) = $response->content()=~/window\.synccheck={retcode:"([^"]+)",selector:"([^"]+)"}/g;
        if(defined $retcode and defined $selector and $retcode == 0 and $selector != 0){
            $self->{_synccheck_error_count}=0;
            $self->_sync(); 
        }
        elsif(defined $retcode and defined $selector and $retcode == 0){
            $self->{_synccheck_error_count}=0;
            $self->_synccheck(); 
        }
        elsif($self->{_synccheck_error_count} < 3){
            $self->{_synccheck_error_count}++;
            $self->timer(5,sub{$self->_sync();});
        }
        else {
            $self->timer(2,sub{$self->_synccheck();});
        }
    }; 
    my @query_string = (
        skey        =>  $self->skey,  
        callback    =>  "jQuery1830847224326338619_" . $self->now(),
        r           =>  $self->now(), 
        sid         =>  $self->wxsid,
        uin         =>  $self->wxuin,
        deviceid    =>  $self->deviceid,
        synckey     =>  join("|",map {$_->{Key} . "_" . $_->{Val};} @{$self->sync_key->{List}}),
        _           =>  $self->now(),
    );
    my $url = gen_url2($api,@query_string);
    $self->timer2("_synccheck",$self->{_synccheck_interval},sub{
        print "GET $url\n" if $self->{debug};
        $self->asyn_http_get($url,$callback);
    });
}
1;
