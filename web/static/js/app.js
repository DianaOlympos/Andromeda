// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

	"use strict";

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
	//import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
	
	import {Socket} from "phoenix";

	let guardianToken = $('meta[name="guardian_token"]').getAttribute('content');
	let socket = new Socket("/socket", { params: { guardian_token: guardianToken } });
	socket.connect();

	let pilotChannel;
	let fleetChannel = socket.channel("fleet:" + window.location.pathname.split("/").splice(-1, 1)[0], {});
	fleetChannel.join()
		.receive("ok", resp => { 
			console.log("Joined fleet successfully", resp); 
			pilotChannel = socket.channel("pilot:" + resp);
			pilotChannel.join()
				.receive("ok", resp => { console.log("Joined pilot successfully", resp); })
				.receive("error", resp => { console.log("Unable to join", resp); });
		})
		.receive("error", resp => { console.log("Unable to join", resp); });