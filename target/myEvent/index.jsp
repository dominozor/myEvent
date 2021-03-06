<!DOCTYPE html>
<html lang="en">
<head>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

    <script>
        var wsocket;
        var serviceLocation = "ws://localhost:8080/myEvent/chat/";
        var $nickName;
        var $message;
        var $chatWindow;
        var room = '';

        function onMessageReceived(evt) {
            //var msg = eval('(' + evt.data + ')');
            var msg = JSON.parse(evt.data); // native API
            var $messageLine = $('<tr><td class="received">' + msg.received
                    + '</td><td class="user label label-info">' + msg.sender
                    + '</td><td class="message badge">' + msg.message
                    + '</td></tr>');
            $chatWindow.append($messageLine);
        }
        function sendMessage() {
            var msg = '{"message":"' + $message.val() + '", "sender":"'
                    + $nickName.val() + '", "received":""}';
            wsocket.send(msg);
            $message.val('').focus();
        }

        function connectToChatserver() {
            room = $('#chatroom option:selected').val();
            wsocket = new WebSocket(serviceLocation + room);
            wsocket.onmessage = onMessageReceived;
        }

        function leaveRoom() {
            wsocket.close();
            $chatWindow.empty();
            $('.chat-wrapper').hide();
            $('.chat-signin').show();
            $nickName.focus();
        }

        $(document).ready(function() {
            $nickName = $('#nickname');
            $message = $('#message');
            $chatWindow = $('#response');
            $('.chat-wrapper').hide();
            $nickName.focus();

            $('#enterRoom').click(function(evt) {
                evt.preventDefault();
                connectToChatserver();
                $('.chat-wrapper h2').text('Chat # '+$nickName.val() + "@" + room);
                $('.chat-signin').hide();
                $('.chat-wrapper').show();
                $message.focus();
            });
            $('#do-chat').submit(function(evt) {
                evt.preventDefault();
                sendMessage()
            });

            $('#leave-room').click(function(){
                leaveRoom();
            });
        });
    </script>
</head>

<body>

<div class="container chat-signin">
    <form class="form-signin">
        <h2 class="form-signin-heading">Chat sign in</h2>
        <label for="nickname">Nickname</label> <input type="text"
                                                      class="input-block-level" placeholder="Nickname" id="nickname">
        <div class="btn-group">
            <label for="chatroom">Chatroom</label> <select size="1"
                                                           id="chatroom">
            <option>arduino</option>
            <option>java</option>
            <option>groovy</option>
            <option>scala</option>
        </select>
        </div>
        <button class="btn btn-large btn-primary" type="submit"
                id="enterRoom">Sign in</button>
    </form>
</div>
<!-- /container -->

<div class="container chat-wrapper">
    <form id="do-chat">
        <h2 class="alert alert-success"></h2>
        <table id="response" class="table table-bordered"></table>
        <fieldset>
            <legend>Enter your message..</legend>
            <div class="controls">
                <input type="text" class="input-block-level" placeholder="Your message..." id="message" style="height:60px"/>
                <input type="submit" class="btn btn-large btn-block btn-primary"
                       value="Send message" />
                <button class="btn btn-large btn-block" type="button" id="leave-room">Leave
                    room</button>
            </div>
        </fieldset>
    </form>
</div>
</body>
</html>