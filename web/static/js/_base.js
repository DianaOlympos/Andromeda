	
	function $ (id) { return document.querySelector(id); }
	function $$ (id) { return document.querySelectorAll(id); }

	String.prototype.format = function() {
		var args = arguments;
		return this.replace(/\${([a-zA-Z\d\-]+)}/g, function(match, varname) {
			return typeof args[0] != 'undefined' && typeof args[0][varname] != 'undefined' ? args[0][varname] : "";
		});
	};

	function El (el, data) {
		var element = typeof el == "string" ? document.createElement(el) : el;

		if(data) for(var i in data) if(i != "dataset" && i != "style") element[i] = data[i];
		if(data && data.style) for(var j in data.style) element.style.setProperty(j, data.style[j]);
		if(data && data.dataset) for(var k in data.dataset) element.dataset[k] = data.dataset[k];

		element.hide = function () { element.style.display = "none"; return element; };
		element.destroy = function () { element.parentNode.removeChild(element); };
		element.show = function () { element.style.display = "block"; return element; };
		element.fadeIn = function () { element.style.opacity = "1"; return element; };
		element.fadeOut = function () { element.style.opacity = "0"; return element; };
		element.appendChildren = function (childs) { childs.map(function (i) { if(i) element.appendChild(i); }); return element; };
		element.beforeChildren = function (childs) { childs.map(function (i) { if(i) element.parentNode.insertBefore(i, element); }); return element; };
		element.clear = function () { element.innerHTML = ""; return element; };
		element.on = function (listen, cb) { element.addEventListener(listen, cb); return element; };
		element.$ = function (id) { return element.querySelector(id); };
		element.$$ = function (id) { return element.querySelectorAll(id); };

		return element;
	}