const http = require('http');
const os = require('os');

const PORT = process.env.PORT || 3000;
const APP_VERSION = process.env.APP_VERSION || '2.0';

const getLocalIP = () => {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]) {
      if (iface.family === 'IPv4' && !iface.internal) {
        return iface.address;
      }
    }
  }
  return '127.0.0.1';
};

const server = http.createServer((req, res) => {
  if (req.url === '/') {
    const response = {
      service: "node-multistage-app",
      version: APP_VERSION,
      hostname: os.hostname(),
      uptime: process.uptime()
    };

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(response));
  } 
  
  else if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: "OK" }));
  } 
  
  else {
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: "Not Found" }));
  }
});

server.listen(PORT, () => {
  console.log(`Server running on http://${getLocalIP()}:${PORT}`);
});
