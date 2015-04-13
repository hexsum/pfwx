package Weixin::Client::Request;
sub http_get{
    my $self = shift;
    my $ua = $self->{ua};
    my $res = $ua->get(@_);
    return (defined $res and $res->is_success)?$res->content:undef;
}
sub asyn_http_get {
    my $self = shift;
    my $callback = pop;
    my $ua = $self->{asyn_ua};
    $ua->get(@_,sub{
        my $response = shift;
        print $response->content(),"\n" if $self->{debug}; 
        $callback->($response);  
    });
}
sub http_post{
    my $self = shift;
    my $ua = $self->{ua};
    my $res = $ua->post(@_);
    return (defined $res and $res->is_success)?$res->content:undef;
}
sub asyn_http_post {
    my $self = shift;
    my $callback = pop;
    my $ua = $self->{asyn_ua};
    $ua->post(@_,sub{
        my $response = shift;
        print $response->content(),"\n" if $self->{debug};
        $callback->($response);
    });
}
1;
