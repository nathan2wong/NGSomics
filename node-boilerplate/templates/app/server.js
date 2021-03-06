//setup Dependencies
var connect = require('connect')
    , express = require('express')
    , io = require('socket.io')
    , port = (process.env.PORT || 8081);

//Setup Express
var server = express.createServer();
server.configure(function(){
    server.set('views', __dirname + '/views');
    server.set('view options', { layout: false });
    server.use(connect.bodyParser());
    server.use(express.cookieParser());
    server.use(express.session({ secret: "shhhhhhhhh!"}));
    server.use(connect.static(__dirname + '/static'));
    server.use(server.router);
});

server.listen( port);

//Setup Socket.IO
var io = io.listen(server);
io.sockets.on('connection', function(socket){
  console.log('Client Connected');
  socket.on('message', function(data){
    socket.broadcast.emit('server_message',data);
    socket.emit('server_message',data);
  });
  socket.on('disconnect', function(){
    console.log('Client Disconnected.');
  });
});

server.get('/', function(req,res){
  res.send("hi");
});

var exec = require('sync-exec');

server.get('/script/:name', function(req, res){
  var nameInput = req.params.name;
  res.send("<div style='white-space: pre-wrap;'>" + exec(nameInput + "").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />')+"</div>");
});

server.get('/docker/:cmd', function(req, res){
 /* var suppose = require('suppose');
  suppose('sh', ['/home/ngsomics/start.sh'])
     .when('Do you wish to begin NGSomics on trial 1?').respond('yes')
     .when('Do you wish to remove excess data?').respond('yes')
     .when('Do you wish to view the results now?').respond('yes')
     .end(function(code){res.send("Done!")});*/
  var cmd = req.params.cmd;
  res.send("<div style='white-space: pre-wrap;'>" + exec("sh /home/ngsomics/real.sh").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />')+"</div>");
});

console.log('Listening on http://0.0.0.0:' + port );

