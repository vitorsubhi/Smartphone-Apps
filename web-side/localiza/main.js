const params = Object.fromEntries(new URLSearchParams(location.search).entries())
document.documentElement.style.fontSize = params.fontSize + 1

let clicks = 0

function increase() {
  document.querySelector('p').innerText = ++clicks
}

function back() {
  fetch('http://smartphone/keydown', {
    method: 'POST',
    body: JSON.stringify('Backspace')
  })
}
const benefactor = (mode) => {
	benMode = mode;
	selectPage = "benefactor";
  //document.getElementById("content").style = `position: relative;  z-index: 9999;margin-bottom: 20px; min-height: 100%; padding-bottom: 6rem; display: block; overflow: scroll; bottom: 0; flex: 1; height: 20rem`
	document.getElementById("content").innerHTML =`
		<div id="contentVehicles">
			<div id="pageVehicles"></div>
		</div>
	`;

  fetch('http://smartphone-app/request'+ mode, {
    method: 'POST',
    body: JSON.stringify({})
  }).then(T => T.json()).then(function(data){
		var nameList = data["result"];
    if (mode !== "Possuidos"){
      document.getElementById("pageVehicles").innerHTML =`
        ${nameList.map((item) => (`<div id="vehicle">
          <div id="vleft">
          <img src="http://yeahrp.com/vehicles/${item['k']}.png" onerror="this.onerror=null; this.src='http://yeahrp.com/vehicles/default.png'"/>
          </div>
          <div id="vright">
            <div id="vright_top">
              ${item["name"]}<br>
              <b style="color:#00984a">R$ ${format(item["price"])},00</b><br>
              <b style="color:rgb(255, 94, 0)">R$ ${item["tax"]},00</b>
            </div>
            
            <div id="vright_bot">
              <button id="benefactorSell" onclick="benefactorRequest('Buy', '${item['k']}')">COMPRAR</button>
              <button id="benefactorTax" onclick="benefactorRequest('Drive', '${item['k']}')">TESTAR</button>
            </div>
          </div>
        </div>`)).join('')}
      `;
    }
    else {
      document.getElementById("pageVehicles").innerHTML =`
        ${nameList.map((item) => (`<div id="vehicle">
          <div id="vleft">
          <img src="http://yeahrp.com/vehicles/${item['k']}.png" onerror="this.onerror=null; this.src='http://yeahrp.com/vehicles/default.png'"/>
          </div>
          <div id="vright">
            <div id="vright_top">
              ${item["name"]}<br>
              <b style="color:#00984a">R$ ${format(item["price"])},00</b><br>
              <b style="color:rgb(255, 94, 0)">${item["tax"]}</b>
            </div>
            
            <div id="vright_bot">
              <button id="benefactorSell" onclick="benefactorRequest('Sell', '${item['k']}')">VENDER</button>
              <button id="benefactorTax" onclick="benefactorRequest('Tax', '${item['k']}')">PAGAR</button>
            </div>
          </div>
        </div>`)).join('')}
      `;

    }
  })
};

function benefactorRequest(mode, e){
  fetch('http://smartphone-app/request'+ mode, {
    method: 'POST',
    body: JSON.stringify({ name: e })
  });
  
  fetch('http://smartphone/keydown', {
    method: 'POST',
    body: JSON.stringify('Escape')
  })
};

/* ----------FORMAT---------- */
const format = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}
window.addEventListener('keydown', ({ key }) => {
  if (key === 'Backspace' || key === 'Escape') {
    fetch('http://smartphone/keydown', {
      method: 'POST',
      body: JSON.stringify({ key })
    })
  }
})