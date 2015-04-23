package Weixin::Client;
sub _get_chatroom{
    my $self  = shift;
    my $chatroom_id = shift;
    my $post = {
        BaseRequest =>  {
            Uin         =>  $self->wxuin,
            DeviceID    =>  $self->deviceid,
            Sid         =>  $self->wxsid,
            Skey        =>  $self->skey,
        },
        Count       =>  1,
        List        =>  [{UserName=>$chatroom_id,ChatRoomId=>""}],
    };

    my $api = "https://wx.qq.com/cgi-bin/mmwebwx-bin/webwxbatchgetcontact";
    my @query_string = (
        type        =>  "ex",
        pass_ticket =>  $self->pass_ticket,
        r           =>  $self->now(),
        skey        =>  uri_escape($self->skey),
        pass_ticket =>  $self->pass_ticket,
    );
    my $json = $self->http_post(gen_url($api,@query_string),("Content-Type"=>"application/json; charset=UTF-8"),Content=>$self->json_encode($post)); 
    return unless defined $json;
    my $d = $self->json_decode($json);
    return unless defined $d;
    return if $d->{BaseResponse}{Ret}!=0;
    return if $d->{Count} != 1;
    my @member_key = qw(HeadImgUrl NickName PYInitial PYQuanPin Alias Province City Sex Id Uin Signature DisplayName RemarkName RemarkPYInitial RemarkPYQuanPin);
    my @chartroom_key = qw(ChatRoomUin MemberCount OwnerUin ChatRoomId ChatRoomName);
    for my $each (@{$d->{ContactList}}){
        if($self->is_chatroom($each->{UserName})){#chatroom
            $each->{ChatRoomUin}  = $each->{Uin};delete $each->{Uin};
            $each->{ChatRoomId}  = $each->{UserName};delete $each->{UserName};
            $each->{ChatRoomName}  = $each->{NickName};delete $each->{NickName};
            my $chatroom = {};
            for(@chartroom_key){
                $chatroom->{$_} = encode_utf8($each->{$_}) if defined $each->{$_};
            }
            $chatroom->{Member} = [];
            for my $m (@{$each->{MemberList}}){
                $m->{Id} = $m->{UserName};delete $m->{UserName};
                my $member = {};
                for(@member_key){
                    $member->{$_} = encode_utf8($m->{$_}) if defined $m->{$_};
                }
                $member->{$_} = $chatroom->{$_} for(grep {$_ ne "Member"} keys %$chatroom);
                push @{$chatroom->{Member}},$member;
            }
            return $chatroom;
        }
    }
    return ;
}
1;
