package Weixin::Client::Callback;
sub on_run :lvalue {
    my $self = shift;
    $self->{on_run};
}

sub on_receive_message:lvalue {
    my $self = shift;
    $self->{on_receive_message};
}

sub on_send_message :lvalue {
    my $self = shift;
    $self->{on_send_message};
}

1;
