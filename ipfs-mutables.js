---
---
/*
 This script talk to the 5001 gateway to convert
 a mfs path into a immutable qm hash
*/
const status = resp => {
  if (resp.status >= 200 && resp.status < 300) {
    return Promise.resolve(resp)
  }
  return Promise.reject(new Error(resp.statusText))
}
const error = err => { console.log(err); }

// ipfs config Addresses.API
//const webui = 'http://127.0.0.1:5001';
const webui = '{{site.data.gw.webui}}'
const api_url = webui + '/api/v0/'

//const lgw = 'http://127.0.0.1:8080'
const lgw = '{{site.data.gw.lgw}}'
const pgw = 'https://ipfs.blockringtm.ml';

var bod = document.getElementsByTagName('body')[0];
    bod.innerHTML = bod.innerHTML.replace(/http:\/\/gateway.local/g,lgw);
    bod.innerHTML = bod.innerHTML.replace(/http:\/\/gateway.public/g,pgw);

var map = {}
var promises = []
    let matches = bod.innerHTML.matchAll( new RegExp('/webui#/files((/[^"]+)?/([^/" ]+))','g') )
    for(let result of matches) {
      let mutable = result[0];
      let fname = result[3];

      console.log('result: ',result)
      if (typeof(map[mutable]) == 'undefined') {
         promises.push( getHashKey(result[2]).then( h => {
		    console.log('s,'+mutable+',/ipfs/'+h+'/'+fname+',g') // OK
		    map[mutable] = '/ipfs/'+h+'/'+fname;
                    bod.innerHTML = bod.innerHTML.replace( new RegExp(mutable,'g'),map[mutable]);
		    } ).catch(error) );
	  
      } else {
                    bod.innerHTML = bod.innerHTML.replace( new RegExp(mutable,'g'),map[mutable]);
      }

    }

    Promise.all(promises).then(callback).catch(error)

function callback(results) {
  console.log(results)
}

function getHashKey(path) {
   // get the hash corresponding to the mfs path
   var url = api_url + 'files/stat?arg='+path+'&hash=1';
   console.log(url);
   return fetchjson(url)
      .then( obj => { console.log(obj); return obj.Hash; } )
      .then( mhash => {
            console.log('path: '+mhash+' '+path);
            return Promise.resolve(mhash) })
      .catch(error)
}

function fetchjson(url) {
  return fetch(url).then(status).then( resp => resp.json() )
}

