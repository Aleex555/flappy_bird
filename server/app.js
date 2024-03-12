const express = require('express')
const gameLoop = require('./utilsGameLoop.js')
const webSockets = require('./utilsWebSockets.js')
const debug = true

/*
    WebSockets server, example of messages:

    From client to server:
        - Client init           { "type": "init", "name": "name", "color": "0x000000" }
        - Player movement       { "type": "move", "x": 0, "y": 0 }

    From server to client:
        - Welcome message       { "type": "welcome", "value": "Welcome to the server", "id", "clientId" }
        
    From server to everybody (broadcast):
        - All clients data      { "type": "data", "data": "clientsData" }
*/

var ws = new webSockets()
var gLoop = new gameLoop()

// Start HTTP server
const app = express()
const port = process.env.PORT || 8888
const availableColors = ['blau', 'vermell', 'taronja', 'verd'];
let assignedColors = {};
let connectedPlayers = [];
let gameCountdown = null;
let gameStarted = false;

// Publish static files from 'public' folder
app.use(express.static('public'))

// Activate HTTP server
const httpServer = app.listen(port, appListen)
async function appListen() {
  console.log(`Listening for HTTP queries on: http://localhost:${port}`)
}

// Close connections when process is killed
process.on('SIGTERM', shutDown);
process.on('SIGINT', shutDown);
function shutDown() {
  console.log('Received kill signal, shutting down gracefully');
  httpServer.close()
  ws.end()
  gLoop.stop()
  process.exit(0);
}

// WebSockets
ws.init(httpServer, port)

ws.onConnection = (socket, id) => {
  // Rechazar conexión si ya hay 4 jugadores
  if (connectedPlayers.length >= 4) {
    console.log(`Máximo de jugadores alcanzado, rechazando conexión: ${id}`);
    socket.close(); // O enviar un mensaje antes de cerrar si lo prefieres
    return;
  }

  if (debug) console.log("WebSocket client connected: " + id);
  const colorIndex = Math.floor(Math.random() * availableColors.length);
  const color = availableColors.splice(colorIndex, 1)[0];
  assignedColors[id] = color;
  connectedPlayers.push({ id: id, name: 'Anónimo', color: color });

  // Cuando el primer jugador se conecta, inicia un contador de 30 segundos
  if (connectedPlayers.length === 1 && !gameStarted) {
    gameCountdown = setTimeout(() => {
      gameStarted = true;
      ws.broadcast(JSON.stringify({ type: "gameStart" }));
      console.log("El juego ha comenzado después de 30 segundos de espera!");
    }, 10000);
  }

  // Si se conectan 4 jugadores antes de que termine el contador, inicia el juego de inmediato
  if (connectedPlayers.length === 4 && !gameStarted) {
    clearTimeout(gameCountdown);
    gameStarted = true;
    ws.broadcast(JSON.stringify({ type: "gameStart" }));
    console.log("El juego ha comenzado con 4 jugadores!");
  }


  socket.send(JSON.stringify({
    type: "welcome",
    value: "Welcome to the server",
    id: id,
    color: color
  }));
};


ws.onMessage = (socket, id, msg) => {
  if (debug) console.log(`New message from ${id}: ${msg.substring(0, 32)}...`);

  let clientData = ws.getClientData(id);
  if (clientData == null) return;

  let obj = JSON.parse(msg);
  switch (obj.type) {
    case "init":
      const playerIndex = connectedPlayers.findIndex(player => player.id === id);
      if (playerIndex !== -1) {
        connectedPlayers[playerIndex].name = obj.name;
      }
      broadcastConnectedPlayers();
      break;
    case "move":
      clientData.x = obj.x;
      clientData.y = obj.y;
      break;
  }
  
};


ws.onClose = (socket, id) => {
  if (debug) console.log("WebSocket client disconnected: " + id);
  connectedPlayers = connectedPlayers.filter(player => player.id !== id);



  // Liberar el color asignado al cliente desconectado
  if (assignedColors[id]) {
    availableColors.push(assignedColors[id]); // Añadir el color de nuevo a la lista de disponibles
    delete assignedColors[id]; // Eliminar la entrada del color asignado
  }

  if (connectedPlayers.length === 0 && !gameStarted) {
    // Si todos los jugadores se han desconectado y el juego no ha comenzado, resetear el estado
    clearTimeout(gameCountdown);
    gameCountdown = null;
    gameStarted = false;
  }

  broadcastConnectedPlayers();
  ws.broadcast(JSON.stringify({
    type: "disconnected",
    from: "server",
    id: id
  }));
};

gLoop.init();
gLoop.run = (fps) => {
  // Este método intenta ejecutarse 30 veces por segundo
  let clientsData = ws.getClientsData();

  // Crear un arreglo con los datos necesarios de cada cliente
  let opponentsData = connectedPlayers.map(player => ({
    id: player.id,
    x: ws.getClientData(player.id).x || 0,
    y: ws.getClientData(player.id).y || 0,
    color: player.color,
  }));
  ws.broadcast(JSON.stringify({ type: "data", opponents: opponentsData }));
}

function broadcastConnectedPlayers() {
  ws.broadcast(JSON.stringify({
    type: "playerListUpdate",
    connectedPlayers: connectedPlayers
  }));
}