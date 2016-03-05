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

	const canvas = $("#map");
	const ctx = canvas.getContext("2d");

	window.addEventListener("resize", drawMap);


	const andi = {
		map: [],
		me: null,
		pilotlist: []
	};

	$("#followfc").addEventListener("change", () => andi.pilotChannel.push("follow_fc", $("#followfc").checked));

	const guardianToken = $('meta[name="guardian_token"]').getAttribute('content');
	const socket = new Socket("/socket", { params: { guardian_token: guardianToken } });
	socket.connect();

	andi.fleetChannel = socket.channel("fleet:" + window.location.pathname.split("/").splice(-1, 1)[0], {});
	
	andi.fleetChannel
		.on("pilot_list", resp => { andi.pilotlist = resp.pilots; drawPilotlist(); });
	
	andi.fleetChannel.join()
		.receive("ok", resp => { 

			console.log("Joined fleet successfully", resp); 

			andi.pilotChannel = socket.channel("pilot:" + resp);
			
			andi.pilotChannel.on("location_member", resp => {});
			andi.pilotChannel.on("location", resp => { andi.me = resp; $("#smallheading").innerHTML = "Andromeda - Welcome " + andi.me.member_name; drawMap(); });
			andi.pilotChannel.on("map", resp => { andi.map = resp.map; drawMap(); });

			andi.pilotChannel.join()
				.receive("ok", resp => { 
					console.log("Joined pilot successfully", resp); 

					andi.pilotlist = resp; drawPilotlist();
				})
				.receive("error", resp => { console.log("Unable to join", resp); });

		})
		.receive("error", resp => { console.log("Unable to join", resp); });


	function drawMap () {
		console.log("draw map");
		if(andi.map.length === 0 || !andi.me)
			return;

		let width = $("main").clientWidth - 20;
		let height = $("main").clientHeight - 20;

		let scale = Math.min(width, height);
		let center = [width / 2, height / 2];

		let ringdist = scale / 2 / 6;

		canvas.width = width;
		canvas.height = height;

		let depths = [
			[],
			[],
			[],
			[],
			[],
			[]
		];

		andi.map.map(system => depths[system.depth].push(system));

		drawSystem(center, depths[0][0]);

		let sysdist = 360 / depths[1].length;

		console.log(depths[1], ringdist, sysdist);

		ctx.strokeStyle = "gray";
		depths.map((depth, index) => {
			ctx.beginPath();
			ctx.arc(center[0], center[1], ringdist * index, 0, Math.PI * 2);
			ctx.stroke();
		});

	
		ctx.strokeStyle = "black";
		depths.map(depth => 
			depth
				.map(system => !(system.render = {}) || system)
				//.map((system, ind) => !(system.render.degrees = ind * (360 / depth.length)) || system)
				.map((system, ind) => {

					let parent = getParent(system);
					let splitDeg = 360 / depth.length;
					let shards = filterByDepth(parent.connection.map(getSystemByID), system.depth);
					let shardIDs = shards.map(shard => shard.id);
					let shardDeg = splitDeg / (shards.length == depth.length ? 1 : shardIDs.length);

					system.render.degrees = (parent.render.degrees) - (splitDeg / 2) + (shardDeg / 2) + (shardDeg * shardIDs.indexOf(system.id));

					return system;
				})
		);



	
		console.log("depths");
		console.log(depths);

		
		andi.map
			.map(system => 
				system.connection.map(systemID => connectSystems(center, ringdist, system, getSystemByID(systemID))) && (drawSystem([
					center[0] - ((ringdist * system.depth) * Math.cos(toRadians(system.render.degrees))),
					center[1] - ((ringdist * system.depth) * Math.sin(toRadians(system.render.degrees)))
				], system))
			);


	}

	function drawSystem (cors, system) {
		ctx.beginPath();
		ctx.arc(cors[0], cors[1], 20, 0, Math.PI * 2);
		ctx.fill();
	}

	function connectSystems (center, ringdist, systemA, systemB) {
		if(!systemA || !systemB)
			return;
		ctx.strokeStyle = "black";
		ctx.beginPath();
		ctx.moveTo(
			center[0] - ((ringdist * systemA.depth) * Math.cos(toRadians(systemA.render.degrees))),
			center[1] - ((ringdist * systemA.depth) * Math.sin(toRadians(systemA.render.degrees)))
		);
		ctx.lineTo(
			center[0] - ((ringdist * systemB.depth) * Math.cos(toRadians(systemB.render.degrees))),
			center[1] - ((ringdist * systemB.depth) * Math.sin(toRadians(systemB.render.degrees)))
		);
		ctx.stroke();
	}

	function drawPilotlist () {
		El($("#memberlist")).clear().appendChildren(andi.pilotlist.map(pilot => El("div", { innerHTML: pilot.name })));
	}

	function toDegrees (angle) {
		return angle * (180 / Math.PI);
	}

	function toRadians (angle) {
		return angle * (Math.PI / 180);
	}

	function getSystemByID (systemID) {
		return andi.map.find(system => system.id == systemID);
	}

	function filterByDepth(systems, depth) {
		return systems.filter(system => system.depth == depth);
	}

	function getParent (system) {
		console.log(system, filterByDepth(andi.map, system.depth - 1).find(sys => sys.connection.indexOf(system.id) != -1) || { render: { degrees: 0 }, connection: [system.id] });
		return filterByDepth(andi.map, system.depth - 1).find(sys => sys.connection.indexOf(system.id) != -1) || { render: { degrees: 0 }, connection: [system.id] };
	}