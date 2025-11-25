

function outDebug(data) {
  document.getElementById('out').textContent =
    JSON.stringify(data, null, 2);
}



function getPlaces() {
  console.log('getPlaces() appelée');
  fetch('/places')
    .then(r => r.json())
    .then(data => {
      outDebug(data);
    })
    .catch(e => outDebug({ error: e.toString() }));
}

function enter() {
  console.log('enter() appelée');
  const input = document.getElementById('numEntree');
  const p = input.value.trim();
  if (!p) return;

  fetch('/enter', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ plaque: p })
  })
    .then(r => r.json())
    .then(data => {
      outDebug(data);
      input.value = '';  
    })
    .catch(e => outDebug({ error: e.toString() }));
}

function exitCar() {
  console.log('exitCar() appelée');
  const input = document.getElementById('numSortie');
  const p = input.value.trim();
  if (!p) return;

  fetch('/exit', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ plaque: p })
  })
    .then(r => r.json())
    .then(data => {
      outDebug(data);
      input.value = '';  
    })
    .catch(e => outDebug({ error: e.toString() }));
}



function fetchInfos() {
  console.log('fetchInfos() appelée');
  fetch('/consult/infos')
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchVoituresParParking() {
  console.log('fetchVoituresParParking() appelée');
  const id = document.getElementById('idParkingVp').value;
  if (!id) return;

  fetch(`/consult/voitures-par-parking?id_parking=${encodeURIComponent(id)}`)
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchParkingsParCommune() {
  console.log('fetchParkingsParCommune() appelée');
  const id = document.getElementById('idCommunePc').value;
  if (!id) return;

  fetch(`/consult/parkings-par-commune?id_commune=${encodeURIComponent(id)}`)
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchParkingsSatures() {
  console.log('fetchParkingsSatures() appelée');
  const jour = document.getElementById('jourSatures').value;
  if (!jour) return;

  fetch(`/consult/parkings-satures?jour=${encodeURIComponent(jour)}`)
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchPlacesDisponibles() {
  console.log('fetchPlacesDisponibles() appelée');
  const id = document.getElementById('idParkingPd').value;
  const jour = document.getElementById('jourPd').value;
  const heure = document.getElementById('heurePd').value;
  if (!id || !jour || !heure) return;

  const qs = new URLSearchParams({
    id_parking: id,
    jour,
    heure
  }).toString();

  fetch(`/consult/places-disponibles?${qs}`)
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchVoituresMultiParkings() {
  console.log('fetchVoituresMultiParkings() appelée');
  const jour = document.getElementById('jourMulti').value;
  if (!jour) return;

  fetch(`/consult/voitures-multi-parkings?jour=${encodeURIComponent(jour)}`)
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}



function fetchMoyPlacesDispo() {
  console.log('fetchMoyPlacesDispo() appelée');
  fetch('/stat/moyenne-places-disponibles')
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchDureeMoy() {
  console.log('fetchDureeMoy() appelée');
  fetch('/stat/duree-moyenne-stationnement')
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchCoutMoyMensuel() {
  console.log('fetchCoutMoyMensuel() appelée');
  fetch('/stat/cout-moyen-mensuel')
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchParkingsMoinsUtilises() {
  console.log('fetchParkingsMoinsUtilises() appelée');
  fetch('/stat/parkings-moins-utilises')
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchParkingsPlusRentables() {
  console.log('fetchParkingsPlusRentables() appelée');
  fetch('/stat/parkings-plus-rentables')
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}

function fetchCommunesPlusDemandees() {
  console.log('fetchCommunesPlusDemandees() appelée');
  fetch('/stat/communes-plus-demandees')
    .then(r => r.json())
    .then(data => outDebug(data))
    .catch(e => outDebug({ error: e.toString() }));
}



document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM prêt');

  
  document.getElementById('btnPlaces')?.addEventListener('click', getPlaces);
  document.getElementById('btnEnter')?.addEventListener('click', enter);
  document.getElementById('btnExit')?.addEventListener('click', exitCar);

  
  document.getElementById('btnInfos')?.addEventListener('click', fetchInfos);
  document.getElementById('btnVoituresParParking')?.addEventListener('click', fetchVoituresParParking);
  document.getElementById('btnParkingsParCommune')?.addEventListener('click', fetchParkingsParCommune);
  document.getElementById('btnParkingsSatures')?.addEventListener('click', fetchParkingsSatures);
  document.getElementById('btnPlacesDisponibles')?.addEventListener('click', fetchPlacesDisponibles);
  document.getElementById('btnVoituresMultiParkings')?.addEventListener('click', fetchVoituresMultiParkings);

  
  document.getElementById('btnMoyPlacesDispo')?.addEventListener('click', fetchMoyPlacesDispo);
  document.getElementById('btnDureeMoy')?.addEventListener('click', fetchDureeMoy);
  document.getElementById('btnCoutMoyMensuel')?.addEventListener('click', fetchCoutMoyMensuel);
  document.getElementById('btnParkingsMoinsUtilises')?.addEventListener('click', fetchParkingsMoinsUtilises);
  document.getElementById('btnParkingsPlusRentables')?.addEventListener('click', fetchParkingsPlusRentables);
  document.getElementById('btnCommunesPlusDemandees')?.addEventListener('click', fetchCommunesPlusDemandees);
});
