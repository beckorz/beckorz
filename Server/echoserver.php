<?php
/*
 * EchoServer.php
 * TASKS $Id: EchoServer.php,v 1.0 2007/07/24 17:12:55 beck Exp $
 */

class HttpServer {
  private $socket = null;
 
  private $method = null;
  private $uri = null;
  private $headers = null;
  private $body = null;
 
  public function __construct($port = 9000) {
    $this->socket = socket_create_listen($port);
    if ($this->socket === false) {
      $this->error();
    }
  }
 
  public function execute() {
    while (true) {
      $client = socket_accept($this->socket);
      if ($client === false) {
        $this->error();
      }
 
      $request = $this->read($client);
 
      $header = "HTTP/1.x 200 OK\r\n";
      $header .= "Content-Type: text/html\r\n";
      $header .= "\r\n\r\n";
      socket_write($client, $header, strlen($header));
 
      $request = nl2br($request);
      socket_write($client, $request, strlen($request));
      socket_close($client);
    }
  }
 
  private function read($client) {
    $this->body = "";
    $req = "";
    while (true) {
      $buff = socket_read($client, 2048, PHP_BINARY_READ);
      $req .= $buff;
 
      if ($buff === false) {
        $this->error();
      } else if ($buff === "" || strlen($buff) <2048) {
        if (preg_match("/\r\n\r\n$/", $req)) {
          $this->parseHeader($req);
        } else {
          $this->body .= $buff;
        }
 
        if ($this->isComplete()) {
          return $req;
        }
      }
    }
  }
 
  protected function parseHeader($req) {
        $lines = explode("\r\n", $req);
    $this->setRequestLine(array_shift($lines));
 
    foreach ($lines as $line) {
      $line = trim($line);
      if (empty($line)) {
        continue;
      }
      $this->setHeader($line);
    }
  }
 
    protected function setRequestLine($line) {
        list($this->method, $this->uri) = explode(" ", $line);
    }
 
    protected function setHeader($line) {
        $header = explode(":", $line);
        $this->headers[trim(array_shift($header))] = trim(join( ":", $header ));
    }
 
  protected function isComplete() {
    if ($this->method == "POST" && !empty($this->headers['Content-Length'])) {
      return strlen($this->body) == $this->headers['Content-Length'];
    }
 
    return true;
  }
 
  private function error() {
    $message = sprintf("error:%d %s", socket_last_error()
                                    , socket_strerror(socket_last_error()));
    die($message);
  }
 
  public function __destruct() {
    if (is_resource($this->socket)) {
      socket_close($this->socket);
    }
  }
}
 
$server = new HttpServer();
$server->execute();
?>
