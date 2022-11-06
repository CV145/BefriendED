/*
Any data, or state, will only exist in memory while the server is running
*/


//Map of users, keyed by username
const users = {};

//Map of chat rooms
const rooms = {};

/*
Rooms consist of 2 people (with potential to expand to more)
users: list of users in the chat room
*/

//socket.io object - require() is used by node.js to load modules
//Starts a http server listening for connections from a client on port 80
//The server is passed into socket.io to make it a WebSocket server 
//WebSocket allows bidirectional communication between sevrer and client
const io = require("socket.io")(
    require("http").createServer(
        //An empty function to fulfill the contract of createServer()
        function() {}
    ).listen(80)
);


/*
We need to tell the server what to respond to and how
*/

//Set up response to the connection message
io.on("connection", io => {
    //Response
    console.log("\n\nConnection established with a client");
    //More stuff
});