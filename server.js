//setup Dependencies
var connect = require('connect')
    , express = require('express')
    , io = require('socket.io')
    , port = (process.env.PORT || 8081)
    , cors = require('cors');

//Setup Express
var server = express.createServer();
server.configure(function(){
    server.set('views', __dirname + '/views');
    server.set('view options', { layout: false });
    server.use(function(req, res, next) {
  	res.header("Access-Control-Allow-Origin", "*");
	res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  	next();
    });
    server.use(connect.bodyParser());
    server.use(express.bodyParser({uploadDir:'/home/ngsomics/trial1/'}));
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

server.get('/', function(req,res, next){
  res.send("hi");
});

var exec = require('sync-exec');

server.get('/script/:name', function(req, res, next){
  var nameInput = req.params.name;
  res.send("<div style='white-space: pre-wrap;'>" + exec(nameInput + "").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />')+"</div>");
});

server.get('/docker/:cmd', function(req, res, next){
	var cmd = req.params.cmd;
	res.send("<div style='white-space: pre-wrap;'>" + exec("sh /home/ngsomics/real.sh").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />')+"</div>");
});

server.post('/print_sam', function(req, res, next){
	res.send(exec("cat /home/ngsomics/trial1/aligned.sam").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />') + "<br /> <br /><hr>");
});

server.post('/run_and_print', function(req, res, next){
	var cmd = req.params.cmd;
	console.log("Request received to /docker_post from ip: " + req.connection.remoteAddress);
	res.send(
		"<div style='white-space: pre-wrap;'>" + exec("sh /home/ngsomics/real.sh").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />')+ "<br /><br /><hr>" + "</div>");
	//	+exec("cat /home/ngsomics/trial1/out.diff.sites_in_files").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />') + "</div>");
});

server.get('/time_test', function(req, res, next){
	res.send(Date.now() + "hi");
});

var fs = require('fs');
server.post('/file-upload', function(req, res, next) {
    var objToSend = {};
    var now = Date.now();

    var tmp_ref_path = req.files.ref.path;
    exec("mkdir /home/ngsomics/nathan/dir" + now + " && mkdir /home/ngsomics/nathan/dir" + now + "/fastq1" + "&& mkdir /home/ngsomics/nathan/dir" + now + "/fastq2");
    var target_ref_path = '/home/ngsomics/nathan/dir' + now + '/' + req.files.ref.name;
    fs.rename(tmp_ref_path, target_ref_path, function(err) {
        if (err) throw err;
        fs.unlink(tmp_ref_path, function() {
            if (err) throw err;
            res.send('Ref file uploaded to: ' + target_ref_path + ' - ' + req.files.ref.size + ' bytes');
        });
    });

    var tmp_fastq1_path = req.files.fastq1.path;
    var target_fastq1_path = '/home/ngsomics/nathan/dir' + now + '/fastq1/' + req.files.fastq1.name;
    fs.rename(tmp_fastq1_path, target_fastq1_path, function(err) {
        if (err) throw err;
        fs.unlink(tmp_fastq1_path, function() {
            if (err) throw err;
            res.send('Fastq1 file uploaded to: ' + target_fastq1_path + ' - ' + req.files.fastq1.size + ' bytes');
        });
    });

    var tmp_fastq2_path = req.files.fastq2.path;
    var target_fastq2_path = '/home/ngsomics/nathan/dir' + now + '/fastq2/' + req.files.fastq2.name;
    fs.rename(tmp_fastq2_path, target_fastq2_path, function(err) {
        if (err) throw err;
        fs.unlink(tmp_fastq2_path, function() {
            if (err) throw err;
            res.send('Fastq2 file uploaded to: ' + target_fastq2_path + ' - ' + req.files.fastq2.size + ' bytes');
        });
    });

    console.log('fdsaoifjdsoaijfdsaoij: ' + now);
    console.log(exec("sh /home/ngsomics/start.sh dir" + now).stdout);

    console.log("Request received to /file-upload from ip: " + req.connection.remoteAddress);
    //objToSend.sam_output = (exec("cat /home/ngsomics/nathan/dir"+now+"/aligned.sam").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />'));
    //objToSend.process_output = (exec("sh /home/ngsomics/real.sh").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />'));
    //objToSend.variants_output = (exec("cat /home/ngsomics/trial1/variants.vcf").stdout.replace(/(?:\r\n|\r|\n)/g, '<br />'));

    res.json(objToSend);
});

console.log('Listening on http://0.0.0.0:' + port );