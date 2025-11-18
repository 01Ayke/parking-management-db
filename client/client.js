
function out(data){ document.getElementById('out').textContent = JSON.stringify(data, null, 2) }


function getPlaces(){ fetch('http://localhost:3000/places').then(r=>r.json()).then(out) }
function enter(){ const p = document.getElementById('numEntree').value; fetch('http://localhost:3000/enter',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({plaque:p})}).then(r=>r.json()).then(out) }
function exitCar(){ const p = document.getElementById('numSortie').value; fetch('http://localhost:3000/exit',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({plaque:p})}).then(r=>r.json()).then(out) }